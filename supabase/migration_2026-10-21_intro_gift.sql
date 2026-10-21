-- The intro is a gift (Raz, 2026-10-21). Run once in the SQL editor; safe to run again.
-- 1. Every active, signed-in account may open the intro: has_access, my_chapters and my_access say so without a row.
-- 2. The intro isn't for sale: no price row, and shop_price drops it. The whole course ('all') is the four paid chapters, and an
--    account owns it when it owns those four for good.
-- 3. Raz's prices: Relational algebra 99, SQL 149, Normalization 99, ERD 99, the whole course 279.

create or replace function public.has_access(p_chapter text) returns boolean language sql stable security definer set search_path = '' as $$
  select public.is_active() and (p_chapter = 'intro' and auth.uid() is not null
    or exists (select 1 from public.entitlements e where e.user_id = auth.uid() and e.chapter = p_chapter
      and e.revoked_at is null and (e.expires_at is null or e.expires_at > now())));
$$;
revoke execute on function public.has_access(text) from public, anon;
grant execute on function public.has_access(text) to authenticated;

create or replace function public.my_chapters() returns setof text language sql stable security definer set search_path = '' as $$
  select c from (
    select 'intro'::text c where auth.uid() is not null
    union
    select e.chapter from public.entitlements e
    where e.user_id = auth.uid() and e.revoked_at is null and (e.expires_at is null or e.expires_at > now())
  ) x where public.is_active() order by c;
$$;
revoke execute on function public.my_chapters() from public, anon;
grant execute on function public.my_chapters() to authenticated;

create or replace function public.my_access() returns table (chapter text, expires_at timestamptz) language sql stable security definer set search_path = '' as $$
  select 'intro'::text, null::timestamptz where auth.uid() is not null and public.is_active()
  union all
  select e.chapter, e.expires_at from public.entitlements e
  where e.user_id = auth.uid() and e.chapter <> 'intro' and e.revoked_at is null and public.is_active()
    and (e.expires_at is null or e.expires_at > now() - interval '60 days');
$$;
revoke execute on function public.my_access() from public, anon;
grant execute on function public.my_access() to authenticated;

delete from public.prices where item = 'intro';
insert into public.prices (item, price) values ('ra', 99), ('sql', 149), ('norm', 99), ('erd', 99), ('all', 279)
  on conflict (item) do update set price = excluded.price, updated_at = now();

create or replace function public.shop_price(p_items text[], p_code text,
  out items jsonb, out subtotal int, out discount int, out total int, out coupon text, out err text)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_uid uuid := auth.uid(); v_items text[]; v_base int; c public.coupons%rowtype;
  v_code text := nullif(upper(regexp_replace(coalesce(p_code, ''), '[\s_]+', '', 'g')), '');
begin
  select array_agg(distinct x) into v_items from unnest(coalesce(p_items, '{}'::text[])) x where x in ('ra', 'sql', 'norm', 'erd', 'all');
  if v_items is null then err := 'empty'; return; end if;
  if 'all' = any (v_items) then
    v_items := array['all'];
    if (select count(*) from public.entitlements e where e.user_id = v_uid and e.revoked_at is null and e.expires_at is null
        and e.chapter in ('ra', 'sql', 'norm', 'erd')) = 4 then err := 'owned'; return; end if;
  else
    v_items := array(select x from unnest(v_items) x where not exists (select 1 from public.entitlements e
      where e.user_id = v_uid and e.chapter = x and e.revoked_at is null and e.expires_at is null));
    if cardinality(v_items) = 0 then err := 'owned'; return; end if;
  end if;
  select jsonb_agg(jsonb_build_object('item', p.item, 'price', p.price) order by array_position(array['ra', 'sql', 'norm', 'erd', 'all'], p.item)),
         coalesce(sum(p.price), 0)::int
    into items, subtotal from public.prices p where p.item = any (v_items);
  discount := 0;
  if v_code is not null then
    select * into c from public.coupons k where k.code = v_code;
    if c.code is null or c.kind <> 'discount' then err := 'unknown'; return; end if;
    if not c.active or (c.redeem_by is not null and c.redeem_by < now()) then err := 'expired'; return; end if;
    if c.quota is not null and (select count(*) from public.orders o where o.coupon = c.code and o.status = 'paid') >= c.quota then err := 'used_up'; return; end if;
    if exists (select 1 from public.orders o where o.coupon = c.code and o.status = 'paid' and o.user_id = v_uid) then err := 'again'; return; end if;
    select coalesce(sum(p.price), 0)::int into v_base from public.prices p where p.item = any (v_items) and p.item = any (c.chapters);
    if v_base > 0 then
      discount := case when c.percent is not null then round(v_base * c.percent / 100.0)::int else least(c.amount, v_base) end;
      coupon := c.code;
    end if;
  end if;
  total := subtotal - discount;
end $$;
revoke execute on function public.shop_price(text[], text) from public, anon, authenticated;

-- the simulated payment grants the paid chapters (the intro is everyone's already)
create or replace function public.order_pay_test(p_id bigint) returns jsonb language plpgsql security definer set search_path = '' as $$
declare o public.orders%rowtype; v_quota int; ch text;
begin
  if not public.shop_tester() then raise exception 'testers only'; end if;
  update public.orders x set status = 'paid', paid_at = now() where x.id = p_id and x.user_id = auth.uid() and x.status = 'pending' returning * into o;
  if o.id is null then return jsonb_build_object('error', 'not found'); end if;
  if o.coupon is not null then
    select k.quota into v_quota from public.coupons k where k.code = o.coupon;
    if v_quota is not null and (select count(*) from public.orders x where x.coupon = o.coupon and x.status = 'paid' and x.id <> o.id) >= v_quota then
      raise exception 'used_up';
    end if;
  end if;
  for ch in select distinct unnest(case when j.v->>'item' = 'all' then array['ra', 'sql', 'norm', 'erd'] else array[j.v->>'item'] end)
            from jsonb_array_elements(o.items) as j(v) loop
    insert into public.entitlements (user_id, chapter, source, ref, expires_at) values (o.user_id, ch, 'purchase', 'order:' || o.id, null)
      on conflict (user_id, chapter) do update set source = 'purchase', ref = excluded.ref, granted_at = now(), revoked_at = null, expires_at = null;
  end loop;
  return jsonb_build_object('id', o.id);
end $$;
revoke execute on function public.order_pay_test(bigint) from public, anon;
grant execute on function public.order_pay_test(bigint) to authenticated;
