-- Dad-scoped Hinesburg, Stowe, and South Burlington guidebook places.
-- Recreates The Pour House (South Burlington) after the earlier Public House rename.
-- Links places to the right Vermont stays. host_note stays null.
-- ES/FR description translations. Safe to paste again.
-- Paste after 20261104140000_dad_photo_places.sql.
-- Do not set recommendation photos from listing images. No star ratings. No em dashes.

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
      and p.slug in (
        'cider-loft',
        'switchback-suite',
        'hinesburg-hideaway-3',
        'hinesburg-hideaway-4',
        'backyard-bungalow',
        'landing-pad'
      )
  ) <> 6 then
    raise exception 'Dad Vermont properties are missing. Run the dad properties migration first.';
  end if;
end
$guard$;

-- Shared places. Insert if missing by name (or known aliases). Refresh copy and maps.
do $places$
declare
  rec record;
  rid uuid;
  maps text;
begin
  for rec in
    select *
    from (
      values
        (
          'd3300000-0000-4000-8000-000000000001'::uuid,
          'Hinesburgh Public House',
          array['Hinesburgh Public House']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Hinesburg',
          '10516 Route 116, Hinesburg, VT',
          'Local Vermont food and a full pub menu at 10516 Route 116, with patio seating. Dinner only. Closed Sundays.',
          'Hinesburgh Public House 10516 Route 116 Hinesburg Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000002'::uuid,
          'Papa Nick''s',
          array['Papa Nick''s']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Hinesburg',
          '10997 Route 116, Hinesburg, VT',
          'Right next door to the Hideaway. Greek and diner favorites, big portions, and a creemee stand. Closed Tuesdays.',
          'Papa Nick''s 10997 Route 116 Hinesburg Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000003'::uuid,
          'Paisley Hippo Sandwich Shop',
          array['Paisley Hippo Sandwich Shop', 'Paisley Hippo']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Hinesburg',
          '22 Commerce St, Hinesburg, VT',
          'Big creative sandwiches at 22 Commerce St. Great after a Mount Philo hike. Closed Sunday and Monday.',
          'Paisley Hippo Sandwich Shop 22 Commerce St Hinesburg Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000004'::uuid,
          'Moondog Tavern',
          array['Moondog Tavern']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Hinesburg',
          '104 Ballards Corner Rd, Hinesburg, VT',
          'Smash burgers, wings, and poutine at 104 Ballards Corner Rd. Newer owners, and Tuesday trivia.',
          'Moondog Tavern 104 Ballards Corner Rd Hinesburg Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000005'::uuid,
          'Parkside Café',
          array['Parkside Café', 'Parkside Cafe']::text[],
          'food_drink',
          'coffee',
          'year_round',
          'Hinesburg',
          '10240 Route 116, Hinesburg, VT',
          'Breakfast burritos, sandwiches, and coffee at 10240 Route 116, next to the town common.',
          'Parkside Cafe 10240 Route 116 Hinesburg Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000006'::uuid,
          'Bake Shop at Red Wagon Plants',
          array['Bake Shop at Red Wagon Plants', 'Red Wagon Plants']::text[],
          'food_drink',
          'sweet_treats',
          'year_round',
          'Hinesburg',
          '2482 Shelburne Falls Rd, Hinesburg, VT',
          'Destination bakery in a barn at a plant nursery on Shelburne Falls Road. Famous for chocolate sourdough. Thursday to Sunday only.',
          'Bake Shop at Red Wagon Plants 2482 Shelburne Falls Rd Hinesburg Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000007'::uuid,
          'Frost Beer Works',
          array['Frost Beer Works']::text[],
          'food_drink',
          'drink',
          'year_round',
          'Hinesburg',
          '171 Commerce St, Hinesburg, VT',
          'Hinesburg brewery at 171 Commerce St. Open Thursday to Sunday afternoons.',
          'Frost Beer Works 171 Commerce St Hinesburg Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000008'::uuid,
          'Ranch Camp',
          array['Ranch Camp']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          null,
          'Casual trailhead lunch spot at Cady Hill Forest. Bike shop energy, easy food, and right next to Switchback Suite.',
          'Ranch Camp Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000009'::uuid,
          'The Bench',
          array['The Bench']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          '492 Mountain Rd, Stowe, VT',
          'Wood-fired pizza and ribs at 492 Mountain Rd. No reservations. Join the waitlist on Resy before you go.',
          'The Bench 492 Mountain Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000010'::uuid,
          'Backyard Tavern',
          array['Backyard Tavern', 'Backyard']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          '395 Mountain Rd, Stowe, VT',
          'Wicked food and fast friends at 395 Mountain Rd. Dog friendly, with a covered patio.',
          'Backyard 395 Mountain Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000011'::uuid,
          'Doc Ponds',
          array['Doc Ponds']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          '294 Mountain Rd, Stowe, VT',
          'Big comfort food and a huge beer list at 294 Mountain Rd. Closed Tuesdays.',
          'Doc Ponds 294 Mountain Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000012'::uuid,
          'Grant''s',
          array['Grant''s', 'Grants']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          '123 Mountain Rd, Stowe, VT',
          'Date-night pick at 123 Mountain Rd with live acoustic music. Check hours. Closed some days in the off season.',
          'Grant''s 123 Mountain Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000013'::uuid,
          'Idletyme',
          array['Idletyme', 'Idletyme Brewing']::text[],
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          '1859 Mountain Rd, Stowe, VT',
          'Brewpub at 1859 Mountain Rd, right on the Stowe Rec Path.',
          'Idletyme 1859 Mountain Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000014'::uuid,
          'The Roastery: Movement Coffee Roasters',
          array['The Roastery: Movement Coffee Roasters', 'Movement Coffee Roasters', 'The Roastery']::text[],
          'food_drink',
          'coffee',
          'year_round',
          'Stowe',
          '1815 Pucker St, Stowe, VT',
          'Best coffee in town at 1815 Pucker St. Great pour-overs.',
          'Movement Coffee Roasters 1815 Pucker St Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000015'::uuid,
          'Stowe Bee Bakery',
          array['Stowe Bee Bakery']::text[],
          'food_drink',
          'coffee',
          'year_round',
          'Stowe',
          '1056 Mountain Rd, Stowe, VT',
          'Biscuit sandwiches and maple lattes at 1056 Mountain Rd. Closed Monday and Tuesday.',
          'Stowe Bee Bakery 1056 Mountain Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000016'::uuid,
          'Woodland Baking & Coffee',
          array['Woodland Baking & Coffee', 'Woodland Baking and Coffee']::text[],
          'food_drink',
          'coffee',
          'year_round',
          'Stowe',
          '394 Mountain Rd, Stowe, VT',
          'Grab-and-go breakfast burritos at 394 Mountain Rd.',
          'Woodland Baking and Coffee 394 Mountain Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000017'::uuid,
          'GiraKofi',
          array['GiraKofi']::text[],
          'food_drink',
          'coffee',
          'year_round',
          'Stowe',
          '1880 Mountain Rd, Stowe, VT',
          'Build-your-own breakfast sandwiches at 1880 Mountain Rd. Giraffe-themed, opens 6:30 AM.',
          'GiraKofi 1880 Mountain Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000018'::uuid,
          'Black Cap Coffee',
          array['Black Cap Coffee']::text[],
          'food_drink',
          'coffee',
          'year_round',
          'Stowe',
          '144 Main St, Stowe, VT',
          'In the village at 144 Main St. Maple croissants. Expect a line on weekend mornings.',
          'Black Cap Coffee 144 Main St Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000019'::uuid,
          'The Alchemist Brewery',
          array['The Alchemist Brewery', 'The Alchemist']::text[],
          'food_drink',
          'drink',
          'year_round',
          'Stowe',
          '100 Cottage Club Rd, Stowe, VT',
          'Home of Heady Topper at 100 Cottage Club Rd. Fresh pours, lawn, and patio.',
          'The Alchemist Brewery 100 Cottage Club Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000020'::uuid,
          'von Trapp Brewing and Bierhall',
          array['von Trapp Brewing and Bierhall', 'von Trapp Brewing', 'Von Trapp Brewing']::text[],
          'food_drink',
          'drink',
          'year_round',
          'Stowe',
          '1333 Luce Hill Rd, Stowe, VT',
          'Austrian food with mountain views at 1333 Luce Hill Rd.',
          'von Trapp Brewing Bierhall 1333 Luce Hill Rd Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000021'::uuid,
          'Lower Bar',
          array['Lower Bar']::text[],
          'food_drink',
          'drink',
          'year_round',
          'Stowe',
          '151 Main St, Stowe, VT',
          'Laid-back village bar at 151 Main St. Great nachos.',
          'Lower Bar 151 Main St Stowe Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000022'::uuid,
          'The Pour House',
          array['The Pour House']::text[],
          'food_drink',
          'eat',
          'year_round',
          'South Burlington',
          null,
          'Easy pre-flight dinner minutes from BTV.',
          'The Pour House South Burlington Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000023'::uuid,
          'Windjammer Restaurant and Upper Deck Pub',
          array['Windjammer Restaurant and Upper Deck Pub', 'Windjammer Restaurant', 'The Windjammer']::text[],
          'food_drink',
          'eat',
          'year_round',
          'South Burlington',
          '1076 Williston Rd, South Burlington, VT',
          'Prime rib and seafood at 1076 Williston Rd. Closed Sunday and Monday.',
          'Windjammer Restaurant 1076 Williston Rd South Burlington Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000024'::uuid,
          'Guild Tavern',
          array['Guild Tavern']::text[],
          'food_drink',
          'eat',
          'year_round',
          'South Burlington',
          '1633 Williston Rd, South Burlington, VT',
          'Wood-fired steakhouse at 1633 Williston Rd. Special-occasion pick. Dinner only.',
          'Guild Tavern 1633 Williston Rd South Burlington Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000025'::uuid,
          'Kestrel Coffee Roasters',
          array['Kestrel Coffee Roasters', 'Kestrel Coffee']::text[],
          'food_drink',
          'coffee',
          'year_round',
          'South Burlington',
          '530 Community Dr, South Burlington, VT',
          'Small-batch roaster at 530 Community Dr. Weekdays only.',
          'Kestrel Coffee Roasters 530 Community Dr South Burlington Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000026'::uuid,
          'Clover Cafe',
          array['Clover Cafe', 'Clover Café']::text[],
          'food_drink',
          'coffee',
          'year_round',
          'South Burlington',
          '510 Shelburne Rd, South Burlington, VT',
          'Creative lattes and pastries at 510 Shelburne Rd.',
          'Clover Cafe 510 Shelburne Rd South Burlington Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000027'::uuid,
          'Good Times Cafe / Matryoshka''s Bakery',
          array[
            'Good Times Cafe / Matryoshka''s Bakery',
            'Good Times Café',
            'Good Times Cafe',
            'Matryoshka''s Bakery'
          ]::text[],
          'food_drink',
          'sweet_treats',
          'year_round',
          'South Burlington',
          '1330 Shelburne Rd, South Burlington, VT',
          'Macarons, maple creme pie, plus pizza and sandwiches at 1330 Shelburne Rd. Closed Mondays.',
          'Good Times Cafe Matryoshka Bakery 1330 Shelburne Rd South Burlington Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000028'::uuid,
          'Klinger''s Bread Co',
          array['Klinger''s Bread Co', 'Klingers Bread Co', 'Klinger''s Bread']::text[],
          'food_drink',
          'sweet_treats',
          'year_round',
          'South Burlington',
          '10 Farrell St, South Burlington, VT',
          'Local bakery at 10 Farrell St. Breakfast croissants.',
          'Klinger''s Bread Co 10 Farrell St South Burlington Vermont'
        ),
        (
          'd3300000-0000-4000-8000-000000000029'::uuid,
          'The Mill Market',
          array['The Mill Market']::text[],
          'shopping',
          'groceries',
          'year_round',
          'South Burlington',
          '1580 Dorset St, South Burlington, VT',
          'Sandwiches, cider donuts, pies, beer, and wine at 1580 Dorset St. Great for a sandwich before a flight.',
          'The Mill Market 1580 Dorset St South Burlington Vermont'
        )
    ) as v(
      id, name, aliases, category, subcategory, season, town, address, description, maps_query
    )
  loop
    select r.id
    into rid
    from public.recommendations r
    where r.name = any (rec.aliases)
    order by r.created_at
    limit 1;

    maps := 'https://www.google.com/maps/search/?api=1&query=' || replace(
      replace(
        replace(
          replace(
            replace(
              replace(rec.maps_query, '%', '%25'),
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
        rec.address,
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
        description = excluded.description,
        address = coalesce(excluded.address, public.recommendations.address),
        maps_url = excluded.maps_url,
        town = excluded.town,
        published_at = coalesce(public.recommendations.published_at, now()),
        updated_at = now();
    else
      update public.recommendations
      set
        name = rec.name,
        category = rec.category,
        subcategory = rec.subcategory,
        season = coalesce(season, rec.season),
        is_active = true,
        description = rec.description,
        address = coalesce(rec.address, address),
        maps_url = maps,
        town = rec.town,
        published_at = coalesce(published_at, now()),
        updated_at = now()
      where id = rid;
    end if;
  end loop;
end
$places$;

-- Hinesburgh Public House belongs on the hideaways only (not South Burlington).
delete from public.property_recommendations pr
using public.properties p,
  public.sites s,
  public.recommendations r
where pr.property_id = p.id
  and s.id = p.site_id
  and pr.recommendation_id = r.id
  and s.key = 'dad'
  and r.name = 'Hinesburgh Public House'
  and p.slug in ('backyard-bungalow', 'landing-pad');

-- Hinesburg Hideaway Unit 3 and Unit 4.
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
  true,
  wanted.sort_order,
  now(),
  null,
  wanted.guest_tags
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join (
  values
    ('Hinesburgh Public House', 10, array['rainy_day', 'dog_friendly']::text[]),
    ('Papa Nick''s', 20, array['walkable', 'rainy_day', 'kid_friendly']::text[]),
    ('Paisley Hippo Sandwich Shop', 30, array['rainy_day']::text[]),
    ('Moondog Tavern', 40, array['rainy_day']::text[]),
    ('Parkside Café', 50, array['rainy_day']::text[]),
    ('Bake Shop at Red Wagon Plants', 60, array['rainy_day', 'kid_friendly']::text[]),
    ('Frost Beer Works', 70, array['rainy_day']::text[])
) as wanted(name, sort_order, guest_tags) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug in ('hinesburg-hideaway-3', 'hinesburg-hideaway-4')
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = null,
  guest_tags = excluded.guest_tags,
  is_featured = true,
  custom_description = null;

-- Switchback Suite (walkable where it fits) and Cider Loft as a Stowe day trip.
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
  true,
  wanted.sort_order,
  now(),
  null,
  case
    when dad.slug = 'switchback-suite' then wanted.switchback_tags
    else wanted.cider_tags
  end
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join (
  values
    ('Ranch Camp', 5, array['walkable', 'rainy_day']::text[], array['rainy_day']::text[]),
    ('The Bench', 20, array['walkable', 'rainy_day']::text[], array['rainy_day']::text[]),
    ('Backyard Tavern', 30, array['walkable', 'rainy_day', 'dog_friendly']::text[], array['rainy_day', 'dog_friendly']::text[]),
    ('Doc Ponds', 40, array['walkable', 'rainy_day']::text[], array['rainy_day']::text[]),
    ('Grant''s', 50, array['walkable', 'rainy_day']::text[], array['rainy_day']::text[]),
    ('Idletyme', 60, array['rainy_day']::text[], array['rainy_day']::text[]),
    ('The Roastery: Movement Coffee Roasters', 70, array['rainy_day']::text[], array['rainy_day']::text[]),
    ('Stowe Bee Bakery', 80, array['walkable', 'rainy_day', 'kid_friendly']::text[], array['rainy_day', 'kid_friendly']::text[]),
    ('Woodland Baking & Coffee', 90, array['walkable', 'rainy_day']::text[], array['rainy_day']::text[]),
    ('GiraKofi', 100, array['rainy_day', 'kid_friendly']::text[], array['rainy_day', 'kid_friendly']::text[]),
    ('Black Cap Coffee', 110, array['walkable', 'rainy_day', 'kid_friendly']::text[], array['rainy_day', 'kid_friendly']::text[]),
    ('The Alchemist Brewery', 120, array['rainy_day']::text[], array['rainy_day']::text[]),
    ('von Trapp Brewing and Bierhall', 130, array['rainy_day', 'kid_friendly']::text[], array['rainy_day', 'kid_friendly']::text[]),
    ('Lower Bar', 140, array['walkable', 'rainy_day']::text[], array['rainy_day']::text[])
) as wanted(name, sort_order, switchback_tags, cider_tags) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug in ('switchback-suite', 'cider-loft')
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = null,
  guest_tags = excluded.guest_tags,
  is_featured = true,
  custom_description = null;

-- Backyard Bungalow and Landing Pad (South Burlington), including Groceries tab places.
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
  true,
  wanted.sort_order,
  now(),
  null,
  wanted.guest_tags
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join (
  values
    ('The Pour House', 10, array['rainy_day']::text[]),
    ('Windjammer Restaurant and Upper Deck Pub', 20, array['rainy_day']::text[]),
    ('Guild Tavern', 30, array['rainy_day']::text[]),
    ('Kestrel Coffee Roasters', 40, array['rainy_day']::text[]),
    ('Clover Cafe', 50, array['rainy_day']::text[]),
    ('Good Times Cafe / Matryoshka''s Bakery', 60, array['rainy_day', 'kid_friendly']::text[]),
    ('Klinger''s Bread Co', 70, array['rainy_day', 'kid_friendly']::text[]),
    ('The Mill Market', 80, array['rainy_day', 'kid_friendly']::text[])
) as wanted(name, sort_order, guest_tags) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug in ('backyard-bungalow', 'landing-pad')
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = null,
  guest_tags = excluded.guest_tags,
  is_featured = true,
  custom_description = null;

-- Spanish and French place descriptions.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', place.id, 'description', lang.language, lang.text
from public.recommendations place
join (
  values
    ('Hinesburgh Public House', 'es', $tr$Comida local de Vermont y menú de pub completo en 10516 Route 116, con patio. Solo cena. Cerrado los domingos.$tr$),
    ('Hinesburgh Public House', 'fr', $tr$Cuisine locale du Vermont et menu de pub complet au 10516 Route 116, avec patio. Dîner seulement. Fermé le dimanche.$tr$),
    ('Papa Nick''s', 'es', $tr$Justo al lado del Hideaway. Favoritos griegos y de diner, porciones grandes y puesto de creemee. Cerrado los martes.$tr$),
    ('Papa Nick''s', 'fr', $tr$Juste à côté du Hideaway. Favoris grecs et diner, grandes portions et stand de creemee. Fermé le mardi.$tr$),
    ('Paisley Hippo Sandwich Shop', 'es', $tr$Sándwiches creativos y generosos en 22 Commerce St. Ideal después de una caminata en Mount Philo. Cerrado domingo y lunes.$tr$),
    ('Paisley Hippo Sandwich Shop', 'fr', $tr$Gros sandwiches créatifs au 22 Commerce St. Parfait après une randonnée au Mount Philo. Fermé dimanche et lundi.$tr$),
    ('Moondog Tavern', 'es', $tr$Smash burgers, alitas y poutine en 104 Ballards Corner Rd. Nuevos dueños, y trivia los martes.$tr$),
    ('Moondog Tavern', 'fr', $tr$Smash burgers, ailes et poutine au 104 Ballards Corner Rd. Nouveaux propriétaires, et trivia le mardi.$tr$),
    ('Parkside Café', 'es', $tr$Burritos de desayuno, sándwiches y café en 10240 Route 116, junto al common del pueblo.$tr$),
    ('Parkside Café', 'fr', $tr$Burritos du petit-déjeuner, sandwiches et café au 10240 Route 116, à côté du common du village.$tr$),
    ('Bake Shop at Red Wagon Plants', 'es', $tr$Panadería destino en un granero de un vivero en Shelburne Falls Road. Famosa por el chocolate sourdough. Solo de jueves a domingo.$tr$),
    ('Bake Shop at Red Wagon Plants', 'fr', $tr$Boulangerie destination dans une grange de pépinière sur Shelburne Falls Road. Célèbre pour le pain au chocolat au levain. Jeudi à dimanche seulement.$tr$),
    ('Frost Beer Works', 'es', $tr$Cervecería de Hinesburg en 171 Commerce St. Abierta de jueves a domingo por la tarde.$tr$),
    ('Frost Beer Works', 'fr', $tr$Brasserie de Hinesburg au 171 Commerce St. Ouverte jeudi à dimanche l'après-midi.$tr$),
    ('Ranch Camp', 'es', $tr$Almuerzo informal en la entrada de Cady Hill Forest. Ambiente de tienda de bicis, comida fácil, junto a Switchback Suite.$tr$),
    ('Ranch Camp', 'fr', $tr$Déjeuner décontracté à l'entrée de Cady Hill Forest. Ambiance bike shop, cuisine simple, juste à côté de Switchback Suite.$tr$),
    ('The Bench', 'es', $tr$Pizza y costillas a la leña en 492 Mountain Rd. Sin reservas. Apúntate en la lista de espera de Resy antes de ir.$tr$),
    ('The Bench', 'fr', $tr$Pizza et ribs au feu de bois au 492 Mountain Rd. Pas de réservations. Inscrivez-vous sur la liste d'attente Resy avant d'y aller.$tr$),
    ('Backyard Tavern', 'es', $tr$Comida contundente y ambiente amable en 395 Mountain Rd. Apto para perros, con patio cubierto.$tr$),
    ('Backyard Tavern', 'fr', $tr$Bonne cuisine et ambiance conviviale au 395 Mountain Rd. Chiens bienvenus, patio couvert.$tr$),
    ('Doc Ponds', 'es', $tr$Comida reconfortante y una enorme carta de cervezas en 294 Mountain Rd. Cerrado los martes.$tr$),
    ('Doc Ponds', 'fr', $tr$Comfort food généreux et immense carte de bières au 294 Mountain Rd. Fermé le mardi.$tr$),
    ('Grant''s', 'es', $tr$Opción para una cita en 123 Mountain Rd con música acústica en vivo. Revisa el horario. Cerrado algunos días fuera de temporada.$tr$),
    ('Grant''s', 'fr', $tr$Adresse pour une soirée en amoureux au 123 Mountain Rd, avec musique acoustique. Vérifiez les horaires. Fermé certains jours hors saison.$tr$),
    ('Idletyme', 'es', $tr$Brewpub en 1859 Mountain Rd, justo en el Stowe Rec Path.$tr$),
    ('Idletyme', 'fr', $tr$Brewpub au 1859 Mountain Rd, juste sur le Stowe Rec Path.$tr$),
    ('The Roastery: Movement Coffee Roasters', 'es', $tr$El mejor café del pueblo en 1815 Pucker St. Excelentes pour-overs.$tr$),
    ('The Roastery: Movement Coffee Roasters', 'fr', $tr$Le meilleur café de la ville au 1815 Pucker St. Excellent en pour-over.$tr$),
    ('Stowe Bee Bakery', 'es', $tr$Sándwiches de biscuit y lattes de maple en 1056 Mountain Rd. Cerrado lunes y martes.$tr$),
    ('Stowe Bee Bakery', 'fr', $tr$Sandwichs biscuits et lattes à l'érable au 1056 Mountain Rd. Fermé lundi et mardi.$tr$),
    ('Woodland Baking & Coffee', 'es', $tr$Burritos de desayuno para llevar en 394 Mountain Rd.$tr$),
    ('Woodland Baking & Coffee', 'fr', $tr$Burritos du petit-déjeuner à emporter au 394 Mountain Rd.$tr$),
    ('GiraKofi', 'es', $tr$Sándwiches de desayuno a tu gusto en 1880 Mountain Rd. Temática de jirafas, abre a las 6:30 AM.$tr$),
    ('GiraKofi', 'fr', $tr$Sandwichs du petit-déjeuner à composer au 1880 Mountain Rd. Thème girafe, ouverture à 6 h 30.$tr$),
    ('Black Cap Coffee', 'es', $tr$En el pueblo, en 144 Main St. Croissants de maple. Espera fila los fines de semana por la mañana.$tr$),
    ('Black Cap Coffee', 'fr', $tr$Dans le village, au 144 Main St. Croissants à l'érable. File d'attente les week-ends le matin.$tr$),
    ('The Alchemist Brewery', 'es', $tr$Casa de Heady Topper en 100 Cottage Club Rd. Cerveza fresca, césped y patio.$tr$),
    ('The Alchemist Brewery', 'fr', $tr$Maison de Heady Topper au 100 Cottage Club Rd. Bières fraîches, pelouse et patio.$tr$),
    ('von Trapp Brewing and Bierhall', 'es', $tr$Comida austriaca con vistas a la montaña en 1333 Luce Hill Rd.$tr$),
    ('von Trapp Brewing and Bierhall', 'fr', $tr$Cuisine autrichienne avec vue sur la montagne au 1333 Luce Hill Rd.$tr$),
    ('Lower Bar', 'es', $tr$Bar relajado del pueblo en 151 Main St. Nachos excelentes.$tr$),
    ('Lower Bar', 'fr', $tr$Bar décontracté du village au 151 Main St. Excellents nachos.$tr$),
    ('The Pour House', 'es', $tr$Cena fácil antes del vuelo, a minutos de BTV.$tr$),
    ('The Pour House', 'fr', $tr$Dîner facile avant le vol, à quelques minutes de BTV.$tr$),
    ('Windjammer Restaurant and Upper Deck Pub', 'es', $tr$Prime rib y mariscos en 1076 Williston Rd. Cerrado domingo y lunes.$tr$),
    ('Windjammer Restaurant and Upper Deck Pub', 'fr', $tr$Prime rib et fruits de mer au 1076 Williston Rd. Fermé dimanche et lundi.$tr$),
    ('Guild Tavern', 'es', $tr$Steakhouse a la leña en 1633 Williston Rd. Para ocasiones especiales. Solo cena.$tr$),
    ('Guild Tavern', 'fr', $tr$Steakhouse au feu de bois au 1633 Williston Rd. Pour les grandes occasions. Dîner seulement.$tr$),
    ('Kestrel Coffee Roasters', 'es', $tr$Tostador de lotes pequeños en 530 Community Dr. Solo entre semana.$tr$),
    ('Kestrel Coffee Roasters', 'fr', $tr$Torréfacteur en petits lots au 530 Community Dr. En semaine seulement.$tr$),
    ('Clover Cafe', 'es', $tr$Lattes creativos y pasteles en 510 Shelburne Rd.$tr$),
    ('Clover Cafe', 'fr', $tr$Lattes créatifs et pâtisseries au 510 Shelburne Rd.$tr$),
    ('Good Times Cafe / Matryoshka''s Bakery', 'es', $tr$Macarons, pastel de maple creme, también pizza y sándwiches en 1330 Shelburne Rd. Cerrado los lunes.$tr$),
    ('Good Times Cafe / Matryoshka''s Bakery', 'fr', $tr$Macarons, tarte à la crème d'érable, aussi pizza et sandwiches au 1330 Shelburne Rd. Fermé le lundi.$tr$),
    ('Klinger''s Bread Co', 'es', $tr$Panadería local en 10 Farrell St. Croissants de desayuno.$tr$),
    ('Klinger''s Bread Co', 'fr', $tr$Boulangerie locale au 10 Farrell St. Croissants du petit-déjeuner.$tr$),
    ('The Mill Market', 'es', $tr$Sándwiches, donuts de sidra, tartas, cerveza y vino en 1580 Dorset St. Ideal para un sándwich antes del vuelo.$tr$),
    ('The Mill Market', 'fr', $tr$Sandwichs, beignes au cidre, tartes, bière et vin au 1580 Dorset St. Parfait pour un sandwich avant le vol.$tr$)
) as lang(name, language, text) on true
where place.name = lang.name
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

do $check$
declare
  ranch_sort integer;
  pour_links integer;
  public_house_sb integer;
  missing text;
begin
  select pr.sort_order into ranch_sort
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  join public.recommendations r on r.id = pr.recommendation_id
  where s.key = 'dad'
    and p.slug = 'switchback-suite'
    and r.name = 'Ranch Camp';

  if ranch_sort is null or ranch_sort > 10 then
    raise exception 'Ranch Camp should sort near the top on Switchback Suite, found %', ranch_sort;
  end if;

  select count(*) into pour_links
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  join public.recommendations r on r.id = pr.recommendation_id
  where s.key = 'dad'
    and r.name = 'The Pour House'
    and p.slug in ('backyard-bungalow', 'landing-pad');

  if pour_links <> 2 then
    raise exception 'The Pour House should link to Backyard Bungalow and Landing Pad, found %', pour_links;
  end if;

  select count(*) into public_house_sb
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  join public.recommendations r on r.id = pr.recommendation_id
  where s.key = 'dad'
    and r.name = 'Hinesburgh Public House'
    and p.slug in ('backyard-bungalow', 'landing-pad');

  if public_house_sb <> 0 then
    raise exception 'Hinesburgh Public House should not stay linked to South Burlington stays';
  end if;

  select string_agg(wanted.name, ', ' order by wanted.name)
  into missing
  from (
    values
      ('Papa Nick''s'),
      ('Paisley Hippo Sandwich Shop'),
      ('Moondog Tavern'),
      ('Bake Shop at Red Wagon Plants'),
      ('Doc Ponds'),
      ('Grant''s'),
      ('Idletyme'),
      ('The Roastery: Movement Coffee Roasters'),
      ('Stowe Bee Bakery'),
      ('GiraKofi'),
      ('Black Cap Coffee'),
      ('von Trapp Brewing and Bierhall'),
      ('Lower Bar'),
      ('The Pour House'),
      ('Windjammer Restaurant and Upper Deck Pub'),
      ('Kestrel Coffee Roasters'),
      ('Clover Cafe'),
      ('Good Times Cafe / Matryoshka''s Bakery'),
      ('Klinger''s Bread Co'),
      ('The Mill Market'),
      ('Hinesburgh Public House'),
      ('Ranch Camp'),
      ('Frost Beer Works')
  ) as wanted(name)
  where not exists (
    select 1 from public.recommendations r where r.name = wanted.name and r.is_active
  );

  if missing is not null then
    raise exception 'Missing guidebook places: %', missing;
  end if;
end
$check$;

notify pgrst, 'reload schema';
