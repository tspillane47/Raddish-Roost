-- Dad-scoped places spotted in listing photos.
-- Renames The Pour House to Hinesburgh Public House, adds missing spots,
-- links them to the right Vermont stays, bumps Ranch Camp near the top on Switchback,
-- and adds ES/FR description translations. Safe to paste again.
-- Paste after 20261104130000_dad_direct_expedia_booking.sql.
-- Do not set recommendation photos from listing images.

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

-- The Pour House was a stand-in name for Hinesburgh Public House.
update public.recommendations
set
  name = 'Hinesburgh Public House',
  description = coalesce(
    description,
    'Local Vermont food, a full pub menu, and a full bar at 10516 Route 116 in Hinesburg. Patio and dog-friendly porch seating.'
  ),
  address = coalesce(address, '10516 Route 116, Hinesburg, VT'),
  town = coalesce(town, 'Hinesburg'),
  subcategory = 'eat',
  category = 'food_drink',
  season = coalesce(season, 'year_round'),
  maps_url = coalesce(
    maps_url,
    'https://www.google.com/maps/search/?api=1&query=Hinesburgh%20Public%20House%2010516%20Route%20116%20Hinesburg%20Vermont'
  ),
  is_active = true,
  published_at = coalesce(published_at, now()),
  updated_at = now()
where name = 'The Pour House';

update public.recommendations
set
  description = 'Local Vermont food, a full pub menu, and a full bar at 10516 Route 116 in Hinesburg. Patio and dog-friendly porch seating.',
  address = coalesce(address, '10516 Route 116, Hinesburg, VT'),
  town = coalesce(town, 'Hinesburg'),
  subcategory = 'eat',
  category = 'food_drink',
  season = coalesce(season, 'year_round'),
  maps_url = coalesce(
    maps_url,
    'https://www.google.com/maps/search/?api=1&query=Hinesburgh%20Public%20House%2010516%20Route%20116%20Hinesburg%20Vermont'
  ),
  is_active = true,
  published_at = coalesce(published_at, now()),
  updated_at = now()
where name = 'Hinesburgh Public House'
  and (
    description is null
    or description = 'Local spot in Hinesburg for a meal or a drink.'
    or address is null
  );

-- Keep guest-facing copy aligned with the real name.
update public.properties p
set
  description = replace(p.description, 'The Pour House', 'Hinesburgh Public House'),
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('hinesburg-hideaway-3', 'hinesburg-hideaway-4')
  and p.description like '%The Pour House%';

update public.guidebook_sections sec
set
  summary = replace(sec.summary, 'The Pour House', 'Hinesburgh Public House'),
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug in ('hinesburg-hideaway-3', 'hinesburg-hideaway-4')
  and sec.summary like '%The Pour House%';

update public.guidebook_blocks b
set
  body = jsonb_set(
    b.body,
    '{markdown}',
    to_jsonb(replace(coalesce(b.body->>'markdown', ''), 'The Pour House', 'Hinesburgh Public House'))
  ),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug in ('hinesburg-hideaway-3', 'hinesburg-hideaway-4')
  and coalesce(b.body->>'markdown', '') like '%The Pour House%';

-- New shared recommendations (insert if missing by name). host_note stays null.
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
          'd3200000-0000-4000-8000-000000000001'::uuid,
          'Hinesburgh Public House',
          'food_drink',
          'eat',
          'year_round',
          'Hinesburg',
          'Local Vermont food, a full pub menu, and a full bar at 10516 Route 116 in Hinesburg. Patio and dog-friendly porch seating.',
          'Hinesburgh Public House 10516 Route 116 Hinesburg Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000002'::uuid,
          'Good Times Café',
          'food_drink',
          'coffee',
          'year_round',
          'Hinesburg',
          'Friendly local cafe in Hinesburg with picnic tables out front. Easy stop for coffee or a simple bite.',
          'Good Times Cafe Hinesburg Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000003'::uuid,
          'Parkside Café',
          'food_drink',
          'coffee',
          'year_round',
          'Hinesburg',
          'Corner cafe on Farmall Drive in Hinesburg. Coffee, casual food, and a few outdoor seats.',
          'Parkside Cafe Hinesburg Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000004'::uuid,
          'Lantman''s Market',
          'shopping',
          'groceries',
          'year_round',
          'Hinesburg',
          'Locally owned market on Route 116 since 1925. Grab groceries, snacks, and Vermont staples without leaving town.',
          'Lantman''s Market Hinesburg Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000005'::uuid,
          'Vermont Smoke & Cure',
          'food_drink',
          'eat',
          'year_round',
          'Hinesburg',
          'Vermont meats and snacks from the Cheese Plant complex in Hinesburg. Handy for picnic supplies.',
          'Vermont Smoke and Cure Hinesburg Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000006'::uuid,
          'Shelburne Sugarworks',
          'food_drink',
          'sweet_treats',
          'year_round',
          'Shelburne',
          'Maple syrup, ice cream, and a four-season outdoor center in Shelburne. A sweet stop between Hinesburg and Burlington.',
          'Shelburne Sugarworks Shelburne Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000007'::uuid,
          'Trillium Hill Farm',
          'vermont_experiences',
          'see',
          'year_round',
          'Hinesburg',
          'Local farm in Hinesburg. Check for farmstand hours and seasonal produce.',
          'Trillium Hill Farm Hinesburg Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000008'::uuid,
          'Barbarian',
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          'Casual patio spot in Stowe, right by the cinema. Colorful tables and an easy meal after the trails.',
          'Barbarian Stowe Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000009'::uuid,
          'The Bench',
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          'Wood-fired food with wine, craft beer, and cocktails in Stowe Village.',
          'The Bench Stowe Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000010'::uuid,
          'Woodland Baking & Coffee',
          'food_drink',
          'coffee',
          'year_round',
          'Stowe',
          'Bakery and coffee shop in Stowe. Perfect for a pastry before a trail day.',
          'Woodland Baking and Coffee Stowe Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000011'::uuid,
          'Stowe Cinema 3 Plex',
          'family',
          'see',
          'year_round',
          'Stowe',
          'Dine-in movie theater in Stowe with reclining seats and a tap room. A solid rainy-day plan.',
          'Stowe Cinema 3 Plex Stowe Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000012'::uuid,
          'Barnyard Pizza',
          'food_drink',
          'eat',
          'year_round',
          'South Burlington',
          'Wood-crafted pizza near the South Burlington stays. Casual and close when you want dinner without a long drive.',
          'Barnyard Pizza South Burlington Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000013'::uuid,
          'Guild Tavern',
          'food_drink',
          'eat',
          'year_round',
          'South Burlington',
          'Wood-fired grill tavern near the airport. Good for a sit-down dinner close to Landing Pad and Backyard Bungalow.',
          'Guild Tavern South Burlington Vermont'
        ),
        (
          'd3200000-0000-4000-8000-000000000014'::uuid,
          'Mirabelles',
          'food_drink',
          'coffee',
          'year_round',
          'Burlington',
          'Croissants, cake, coffee, and pastries. A sweet Burlington stop near the South Burlington stays.',
          'Mirabelles Burlington Vermont'
        )
    ) as v(id, name, category, subcategory, season, town, description, maps_query)
  loop
    select r.id
    into rid
    from public.recommendations r
    where r.name = rec.name
       or (rec.name = 'Hinesburgh Public House' and r.name = 'The Pour House')
       or (rec.name = 'Vermont Smoke & Cure' and r.name in ('Vermont Smoke and Cure', 'Vermont Smoke & Cure'))
    order by r.created_at
    limit 1;

    query_text := rec.maps_query;
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
        case
          when rec.name = 'Hinesburgh Public House' then '10516 Route 116, Hinesburg, VT'
          else null
        end,
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
        address = coalesce(public.recommendations.address, excluded.address),
        maps_url = coalesce(public.recommendations.maps_url, excluded.maps_url),
        town = coalesce(public.recommendations.town, excluded.town),
        published_at = coalesce(public.recommendations.published_at, now()),
        updated_at = now();
    else
      update public.recommendations
      set
        name = rec.name,
        category = coalesce(category, rec.category),
        subcategory = coalesce(subcategory, rec.subcategory),
        season = coalesce(season, rec.season),
        is_active = true,
        description = case
          when description is null
            or description = 'Local spot in Hinesburg for a meal or a drink.'
            then rec.description
          else description
        end,
        address = case
          when rec.name = 'Hinesburgh Public House' then coalesce(address, '10516 Route 116, Hinesburg, VT')
          else address
        end,
        maps_url = coalesce(maps_url, maps),
        town = coalesce(town, rec.town),
        published_at = coalesce(published_at, now()),
        updated_at = now()
      where id = rid;
    end if;
  end loop;
end
$places$;

-- Hinesburg-area favorites on both hideaways, plus Backyard Bungalow and Landing Pad as day trips.
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
    ('Hinesburgh Public House', 5, array['rainy_day', 'dog_friendly']::text[]),
    ('Frost Beer Works', 20, array['rainy_day']::text[]),
    ('Hinesburg Town Forest', 30, '{}'::text[]),
    ('Good Times Café', 40, array['rainy_day']::text[]),
    ('Parkside Café', 50, array['rainy_day']::text[]),
    ('Lantman''s Market', 60, array['rainy_day', 'kid_friendly']::text[]),
    ('Vermont Smoke & Cure', 70, array['rainy_day']::text[]),
    ('Trillium Hill Farm', 80, array['kid_friendly']::text[]),
    ('Shelburne Sugarworks', 90, array['kid_friendly']::text[])
) as wanted(name, sort_order, guest_tags) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug in (
    'hinesburg-hideaway-3',
    'hinesburg-hideaway-4',
    'backyard-bungalow',
    'landing-pad'
  )
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = null,
  guest_tags = excluded.guest_tags,
  is_featured = true,
  custom_description = null;

-- South Burlington / Burlington photo spots on Landing Pad and Backyard Bungalow,
-- plus the Hinesburg stays as easy day-trip picks.
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
    ('Barnyard Pizza', 110, array['rainy_day']::text[]),
    ('Guild Tavern', 120, array['rainy_day']::text[]),
    ('Mirabelles', 130, array['rainy_day', 'kid_friendly']::text[])
) as wanted(name, sort_order, guest_tags) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug in (
    'landing-pad',
    'backyard-bungalow',
    'hinesburg-hideaway-3',
    'hinesburg-hideaway-4'
  )
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = null,
  guest_tags = excluded.guest_tags,
  is_featured = true,
  custom_description = null;

-- Switchback Suite Stowe photo spots. Ranch Camp near the top. Walkable where it fits.
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
    ('Ranch Camp', 5, array['walkable', 'rainy_day']::text[]),
    ('Backyard Tavern', 100, array['walkable', 'rainy_day']::text[]),
    ('Rimrocks Mountain Tavern', 110, array['walkable', 'rainy_day']::text[]),
    ('Alfie''s Wild Ride', 120, array['walkable', 'rainy_day']::text[]),
    ('Barbarian', 125, array['walkable', 'rainy_day']::text[]),
    ('The Bench', 128, array['walkable', 'rainy_day']::text[]),
    ('Woodland Baking & Coffee', 132, array['walkable', 'rainy_day']::text[]),
    ('Stowe Cinema 3 Plex', 136, array['walkable', 'rainy_day', 'kid_friendly']::text[]),
    ('Vermont Ski & Snowboard Museum', 140, array['walkable', 'rainy_day']::text[]),
    ('Cady Hill Forest', 10, '{}'::text[])
) as wanted(name, sort_order, guest_tags) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug = 'switchback-suite'
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = null,
  guest_tags = excluded.guest_tags,
  is_featured = true,
  custom_description = null;

-- Same Stowe photo spots as day trips from Cider Loft (not walkable).
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
    ('Ranch Camp', 500, array['rainy_day']::text[]),
    ('Backyard Tavern', 510, array['rainy_day']::text[]),
    ('Rimrocks Mountain Tavern', 520, array['rainy_day']::text[]),
    ('Alfie''s Wild Ride', 530, array['rainy_day']::text[]),
    ('Barbarian', 540, array['rainy_day']::text[]),
    ('The Bench', 550, array['rainy_day']::text[]),
    ('Woodland Baking & Coffee', 560, array['rainy_day']::text[]),
    ('Stowe Cinema 3 Plex', 570, array['rainy_day', 'kid_friendly']::text[])
) as wanted(name, sort_order, guest_tags) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug = 'cider-loft'
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = null,
  guest_tags = excluded.guest_tags,
  is_featured = true,
  custom_description = null;

-- Spanish and French for place descriptions.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', place.id, 'description', lang.language, lang.text
from public.recommendations place
join (
  values
    ('Hinesburgh Public House', 'es', $tr$Comida local de Vermont, menú de pub completo y barra completa en 10516 Route 116 en Hinesburg. Patio y porche apto para perros.$tr$),
    ('Hinesburgh Public House', 'fr', $tr$Cuisine locale du Vermont, menu de pub complet et bar complet au 10516 Route 116 à Hinesburg. Patio et porche accueillant les chiens.$tr$),
    ('Good Times Café', 'es', $tr$Café local y acogedor en Hinesburg con mesas de picnic delante. Parada fácil para un café o un bocado sencillo.$tr$),
    ('Good Times Café', 'fr', $tr$Café local sympathique à Hinesburg avec des tables de pique-nique devant. Arrêt facile pour un café ou une collation.$tr$),
    ('Parkside Café', 'es', $tr$Café en la esquina de Farmall Drive en Hinesburg. Café, comida informal y algunas mesas al aire libre.$tr$),
    ('Parkside Café', 'fr', $tr$Café au coin de Farmall Drive à Hinesburg. Café, cuisine décontractée et quelques places en extérieur.$tr$),
    ('Lantman''s Market', 'es', $tr$Mercado de propiedad local en la Route 116 desde 1925. Compra víveres, snacks y productos de Vermont sin salir del pueblo.$tr$),
    ('Lantman''s Market', 'fr', $tr$Épicerie locale sur la Route 116 depuis 1925. Courses, snacks et produits du Vermont sans quitter le village.$tr$),
    ('Vermont Smoke & Cure', 'es', $tr$Carnes y snacks de Vermont en el complejo The Cheese Plant en Hinesburg. Ideal para un picnic.$tr$),
    ('Vermont Smoke & Cure', 'fr', $tr$Viandes et snacks du Vermont au complexe The Cheese Plant à Hinesburg. Pratique pour un pique-nique.$tr$),
    ('Shelburne Sugarworks', 'es', $tr$Jarabe de maple, helado y un centro al aire libre las cuatro estaciones en Shelburne. Una parada dulce entre Hinesburg y Burlington.$tr$),
    ('Shelburne Sugarworks', 'fr', $tr$Sirop d'érable, glaces et centre de plein air quatre saisons à Shelburne. Une halte sucrée entre Hinesburg et Burlington.$tr$),
    ('Trillium Hill Farm', 'es', $tr$Granja local en Hinesburg. Consulta el horario del puesto de granja y los productos de temporada.$tr$),
    ('Trillium Hill Farm', 'fr', $tr$Ferme locale à Hinesburg. Vérifiez les horaires du stand et les produits de saison.$tr$),
    ('Barbarian', 'es', $tr$Patio informal en Stowe, junto al cine. Mesas de colores y una comida fácil después de los senderos.$tr$),
    ('Barbarian', 'fr', $tr$Spot décontracté avec patio à Stowe, juste à côté du cinéma. Tables colorées et repas facile après les sentiers.$tr$),
    ('The Bench', 'es', $tr$Comida a la leña con vino, cerveza artesanal y cócteles en Stowe Village.$tr$),
    ('The Bench', 'fr', $tr$Cuisine au feu de bois avec vins, bières artisanales et cocktails à Stowe Village.$tr$),
    ('Woodland Baking & Coffee', 'es', $tr$Panadería y café en Stowe. Perfecto para un pastel antes de un día de senderos.$tr$),
    ('Woodland Baking & Coffee', 'fr', $tr$Boulangerie et café à Stowe. Parfait pour une pâtisserie avant une journée sur les sentiers.$tr$),
    ('Stowe Cinema 3 Plex', 'es', $tr$Cine con servicio en el asiento en Stowe, butacas reclinables y tap room. Un plan sólido para un día de lluvia.$tr$),
    ('Stowe Cinema 3 Plex', 'fr', $tr$Cinéma avec service à la place à Stowe, fauteuils inclinables et tap room. Un bon plan pour un jour de pluie.$tr$),
    ('Barnyard Pizza', 'es', $tr$Pizza elaborada a la leña cerca de los alojamientos de South Burlington. Informal y cerca cuando quieres cenar sin un viaje largo.$tr$),
    ('Barnyard Pizza', 'fr', $tr$Pizza au feu de bois près des hébergements de South Burlington. Décontracté et proche quand vous voulez dîner sans long trajet.$tr$),
    ('Guild Tavern', 'es', $tr$Taberna de parrilla a la leña cerca del aeropuerto. Buena opción para una cena formal cerca de Landing Pad y Backyard Bungalow.$tr$),
    ('Guild Tavern', 'fr', $tr$Taverne au grill au feu de bois près de l'aéroport. Bon choix pour un dîner assis près de Landing Pad et Backyard Bungalow.$tr$),
    ('Mirabelles', 'es', $tr$Croissants, pasteles, café y bollería. Una parada dulce en Burlington cerca de los alojamientos de South Burlington.$tr$),
    ('Mirabelles', 'fr', $tr$Croissants, gâteaux, café et pâtisseries. Une halte sucrée à Burlington près des hébergements de South Burlington.$tr$)
) as lang(name, language, text) on true
where place.name = lang.name
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

do $check$
declare
  public_house_links integer;
  ranch_camp_sort integer;
  missing text;
begin
  select count(*) into public_house_links
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  join public.recommendations r on r.id = pr.recommendation_id
  where s.key = 'dad'
    and r.name = 'Hinesburgh Public House'
    and p.slug in (
      'hinesburg-hideaway-3',
      'hinesburg-hideaway-4',
      'backyard-bungalow',
      'landing-pad'
    );

  if public_house_links <> 4 then
    raise exception 'Hinesburgh Public House should link to 4 dad stays, found %', public_house_links;
  end if;

  if exists (select 1 from public.recommendations where name = 'The Pour House' and is_active) then
    raise exception 'The Pour House should have been renamed to Hinesburgh Public House';
  end if;

  select pr.sort_order into ranch_camp_sort
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  join public.recommendations r on r.id = pr.recommendation_id
  where s.key = 'dad'
    and p.slug = 'switchback-suite'
    and r.name = 'Ranch Camp';

  if ranch_camp_sort is null or ranch_camp_sort > 20 then
    raise exception 'Ranch Camp should sort near the top on Switchback Suite, found %', ranch_camp_sort;
  end if;

  select string_agg(wanted.name, ', ' order by wanted.name)
  into missing
  from (
    values
      ('Good Times Café'),
      ('Parkside Café'),
      ('Lantman''s Market'),
      ('Vermont Smoke & Cure'),
      ('Shelburne Sugarworks'),
      ('Trillium Hill Farm'),
      ('Barbarian'),
      ('The Bench'),
      ('Woodland Baking & Coffee'),
      ('Stowe Cinema 3 Plex'),
      ('Barnyard Pizza'),
      ('Guild Tavern'),
      ('Mirabelles'),
      ('Hinesburgh Public House'),
      ('Ranch Camp')
  ) as wanted(name)
  where not exists (
    select 1 from public.recommendations r where r.name = wanted.name and r.is_active
  );

  if missing is not null then
    raise exception 'Missing photo places: %', missing;
  end if;
end
$check$;

notify pgrst, 'reload schema';
