-- Errin site row and default settings. Safe to paste again.
-- Does not touch roost or dad rows. No properties yet. No em dashes.

do $guard$
begin
  if to_regclass('public.sites') is null then
    raise exception 'sites table is missing. Run the sites migration before this file.';
  end if;
end
$guard$;

insert into public.sites (id, key, name, domain, settings)
values (
  'c1000000-0000-4000-8000-000000000003',
  'errin',
  'Errin''s Digs',
  null,
  '{}'::jsonb
)
on conflict (key) do update
set
  name = excluded.name,
  domain = coalesce(public.sites.domain, excluded.domain),
  updated_at = now();

insert into public.site_settings (site_id, key, value)
select s.id, v.key, v.value
from public.sites s
join (
  values
    ('brand_name', '"Errin''s Digs"'::jsonb),
    ('allow_indexing', 'false'::jsonb),
    ('active_seasons', '{"spring":false,"summer":false,"fall":false,"winter":false}'::jsonb),
    ('public_site_url', '""'::jsonb)
) as v(key, value) on true
where s.key = 'errin'
on conflict (site_id, key) do update
set value = excluded.value;

do $check$
declare
  site_count integer;
  settings_count integer;
begin
  select count(*) into site_count
  from public.sites
  where key = 'errin'
    and id = 'c1000000-0000-4000-8000-000000000003'
    and name = 'Errin''s Digs';

  select count(*) into settings_count
  from public.site_settings ss
  join public.sites s on s.id = ss.site_id
  where s.key = 'errin'
    and ss.key in ('brand_name', 'allow_indexing', 'active_seasons', 'public_site_url');

  if site_count <> 1 or settings_count <> 4 then
    raise exception 'Errin site migration checks failed.';
  end if;

  if exists (
    select 1
    from public.site_settings ss
    join public.sites s on s.id = ss.site_id
    where s.key = 'errin'
      and ss.key = 'allow_indexing'
      and ss.value <> 'false'::jsonb
  ) then
    raise exception 'Errin allow_indexing must be false.';
  end if;
end
$check$;
