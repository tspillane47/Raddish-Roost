-- Vermont Roost Collection
-- File 2 of 3 — public photo bucket.
-- Run after the schema file succeeds, and before the seed file.
-- Dashboard → SQL → New query → paste this entire file → Run.
-- If this file fails, create the bucket by hand:
-- Storage → New bucket → name guidebook-media → Public bucket → on.
-- File size limit 5 MB. Allowed types: image/jpeg, image/png, image/webp.
-- Then paste this file again only if the policies were not created.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'guidebook-media',
  'guidebook-media',
  true,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create policy guidebook_media_public_read
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'guidebook-media');

create policy guidebook_media_staff_insert
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'guidebook-media'
    and public.is_staff()
    and lower(storage.extension(name)) in ('jpg', 'jpeg', 'png', 'webp')
  );

create policy guidebook_media_staff_update
  on storage.objects
  for update
  to authenticated
  using (bucket_id = 'guidebook-media' and public.is_staff())
  with check (
    bucket_id = 'guidebook-media'
    and public.is_staff()
    and lower(storage.extension(name)) in ('jpg', 'jpeg', 'png', 'webp')
  );

create policy guidebook_media_staff_delete
  on storage.objects
  for delete
  to authenticated
  using (bucket_id = 'guidebook-media' and public.is_staff());
