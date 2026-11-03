-- Dad-scoped Things to Do links.
-- Recommendations stay a shared pool. New places are added only if missing by name.
-- Links leave host_note null so roost tip text is not copied onto dad stays.
-- Paste after 20261103140100_dad_properties.sql. Safe to paste again.

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

-- New shared recommendations (insert if not exists by name). host_note stays null.
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
          'd3000000-0000-4000-8000-000000000001'::uuid,
          'Ranch Camp',
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          'Casual spot in Stowe for lunch near the Cady Hill Forest trails.'
        ),
        (
          'd3000000-0000-4000-8000-000000000002'::uuid,
          'Backyard Tavern',
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          'Neighborhood tavern in Stowe for a meal or a drink.'
        ),
        (
          'd3000000-0000-4000-8000-000000000003'::uuid,
          'Rimrocks Mountain Tavern',
          'food_drink',
          'drink',
          'year_round',
          'Stowe',
          'Mountain tavern in Stowe for a drink after a day on the trails.'
        ),
        (
          'd3000000-0000-4000-8000-000000000004'::uuid,
          'Alfie''s Wild Ride',
          'food_drink',
          'eat',
          'year_round',
          'Stowe',
          'Casual place to eat in Stowe, within walking distance of Switchback Suite.'
        ),
        (
          'd3000000-0000-4000-8000-000000000005'::uuid,
          'Vermont Ski & Snowboard Museum',
          'vermont_experiences',
          'see',
          'year_round',
          'Stowe',
          'Museum in Stowe Village dedicated to Vermont skiing and snowboarding history.'
        ),
        (
          'd3000000-0000-4000-8000-000000000006'::uuid,
          'The Pour House',
          'food_drink',
          'eat',
          'year_round',
          'Hinesburg',
          'Local spot in Hinesburg for a meal or a drink.'
        ),
        (
          'd3000000-0000-4000-8000-000000000007'::uuid,
          'Frost Beer Works',
          'food_drink',
          'drink',
          'year_round',
          'Hinesburg',
          'Hinesburg brewery known for craft beer.'
        ),
        (
          'd3000000-0000-4000-8000-000000000008'::uuid,
          'Hinesburg Town Forest',
          'outdoors',
          'bike',
          'year_round',
          'Hinesburg',
          'Town forest in Hinesburg with trails for hiking and biking.'
        )
    ) as v(id, name, category, subcategory, season, town, description)
  loop
    select r.id
    into rid
    from public.recommendations r
    where r.name = rec.name
    order by r.created_at
    limit 1;

    query_text := rec.name || ' ' || rec.town || ' Vermont';
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
      -- Intentionally leave host_note untouched / null for new shared places.
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
      -- Do not rewrite shared host_note text.
    end if;
  end loop;
end
$places$;

-- Cider Loft: Cold Hollow Cider Mill (walkable) plus Waterbury and Stowe places
-- already linked to The Raddish Roost. host_note stays null on the dad link.
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
  coalesce(roost_link.sort_order, 1000),
  now(),
  null,
  case
    when place.name = 'Cold Hollow Cider Mill' then array['walkable']::text[]
    else '{}'::text[]
  end
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join public.property_recommendations roost_link
  on true
join public.properties roost
  on roost.id = roost_link.property_id
 and roost.slug = 'raddish-roost'
join public.recommendations place
  on place.id = roost_link.recommendation_id
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug = 'cider-loft'
on conflict (property_id, recommendation_id) do nothing;

-- Switchback Suite: named Stowe favorites plus the five new Stowe places.
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
    when wanted.walkable then array['walkable']::text[]
    else '{}'::text[]
  end
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join (
  values
    ('Cady Hill Forest', 10, false),
    ('The Alchemist Brewery', 20, false),
    ('Stowe Cider', 30, false),
    ('Stowe Mountain Resort', 40, false),
    ('Stowe Pinnacle', 50, false),
    ('Mount Mansfield', 60, false),
    ('Trapp Family Lodge', 70, false),
    ('Upper Hollow Road', 80, false),
    ('Ranch Camp', 90, true),
    ('Backyard Tavern', 100, true),
    ('Rimrocks Mountain Tavern', 110, true),
    ('Alfie''s Wild Ride', 120, true),
    ('Vermont Ski & Snowboard Museum', 130, true)
) as wanted(name, sort_order, walkable) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug = 'switchback-suite'
on conflict (property_id, recommendation_id) do nothing;

-- Hinesburg units, Backyard Bungalow, Landing Pad:
-- Burlington-area places from the Winooski guide, excluding walkable Winooski-only spots,
-- plus the three new Hinesburg places.
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
select distinct
  dad.id,
  place.id,
  null,
  true,
  coalesce(winooski_link.sort_order, 2000),
  now(),
  null,
  '{}'::text[]
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join public.property_recommendations winooski_link
  on true
join public.properties winooski
  on winooski.id = winooski_link.property_id
 and winooski.slug in ('shallot-chalet', 'onion-ranch')
join public.recommendations place
  on place.id = winooski_link.recommendation_id
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug in (
    'hinesburg-hideaway-3',
    'hinesburg-hideaway-4',
    'backyard-bungalow',
    'landing-pad'
  )
  and place.name not in (
    'Waterworks',
    'Waterworks Food + Drink',
    'Onion City Chicken & Oysters',
    'Four Quarters Brewery',
    'Four Quarters Brewing',
    'Our House',
    'Mule Bar',
    'Scout Coffee',
    'Winooski Falls and river trails'
  )
on conflict (property_id, recommendation_id) do nothing;

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
  '{}'::text[]
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join (
  values
    ('The Pour House', 10),
    ('Frost Beer Works', 20),
    ('Hinesburg Town Forest', 30)
) as wanted(name, sort_order) on true
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
on conflict (property_id, recommendation_id) do nothing;

-- Ensure walkable tags on re-paste for the pairs that should stay walkable.
-- In UPDATE ... FROM, never put the update target alias in a JOIN ON clause.
-- Put those conditions in WHERE instead (Postgres error 42P01).
update public.property_recommendations pr
set guest_tags = (
  select coalesce(array_agg(distinct tag order by tag), '{}')
  from (
    select unnest(pr.guest_tags) as tag
    union
    select 'walkable'::text
  ) combined
  where tag is not null
)
from public.properties stay,
  public.sites site,
  public.recommendations place
where pr.property_id = stay.id
  and site.id = stay.site_id
  and pr.recommendation_id = place.id
  and site.key = 'dad'
  and (
    (stay.slug = 'cider-loft' and place.name = 'Cold Hollow Cider Mill')
    or (
      stay.slug = 'switchback-suite'
      and place.name in (
        'Ranch Camp',
        'Backyard Tavern',
        'Rimrocks Mountain Tavern',
        'Alfie''s Wild Ride',
        'Vermont Ski & Snowboard Museum'
      )
    )
  );

do $check$
declare
  cider_links integer;
  switchback_links integer;
begin
  select count(*) into cider_links
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and p.slug = 'cider-loft';

  if cider_links = 0 then
    raise exception 'cider-loft has zero Things to Do links';
  end if;

  select count(*) into switchback_links
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and p.slug = 'switchback-suite';

  if switchback_links = 0 then
    raise exception 'switchback-suite has zero Things to Do links';
  end if;
end
$check$;

notify pgrst, 'reload schema';
