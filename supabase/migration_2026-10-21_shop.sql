-- Coupons, stage 2 (2026-10-21): discounts, prices on the server, orders, and a simulated payment for Raz's test accounts.
-- Run once in the SQL editor; safe to run again.
-- 1. prices: one row per item (each chapter, and 'all' for the whole-course bundle). Signed-in users read them; staff edit them.
-- 2. coupons.kind: 'access' (opens chapters, stage 1) or 'discount' (a percent or an amount off the items it covers; 'all' may be
--    one of them). coupon_redeem answers a discount code with {kind, code, percent, amount, items} and doesn't spend it: a paid
--    order does.
-- 3. orders, priced here (shop_price): the items once each, the bundle alone, nothing the account owns for good, then the code.
--    While there is no payment provider, only a tester (staff, or an account in shop_testers) can make one (order_create) and
--    pay it with a simulated payment (order_pay_test), which grants its chapters for good (entitlements, source 'purchase').
--    Orders outlive a deleted account (user_id set null), for the books.
-- 4. my_orders(), order_list() (staff), shop_me(); coupon_list also shows a coupon's type, and for a discount counts paid orders.

create table if not exists public.prices (
  item       text primary key check (item in ('intro', 'ra', 'sql', 'norm', 'erd', 'all')),
  price      int not null check (price between 1 and 100000),
  updated_at timestamptz not null default now()
);
alter table public.prices enable row level security;
revoke all on public.prices from anon, authenticated;
grant select, update on public.prices to authenticated;
drop policy if exists prices_read on public.prices;
create policy prices_read on public.prices for select to authenticated using (true);
drop policy if exists prices_staff on public.prices;
create policy prices_staff on public.prices for update using (public.is_teacher()) with check (public.is_teacher());
insert into public.prices (item, price) values ('intro', 29), ('ra', 99), ('sql', 149), ('norm', 89), ('erd', 89), ('all', 279)
  on conflict (item) do nothing;

alter table public.coupons add column if not exists kind text not null default 'access';
alter table public.coupons add column if not exists percent int;
alter table public.coupons add column if not exists amount int;
alter table public.coupons drop constraint if exists coupons_chapters_check;
alter table public.coupons add constraint coupons_chapters_check
  check (cardinality(chapters) between 1 and 10 and chapters <@ array['intro', 'ra', 'sql', 'norm', 'erd', 'all']);
alter table public.coupons drop constraint if exists coupons_kind_check;
alter table public.coupons add constraint coupons_kind_check check (
  (kind = 'access' and percent is null and amount is null and not ('all' = any (chapters)))
  or (kind = 'discount' and days is null and until is null
      and ((percent between 1 and 100 and amount is null) or (amount between 1 and 10000 and percent is null))));

create table if not exists public.shop_testers (
  user_id uuid primary key references auth.users (id) on delete cascade,
  at      timestamptz not null default now()
);
alter table public.shop_testers enable row level security;
revoke all on public.shop_testers from anon, authenticated;

create table if not exists public.orders (
  id       bigint generated always as identity primary key,
  user_id  uuid references auth.users (id) on delete set null,
  at       timestamptz not null default now(),
  items    jsonb not null,            -- [{item, price}]
  subtotal int not null check (subtotal >= 0),
  discount int not null default 0 check (discount >= 0),
  total    int not null check (total >= 0),
  coupon   text references public.coupons (code) on update cascade,
  status   text not null default 'pending' check (status in ('pending', 'paid', 'cancelled')),
  test     boolean not null default false,
  paid_at  timestamptz
);
create index if not exists orders_user on public.orders (user_id, at);
create index if not exists orders_coupon on public.orders (coupon) where status = 'paid';
alter table public.orders enable row level security;
revoke all on public.orders from anon, authenticated;

-- may finish a simulated payment: staff, or one of Raz's test accounts
create or replace function public.shop_tester() returns boolean language sql stable security definer set search_path = '' as $$
  select public.is_active() and (public.is_teacher() or exists (select 1 from public.shop_testers t where t.user_id = auth.uid()));
$$;
revoke execute on function public.shop_tester() from public, anon, authenticated;

create or replace function public.shop_me() returns jsonb language sql stable security definer set search_path = '' as $$
  select jsonb_build_object('tester', auth.uid() is not null and public.shop_tester());
$$;
revoke execute on function public.shop_me() from public, anon;
grant execute on function public.shop_me() to authenticated;

-- the price of a cart for the caller: what the page shows, decided here
create or replace function public.shop_price(p_items text[], p_code text,
  out items jsonb, out subtotal int, out discount int, out total int, out coupon text, out err text)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_uid uuid := auth.uid(); v_items text[]; v_base int; c public.coupons%rowtype;
  v_code text := nullif(upper(regexp_replace(coalesce(p_code, ''), '[\s_]+', '', 'g')), '');
begin
  select array_agg(distinct x) into v_items from unnest(coalesce(p_items, '{}'::text[])) x where x in ('intro', 'ra', 'sql', 'norm', 'erd', 'all');
  if v_items is null then err := 'empty'; return; end if;
  if 'all' = any (v_items) then
    v_items := array['all'];
    if (select count(*) from public.entitlements e where e.user_id = v_uid and e.revoked_at is null and e.expires_at is null
        and e.chapter in ('intro', 'ra', 'sql', 'norm', 'erd')) = 5 then err := 'owned'; return; end if;
  else
    v_items := array(select x from unnest(v_items) x where not exists (select 1 from public.entitlements e
      where e.user_id = v_uid and e.chapter = x and e.revoked_at is null and e.expires_at is null));
    if cardinality(v_items) = 0 then err := 'owned'; return; end if;
  end if;
  select jsonb_agg(jsonb_build_object('item', p.item, 'price', p.price) order by array_position(array['intro', 'ra', 'sql', 'norm', 'erd', 'all'], p.item)),
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

create or replace function public.order_create(p_items text[], p_code text default null) returns jsonb
language plpgsql security definer set search_path = '' as $$
declare q record; v_id bigint;
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  if not public.shop_tester() then return jsonb_build_object('error', 'closed'); end if;   -- sales open with a payment provider
  if (select count(*) from public.orders o where o.user_id = auth.uid() and o.status = 'pending' and o.at > now() - interval '1 hour') >= 10 then
    return jsonb_build_object('error', 'slow');
  end if;
  select * into q from public.shop_price(p_items, p_code);
  if q.err is not null then return jsonb_build_object('error', q.err); end if;
  insert into public.orders (user_id, items, subtotal, discount, total, coupon, test)
    values (auth.uid(), q.items, q.subtotal, q.discount, q.total, q.coupon, true) returning id into v_id;
  return jsonb_build_object('id', v_id, 'items', q.items, 'subtotal', q.subtotal, 'discount', q.discount, 'total', q.total, 'coupon', q.coupon);
end $$;
revoke execute on function public.order_create(text[], text) from public, anon;
grant execute on function public.order_create(text[], text) to authenticated;

-- the simulated payment: the order is paid, its chapters are the account's for good
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
  for ch in select distinct unnest(case when j.v->>'item' = 'all' then array['intro', 'ra', 'sql', 'norm', 'erd'] else array[j.v->>'item'] end)
            from jsonb_array_elements(o.items) as j(v) loop
    insert into public.entitlements (user_id, chapter, source, ref, expires_at) values (o.user_id, ch, 'purchase', 'order:' || o.id, null)
      on conflict (user_id, chapter) do update set source = 'purchase', ref = excluded.ref, granted_at = now(), revoked_at = null, expires_at = null;
  end loop;
  return jsonb_build_object('id', o.id);
end $$;
revoke execute on function public.order_pay_test(bigint) from public, anon;
grant execute on function public.order_pay_test(bigint) to authenticated;

create or replace function public.my_orders() returns table (id bigint, at timestamptz, paid_at timestamptz, items jsonb, subtotal int,
  discount int, total int, coupon text, status text, test boolean)
language sql stable security definer set search_path = '' as $$
  select o.id, o.at, o.paid_at, o.items, o.subtotal, o.discount, o.total, o.coupon, o.status, o.test
  from public.orders o where o.user_id = auth.uid() order by o.at desc limit 100;
$$;
revoke execute on function public.my_orders() from public, anon;
grant execute on function public.my_orders() to authenticated;

create or replace function public.order_list() returns table (id bigint, at timestamptz, paid_at timestamptz, name text, email text, items jsonb,
  subtotal int, discount int, total int, coupon text, status text, test boolean)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  return query select o.id, o.at, o.paid_at, p.full_name, u.email::text, o.items, o.subtotal, o.discount, o.total, o.coupon, o.status, o.test
    from public.orders o left join auth.users u on u.id = o.user_id left join public.profiles p on p.id = o.user_id
    order by o.at desc limit 500;
end $$;
revoke execute on function public.order_list() from public, anon;
grant execute on function public.order_list() to authenticated;

-- coupon_list: a coupon's type, and for a discount, how many paid orders used it
drop function if exists public.coupon_list();
create or replace function public.coupon_list() returns table (code text, note text, kind text, chapters text[], percent int, amount int, days int,
  until timestamptz, quota int, redeem_by timestamptz, active boolean, created_at timestamptz, used int)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  return query select c.code, c.note, c.kind, c.chapters, c.percent, c.amount, c.days, c.until, c.quota, c.redeem_by, c.active, c.created_at,
    case when c.kind = 'discount' then (select count(*)::int from public.orders o where o.coupon = c.code and o.status = 'paid')
         else (select count(*)::int from public.coupon_redemptions r where r.code = c.code) end
    from public.coupons c order by c.created_at desc;
end $$;
revoke execute on function public.coupon_list() from public, anon;
grant execute on function public.coupon_list() to authenticated;

-- coupon_redeem, now with a branch for discount codes (they go into the cart; the order spends them). The access branch is unchanged.
create or replace function public.coupon_redeem(p_code text) returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_uid uuid := auth.uid();
  v_code text := upper(regexp_replace(coalesce(p_code, ''), '[\s_]+', '', 'g'));
  c public.coupons%rowtype; e public.entitlements%rowtype;
  v_exp timestamptz; v_open text[] := '{}'; ch text;
begin
  if v_uid is null then raise exception 'not signed in'; end if;
  if not public.is_active() then raise exception 'blocked'; end if;
  delete from public.coupon_attempts a where a.user_id = v_uid and a.at < now() - interval '1 day';
  if (select count(*) from public.coupon_attempts a where a.user_id = v_uid and not a.ok and a.at > now() - interval '10 minutes') >= 5 then
    return jsonb_build_object('error', 'slow');
  end if;
  if v_code ~ '^[A-Z0-9-]{4,24}$' then select * into c from public.coupons k where k.code = v_code for update; end if;
  if c.code is null then
    insert into public.coupon_attempts (user_id, ok) values (v_uid, false);
    return jsonb_build_object('error', 'unknown');
  end if;
  if c.kind = 'discount' then
    if not c.active or (c.redeem_by is not null and c.redeem_by < now()) then return jsonb_build_object('error', 'expired'); end if;
    if c.quota is not null and (select count(*) from public.orders o where o.coupon = c.code and o.status = 'paid') >= c.quota then
      return jsonb_build_object('error', 'used_up');
    end if;
    if exists (select 1 from public.orders o where o.coupon = c.code and o.status = 'paid' and o.user_id = v_uid) then
      return jsonb_build_object('error', 'again');
    end if;
    insert into public.coupon_attempts (user_id, ok) values (v_uid, true);
    return jsonb_build_object('kind', 'discount', 'code', c.code, 'percent', c.percent, 'amount', c.amount, 'items', to_jsonb(c.chapters));
  end if;
  if not c.active or (c.redeem_by is not null and c.redeem_by < now()) or (c.until is not null and c.until <= now()) then
    return jsonb_build_object('error', 'expired');
  end if;
  if exists (select 1 from public.coupon_redemptions r where r.code = c.code and r.user_id = v_uid) then
    return jsonb_build_object('error', 'again');
  end if;
  if c.quota is not null and (select count(*) from public.coupon_redemptions r where r.code = c.code) >= c.quota then
    return jsonb_build_object('error', 'used_up');
  end if;
  v_exp := case when c.days is not null then now() + make_interval(days => c.days) else c.until end;   -- null: for good
  foreach ch in array c.chapters loop
    select * into e from public.entitlements x where x.user_id = v_uid and x.chapter = ch for update;
    if e.user_id is null then
      insert into public.entitlements (user_id, chapter, source, ref, expires_at) values (v_uid, ch, 'coupon', c.code, v_exp);
      v_open := v_open || ch;
    elsif e.revoked_at is not null or (e.expires_at is not null and e.expires_at <= now()) then
      update public.entitlements x set source = 'coupon', ref = c.code, granted_at = now(), revoked_at = null, expires_at = v_exp
        where x.user_id = v_uid and x.chapter = ch;
      v_open := v_open || ch;
    elsif e.expires_at is not null and (v_exp is null or v_exp > e.expires_at) then
      update public.entitlements x set source = 'coupon', ref = c.code, expires_at = v_exp where x.user_id = v_uid and x.chapter = ch;
      v_open := v_open || ch;
    end if;
    e := null;
  end loop;
  if cardinality(v_open) = 0 then return jsonb_build_object('chapters', '[]'::jsonb, 'expires_at', null); end if;
  insert into public.coupon_redemptions (code, user_id, chapters, expires_at) values (c.code, v_uid, v_open, v_exp);
  insert into public.coupon_attempts (user_id, ok) values (v_uid, true);
  return jsonb_build_object('chapters', to_jsonb(v_open), 'expires_at', v_exp);
end $$;
revoke execute on function public.coupon_redeem(text) from public, anon;
grant execute on function public.coupon_redeem(text) to authenticated;
