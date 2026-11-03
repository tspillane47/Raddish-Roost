-- VRBO booking links for Far & Familiar (dad) stays that list on VRBO.
-- Paste after the dad properties migration.
-- Dad-scoped only. Updates an existing VRBO row; inserts when that stay has none.
-- Switchback Suite, A35 Tennisplace, and Sanibel Sunsets have no VRBO listing.

do $$
begin
  if not exists (select 1 from public.sites where key = 'dad') then
    raise exception 'Dad site is missing. Paste the sites migration before this one.';
  end if;

  if not exists (
    select 1
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'dad'
      and p.slug in (
        'cider-loft',
        'landing-pad',
        'backyard-bungalow',
        'hinesburg-hideaway-3',
        'hinesburg-hideaway-4'
      )
    having count(*) = 5
  ) then
    raise exception 'One of the five dad VRBO stays was not found. Paste the dad properties file before this one.';
  end if;
end;
$$;

update public.booking_links bl
set
  label = 'Book on VRBO',
  url = v.url,
  is_primary = false,
  sort_order = 20
from (
  values
    ('cider-loft', 'https://www.vrbo.com/4222612'),
    ('landing-pad', 'https://www.vrbo.com/4469922'),
    ('backyard-bungalow', 'https://www.vrbo.com/4663810'),
    ('hinesburg-hideaway-3', 'https://www.vrbo.com/5287610'),
    ('hinesburg-hideaway-4', 'https://www.vrbo.com/4469930')
) as v(slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'dad'
where bl.property_id = p.id
  and bl.channel = 'vrbo';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'vrbo', 'Book on VRBO', v.url, false, 20
from (
  values
    (
      'd7000000-0000-4000-8000-000000000001'::uuid,
      'cider-loft',
      'https://www.vrbo.com/4222612'
    ),
    (
      'd7000000-0000-4000-8000-000000000002'::uuid,
      'landing-pad',
      'https://www.vrbo.com/4469922'
    ),
    (
      'd7000000-0000-4000-8000-000000000003'::uuid,
      'backyard-bungalow',
      'https://www.vrbo.com/4663810'
    ),
    (
      'd7000000-0000-4000-8000-000000000004'::uuid,
      'hinesburg-hideaway-3',
      'https://www.vrbo.com/5287610'
    ),
    (
      'd7000000-0000-4000-8000-000000000005'::uuid,
      'hinesburg-hideaway-4',
      'https://www.vrbo.com/4469930'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'dad'
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
  sort_order = excluded.sort_order;

notify pgrst, 'reload schema';
