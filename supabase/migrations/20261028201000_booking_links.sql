-- Booking links and booking click tracking.
-- Paste once in the Supabase SQL Editor after the listing files.
-- Saves each property's Airbnb link without adding a second row.
-- Direct and VRBO stay empty until those addresses are ready.
-- Booking addresses must be https. The booking_links table already requires that.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'raddish-roost')
    or not exists (select 1 from public.properties where slug = 'shallot-chalet')
    or not exists (select 1 from public.properties where slug = 'onion-ranch') then
    raise exception 'One of the three stays was not found. Paste the seed file before this one.';
  end if;
end;
$$;

alter table public.analytics_events
  add column if not exists platform text;

alter table public.analytics_events drop constraint if exists analytics_events_name;
alter table public.analytics_events add constraint analytics_events_name check (
  event_name in (
    'homepage_view',
    'property_select',
    'section_view',
    'recommendation_click',
    'contact_click',
    'rebooking_click',
    'qr_entry',
    'booking_click'
  )
);

alter table public.analytics_events drop constraint if exists analytics_events_platform;
alter table public.analytics_events add constraint analytics_events_platform check (
  platform is null or platform in ('direct', 'airbnb', 'vrbo')
);

alter table public.analytics_events drop constraint if exists analytics_events_booking_platform;
alter table public.analytics_events add constraint analytics_events_booking_platform check (
  event_name <> 'booking_click' or platform is not null
);

grant insert (event_name, property_slug, path, platform) on table public.analytics_events to anon;

drop policy if exists analytics_events_public_insert on public.analytics_events;
create policy analytics_events_public_insert on public.analytics_events
  for insert to anon
  with check (
    event_name = 'booking_click'
    and platform in ('direct', 'airbnb', 'vrbo')
    and property_slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'
  );

update public.booking_links bl
set
  label = 'Book on Airbnb',
  url = v.url,
  is_primary = true
from (
  values
    ('raddish-roost', 'https://www.airbnb.com/rooms/1477625352327415954'),
    ('shallot-chalet', 'https://www.airbnb.com/rooms/1064639214342902592'),
    ('onion-ranch', 'https://www.airbnb.com/rooms/862913226430309914')
) as v(slug, url)
join public.properties p on p.slug = v.slug
where bl.property_id = p.id
  and bl.channel = 'airbnb';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'airbnb', 'Book on Airbnb', v.url, true, 10
from (
  values
    (
      'f6000000-0000-4000-8000-000000000002'::uuid,
      'raddish-roost',
      'https://www.airbnb.com/rooms/1477625352327415954'
    ),
    (
      'f6000000-0000-4000-8000-000000000012'::uuid,
      'shallot-chalet',
      'https://www.airbnb.com/rooms/1064639214342902592'
    ),
    (
      'f6000000-0000-4000-8000-000000000022'::uuid,
      'onion-ranch',
      'https://www.airbnb.com/rooms/862913226430309914'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
where not exists (
  select 1
  from public.booking_links existing
  where existing.property_id = p.id
    and existing.channel = 'airbnb'
)
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  url = excluded.url,
  is_primary = true,
  sort_order = excluded.sort_order;

notify pgrst, 'reload schema';
