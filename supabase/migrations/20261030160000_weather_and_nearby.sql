-- Town-level weather coordinates and nearby essentials for all three stays.
-- Coordinates are town centers, not street addresses.
-- Safe to paste again. An existing place name or map link is left as you saved it.

alter table public.properties
  add column if not exists weather_latitude numeric,
  add column if not exists weather_longitude numeric;

alter table public.properties drop constraint if exists properties_weather_coordinates;
alter table public.properties add constraint properties_weather_coordinates check (
  (
    weather_latitude is null
    and weather_longitude is null
  )
  or (
    weather_latitude between -90 and 90
    and weather_longitude between -180 and 180
  )
);

grant select (weather_latitude, weather_longitude) on public.properties to anon;

update public.properties
set
  weather_latitude = 44.3378,
  weather_longitude = -72.7562
where slug = 'raddish-roost'
  and weather_latitude is null
  and weather_longitude is null;

update public.properties
set
  weather_latitude = 44.4914,
  weather_longitude = -73.1854
where slug in ('shallot-chalet', 'onion-ranch')
  and weather_latitude is null
  and weather_longitude is null;

create table if not exists public.nearby_essentials (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  kind text not null,
  label text not null,
  search_query text not null,
  place_name text,
  maps_url text,
  note text,
  sort_order integer not null default 0,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint nearby_essentials_kind check (
    kind in ('grocery', 'pharmacy', 'gas', 'urgent_care', 'hospital')
  ),
  constraint nearby_essentials_label check (char_length(btrim(label)) between 1 and 80),
  constraint nearby_essentials_search check (char_length(btrim(search_query)) between 1 and 160),
  constraint nearby_essentials_place_name check (
    place_name is null or char_length(btrim(place_name)) between 1 and 120
  ),
  constraint nearby_essentials_maps_url check (maps_url is null or maps_url ~ '^https://'),
  constraint nearby_essentials_note check (note is null or char_length(btrim(note)) between 1 and 200),
  constraint nearby_essentials_sort_order check (sort_order >= 0),
  constraint nearby_essentials_property_kind unique (property_id, kind)
);

drop trigger if exists nearby_essentials_set_updated_at on public.nearby_essentials;
create trigger nearby_essentials_set_updated_at
  before update on public.nearby_essentials
  for each row execute function public.set_updated_at();

alter table public.nearby_essentials enable row level security;

revoke all on table public.nearby_essentials from anon, authenticated;

grant select (
  id, property_id, kind, label, search_query, place_name, maps_url, note, sort_order, published_at
) on public.nearby_essentials to anon;
grant select, insert, update, delete on public.nearby_essentials to authenticated;

drop policy if exists nearby_essentials_public_read on public.nearby_essentials;
create policy nearby_essentials_public_read on public.nearby_essentials
  for select to anon
  using (
    published_at is not null
    and exists (
      select 1
      from public.properties p
      where p.id = nearby_essentials.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

drop policy if exists nearby_essentials_staff on public.nearby_essentials;
create policy nearby_essentials_staff on public.nearby_essentials
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

insert into public.nearby_essentials (
  property_id, kind, label, search_query, note, sort_order, published_at
)
select p.id, item.kind, item.label, item.search_lead || ' ' || town.town, item.note, item.sort_order, now()
from public.properties p
join (
  values
    ('raddish-roost', 'Waterbury, VT'),
    ('shallot-chalet', 'Winooski, VT'),
    ('onion-ranch', 'Winooski, VT')
) as town(slug, town) on town.slug = p.slug
cross join (
  values
    ('grocery'::text, 'Grocery store'::text, 'grocery store near'::text, null::text, 10),
    ('pharmacy', 'Pharmacy', 'pharmacy near', null, 20),
    ('gas', 'Gas station', 'gas station near', null, 30),
    ('urgent_care', 'Urgent care', 'urgent care near', null, 40),
    ('hospital', 'Hospital (ER)', 'hospital near', 'For emergencies, call 911.', 50)
) as item(kind, label, search_lead, note, sort_order)
where not exists (
  select 1
  from public.nearby_essentials existing
  where existing.property_id = p.id
    and existing.kind = item.kind
);

notify pgrst, 'reload schema';
