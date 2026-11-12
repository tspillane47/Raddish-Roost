-- Errin / Queen City Stays VRBO and Expedia booking links.
-- Scoped to sites.key = 'errin' only. Does not change roost or dad.
-- Safe to paste again. Wrapped in begin/commit. No em dashes.
-- Book Now order stays direct (when present), Airbnb, VRBO, Expedia.
-- Paste after 20261112120000_errin_properties.sql.

begin;

do $guard$
begin
  if not exists (select 1 from public.sites where key = 'errin') then
    raise exception 'Errin site is missing. Run 20261112000000_errin_site.sql before this file.';
  end if;
  if (
    select count(*)
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'errin'
      and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
  ) <> 3 then
    raise exception 'Errin properties are missing. Run 20261112120000_errin_properties.sql first.';
  end if;
end
$guard$;

-- Expedia must be allowed as a booking channel (idempotent with the dad Expedia migration).
alter table public.booking_links drop constraint if exists booking_links_channel;
alter table public.booking_links
  add constraint booking_links_channel check (
    channel in ('airbnb', 'vrbo', 'direct', 'expedia', 'other')
  );

-- Keep Airbnb first among current Errin channels (direct can take sort_order 0 later).
update public.booking_links bl
set
  is_primary = true,
  sort_order = 10,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where bl.property_id = p.id
  and s.key = 'errin'
  and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
  and bl.channel = 'airbnb';

update public.booking_links bl
set
  label = 'Book on VRBO',
  url = v.url,
  is_primary = false,
  sort_order = 20,
  updated_at = now()
from (
  values
    ('winooski-flat', 'https://www.vrbo.com/3213347407ha'),
    ('mill-house', 'https://www.vrbo.com/3161258'),
    ('maple-street-flat', 'https://www.vrbo.com/1824841')
) as v(slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
where bl.property_id = p.id
  and bl.channel = 'vrbo';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'vrbo', 'Book on VRBO', v.url, false, 20
from (
  values
    (
      'e6100000-0000-4000-8000-000000000001'::uuid,
      'winooski-flat',
      'https://www.vrbo.com/3213347407ha'
    ),
    (
      'e6100000-0000-4000-8000-000000000002'::uuid,
      'mill-house',
      'https://www.vrbo.com/3161258'
    ),
    (
      'e6100000-0000-4000-8000-000000000003'::uuid,
      'maple-street-flat',
      'https://www.vrbo.com/1824841'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
where not exists (
  select 1
  from public.booking_links existing
  where existing.property_id = p.id
    and existing.channel = 'vrbo'
)
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  url = excluded.url,
  is_primary = false,
  sort_order = excluded.sort_order,
  updated_at = now();

update public.booking_links bl
set
  label = 'Book on Expedia',
  url = v.url,
  is_primary = false,
  sort_order = 30,
  updated_at = now()
from (
  values
    (
      'winooski-flat',
      'https://www.expedia.com/Winooski-Hotels-Cozy-2bdrm-Apt-Walk-Downtown-Bring-Your-Pets.h92786475.Hotel-Information'
    ),
    (
      'mill-house',
      'https://www.expedia.com/Winooski-Hotels-Large-Cozy-And-Peaceful-Apartment-Walk-Anywhere.h89988135.Hotel-Information'
    ),
    (
      'maple-street-flat',
      'https://www.expedia.com/Burlington-Hotels-Cozy-2-Bedroom-Clean-And-Quiet-Maple-St-Walk-Anywhere.h44268702.Hotel-Information'
    )
) as v(slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
where bl.property_id = p.id
  and bl.channel = 'expedia';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'expedia', 'Book on Expedia', v.url, false, 30
from (
  values
    (
      'e6200000-0000-4000-8000-000000000001'::uuid,
      'winooski-flat',
      'https://www.expedia.com/Winooski-Hotels-Cozy-2bdrm-Apt-Walk-Downtown-Bring-Your-Pets.h92786475.Hotel-Information'
    ),
    (
      'e6200000-0000-4000-8000-000000000002'::uuid,
      'mill-house',
      'https://www.expedia.com/Winooski-Hotels-Large-Cozy-And-Peaceful-Apartment-Walk-Anywhere.h89988135.Hotel-Information'
    ),
    (
      'e6200000-0000-4000-8000-000000000003'::uuid,
      'maple-street-flat',
      'https://www.expedia.com/Burlington-Hotels-Cozy-2-Bedroom-Clean-And-Quiet-Maple-St-Walk-Anywhere.h44268702.Hotel-Information'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
where not exists (
  select 1
  from public.booking_links existing
  where existing.property_id = p.id
    and existing.channel = 'expedia'
)
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  url = excluded.url,
  is_primary = false,
  sort_order = excluded.sort_order,
  updated_at = now();

do $check$
declare
  vrbo_count integer;
  expedia_count integer;
begin
  select count(*) into vrbo_count
  from public.booking_links bl
  join public.properties p on p.id = bl.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and bl.channel = 'vrbo'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat');

  if vrbo_count <> 3 then
    raise exception 'Expected 3 errin VRBO booking links, found %.', vrbo_count;
  end if;

  select count(*) into expedia_count
  from public.booking_links bl
  join public.properties p on p.id = bl.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and bl.channel = 'expedia'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat');

  if expedia_count <> 3 then
    raise exception 'Expected 3 errin Expedia booking links, found %.', expedia_count;
  end if;
end
$check$;

notify pgrst, 'reload schema';

commit;
