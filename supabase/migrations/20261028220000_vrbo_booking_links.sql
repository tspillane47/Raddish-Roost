-- VRBO booking links for the three stays.
-- Paste once in the Supabase SQL Editor after the booking links file.
-- Updates an existing VRBO row. Inserts one only when that stay has none.
-- Direct booking links are not added here.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'raddish-roost')
    or not exists (select 1 from public.properties where slug = 'shallot-chalet')
    or not exists (select 1 from public.properties where slug = 'onion-ranch') then
    raise exception 'One of the three stays was not found. Paste the seed file before this one.';
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
    ('raddish-roost', 'https://www.vrbo.com/p4832729vb'),
    ('shallot-chalet', 'https://www.vrbo.com/p4832731vb'),
    ('onion-ranch', 'https://www.vrbo.com/p4832726vb')
) as v(slug, url)
join public.properties p on p.slug = v.slug
where bl.property_id = p.id
  and bl.channel = 'vrbo';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'vrbo', 'Book on VRBO', v.url, false, 20
from (
  values
    (
      'f6000000-0000-4000-8000-000000000003'::uuid,
      'raddish-roost',
      'https://www.vrbo.com/p4832729vb'
    ),
    (
      'f6000000-0000-4000-8000-000000000013'::uuid,
      'shallot-chalet',
      'https://www.vrbo.com/p4832731vb'
    ),
    (
      'f6000000-0000-4000-8000-000000000023'::uuid,
      'onion-ranch',
      'https://www.vrbo.com/p4832726vb'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
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
