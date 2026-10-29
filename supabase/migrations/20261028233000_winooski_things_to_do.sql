-- Things to do for The Shallot Chalet and The Onion Ranch.
-- Waterworks, Onion City, and Four Quarters are updated in place.
-- The Burlington restaurant stays separate from the Waterbury restaurant of the same name.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'shallot-chalet') then
    raise exception 'The Shallot Chalet is missing. Run the seed before this file.';
  end if;
  if not exists (select 1 from public.properties where slug = 'onion-ranch') then
    raise exception 'The Onion Ranch is missing. Run the seed before this file.';
  end if;
end $$;

alter table public.recommendations
  add column if not exists subcategory text,
  add column if not exists town text;

alter table public.recommendations drop constraint if exists recommendations_subcategory;
alter table public.recommendations
  add constraint recommendations_subcategory check (
    subcategory is null or subcategory in (
      'eat', 'drink', 'coffee', 'ski_ride', 'see', 'hike', 'bike', 'winter_fun', 'sweet_treats'
    )
  );

alter table public.recommendations drop constraint if exists recommendations_town;
alter table public.recommendations
  add constraint recommendations_town check (
    town is null or char_length(btrim(town)) between 1 and 80
  );

grant select (subcategory, town) on public.recommendations to anon;

do $body$
declare
  rec record;
  rid uuid;
  maps text;
begin
  for rec in
    select *
    from (
      values
    ('c3000000-0000-4000-8000-000000000011'::uuid, 'Waterworks|Waterworks Food + Drink', 'Waterworks Food + Drink', 'food_drink', 'eat', 'year_round', 'Winooski', $tip$The steak frites are to die for!$tip$, 10),
    ('c3000000-0000-4000-8000-000000000018'::uuid, 'Pho Hong', 'Pho Hong', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Best Vietnamese place in town! Mostly locals and great for takeout.$tip$, 20),
    ('c3000000-0000-4000-8000-000000000019'::uuid, 'Trattoria Delia', 'Trattoria Delia', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Cozy and delicious Italian food! Wine bar Sotto is next door.$tip$, 30),
    ('c3000000-0000-4000-8000-000000000020'::uuid, 'Restaurant Poco', 'Restaurant Poco', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Delicious tapas! Small restaurant, walk-ins only.$tip$, 40),
    ('c3000000-0000-4000-8000-000000000021'::uuid, 'Santiago''s Cuban Cuisine', 'Santiago''s Cuban Cuisine', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Authentic Cuban food and drinks!$tip$, 50),
    ('c3000000-0000-4000-8000-000000000022'::uuid, 'Honey Road', 'Honey Road', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Easily one of the best restaurants in Burlington! Mediterranean small plates. Book your reservation in advance!$tip$, 60),
    ('c3000000-0000-4000-8000-000000000023'::uuid, 'Hen of the Wood (Burlington)', 'Hen of the Wood (Burlington)', 'food_drink', 'eat', 'year_round', 'Burlington', null::text, 70),
    ('c3000000-0000-4000-8000-000000000024'::uuid, 'Shanty on the Shore', 'Shanty on the Shore', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Great seafood!$tip$, 80),
    ('c3000000-0000-4000-8000-000000000014'::uuid, 'Onion City Chicken & Oysters', 'Onion City Chicken & Oysters', 'food_drink', 'eat', 'year_round', 'Winooski', $tip$Great cocktails! The menu is limited but delicious. Come in the mood for chicken or oysters!$tip$, 90),
    ('c3000000-0000-4000-8000-000000000025'::uuid, 'Taco Gordo', 'Taco Gordo', 'food_drink', 'eat', 'year_round', 'Burlington area', null::text, 100),
    ('c3000000-0000-4000-8000-000000000026'::uuid, 'Farmhouse Tap & Grill', 'Farmhouse Tap & Grill', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Cozy basement with a fireplace in winter and a back patio in summer.$tip$, 110),
    ('c3000000-0000-4000-8000-000000000027'::uuid, 'Pascolo Ristorante', 'Pascolo Ristorante', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Delicious Italian food right on Church Street!$tip$, 120),
    ('c3000000-0000-4000-8000-000000000028'::uuid, 'A Single Pebble', 'A Single Pebble', 'food_drink', 'eat', 'year_round', 'Burlington', null::text, 130),
    ('c3000000-0000-4000-8000-000000000029'::uuid, 'Leunig''s Bistro', 'Leunig''s Bistro', 'food_drink', 'eat', 'year_round', 'Burlington', $tip$Cozy French restaurant right on Church Street.$tip$, 140),
    ('c3000000-0000-4000-8000-000000000030'::uuid, 'May Day', 'May Day', 'food_drink', 'eat', 'year_round', 'Burlington', null::text, 150),
    ('c3000000-0000-4000-8000-000000000031'::uuid, 'Spot on the Dock', 'Spot on the Dock', 'food_drink', 'drink', 'summer', 'Burlington', $tip$Fun place right on the water for cocktails! Beautiful at sunset.$tip$, 160),
    ('c3000000-0000-4000-8000-000000000015'::uuid, 'Four Quarters Brewery|Four Quarters Brewing', 'Four Quarters Brewing', 'food_drink', 'drink', 'year_round', 'Winooski', $tip$Craft beer and delicious food! Very chill and dog friendly.$tip$, 170),
    ('c3000000-0000-4000-8000-000000000032'::uuid, 'Foam Brewers', 'Foam Brewers', 'food_drink', 'drink', 'year_round', 'Burlington', $tip$Great place for live music and craft beer! Near the lake with a fun outdoor patio in the summer.$tip$, 180),
    ('c3000000-0000-4000-8000-000000000033'::uuid, 'Burlington Beer Co.', 'Burlington Beer Co.', 'food_drink', 'drink', 'year_round', 'Burlington', $tip$Large beer hall! The food is awesome too. Great for a big group.$tip$, 190),
    ('c3000000-0000-4000-8000-000000000034'::uuid, 'Devil Takes a Holiday', 'Devil Takes a Holiday', 'food_drink', 'drink', 'year_round', 'Burlington', $tip$Great date spot! High-quality cocktails.$tip$, 200),
    ('c3000000-0000-4000-8000-000000000035'::uuid, 'Zero Gravity Brewery', 'Zero Gravity Brewery', 'food_drink', 'drink', 'year_round', 'Burlington', null::text, 210),
    ('c3000000-0000-4000-8000-000000000036'::uuid, 'The 126', 'The 126', 'food_drink', 'drink', 'year_round', 'Burlington', $tip$Cozy speakeasy with live music!$tip$, 220),
    ('c3000000-0000-4000-8000-000000000037'::uuid, 'Smugglers'' Notch', 'Smugglers'' Notch', 'outdoors', 'ski_ride', 'winter', 'Jeffersonville', $tip$Local spot for skiing and snowboarding!$tip$, 230),
    ('c3000000-0000-4000-8000-000000000038'::uuid, 'Stowe Mountain Resort', 'Stowe Mountain Resort', 'outdoors', 'ski_ride', 'winter', 'Stowe', $tip$On the Epic Pass! Tons of bars and restaurants along the Mountain Road, plus a spa, skating rink, and much more.$tip$, 240),
    ('c3000000-0000-4000-8000-000000000039'::uuid, 'Sugarbush Resort', 'Sugarbush Resort', 'outdoors', 'ski_ride', 'winter', 'Warren', $tip$On the Ikon Pass.$tip$, 250),
    ('c3000000-0000-4000-8000-000000000040'::uuid, 'Bolton Valley Resort', 'Bolton Valley Resort', 'outdoors', 'ski_ride', 'winter', 'Bolton', $tip$Great for beginners and kids! Night skiing!$tip$, 260),
    ('c3000000-0000-4000-8000-000000000041'::uuid, 'Trapp Family Lodge', 'Trapp Family Lodge', 'outdoors', 'ski_ride', 'winter', 'Stowe', $tip$Great place for cross-country skiing, with a brewery on site too!$tip$, 270),
    ('c3000000-0000-4000-8000-000000000042'::uuid, 'Shelburne Farms', 'Shelburne Farms', 'vermont_experiences', 'see', 'year_round', 'Shelburne', $tip$Beautiful walking trails open all season (sorry, no dogs). Gardens overlooking the lake and the Adirondack mountains. In summer, grab drinks at the Inn and sit in the Adirondack chairs overlooking the water.$tip$, 280),
    ('c3000000-0000-4000-8000-000000000043'::uuid, 'Church Street', 'Church Street', 'vermont_experiences', 'see', 'year_round', 'Burlington', $tip$Pedestrian street with tons of great restaurants, boutiques, bars, coffee shops, and shopping. Lit up at night!$tip$, 290),
    ('c3000000-0000-4000-8000-000000000044'::uuid, 'Spirit of Ethan Allen', 'Spirit of Ethan Allen', 'vermont_experiences', 'see', 'summer', 'Burlington', $tip$Dinner and drink cruise on the lake.$tip$, 300),
    ('c3000000-0000-4000-8000-000000000045'::uuid, 'Upper Hollow Road', 'Upper Hollow Road', 'outdoors', 'hike', 'fall', 'Stowe', $tip$Beautiful in the fall!$tip$, 310),
    ('c3000000-0000-4000-8000-000000000046'::uuid, 'Mount Philo', 'Mount Philo', 'outdoors', 'hike', 'year_round', 'Charlotte', $tip$Easy hike on a paved road or wooded trail, with lake views. Dogs on a leash.$tip$, 320),
    ('c3000000-0000-4000-8000-000000000047'::uuid, 'Indian Brook Reservoir', 'Indian Brook Reservoir', 'outdoors', 'hike', 'year_round', 'Essex', $tip$Great walking trails. Dog-friendly!$tip$, 330),
    ('c3000000-0000-4000-8000-000000000048'::uuid, 'Sterling Pond Trail', 'Sterling Pond Trail', 'outdoors', 'hike', 'year_round', 'Smugglers'' Notch', null::text, 340),
    ('c3000000-0000-4000-8000-000000000049'::uuid, 'Burnt Rock Mountain', 'Burnt Rock Mountain', 'outdoors', 'hike', 'year_round', 'Fayston', null::text, 350),
    ('c3000000-0000-4000-8000-000000000050'::uuid, 'Camel''s Hump', 'Camel''s Hump', 'outdoors', 'hike', 'year_round', 'Huntington / Duxbury', $tip$Famous Vermont hike! Not recommended for beginners.$tip$, 360),
    ('c3000000-0000-4000-8000-000000000051'::uuid, 'Vermont Comedy Club', 'Vermont Comedy Club', 'vermont_experiences', 'winter_fun', 'year_round', 'Burlington', null::text, 370),
    ('c3000000-0000-4000-8000-000000000052'::uuid, 'Catamount Outdoor Family Center', 'Catamount Outdoor Family Center', 'vermont_experiences', 'winter_fun', 'year_round', 'Williston', $tip$Four-season spot for biking, skiing, or snowshoeing. Rental equipment available.$tip$, 380),
    ('c3000000-0000-4000-8000-000000000053'::uuid, 'Shy Guy Gelato', 'Shy Guy Gelato', 'food_drink', 'sweet_treats', 'year_round', 'Burlington', null::text, 390),
    ('c3000000-0000-4000-8000-000000000054'::uuid, 'Mr. Creemee Stand', 'Mr. Creemee Stand', 'food_drink', 'sweet_treats', 'year_round', 'Burlington area', null::text, 400)
    ) as v(id, aliases, name, category, subcategory, season, town, host_note, sort_order)
  loop
    select r.id
    into rid
    from public.recommendations r
    where r.name = any (string_to_array(rec.aliases, '|'))
    order by case when r.id = rec.id then 0 else 1 end, r.created_at
    limit 1;

    maps := 'https://www.google.com/maps/search/?api=1&query=' || replace(
      replace(
        replace(
          replace(
            replace(
              replace(rec.name || ' ' || rec.town || ' Vermont', '%', '%25'),
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
        id, category, subcategory, season, is_active, name, description, host_note,
        address, website_url, maps_url, town, published_at
      )
      values (
        rec.id, rec.category, rec.subcategory, rec.season, true, rec.name, null, rec.host_note,
        null, null, maps, rec.town, now()
      )
      on conflict (id) do update
      set
        category = excluded.category,
        subcategory = excluded.subcategory,
        season = excluded.season,
        is_active = true,
        name = excluded.name,
        description = null,
        host_note = excluded.host_note,
        address = null,
        website_url = null,
        maps_url = excluded.maps_url,
        town = excluded.town,
        published_at = coalesce(public.recommendations.published_at, now());
      rid := rec.id;
    else
      update public.recommendations
      set
        category = rec.category,
        subcategory = rec.subcategory,
        season = rec.season,
        is_active = true,
        name = rec.name,
        description = null,
        host_note = rec.host_note,
        address = null,
        website_url = null,
        maps_url = maps,
        town = rec.town,
        published_at = coalesce(published_at, now())
      where id = rid;
    end if;

    insert into public.property_recommendations (
      property_id, recommendation_id, is_featured, sort_order, published_at
    )
    select p.id, rid, true, rec.sort_order, now()
    from public.properties p
    where p.slug in ('shallot-chalet', 'onion-ranch')
    on conflict (property_id, recommendation_id) do update
    set
      is_featured = true,
      sort_order = excluded.sort_order,
      published_at = coalesce(public.property_recommendations.published_at, now());
  end loop;
end
$body$;

update public.guidebook_sections s
set summary = 'Places to eat, drink, ski, hike, and more nearby.'
from public.properties p
where s.property_id = p.id
  and p.slug in ('shallot-chalet', 'onion-ranch')
  and s.section_type = 'recommendations';

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Open Explore for places to eat, drink, ski, hike, and more. Each place has a tip and directions.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug in ('shallot-chalet', 'onion-ranch')
  and s.section_type = 'recommendations';

update public.guidebook_blocks b
set
  body = jsonb_set(
    b.body,
    '{markdown}',
    to_jsonb(replace(b.body->>'markdown', 'Our favorite places are in Local Recommendations.', 'Our favorite places are on Things to Do.'))
  )
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'things_to_do'
  and b.body->>'markdown' like '%Our favorite places are in Local Recommendations.%';

notify pgrst, 'reload schema';
