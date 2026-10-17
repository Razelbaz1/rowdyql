-- Course materials (2026-10-17): the private bucket "materials" for the files students upload under "החומרים שלי"
-- (past exams, solutions, exercises, syllabi). Each student writes only under their own folder (<user id>/...), reads and
-- deletes only their own files; the course staff (is_teacher) can read everything. Nothing is public.
-- Run once; safe to run again. The plan answers themselves need no change: they travel in public.progress (key 'dbs_plan').

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('materials', 'materials', false, 20971520,
        array['application/pdf', 'application/msword',
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
              'image/png', 'image/jpeg'])
on conflict (id) do update set public = false, file_size_limit = excluded.file_size_limit, allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "materials: students upload to their folder" on storage.objects;
create policy "materials: students upload to their folder" on storage.objects for insert to authenticated
  with check (bucket_id = 'materials' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "materials: students read their files, staff read all" on storage.objects;
create policy "materials: students read their files, staff read all" on storage.objects for select to authenticated
  using (bucket_id = 'materials' and ((storage.foldername(name))[1] = auth.uid()::text or public.is_teacher()));

drop policy if exists "materials: students delete their files" on storage.objects;
create policy "materials: students delete their files" on storage.objects for delete to authenticated
  using (bucket_id = 'materials' and (storage.foldername(name))[1] = auth.uid()::text);
