-- Dad-scoped Sanibel Island Things to Do for A35 Tennisplace and Sanibel Sunsets.
-- Shared recommendations (one row per place) link to both condos. Safe to paste again.
-- Paste after 20261103160000_dad_check_in_checkout.sql.

do $guard$
begin
  if not exists (select 1 from public.sites where key = 'dad') then
    raise exception 'Dad site is missing. Run the sites migration before this file.';
  end if;

  if (
    select count(*)
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'dad'
      and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  ) <> 2 then
    raise exception 'Dad Sanibel properties are missing. Run the dad properties migration first.';
  end if;
end
$guard$;

-- Allow Beaches, Groceries, and On the Water section tabs.
alter table public.recommendations drop constraint if exists recommendations_subcategory;
alter table public.recommendations
  add constraint recommendations_subcategory check (
    subcategory is null or subcategory in (
      'eat', 'drink', 'coffee', 'ski_ride', 'see', 'hike', 'bike', 'winter_fun', 'sweet_treats',
      'beaches', 'groceries', 'on_the_water'
    )
  );

-- Named Perfect Day options (keep fall/winter for Vermont stays).
alter table public.itineraries drop constraint if exists itineraries_season;
alter table public.itineraries
  add constraint itineraries_season check (season ~ '^[a-z][a-z0-9_]{0,39}$');

-- Shared Sanibel places. host_note stays null. Maps search uses name + town + Florida.
do $places$
declare
  rec record;
  rid uuid;
  maps text;
  query_text text;
begin
  for rec in
    select *
    from (
      values
        (
          'd3100000-0000-4000-8000-000000000001'::uuid,
          'Bowman''s Beach',
          'outdoors',
          'beaches',
          'year_round',
          'Sanibel',
          'A quieter, more natural beach on the west end, known as one of the island''s best for shelling. Bring a cart or travel light, since it''s a short walk from the parking lot.'
        ),
        (
          'd3100000-0000-4000-8000-000000000002'::uuid,
          'Lighthouse Beach Park',
          'outdoors',
          'beaches',
          'year_round',
          'Sanibel',
          'At the east tip of the island beside the historic Sanibel Lighthouse, with a nature trail and bay views. The fishing pier is still closed for rebuilding.'
        ),
        (
          'd3100000-0000-4000-8000-000000000003'::uuid,
          'Gulfside City Park Beach',
          'outdoors',
          'beaches',
          'year_round',
          'Sanibel',
          'A calm, family-friendly beach with picnic areas, good for a relaxed afternoon.'
        ),
        (
          'd3100000-0000-4000-8000-000000000004'::uuid,
          'Tarpon Bay Road Beach',
          'outdoors',
          'beaches',
          'year_round',
          'Sanibel',
          'A central, easy-to-reach beach that works well for families.'
        ),
        (
          'd3100000-0000-4000-8000-000000000005'::uuid,
          'Blind Pass Beach',
          'outdoors',
          'beaches',
          'year_round',
          'Sanibel',
          'Excellent shelling at the pass between Sanibel and Captiva. Currents can be strong here, so use caution swimming.'
        ),
        (
          'd3100000-0000-4000-8000-000000000006'::uuid,
          'Turner Beach',
          'outdoors',
          'beaches',
          'year_round',
          'Captiva',
          'On the Captiva side of Blind Pass, a favorite spot for sunsets and shelling. Strong currents near the pass.'
        ),
        (
          'd3100000-0000-4000-8000-000000000007'::uuid,
          'Causeway Beach Park',
          'outdoors',
          'beaches',
          'year_round',
          'Sanibel',
          'Beach along the causeway islands, popular for water sports and views of the bay.'
        ),
        (
          'd3100000-0000-4000-8000-000000000008'::uuid,
          'Sanibel Sprout',
          'food_drink',
          'coffee',
          'year_round',
          'Sanibel',
          'A cozy cafe serving organic, plant-based food, smoothies, and coffee.'
        ),
        (
          'd3100000-0000-4000-8000-000000000009'::uuid,
          'Over Easy Cafe',
          'food_drink',
          'coffee',
          'year_round',
          'Sanibel',
          'A longtime island favorite for breakfast and lunch, now in a new location on Periwinkle Way.'
        ),
        (
          'd3100000-0000-4000-8000-000000000010'::uuid,
          'The Sanibel Cafe',
          'food_drink',
          'coffee',
          'year_round',
          'Sanibel',
          'Made-from-scratch breakfast and lunch, served on its famous seashell-filled tables in the Tahitian Gardens plaza.'
        ),
        (
          'd3100000-0000-4000-8000-000000000011'::uuid,
          'Doc Ford''s Rum Bar & Grille',
          'food_drink',
          'eat',
          'year_round',
          'Sanibel',
          'A lively island institution with a Caribbean-inspired menu and rum drinks.'
        ),
        (
          'd3100000-0000-4000-8000-000000000012'::uuid,
          'Timbers Restaurant & Fish Market',
          'food_drink',
          'eat',
          'year_round',
          'Sanibel',
          'A local favorite for fresh seafood, with a fish market on site.'
        ),
        (
          'd3100000-0000-4000-8000-000000000013'::uuid,
          'Gramma Dot''s',
          'food_drink',
          'eat',
          'year_round',
          'Sanibel',
          'A classic seaside spot for lunch and dinner inside the Sanibel Marina.'
        ),
        (
          'd3100000-0000-4000-8000-000000000014'::uuid,
          'Cielo',
          'food_drink',
          'eat',
          'year_round',
          'Sanibel',
          'A more upscale choice with fresh seafood, house-made pasta, and craft cocktails.'
        ),
        (
          'd3100000-0000-4000-8000-000000000015'::uuid,
          'The Bubble Room',
          'food_drink',
          'eat',
          'year_round',
          'Captiva',
          'A whimsical, one-of-a-kind restaurant famous for its nostalgic decor and giant layered cakes. No reservations.'
        ),
        (
          'd3100000-0000-4000-8000-000000000016'::uuid,
          'The Mucky Duck',
          'food_drink',
          'eat',
          'year_round',
          'Captiva',
          'A beachfront Captiva classic, great for watching the sunset.'
        ),
        (
          'd3100000-0000-4000-8000-000000000017'::uuid,
          'The Shack of Sanibel',
          'food_drink',
          'sweet_treats',
          'year_round',
          'Sanibel',
          'Fresh frozen custard with build-your-own toppings.'
        ),
        (
          'd3100000-0000-4000-8000-000000000018'::uuid,
          'Pinocchio''s Original Italian Ice Cream',
          'food_drink',
          'sweet_treats',
          'year_round',
          'Sanibel',
          'A Sanibel favorite at Periwinkle Place, known for its creative flavors.'
        ),
        (
          'd3100000-0000-4000-8000-000000000019'::uuid,
          'Boops by The Bubble Room',
          'food_drink',
          'sweet_treats',
          'year_round',
          'Captiva',
          'Grab a slice of the Bubble Room''s famous cakes to go.'
        ),
        (
          'd3100000-0000-4000-8000-000000000020'::uuid,
          'Jerry''s Foods',
          'shopping',
          'groceries',
          'year_round',
          'Sanibel',
          'The island''s full-size grocery store on Periwinkle Way.'
        ),
        (
          'd3100000-0000-4000-8000-000000000021'::uuid,
          'A Bit of Bailey''s',
          'shopping',
          'groceries',
          'year_round',
          'Sanibel',
          'The Bailey family''s market on Rabbit Road with groceries, deli items, and wine, while the original Bailey''s General Store is rebuilt.'
        ),
        (
          'd3100000-0000-4000-8000-000000000022'::uuid,
          'J.N. "Ding" Darling National Wildlife Refuge',
          'outdoors',
          'see',
          'year_round',
          'Sanibel',
          'A huge protected refuge with Wildlife Drive, trails, and a visitor center. Great for birding, especially early morning.'
        ),
        (
          'd3100000-0000-4000-8000-000000000023'::uuid,
          'Bailey-Matthews National Shell Museum & Aquarium',
          'family',
          'see',
          'year_round',
          'Sanibel',
          'Fascinating exhibits on shells and sea life. A perfect rainy day stop.'
        ),
        (
          'd3100000-0000-4000-8000-000000000024'::uuid,
          'Island biking',
          'outdoors',
          'see',
          'year_round',
          'Sanibel',
          'Sanibel has miles of shared-use paths, making bikes one of the best ways to get around. Your condo may include bikes, so check before renting.'
        ),
        (
          'd3100000-0000-4000-8000-000000000025'::uuid,
          'Tarpon Bay Explorers',
          'outdoors',
          'on_the_water',
          'year_round',
          'Sanibel',
          'The official concessionaire for Ding Darling, offering kayak and paddleboard rentals, guided kayak tours, and eco-cruises. Reservations recommended.'
        ),
        (
          'd3100000-0000-4000-8000-000000000026'::uuid,
          'Adventures in Paradise',
          'outdoors',
          'on_the_water',
          'year_round',
          'Sanibel',
          'Family-run since 1986, with dolphin and wildlife cruises, shelling trips, and sunset cruises.'
        )
    ) as v(id, name, category, subcategory, season, town, description)
  loop
    select r.id
    into rid
    from public.recommendations r
    where r.name = rec.name
    order by r.created_at
    limit 1;

    query_text := rec.name || ' ' || rec.town || ' Florida';
    maps := 'https://www.google.com/maps/search/?api=1&query=' || replace(
      replace(
        replace(
          replace(
            replace(
              replace(query_text, '%', '%25'),
              '&', '%26'
            ),
            '+', '%2B'
          ),
          '/', '%2F'
        ),
        '''', '%27'
      ),
      ' ', '%20'
    );

    if rid is null then
      insert into public.recommendations (
        id,
        category,
        subcategory,
        season,
        is_active,
        name,
        description,
        host_note,
        address,
        website_url,
        maps_url,
        town,
        published_at
      )
      values (
        rec.id,
        rec.category,
        rec.subcategory,
        rec.season,
        true,
        rec.name,
        rec.description,
        null,
        null,
        null,
        maps,
        rec.town,
        now()
      )
      on conflict (id) do update
      set
        category = excluded.category,
        subcategory = excluded.subcategory,
        season = excluded.season,
        is_active = true,
        name = excluded.name,
        description = coalesce(public.recommendations.description, excluded.description),
        maps_url = coalesce(public.recommendations.maps_url, excluded.maps_url),
        town = coalesce(public.recommendations.town, excluded.town),
        published_at = coalesce(public.recommendations.published_at, now()),
        updated_at = now();
    else
      update public.recommendations
      set
        category = coalesce(category, rec.category),
        subcategory = coalesce(subcategory, rec.subcategory),
        season = coalesce(season, rec.season),
        is_active = true,
        description = coalesce(description, rec.description),
        maps_url = coalesce(maps_url, maps),
        town = coalesce(town, rec.town),
        published_at = coalesce(published_at, now()),
        updated_at = now()
      where id = rid;
    end if;
  end loop;
end
$places$;

-- Link every Sanibel place to both condos. Same tags on both. host_note stays null.
insert into public.property_recommendations (
  property_id,
  recommendation_id,
  custom_description,
  is_featured,
  sort_order,
  published_at,
  host_note,
  guest_tags
)
select
  dad.id,
  place.id,
  null,
  false,
  wanted.sort_order,
  now(),
  null,
  wanted.guest_tags
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join (
  values
    ('Bowman''s Beach', 10, array['kid_friendly']::text[]),
    ('Lighthouse Beach Park', 20, array['kid_friendly']::text[]),
    ('Gulfside City Park Beach', 30, array['kid_friendly']::text[]),
    ('Tarpon Bay Road Beach', 40, array['kid_friendly']::text[]),
    ('Blind Pass Beach', 50, '{}'::text[]),
    ('Turner Beach', 60, '{}'::text[]),
    ('Causeway Beach Park', 70, array['kid_friendly']::text[]),
    ('Sanibel Sprout', 80, array['rainy_day']::text[]),
    ('Over Easy Cafe', 90, array['rainy_day']::text[]),
    ('The Sanibel Cafe', 100, array['rainy_day']::text[]),
    ('Doc Ford''s Rum Bar & Grille', 110, array['rainy_day']::text[]),
    ('Timbers Restaurant & Fish Market', 120, array['rainy_day']::text[]),
    ('Gramma Dot''s', 130, array['rainy_day']::text[]),
    ('Cielo', 140, array['rainy_day']::text[]),
    ('The Bubble Room', 150, array['rainy_day', 'kid_friendly']::text[]),
    ('The Mucky Duck', 160, array['rainy_day']::text[]),
    ('The Shack of Sanibel', 170, array['rainy_day', 'kid_friendly']::text[]),
    ('Pinocchio''s Original Italian Ice Cream', 180, array['rainy_day', 'kid_friendly']::text[]),
    ('Boops by The Bubble Room', 190, array['rainy_day', 'kid_friendly']::text[]),
    ('Jerry''s Foods', 200, array['rainy_day']::text[]),
    ('A Bit of Bailey''s', 210, array['rainy_day']::text[]),
    ('J.N. "Ding" Darling National Wildlife Refuge', 220, array['kid_friendly']::text[]),
    ('Bailey-Matthews National Shell Museum & Aquarium', 230, array['rainy_day', 'kid_friendly']::text[]),
    ('Island biking', 240, '{}'::text[]),
    ('Tarpon Bay Explorers', 250, array['kid_friendly']::text[]),
    ('Adventures in Paradise', 260, array['kid_friendly']::text[])
) as wanted(name, sort_order, guest_tags) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug in ('tennisplace-a35', 'sanibel-sunsets')
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = null,
  guest_tags = excluded.guest_tags,
  custom_description = null;

-- Refresh section blurb for both Florida stays.
update public.guidebook_sections sec
set
  summary = 'Beaches, shelling, Ding Darling, Captiva favorites, and a few perfect island days.',
  published_at = coalesce(sec.published_at, now()),
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'things_to_do';

-- Named Perfect Day options for both Sanibel condos.
do $days$
declare
  prop record;
  day record;
  stop record;
  iid uuid;
  place_id uuid;
begin
  for prop in
    select p.id, p.slug
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'dad'
      and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  loop

    insert into public.itineraries (
      property_id, season, title, sort_order, is_visible, published_at
    )
    values (
      prop.id,
      'beach_day',
      'The Perfect Beach Day',
      10,
      true,
      now()
    )
    on conflict (property_id, season) do update
    set
      title = excluded.title,
      sort_order = excluded.sort_order,
      is_visible = true,
      published_at = coalesce(public.itineraries.published_at, now()),
      updated_at = now();

    select i.id into iid
    from public.itineraries i
    where i.property_id = prop.id and i.season = 'beach_day';

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Sanibel Sprout'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Morning', 'Sanibel Sprout', 'Start with coffee and something plant-based before the beach.', 10
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 10
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Morning',
      name = 'Sanibel Sprout',
      detail = 'Start with coffee and something plant-based before the beach.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 10;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Bowman''s Beach'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Midday', 'Bowman''s Beach', 'Spend the morning shelling on this quieter west-end beach.', 20
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 20
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Midday',
      name = 'Bowman''s Beach',
      detail = 'Spend the morning shelling on this quieter west-end beach.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 20;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'The Shack of Sanibel'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Afternoon', 'The Shack of Sanibel', 'Cool off with frozen custard and your own toppings.', 30
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 30
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Afternoon',
      name = 'The Shack of Sanibel',
      detail = 'Cool off with frozen custard and your own toppings.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 30;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Timbers Restaurant & Fish Market'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Evening', 'Timbers Restaurant & Fish Market', 'Fresh seafood dinner, with a fish market on site.', 40
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 40
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Evening',
      name = 'Timbers Restaurant & Fish Market',
      detail = 'Fresh seafood dinner, with a fish market on site.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 40;

    insert into public.itineraries (
      property_id, season, title, sort_order, is_visible, published_at
    )
    values (
      prop.id,
      'nature_day',
      'The Nature Lover''s Day',
      20,
      true,
      now()
    )
    on conflict (property_id, season) do update
    set
      title = excluded.title,
      sort_order = excluded.sort_order,
      is_visible = true,
      published_at = coalesce(public.itineraries.published_at, now()),
      updated_at = now();

    select i.id into iid
    from public.itineraries i
    where i.property_id = prop.id and i.season = 'nature_day';

    select r.id into place_id
    from public.recommendations r
    where r.name = 'The Sanibel Cafe'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Morning', 'The Sanibel Cafe', 'Breakfast on the seashell tables at Tahitian Gardens.', 10
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 10
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Morning',
      name = 'The Sanibel Cafe',
      detail = 'Breakfast on the seashell tables at Tahitian Gardens.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 10;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'J.N. "Ding" Darling National Wildlife Refuge'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Late morning', 'J.N. "Ding" Darling National Wildlife Refuge', 'Drive or bike Wildlife Drive early for the best birding.', 20
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 20
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Late morning',
      name = 'J.N. "Ding" Darling National Wildlife Refuge',
      detail = 'Drive or bike Wildlife Drive early for the best birding.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 20;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Tarpon Bay Explorers'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Midday', 'Tarpon Bay Explorers', 'Kayak, paddleboard, or take an eco-cruise. Reserve ahead.', 30
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 30
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Midday',
      name = 'Tarpon Bay Explorers',
      detail = 'Kayak, paddleboard, or take an eco-cruise. Reserve ahead.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 30;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Bailey-Matthews National Shell Museum & Aquarium'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Afternoon', 'Bailey-Matthews National Shell Museum & Aquarium', 'Shells and sea life indoors when you want a break from the sun.', 40
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 40
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Afternoon',
      name = 'Bailey-Matthews National Shell Museum & Aquarium',
      detail = 'Shells and sea life indoors when you want a break from the sun.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 40;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Doc Ford''s Rum Bar & Grille'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Evening', 'Doc Ford''s Rum Bar & Grille', 'Caribbean-inspired dinner and a rum drink to close the day.', 50
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 50
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Evening',
      name = 'Doc Ford''s Rum Bar & Grille',
      detail = 'Caribbean-inspired dinner and a rum drink to close the day.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 50;

    insert into public.itineraries (
      property_id, season, title, sort_order, is_visible, published_at
    )
    values (
      prop.id,
      'captiva_day',
      'A Day on Captiva',
      30,
      true,
      now()
    )
    on conflict (property_id, season) do update
    set
      title = excluded.title,
      sort_order = excluded.sort_order,
      is_visible = true,
      published_at = coalesce(public.itineraries.published_at, now()),
      updated_at = now();

    select i.id into iid
    from public.itineraries i
    where i.property_id = prop.id and i.season = 'captiva_day';

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Over Easy Cafe'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Morning', 'Over Easy Cafe', 'Breakfast or lunch on Periwinkle Way before you head to Captiva.', 10
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 10
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Morning',
      name = 'Over Easy Cafe',
      detail = 'Breakfast or lunch on Periwinkle Way before you head to Captiva.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 10;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Turner Beach'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Midday', 'Turner Beach', 'Shelling and sunsets on the Captiva side of Blind Pass. Watch the currents.', 20
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 20
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Midday',
      name = 'Turner Beach',
      detail = 'Shelling and sunsets on the Captiva side of Blind Pass. Watch the currents.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 20;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'Adventures in Paradise'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Afternoon', 'Adventures in Paradise', 'Dolphin, wildlife, shelling, or sunset cruise. Family-run since 1986.', 30
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 30
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Afternoon',
      name = 'Adventures in Paradise',
      detail = 'Dolphin, wildlife, shelling, or sunset cruise. Family-run since 1986.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 30;

    select r.id into place_id
    from public.recommendations r
    where r.name = 'The Bubble Room'
    order by r.created_at
    limit 1;

    insert into public.itinerary_stops (
      itinerary_id, recommendation_id, time_label, name, detail, sort_order
    )
    select iid, place_id, 'Evening', 'The Bubble Room', 'Whimsical dinner and giant cakes. No reservations. Or catch sunset at The Mucky Duck.', 40
    where not exists (
      select 1 from public.itinerary_stops existing
      where existing.itinerary_id = iid and existing.sort_order = 40
    );

    update public.itinerary_stops
    set
      recommendation_id = place_id,
      time_label = 'Evening',
      name = 'The Bubble Room',
      detail = 'Whimsical dinner and giant cakes. No reservations. Or catch sunset at The Mucky Duck.',
      updated_at = now()
    where itinerary_id = iid and sort_order = 40;

  end loop;
end
$days$;

-- Spanish and French for place descriptions.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', place.id, 'description', lang.language, lang.text
from public.recommendations place
join (
  values
    ('Bowman''s Beach', 'es', $tr$Una playa más tranquila y natural en el extremo oeste, conocida como una de las mejores de la isla para recoger conchas. Lleva un carrito o viaja ligero: hay un corto paseo desde el aparcamiento.$tr$),
    ('Bowman''s Beach', 'fr', $tr$Une plage plus calme et naturelle à l'ouest de l'île, réputée pour la collecte de coquillages. Prenez un chariot ou voyagez léger: un court trajet à pied depuis le parking.$tr$),
    ('Lighthouse Beach Park', 'es', $tr$En la punta este de la isla, junto al histórico faro de Sanibel, con un sendero natural y vistas a la bahía. El muelle de pesca sigue cerrado por reconstrucción.$tr$),
    ('Lighthouse Beach Park', 'fr', $tr$À la pointe est de l'île, près du phare historique de Sanibel, avec un sentier nature et des vues sur la baie. La jetée de pêche est encore fermée pour reconstruction.$tr$),
    ('Gulfside City Park Beach', 'es', $tr$Una playa tranquila y familiar con zonas de picnic, ideal para una tarde relajada.$tr$),
    ('Gulfside City Park Beach', 'fr', $tr$Une plage calme et familiale avec des aires de pique-nique, idéale pour un après-midi tranquille.$tr$),
    ('Tarpon Bay Road Beach', 'es', $tr$Una playa central y fácil de alcanzar que funciona bien para familias.$tr$),
    ('Tarpon Bay Road Beach', 'fr', $tr$Une plage centrale et facile d'accès, bien adaptée aux familles.$tr$),
    ('Blind Pass Beach', 'es', $tr$Excelente para recoger conchas en el paso entre Sanibel y Captiva. Las corrientes pueden ser fuertes, así que ten cuidado al nadar.$tr$),
    ('Blind Pass Beach', 'fr', $tr$Excellent pour les coquillages au passage entre Sanibel et Captiva. Les courants peuvent être forts: soyez prudent pour nager.$tr$),
    ('Turner Beach', 'es', $tr$En el lado de Captiva de Blind Pass, un lugar favorito para atardeceres y conchas. Corrientes fuertes cerca del paso.$tr$),
    ('Turner Beach', 'fr', $tr$Du côté Captiva de Blind Pass, un spot préféré pour les couchers de soleil et les coquillages. Forts courants près du passage.$tr$),
    ('Causeway Beach Park', 'es', $tr$Playa a lo largo de las islas de la calzada, popular para deportes acuáticos y vistas a la bahía.$tr$),
    ('Causeway Beach Park', 'fr', $tr$Plage le long des îles de la chaussée, populaire pour les sports nautiques et les vues sur la baie.$tr$),
    ('Sanibel Sprout', 'es', $tr$Un café acogedor con comida orgánica de origen vegetal, batidos y café.$tr$),
    ('Sanibel Sprout', 'fr', $tr$Un café chaleureux avec cuisine végétale bio, smoothies et café.$tr$),
    ('Over Easy Cafe', 'es', $tr$Un favorito de la isla para desayuno y almuerzo, ahora en una nueva ubicación en Periwinkle Way.$tr$),
    ('Over Easy Cafe', 'fr', $tr$Un classique de l'île pour le petit-déjeuner et le déjeuner, désormais à une nouvelle adresse sur Periwinkle Way.$tr$),
    ('The Sanibel Cafe', 'es', $tr$Desayuno y almuerzo caseros, servidos en sus famosas mesas llenas de conchas en la plaza Tahitian Gardens.$tr$),
    ('The Sanibel Cafe', 'fr', $tr$Petit-déjeuner et déjeuner faits maison, servis sur ses célèbres tables remplies de coquillages à la place Tahitian Gardens.$tr$),
    ('Doc Ford''s Rum Bar & Grille', 'es', $tr$Una institución animada de la isla con menú de inspiración caribeña y bebidas de ron.$tr$),
    ('Doc Ford''s Rum Bar & Grille', 'fr', $tr$Une institution animée de l'île, menu d'inspiration caraïbe et cocktails au rhum.$tr$),
    ('Timbers Restaurant & Fish Market', 'es', $tr$Un favorito local de mariscos frescos, con pescadería en el mismo sitio.$tr$),
    ('Timbers Restaurant & Fish Market', 'fr', $tr$Un favori local pour les fruits de mer frais, avec une poissonnerie sur place.$tr$),
    ('Gramma Dot''s', 'es', $tr$Un clásico junto al mar para almuerzo y cena dentro del Sanibel Marina.$tr$),
    ('Gramma Dot''s', 'fr', $tr$Un classique en bord de mer pour le déjeuner et le dîner dans le Sanibel Marina.$tr$),
    ('Cielo', 'es', $tr$Una opción más sofisticada con mariscos frescos, pasta casera y cócteles de autor.$tr$),
    ('Cielo', 'fr', $tr$Une option plus raffinée avec fruits de mer frais, pâtes maison et cocktails d'auteur.$tr$),
    ('The Bubble Room', 'es', $tr$Un restaurante caprichoso y único, famoso por su decoración nostálgica y pasteles de capas enormes. Sin reservas.$tr$),
    ('The Bubble Room', 'fr', $tr$Un restaurant fantaisiste et unique, célèbre pour son décor nostalgique et ses gâteaux à étages géants. Pas de réservations.$tr$),
    ('The Mucky Duck', 'es', $tr$Un clásico frente a la playa en Captiva, ideal para ver el atardecer.$tr$),
    ('The Mucky Duck', 'fr', $tr$Un classique face à la plage à Captiva, parfait pour regarder le coucher de soleil.$tr$),
    ('The Shack of Sanibel', 'es', $tr$Custard congelado fresco con toppings a tu gusto.$tr$),
    ('The Shack of Sanibel', 'fr', $tr$Crème glacée custard fraîche avec garnitures à composer soi-même.$tr$),
    ('Pinocchio''s Original Italian Ice Cream', 'es', $tr$Un favorito de Sanibel en Periwinkle Place, conocido por sus sabores creativos.$tr$),
    ('Pinocchio''s Original Italian Ice Cream', 'fr', $tr$Un favori de Sanibel à Periwinkle Place, connu pour ses parfums créatifs.$tr$),
    ('Boops by The Bubble Room', 'es', $tr$Lleva una porción de los famosos pasteles de The Bubble Room para llevar.$tr$),
    ('Boops by The Bubble Room', 'fr', $tr$Emportez une part des célèbres gâteaux de The Bubble Room.$tr$),
    ('Jerry''s Foods', 'es', $tr$El supermercado completo de la isla en Periwinkle Way.$tr$),
    ('Jerry''s Foods', 'fr', $tr$Le supermarché complet de l'île sur Periwinkle Way.$tr$),
    ('A Bit of Bailey''s', 'es', $tr$El mercado de la familia Bailey en Rabbit Road, con comestibles, delicatessen y vino, mientras se reconstruye el Bailey's General Store original.$tr$),
    ('A Bit of Bailey''s', 'fr', $tr$Le marché de la famille Bailey sur Rabbit Road, avec épicerie, traiteur et vins, pendant la reconstruction du Bailey's General Store d'origine.$tr$),
    ('J.N. "Ding" Darling National Wildlife Refuge', 'es', $tr$Un gran refugio protegido con Wildlife Drive, senderos y centro de visitantes. Ideal para observar aves, sobre todo temprano por la mañana.$tr$),
    ('J.N. "Ding" Darling National Wildlife Refuge', 'fr', $tr$Un vaste refuge protégé avec Wildlife Drive, sentiers et centre d'accueil. Idéal pour l'observation des oiseaux, surtout tôt le matin.$tr$),
    ('Bailey-Matthews National Shell Museum & Aquarium', 'es', $tr$Exposiciones fascinantes sobre conchas y vida marina. Una parada perfecta en un día de lluvia.$tr$),
    ('Bailey-Matthews National Shell Museum & Aquarium', 'fr', $tr$Des expositions fascinantes sur les coquillages et la vie marine. Une halte parfaite les jours de pluie.$tr$),
    ('Island biking', 'es', $tr$Sanibel tiene kilómetros de caminos compartidos; la bici es una de las mejores formas de moverse. Tu condo puede incluir bicis, así que comprueba antes de alquilar.$tr$),
    ('Island biking', 'fr', $tr$Sanibel offre des kilomètres de pistes partagées: le vélo est l'un des meilleurs moyens de se déplacer. Votre condo peut inclure des vélos, vérifiez avant de louer.$tr$),
    ('Tarpon Bay Explorers', 'es', $tr$El concesionario oficial de Ding Darling: alquiler de kayaks y paddleboards, tours guiados en kayak y eco-cruceros. Se recomiendan reservas.$tr$),
    ('Tarpon Bay Explorers', 'fr', $tr$Le concessionnaire officiel de Ding Darling: location de kayaks et paddleboards, sorties guidées en kayak et eco-croisières. Réservation recommandée.$tr$),
    ('Adventures in Paradise', 'es', $tr$Empresa familiar desde 1986, con cruceros de delfines y fauna, viajes de conchas y cruceros al atardecer.$tr$),
    ('Adventures in Paradise', 'fr', $tr$Entreprise familiale depuis 1986, avec croisières dauphins et faune, sorties coquillages et croisières au coucher du soleil.$tr$)
) as lang(name, language, text) on true
where place.name = lang.name
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Things to do section summary translations.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('es', $tr$Playas, conchas, Ding Darling, favoritos de Captiva y unos días perfectos en la isla.$tr$),
    ('fr', $tr$Plages, coquillages, Ding Darling, favoris de Captiva et quelques journées idéales sur l'île.$tr$)
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'things_to_do'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Perfect Day title translations.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'itineraries', i.id, 'title', lang.language, lang.text
from public.itineraries i
join public.properties p on p.id = i.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('beach_day', 'es', $tr$El día perfecto de playa$tr$),
    ('beach_day', 'fr', $tr$La journée plage idéale$tr$),
    ('nature_day', 'es', $tr$El día del amante de la naturaleza$tr$),
    ('nature_day', 'fr', $tr$La journée nature$tr$),
    ('captiva_day', 'es', $tr$Un día en Captiva$tr$),
    ('captiva_day', 'fr', $tr$Une journée à Captiva$tr$)
) as lang(season, language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and i.season = lang.season
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Perfect Day stop detail + time_label translations.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, lang.field, lang.language, lang.text
from public.itinerary_stops st
join public.itineraries i on i.id = st.itinerary_id
join public.properties p on p.id = i.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('beach_day', 10, 'time_label', 'es', $tr$Mañana$tr$),
    ('beach_day', 10, 'time_label', 'fr', $tr$Matin$tr$),
    ('beach_day', 10, 'detail', 'es', $tr$Empieza con café y algo vegetal antes de la playa.$tr$),
    ('beach_day', 10, 'detail', 'fr', $tr$Commencez par un café et quelque chose de végétal avant la plage.$tr$),
    ('beach_day', 20, 'time_label', 'es', $tr$Mediodía$tr$),
    ('beach_day', 20, 'time_label', 'fr', $tr$Midi$tr$),
    ('beach_day', 20, 'detail', 'es', $tr$Pasa la mañana recogiendo conchas en esta playa más tranquila del oeste.$tr$),
    ('beach_day', 20, 'detail', 'fr', $tr$Passez la matinée à collecter des coquillages sur cette plage plus calme à l'ouest.$tr$),
    ('beach_day', 30, 'time_label', 'es', $tr$Tarde$tr$),
    ('beach_day', 30, 'time_label', 'fr', $tr$Après-midi$tr$),
    ('beach_day', 30, 'detail', 'es', $tr$Refréscate con custard congelado y toppings a tu gusto.$tr$),
    ('beach_day', 30, 'detail', 'fr', $tr$Rafraîchissez-vous avec de la custard glacée et vos garnitures.$tr$),
    ('beach_day', 40, 'time_label', 'es', $tr$Noche$tr$),
    ('beach_day', 40, 'time_label', 'fr', $tr$Soir$tr$),
    ('beach_day', 40, 'detail', 'es', $tr$Cena de mariscos frescos, con pescadería en el mismo sitio.$tr$),
    ('beach_day', 40, 'detail', 'fr', $tr$Dîner de fruits de mer frais, avec poissonnerie sur place.$tr$),
    ('nature_day', 10, 'time_label', 'es', $tr$Mañana$tr$),
    ('nature_day', 10, 'time_label', 'fr', $tr$Matin$tr$),
    ('nature_day', 10, 'detail', 'es', $tr$Desayuno en las mesas de conchas de Tahitian Gardens.$tr$),
    ('nature_day', 10, 'detail', 'fr', $tr$Petit-déjeuner sur les tables à coquillages de Tahitian Gardens.$tr$),
    ('nature_day', 20, 'time_label', 'es', $tr$Media mañana$tr$),
    ('nature_day', 20, 'time_label', 'fr', $tr$Fin de matinée$tr$),
    ('nature_day', 20, 'detail', 'es', $tr$Conduce o pedalea por Wildlife Drive temprano para ver aves.$tr$),
    ('nature_day', 20, 'detail', 'fr', $tr$Parcourez Wildlife Drive tôt en voiture ou à vélo pour les oiseaux.$tr$),
    ('nature_day', 30, 'time_label', 'es', $tr$Mediodía$tr$),
    ('nature_day', 30, 'time_label', 'fr', $tr$Midi$tr$),
    ('nature_day', 30, 'detail', 'es', $tr$Kayak, paddleboard o eco-crucero. Reserva con antelación.$tr$),
    ('nature_day', 30, 'detail', 'fr', $tr$Kayak, paddleboard ou eco-croisière. Réservez à l'avance.$tr$),
    ('nature_day', 40, 'time_label', 'es', $tr$Tarde$tr$),
    ('nature_day', 40, 'time_label', 'fr', $tr$Après-midi$tr$),
    ('nature_day', 40, 'detail', 'es', $tr$Conchas y vida marina bajo techo cuando quieras un descanso del sol.$tr$),
    ('nature_day', 40, 'detail', 'fr', $tr$Coquillages et vie marine à l'intérieur pour une pause au soleil.$tr$),
    ('nature_day', 50, 'time_label', 'es', $tr$Noche$tr$),
    ('nature_day', 50, 'time_label', 'fr', $tr$Soir$tr$),
    ('nature_day', 50, 'detail', 'es', $tr$Cena de inspiración caribeña y un ron para cerrar el día.$tr$),
    ('nature_day', 50, 'detail', 'fr', $tr$Dîner d'inspiration caraïbe et un rhum pour finir la journée.$tr$),
    ('captiva_day', 10, 'time_label', 'es', $tr$Mañana$tr$),
    ('captiva_day', 10, 'time_label', 'fr', $tr$Matin$tr$),
    ('captiva_day', 10, 'detail', 'es', $tr$Desayuno o almuerzo en Periwinkle Way antes de ir a Captiva.$tr$),
    ('captiva_day', 10, 'detail', 'fr', $tr$Petit-déjeuner ou déjeuner sur Periwinkle Way avant Captiva.$tr$),
    ('captiva_day', 20, 'time_label', 'es', $tr$Mediodía$tr$),
    ('captiva_day', 20, 'time_label', 'fr', $tr$Midi$tr$),
    ('captiva_day', 20, 'detail', 'es', $tr$Conchas y atardeceres en el lado Captiva de Blind Pass. Cuidado con las corrientes.$tr$),
    ('captiva_day', 20, 'detail', 'fr', $tr$Coquillages et couchers de soleil côté Captiva de Blind Pass. Attention aux courants.$tr$),
    ('captiva_day', 30, 'time_label', 'es', $tr$Tarde$tr$),
    ('captiva_day', 30, 'time_label', 'fr', $tr$Après-midi$tr$),
    ('captiva_day', 30, 'detail', 'es', $tr$Crucero de delfines, fauna, conchas o atardecer. Familiar desde 1986.$tr$),
    ('captiva_day', 30, 'detail', 'fr', $tr$Croisière dauphins, faune, coquillages ou coucher de soleil. Familiale depuis 1986.$tr$),
    ('captiva_day', 40, 'time_label', 'es', $tr$Noche$tr$),
    ('captiva_day', 40, 'time_label', 'fr', $tr$Soir$tr$),
    ('captiva_day', 40, 'detail', 'es', $tr$Cena caprichosa y pasteles enormes. Sin reservas. O el atardecer en The Mucky Duck.$tr$),
    ('captiva_day', 40, 'detail', 'fr', $tr$Dîner fantaisiste et gâteaux géants. Pas de réservations. Ou le coucher de soleil au Mucky Duck.$tr$)
) as lang(season, sort_order, field, language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and i.season = lang.season
  and st.sort_order = lang.sort_order
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Sanity checks.
do $check$
declare
  place_count integer;
  link_count integer;
  day_count integer;
begin
  select count(*) into place_count
  from public.recommendations r
  where r.name in (
    'Bowman''s Beach',
    'Lighthouse Beach Park',
    'Gulfside City Park Beach',
    'Tarpon Bay Road Beach',
    'Blind Pass Beach',
    'Turner Beach',
    'Causeway Beach Park',
    'Sanibel Sprout',
    'Over Easy Cafe',
    'The Sanibel Cafe',
    'Doc Ford''s Rum Bar & Grille',
    'Timbers Restaurant & Fish Market',
    'Gramma Dot''s',
    'Cielo',
    'The Bubble Room',
    'The Mucky Duck',
    'The Shack of Sanibel',
    'Pinocchio''s Original Italian Ice Cream',
    'Boops by The Bubble Room',
    'Jerry''s Foods',
    'A Bit of Bailey''s',
    'J.N. "Ding" Darling National Wildlife Refuge',
    'Bailey-Matthews National Shell Museum & Aquarium',
    'Island biking',
    'Tarpon Bay Explorers',
    'Adventures in Paradise'
  )
  and r.is_active
  and r.published_at is not null;

  if place_count < 26 then
    raise exception 'Expected 26 Sanibel places, found %.', place_count;
  end if;

  select count(*) into link_count
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  join public.recommendations r on r.id = pr.recommendation_id
  where s.key = 'dad'
    and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
    and r.name in (
      'Bowman''s Beach',
      'Lighthouse Beach Park',
      'Gulfside City Park Beach',
      'Tarpon Bay Road Beach',
      'Blind Pass Beach',
      'Turner Beach',
      'Causeway Beach Park',
      'Sanibel Sprout',
      'Over Easy Cafe',
      'The Sanibel Cafe',
      'Doc Ford''s Rum Bar & Grille',
      'Timbers Restaurant & Fish Market',
      'Gramma Dot''s',
      'Cielo',
      'The Bubble Room',
      'The Mucky Duck',
      'The Shack of Sanibel',
      'Pinocchio''s Original Italian Ice Cream',
      'Boops by The Bubble Room',
      'Jerry''s Foods',
      'A Bit of Bailey''s',
      'J.N. "Ding" Darling National Wildlife Refuge',
      'Bailey-Matthews National Shell Museum & Aquarium',
      'Island biking',
      'Tarpon Bay Explorers',
      'Adventures in Paradise'
    )
    and pr.published_at is not null;

  if link_count <> 52 then
    raise exception 'Expected 52 Sanibel property links, found %.', link_count;
  end if;

  select count(*) into day_count
  from public.itineraries i
  join public.properties p on p.id = i.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
    and i.season in ('beach_day', 'nature_day', 'captiva_day')
    and i.is_visible
    and i.published_at is not null;

  if day_count <> 6 then
    raise exception 'Expected 6 Sanibel perfect days, found %.', day_count;
  end if;
end
$check$;

notify pgrst, 'reload schema';
