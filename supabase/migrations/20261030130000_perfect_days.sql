-- Perfect day itineraries for all three stays.
-- Paste after 20261030120000_guest_notes.sql. Safe to paste again.
-- Each place is matched once by name in recommendations, then linked to each stay.
-- A later paste fills in a missing stop and leaves a stop you already edited.

create table if not exists public.itineraries (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  season text not null,
  title text not null default 'Our perfect day',
  sort_order integer not null default 0,
  is_visible boolean not null default true,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint itineraries_season check (season in ('fall', 'winter')),
  constraint itineraries_title check (char_length(btrim(title)) between 1 and 120),
  constraint itineraries_sort_order check (sort_order >= 0),
  constraint itineraries_property_season unique (property_id, season)
);

create table if not exists public.itinerary_stops (
  id uuid primary key default gen_random_uuid(),
  itinerary_id uuid not null references public.itineraries (id) on delete cascade,
  recommendation_id uuid references public.recommendations (id) on delete set null,
  time_label text not null,
  name text not null,
  detail text not null,
  sort_order integer not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint itinerary_stops_time_label check (char_length(btrim(time_label)) between 1 and 40),
  constraint itinerary_stops_name check (char_length(btrim(name)) between 1 and 120),
  constraint itinerary_stops_detail check (char_length(btrim(detail)) between 1 and 280),
  constraint itinerary_stops_sort_order check (sort_order >= 0),
  constraint itinerary_stops_itinerary_sort unique (itinerary_id, sort_order)
);

drop trigger if exists itineraries_set_updated_at on public.itineraries;
create trigger itineraries_set_updated_at
  before update on public.itineraries
  for each row execute function public.set_updated_at();

drop trigger if exists itinerary_stops_set_updated_at on public.itinerary_stops;
create trigger itinerary_stops_set_updated_at
  before update on public.itinerary_stops
  for each row execute function public.set_updated_at();

alter table public.itineraries enable row level security;
alter table public.itinerary_stops enable row level security;

revoke all on table public.itineraries from anon, authenticated;
revoke all on table public.itinerary_stops from anon, authenticated;

grant select (
  id, property_id, season, title, sort_order, is_visible, published_at
) on public.itineraries to anon;
grant select, insert, update, delete on public.itineraries to authenticated;

grant select (
  id, itinerary_id, recommendation_id, time_label, name, detail, sort_order
) on public.itinerary_stops to anon;
grant select, insert, update, delete on public.itinerary_stops to authenticated;

drop policy if exists itineraries_public_read on public.itineraries;
create policy itineraries_public_read on public.itineraries
  for select to anon
  using (
    is_visible
    and published_at is not null
    and exists (
      select 1
      from public.properties p
      where p.id = itineraries.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

drop policy if exists itineraries_staff on public.itineraries;
create policy itineraries_staff on public.itineraries
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

drop policy if exists itinerary_stops_public_read on public.itinerary_stops;
create policy itinerary_stops_public_read on public.itinerary_stops
  for select to anon
  using (
    exists (
      select 1
      from public.itineraries i
      join public.properties p on p.id = i.property_id
      where i.id = itinerary_stops.itinerary_id
        and i.is_visible
        and i.published_at is not null
        and p.status = 'published'
        and p.published_at is not null
    )
  );

drop policy if exists itinerary_stops_staff on public.itinerary_stops;
create policy itinerary_stops_staff on public.itinerary_stops
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

do $seed$
declare
  missing text;
begin
  if not exists (select 1 from public.properties where slug = 'raddish-roost')
    or not exists (select 1 from public.properties where slug = 'shallot-chalet')
    or not exists (select 1 from public.properties where slug = 'onion-ranch') then
    raise exception 'One of the three stays was not found. Paste the listing files before this one.';
  end if;

  drop table if exists perfect_day_stops;
  create temporary table perfect_day_stops (
    property_slug text not null,
    season text not null,
    sort_order integer not null,
    time_label text not null,
    place_name text not null,
    detail text not null
  ) on commit drop;

  drop table if exists perfect_day_places;
  create temporary table perfect_day_places (
    place_name text primary key,
    recommendation_id uuid not null
  ) on commit drop;

  insert into perfect_day_stops (property_slug, season, sort_order, time_label, place_name, detail)
  values
    ('raddish-roost', 'fall', 10, 'Morning', 'Black Cap Coffee & Bakery', 'Coffee and a pastry, a short walk from the house.'),
    ('raddish-roost', 'fall', 20, 'Mid-morning', 'Cold Hollow Cider Mill', 'Fresh cider and cider donuts.'),
    ('raddish-roost', 'fall', 30, 'Late morning', 'Stowe Pinnacle', 'Hike for big foliage views.'),
    ('raddish-roost', 'fall', 40, 'Lunch', 'Gallus Handcrafted Pasta', 'Fresh pasta.'),
    ('raddish-roost', 'fall', 50, 'Afternoon', 'Upper Hollow Road', 'A scenic drive through Stowe.'),
    ('raddish-roost', 'fall', 60, 'Afternoon', 'The Alchemist Brewery', 'A stop after the drive.'),
    ('raddish-roost', 'fall', 70, 'Late afternoon', 'Ben & Jerry''s Factory', 'A tour and samples.'),
    ('raddish-roost', 'fall', 80, 'Dinner', 'Prohibition Pig', 'Dinner, then a beer at the brewery around the back.'),
    ('raddish-roost', 'winter', 10, 'Morning', 'K.C.''s Bagel Café', 'Bagels to start the day.'),
    ('raddish-roost', 'winter', 20, 'Day', 'Bolton Valley Resort', 'Ski or ride for the day.'),
    ('raddish-roost', 'winter', 30, 'Day', 'Stowe Mountain Resort', 'Ski or ride for the day.'),
    ('raddish-roost', 'winter', 40, 'Après', 'The Reservoir', 'A pint and casual bites.'),
    ('raddish-roost', 'winter', 50, 'Dinner', 'Blackback Pub', 'Dinner at the pub.'),
    ('raddish-roost', 'winter', 60, 'Night', 'Bolton Valley Resort', 'Night skiing is a fun alternative to an early night.');

  insert into perfect_day_stops (property_slug, season, sort_order, time_label, place_name, detail)
  select stay.slug, day.season, day.sort_order, day.time_label, day.place_name, day.detail
  from (values ('shallot-chalet'::text), ('onion-ranch'::text)) as stay(slug)
  cross join (
    values
      ('fall'::text, 10, 'Morning'::text, 'Scout Coffee'::text, 'Coffee to start the morning.'::text),
      ('fall', 20, 'Morning', 'Winooski Falls and river trails', 'A walk along the falls and the river trails.'),
      ('fall', 30, 'Late morning', 'Shelburne Farms', 'Walk the trails and gardens on the lake.'),
      ('fall', 40, 'Lunch', 'Pascolo Ristorante', 'Lunch on Church Street.'),
      ('fall', 50, 'Lunch', 'Church Street', 'Stroll Church Street after lunch.'),
      ('fall', 60, 'Afternoon', 'Mount Philo', 'A hike with Lake Champlain views.'),
      ('fall', 70, 'Sunset', 'Spot on the Dock', 'Drinks at sunset.'),
      ('fall', 80, 'Dinner', 'Waterworks Food + Drink', 'Dinner back in Winooski.'),
      ('fall', 90, 'Nightcap', 'The 126', 'Live music.'),
      ('winter', 10, 'Morning', 'Scout Coffee', 'Coffee to start the morning.'),
      ('winter', 20, 'Day', 'Smugglers'' Notch', 'Ski or ride for the day.'),
      ('winter', 30, 'Day', 'Bolton Valley Resort', 'Ski or ride for the day.'),
      ('winter', 40, 'Day', 'Catamount Outdoor Family Center', 'Snowshoe the trails.'),
      ('winter', 50, 'Après', 'Foam Brewers', 'Craft beer.'),
      ('winter', 60, 'Dinner', 'Honey Road', 'Dinner. Book well in advance.'),
      ('winter', 70, 'After dinner', 'Vermont Comedy Club', 'A show.')
  ) as day(season, sort_order, time_label, place_name, detail);

  select string_agg(place_name, ', ' order by place_name)
  into missing
  from (
    select names.place_name
    from (select distinct place_name from perfect_day_stops) names
    left join public.recommendations r
      on r.name = names.place_name
     and r.is_active
     and r.published_at is not null
    group by names.place_name
    having count(r.id) <> 1
  ) bad;

  if missing is not null then
    raise exception 'A perfect day place is missing or duplicated: %', missing;
  end if;

  insert into perfect_day_places (place_name, recommendation_id)
  select names.place_name, r.id
  from (select distinct place_name from perfect_day_stops) names
  join public.recommendations r
    on r.name = names.place_name
   and r.is_active
   and r.published_at is not null;

  insert into public.property_recommendations (
    property_id, recommendation_id, is_featured, sort_order, published_at
  )
  select distinct p.id, place.recommendation_id, false, 900, now()
  from perfect_day_stops s
  join public.properties p on p.slug = s.property_slug
  join perfect_day_places place on place.place_name = s.place_name
  on conflict (property_id, recommendation_id) do nothing;

  update public.property_recommendations pr
  set published_at = now()
  from perfect_day_stops s
  join public.properties p on p.slug = s.property_slug
  join perfect_day_places place on place.place_name = s.place_name
  where pr.property_id = p.id
    and pr.recommendation_id = place.recommendation_id
    and pr.published_at is null;

  select string_agg(distinct s.property_slug || ': ' || s.place_name, ', ')
  into missing
  from perfect_day_stops s
  join public.properties p on p.slug = s.property_slug
  join perfect_day_places place on place.place_name = s.place_name
  left join public.property_recommendations pr
    on pr.property_id = p.id
   and pr.recommendation_id = place.recommendation_id
   and pr.published_at is not null
  where pr.property_id is null;

  if missing is not null then
    raise exception 'A perfect day place is not linked: %', missing;
  end if;

  insert into public.itineraries (
    property_id, season, title, sort_order, is_visible, published_at
  )
  select p.id, s.season, 'Our perfect day', case s.season when 'fall' then 10 else 20 end, true, now()
  from (select distinct property_slug, season from perfect_day_stops) s
  join public.properties p on p.slug = s.property_slug
  on conflict (property_id, season) do nothing;

  insert into public.itinerary_stops (
    itinerary_id, recommendation_id, time_label, name, detail, sort_order
  )
  select i.id, place.recommendation_id, s.time_label, place.place_name, s.detail, s.sort_order
  from perfect_day_stops s
  join public.properties p on p.slug = s.property_slug
  join public.itineraries i on i.property_id = p.id and i.season = s.season
  join perfect_day_places place on place.place_name = s.place_name
  where not exists (
    select 1
    from public.itinerary_stops existing
    where existing.itinerary_id = i.id
      and existing.sort_order = s.sort_order
  );

  if exists (
    select 1
    from perfect_day_stops s
    join public.properties p on p.slug = s.property_slug
    join public.itineraries i on i.property_id = p.id and i.season = s.season
    left join public.itinerary_stops st
      on st.itinerary_id = i.id
     and st.sort_order = s.sort_order
    where st.id is null
  ) then
    raise exception 'A perfect day stop was not saved.';
  end if;

  if (
    select count(*)
    from public.itinerary_stops st
    join public.itineraries i on i.id = st.itinerary_id
    join public.properties p on p.id = i.property_id
    where p.slug = 'raddish-roost' and i.season = 'fall'
  ) < 8 then
    raise exception 'The Raddish Roost fall day should have 8 stops.';
  end if;

  if (
    select count(*)
    from public.itinerary_stops st
    join public.itineraries i on i.id = st.itinerary_id
    join public.properties p on p.id = i.property_id
    where p.slug = 'raddish-roost' and i.season = 'winter'
  ) < 6 then
    raise exception 'The Raddish Roost winter day should have 6 stops.';
  end if;

  if (
    select count(*)
    from public.itinerary_stops st
    join public.itineraries i on i.id = st.itinerary_id
    join public.properties p on p.id = i.property_id
    where p.slug = 'shallot-chalet' and i.season = 'fall'
  ) < 9
  or (
    select count(*)
    from public.itinerary_stops st
    join public.itineraries i on i.id = st.itinerary_id
    join public.properties p on p.id = i.property_id
    where p.slug = 'onion-ranch' and i.season = 'fall'
  ) < 9 then
    raise exception 'Each Winooski fall day should have 9 stops.';
  end if;

  if (
    select count(*)
    from public.itinerary_stops st
    join public.itineraries i on i.id = st.itinerary_id
    join public.properties p on p.id = i.property_id
    where p.slug = 'shallot-chalet' and i.season = 'winter'
  ) < 7
  or (
    select count(*)
    from public.itinerary_stops st
    join public.itineraries i on i.id = st.itinerary_id
    join public.properties p on p.id = i.property_id
    where p.slug = 'onion-ranch' and i.season = 'winter'
  ) < 7 then
    raise exception 'Each Winooski winter day should have 7 stops.';
  end if;
end;
$seed$;

notify pgrst, 'reload schema';
