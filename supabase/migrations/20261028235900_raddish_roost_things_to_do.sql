-- Things to do for The Raddish Roost.
-- Existing places are updated or linked in place. New places are added for this stay only.
-- Shared mountains and ski areas keep their current tips and their other stay links.
-- The existing Waterbury restaurant row that is not listed below is left unchanged.
-- Run 20261028233000_winooski_things_to_do.sql first when that file has not been run yet.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'raddish-roost') then
    raise exception 'The Raddish Roost is missing. Run the seed before this file.';
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
  query_text text;
begin
  for rec in
    select *
    from (
      values
    ('c3000000-0000-4000-8000-000000000003'::uuid, 'Blackback Pub', 'Blackback Pub', 'food_drink', 'eat', 'year_round', 'Waterbury', $tip$Great food and an excellent beer selection.$tip$, 10, false),
    ('c3000000-0000-4000-8000-000000000055'::uuid, 'Gallus Handcrafted Pasta', 'Gallus Handcrafted Pasta', 'food_drink', 'eat', 'year_round', 'Waterbury', $tip$Delicious Italian food.$tip$, 20, false),
    ('c3000000-0000-4000-8000-000000000001'::uuid, 'The Reservoir', 'The Reservoir', 'food_drink', 'eat', 'year_round', 'Waterbury', $tip$Casual bites.$tip$, 30, false),
    ('c3000000-0000-4000-8000-000000000056'::uuid, 'Park Row Cafe', 'Park Row Cafe', 'food_drink', 'eat', 'year_round', 'Waterbury', $tip$Diner vibes!$tip$, 40, false),
    ('c3000000-0000-4000-8000-000000000057'::uuid, 'Salt & Rind', 'Salt & Rind', 'food_drink', 'eat', 'year_round', 'Waterbury', null::text, 50, false),
    ('c3000000-0000-4000-8000-000000000058'::uuid, 'Maxi''s', 'Maxi''s', 'food_drink', 'eat', 'year_round', 'Waterbury', $tip$Great for brunch!$tip$, 60, false),
    ('c3000000-0000-4000-8000-000000000059'::uuid, 'Michael''s on the Hill', 'Michael''s on the Hill', 'food_drink', 'eat', 'year_round', 'Waterbury Center', null::text, 70, false),
    ('c3000000-0000-4000-8000-000000000060'::uuid, 'Stone''s Throw Pizza', 'Stone''s Throw Pizza', 'food_drink', 'eat', 'year_round', 'Waterbury', null::text, 80, false),
    ('c3000000-0000-4000-8000-000000000002'::uuid, 'Prohibition Pig', 'Prohibition Pig', 'food_drink', 'drink', 'year_round', 'Waterbury', $tip$Brewery around the back!$tip$, 90, false),
    ('c3000000-0000-4000-8000-000000000061'::uuid, 'The Alchemist Brewery', 'The Alchemist Brewery', 'food_drink', 'drink', 'year_round', 'Stowe', null::text, 100, false),
    ('c3000000-0000-4000-8000-000000000062'::uuid, 'Stowe Cider', 'Stowe Cider', 'food_drink', 'drink', 'year_round', 'Stowe', null::text, 110, false),
    ('c3000000-0000-4000-8000-000000000063'::uuid, 'Lawson''s Finest Liquids', 'Lawson''s Finest Liquids', 'food_drink', 'drink', 'year_round', 'Waitsfield', null::text, 120, false),
    ('c3000000-0000-4000-8000-000000000064'::uuid, 'Hender''s Bake Shop & Cafe', 'Hender''s Bake Shop & Cafe', 'food_drink', 'coffee', 'year_round', 'Waterbury', null::text, 130, false),
    ('c3000000-0000-4000-8000-000000000065'::uuid, 'K.C.''s Bagel Café', 'K.C.''s Bagel Café', 'food_drink', 'coffee', 'year_round', 'Waterbury', null::text, 140, false),
    ('c3000000-0000-4000-8000-000000000066'::uuid, 'Black Cap Coffee & Bakery', 'Black Cap Coffee & Bakery', 'food_drink', 'coffee', 'year_round', 'Waterbury', $tip$Lunch, pastries, sandwiches, and lattes.$tip$, 150, false),
    ('c3000000-0000-4000-8000-000000000067'::uuid, 'Stowe Street Café', 'Stowe Street Café', 'food_drink', 'coffee', 'year_round', 'Waterbury', null::text, 160, false),
    ('c3000000-0000-4000-8000-000000000068'::uuid, 'Vermont Artisan Coffee & Tea', 'Vermont Artisan Coffee & Tea', 'food_drink', 'coffee', 'year_round', 'Waterbury Center', null::text, 170, false),
    ('c3000000-0000-4000-8000-000000000040'::uuid, 'Bolton Valley Resort', 'Bolton Valley Resort', 'outdoors', 'ski_ride', 'winter', 'Bolton', $tip$Great for beginners and kids! Night skiing!$tip$, 180, true),
    ('c3000000-0000-4000-8000-000000000039'::uuid, 'Sugarbush Resort', 'Sugarbush Resort', 'outdoors', 'ski_ride', 'winter', 'Warren', $tip$On the Ikon Pass.$tip$, 190, true),
    ('c3000000-0000-4000-8000-000000000038'::uuid, 'Stowe Mountain Resort', 'Stowe Mountain Resort', 'outdoors', 'ski_ride', 'winter', 'Stowe', $tip$On the Epic Pass! Tons of bars and restaurants along the Mountain Road, plus a spa, skating rink, and much more.$tip$, 200, true),
    ('c3000000-0000-4000-8000-000000000069'::uuid, 'Ben & Jerry''s Factory', 'Ben & Jerry''s Factory', 'vermont_experiences', 'see', 'year_round', 'Waterbury', null::text, 210, false),
    ('c3000000-0000-4000-8000-000000000070'::uuid, 'Cold Hollow Cider Mill', 'Cold Hollow Cider Mill', 'vermont_experiences', 'see', 'year_round', 'Waterbury Center', null::text, 220, false),
    ('c3000000-0000-4000-8000-000000000071'::uuid, 'Cabot Farmers'' Store', 'Cabot Farmers'' Store', 'vermont_experiences', 'see', 'year_round', 'Waterbury Center', null::text, 230, false),
    ('c3000000-0000-4000-8000-000000000072'::uuid, 'Little River State Park', 'Little River State Park', 'vermont_experiences', 'see', 'year_round', 'Waterbury', null::text, 240, false),
    ('c3000000-0000-4000-8000-000000000073'::uuid, 'Stowe Pinnacle', 'Stowe Pinnacle', 'outdoors', 'hike', 'year_round', 'Stowe', null::text, 250, false),
    ('c3000000-0000-4000-8000-000000000049'::uuid, 'Burnt Rock Mountain', 'Burnt Rock Mountain', 'outdoors', 'hike', 'year_round', 'Fayston', null::text, 260, true),
    ('c3000000-0000-4000-8000-000000000050'::uuid, 'Camel''s Hump', 'Camel''s Hump', 'outdoors', 'hike', 'year_round', 'Huntington / Duxbury', $tip$Famous Vermont hike! Not recommended for beginners.$tip$, 270, true),
    ('c3000000-0000-4000-8000-000000000074'::uuid, 'Mount Mansfield', 'Mount Mansfield', 'outdoors', 'hike', 'year_round', 'Stowe', null::text, 280, false),
    ('c3000000-0000-4000-8000-000000000075'::uuid, 'Cady Hill Forest', 'Cady Hill Forest', 'outdoors', 'bike', 'year_round', 'Stowe', $tip$Great mountain bike trails.$tip$, 290, false),
    ('c3000000-0000-4000-8000-000000000076'::uuid, 'The Driving Range Adaptive Mountain Bike Trails', 'The Driving Range Adaptive Mountain Bike Trails', 'outdoors', 'bike', 'year_round', null::text, null::text, 300, false)
    ) as v(id, aliases, name, category, subcategory, season, town, host_note, sort_order, link_only)
  loop
    select r.id
    into rid
    from public.recommendations r
    where r.name = any (string_to_array(rec.aliases, '|'))
    order by case when r.id = rec.id then 0 else 1 end, r.created_at
    limit 1;

    query_text := rec.name || case when rec.town is null then '' else ' ' || rec.town end || ' Vermont';
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
    elsif not rec.link_only then
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
    where p.slug = 'raddish-roost'
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
  and p.slug = 'raddish-roost'
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
  and p.slug = 'raddish-roost'
  and s.section_type = 'recommendations';

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$You can walk to downtown restaurants, cafes, and a grocery store. Our favorite places are on Things to Do.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'things_to_do'
  and b.sort_order = 10;

notify pgrst, 'reload schema';
