-- Guest area on properties for multi-region sites.
-- Additive only. Safe to paste again. Does not delete anything.

alter table public.properties
  add column if not exists guest_area text;

alter table public.properties drop constraint if exists properties_guest_area;
alter table public.properties
  add constraint properties_guest_area check (
    guest_area is null or guest_area in ('vermont', 'florida')
  );

grant select (guest_area) on public.properties to anon;

update public.properties
set guest_area = 'vermont'
where site_id = 'c1000000-0000-4000-8000-000000000001'
  and guest_area is null;

notify pgrst, 'reload schema';
