-- Dad site properties for The Far & Familiar Collection.
-- Scoped to sites.key = 'dad' only. Does not touch roost properties.
-- Paste after 20261103140000_dad_guest_area.sql.
-- Safe to paste again after a partial run: inserts use on conflict do update / do nothing.
-- No door codes. No em dashes. Wi-Fi and access details stay in Airbnb messages.

do $guard$
begin
  if not exists (select 1 from public.sites where key = 'dad') then
    raise exception 'Dad site is missing. Run the sites migration before this file.';
  end if;
end
$guard$;

insert into public.locations (id, name, notes)
values
  (
    'd1000000-0000-4000-8000-000000000001',
    'Waterbury Center, Vermont',
    'Home of The Cider Loft, next to Cold Hollow Cider Mill.'
  ),
  (
    'd1000000-0000-4000-8000-000000000002',
    'Stowe, Vermont',
    'Home of Switchback Suite, at the base of the Cady Hill Forest trails.'
  ),
  (
    'd1000000-0000-4000-8000-000000000003',
    'Hinesburg, Vermont',
    'Shared by The Hinesburg Hideaway, Unit 3 and Unit 4.'
  ),
  (
    'd1000000-0000-4000-8000-000000000004',
    'South Burlington, Vermont',
    'Home of Backyard Bungalow and The Landing Pad.'
  ),
  (
    'd1000000-0000-4000-8000-000000000005',
    'Sanibel Island, Florida',
    'Tennisplace complex. Home of A35 Tennisplace and Sanibel Sunsets.'
  )
on conflict (id) do update
set
  name = excluded.name,
  notes = excluded.notes,
  updated_at = now();

insert into public.properties (
  id,
  site_id,
  location_id,
  slug,
  name,
  tagline,
  description,
  welcome_title,
  welcome_message,
  address_line,
  locality,
  region,
  postal_code,
  check_in_time,
  check_out_time,
  parking_summary,
  guest_area,
  weather_latitude,
  weather_longitude,
  status,
  published_at,
  sort_order
)
select
  v.id,
  s.id,
  v.location_id,
  v.slug,
  v.name,
  v.tagline,
  v.description,
  v.welcome_title,
  v.welcome_message,
  null,
  v.locality,
  v.region,
  null,
  'Details coming soon',
  'Details coming soon',
  v.parking_summary,
  v.guest_area,
  v.weather_latitude,
  v.weather_longitude,
  'published',
  now(),
  v.sort_order
from public.sites s
join (
  values
    (
      'd2000000-0000-4000-8000-000000000001'::uuid,
      'd1000000-0000-4000-8000-000000000001'::uuid,
      'cider-loft',
      'The Cider Loft',
      'A cozy, rustic ski-themed loft next to Cold Hollow Cider Mill',
      $d$A cozy, rustic ski-themed loft right next to Cold Hollow Cider Mill and a minute up the road from Ben & Jerry's Factory. Two bedrooms with two queens, plus a futon or sofa bed in the living room, one bath, and sleeps 5. Well-equipped kitchen, spacious living area, and a 55-inch smart TV. Steep stairs and a small bathroom. Window AC is available May through September. Pets are allowed.$d$,
      'Welcome to The Cider Loft',
      $w$We're so glad you're here. The Cider Loft is a cozy, rustic ski-themed loft right next to Cold Hollow Cider Mill, with Ben & Jerry's Factory just a minute up the road. Make yourself at home.$w$,
      'Waterbury Center',
      'VT',
      'vermont',
      'Free parking.',
      44.3770::numeric,
      -72.7220::numeric,
      1
    ),
    (
      'd2000000-0000-4000-8000-000000000002'::uuid,
      'd1000000-0000-4000-8000-000000000002'::uuid,
      'switchback-suite',
      'Switchback Suite',
      'Built for adventure at the base of the Cady Hill Forest trails',
      $d$Built for adventure, at the base of the Cady Hill Forest mountain bike trails. One bedroom with a queen, one bath, and sleeps 3. Lunch next door at Ranch Camp or Backyard Tavern, a drink on the back porch, and Rimrocks Mountain Tavern and Alfie's Wild Ride within walking distance. About a 5-minute walk to the Vermont Ski & Snowboard Museum and Stowe Village. Patio, AC, and free parking.$d$,
      'Welcome to Switchback Suite',
      $w$We're so glad you're here. Switchback Suite is built for adventure at the base of the Cady Hill Forest trails, with Stowe Village just a short walk away. Make yourself at home.$w$,
      'Stowe',
      'VT',
      'vermont',
      'Free parking.',
      44.4654::numeric,
      -72.6874::numeric,
      2
    ),
    (
      'd2000000-0000-4000-8000-000000000003'::uuid,
      'd1000000-0000-4000-8000-000000000003'::uuid,
      'hinesburg-hideaway-3',
      'The Hinesburg Hideaway, Unit 3',
      'A newly renovated hideaway with a serene back patio',
      $d$A newly renovated unit in a charming sixplex. One bedroom with a queen plus a queen pull-out, one bath, and sleeps 4. Back patio with a serene view and a smart TV. Near The Pour House, Frost Beer Works, and Hinesburg Town Forest bike trails. Burlington is about 20 minutes away. Guest parking is marked with a sign out front. Window AC is available May through September. Pets are allowed.$d$,
      'Welcome to The Hinesburg Hideaway, Unit 3',
      $w$We're so glad you're here. The Hinesburg Hideaway, Unit 3 is a newly renovated spot with a quiet back patio, close to town and about 20 minutes from Burlington. Make yourself at home.$w$,
      'Hinesburg',
      'VT',
      'vermont',
      'Guest parking is marked with a sign out front.',
      44.3360::numeric,
      -73.1108::numeric,
      3
    ),
    (
      'd2000000-0000-4000-8000-000000000004'::uuid,
      'd1000000-0000-4000-8000-000000000003'::uuid,
      'hinesburg-hideaway-4',
      'The Hinesburg Hideaway, Unit 4',
      'A newly renovated hideaway with a serene back patio',
      $d$A newly renovated unit in a charming sixplex. One bedroom with a queen plus a queen pull-out, one bath, and sleeps 4. Back patio with a serene view and a smart TV. Near The Pour House, Frost Beer Works, and Hinesburg Town Forest bike trails. Burlington is about 20 minutes away. Guest parking is marked with a sign out front. Window AC is available May through September. Pets are allowed.$d$,
      'Welcome to The Hinesburg Hideaway, Unit 4',
      $w$We're so glad you're here. The Hinesburg Hideaway, Unit 4 is a newly renovated spot with a quiet back patio, close to town and about 20 minutes from Burlington. Make yourself at home.$w$,
      'Hinesburg',
      'VT',
      'vermont',
      'Guest parking is marked with a sign out front.',
      44.3360::numeric,
      -73.1108::numeric,
      4
    ),
    (
      'd2000000-0000-4000-8000-000000000005'::uuid,
      'd1000000-0000-4000-8000-000000000004'::uuid,
      'backyard-bungalow',
      'Backyard Bungalow',
      'A stylish, cozy home with a fully fenced backyard',
      $d$A stylish, cozy home with a fully fenced backyard, front porch, fully stocked kitchen, dining table, smart TV, in-unit laundry, and free driveway parking. Two bedrooms plus a queen pull-out sofa, one bath, and sleeps 5. About half a mile from the interstate and the airport, and close to everything in Burlington. Pets are welcome and must stay off furniture and be house-trained. Sofa bed linens must be requested when booking. Window AC is available May through September.$d$,
      'Welcome to Backyard Bungalow',
      $w$We're so glad you're here. Backyard Bungalow is a stylish, cozy home with a fully fenced backyard, close to Burlington and just about half a mile from the airport. Make yourself at home.$w$,
      'South Burlington',
      'VT',
      'vermont',
      'Free driveway parking.',
      44.4669::numeric,
      -73.1709::numeric,
      5
    ),
    (
      'd2000000-0000-4000-8000-000000000006'::uuid,
      'd1000000-0000-4000-8000-000000000004'::uuid,
      'landing-pad',
      'The Landing Pad',
      'A family-friendly home near the airport and downtown Burlington',
      $d$A family-friendly neighborhood about 2 minutes from the airport and 10 minutes to downtown Burlington. Great for family reunions and group trips. Three bedrooms (queen; two singles; queen) plus a queen pull-out couch, one bath, and sleeps 8. Full kitchen, washer and dryer, and free parking. Pets are allowed.$d$,
      'Welcome to The Landing Pad',
      $w$We're so glad you're here. The Landing Pad is a family-friendly spot about 2 minutes from the airport and 10 minutes to downtown Burlington. Perfect for groups. Make yourself at home.$w$,
      'South Burlington',
      'VT',
      'vermont',
      'Free parking.',
      44.4669::numeric,
      -73.1709::numeric,
      6
    ),
    (
      'd2000000-0000-4000-8000-000000000007'::uuid,
      'd1000000-0000-4000-8000-000000000005'::uuid,
      'tennisplace-a35',
      'A35 Tennisplace',
      'A waterfront condo steps from Dixie Beach',
      $d$A waterfront condo in the Tennisplace complex with bikes included, a shared pool, a kayak, and a waterfront gas grill. Two bedrooms with two queens, 1.5 baths, and sleeps 5. Dixie Beach is steps away. Canal views and great sunrises.$d$,
      'Welcome to A35 Tennisplace',
      $w$We're so glad you're here. A35 Tennisplace is a waterfront condo in the Tennisplace complex, with Dixie Beach just steps away. Make yourself at home.$w$,
      'Sanibel',
      'FL',
      'florida',
      'Details coming soon',
      26.4390::numeric,
      -82.1140::numeric,
      7
    ),
    (
      'd2000000-0000-4000-8000-000000000008'::uuid,
      'd1000000-0000-4000-8000-000000000005'::uuid,
      'sanibel-sunsets',
      'Sanibel Sunsets',
      'A canal-side condo with stylish updates and island calm',
      $d$A recently updated condo on the canal with stylish decor. Two bedrooms, three beds, 1.5 baths, and sleeps 4. Shared pool and tennis courts, about a 5-minute walk to Dixie Beach, and close to bike paths. Guests have spotted dolphins and manatees from the porch.$d$,
      'Welcome to Sanibel Sunsets',
      $w$We're so glad you're here. Sanibel Sunsets is a recently updated canal-side condo in the Tennisplace complex, with Dixie Beach about a 5-minute walk away. Make yourself at home.$w$,
      'Sanibel',
      'FL',
      'florida',
      'Details coming soon',
      26.4390::numeric,
      -82.1140::numeric,
      8
    )
) as v(
  id,
  location_id,
  slug,
  name,
  tagline,
  description,
  welcome_title,
  welcome_message,
  locality,
  region,
  guest_area,
  parking_summary,
  weather_latitude,
  weather_longitude,
  sort_order
) on true
where s.key = 'dad'
on conflict (id) do update
set
  site_id = excluded.site_id,
  location_id = excluded.location_id,
  slug = excluded.slug,
  name = excluded.name,
  tagline = excluded.tagline,
  description = excluded.description,
  welcome_title = excluded.welcome_title,
  welcome_message = excluded.welcome_message,
  locality = excluded.locality,
  region = excluded.region,
  check_in_time = excluded.check_in_time,
  check_out_time = excluded.check_out_time,
  parking_summary = excluded.parking_summary,
  guest_area = excluded.guest_area,
  weather_latitude = excluded.weather_latitude,
  weather_longitude = excluded.weather_longitude,
  status = 'published',
  published_at = coalesce(public.properties.published_at, now()),
  sort_order = excluded.sort_order,
  updated_at = now()
where public.properties.site_id = (
  select id from public.sites where key = 'dad'
);

-- Seed the standard visible guidebook sections for each dad stay.
do $seed$
declare
  prop record;
begin
  for prop in
    select p.id
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'dad'
      and p.slug in (
        'cider-loft',
        'switchback-suite',
        'hinesburg-hideaway-3',
        'hinesburg-hideaway-4',
        'backyard-bungalow',
        'landing-pad',
        'tennisplace-a35',
        'sanibel-sunsets'
      )
  loop
    perform public.seed_guidebook_sections(prop.id);
  end loop;
end
$seed$;

-- Section summaries (visible sections only).
update public.guidebook_sections s
set
  summary = v.summary,
  is_visible = true,
  published_at = coalesce(s.published_at, now()),
  updated_at = now()
from public.properties p
join public.sites site on site.id = p.site_id
join (
  values
    ('cider-loft', 'check_in', 'The door uses a code. Your code arrives in Airbnb messages. Check-in and checkout times: Details coming soon.'),
    ('cider-loft', 'getting_here', 'Waterbury Center, right next to Cold Hollow Cider Mill. Free parking.'),
    ('cider-loft', 'wifi', 'Details coming soon. Network details stay in your Airbnb messages for now.'),
    ('cider-loft', 'house_guide', 'Two bedrooms, one bath, sleeps 5. Steep stairs and a small bathroom.'),
    ('cider-loft', 'house_rules', 'Pets are allowed. Please take care on the steep stairs.'),
    ('cider-loft', 'things_to_do', 'Cold Hollow Cider Mill is walkable. Open Explore for Waterbury and Stowe favorites.'),
    ('cider-loft', 'contact', 'Send us an Airbnb message. We usually reply soon.'),
    ('cider-loft', 'stay_again', 'Book The Cider Loft again on Airbnb.'),
    ('switchback-suite', 'check_in', 'The door uses a code. Your code arrives in Airbnb messages. Check-in and checkout times: Details coming soon.'),
    ('switchback-suite', 'getting_here', 'Stowe, at the base of the Cady Hill Forest trails. Free parking.'),
    ('switchback-suite', 'wifi', 'Details coming soon. Network details stay in your Airbnb messages for now.'),
    ('switchback-suite', 'house_guide', 'One bedroom, one bath, sleeps 3. Patio and AC.'),
    ('switchback-suite', 'house_rules', 'A quiet base for adventure near Stowe Village.'),
    ('switchback-suite', 'things_to_do', 'Walk to Ranch Camp, Backyard Tavern, and more. Open Explore for Stowe favorites.'),
    ('switchback-suite', 'contact', 'Send us an Airbnb message. We usually reply soon.'),
    ('switchback-suite', 'stay_again', 'Book Switchback Suite again on Airbnb.'),
    ('hinesburg-hideaway-3', 'check_in', 'The door uses a code. Your code arrives in Airbnb messages. Check-in and checkout times: Details coming soon.'),
    ('hinesburg-hideaway-3', 'getting_here', 'Hinesburg. Guest parking is marked with a sign out front.'),
    ('hinesburg-hideaway-3', 'wifi', 'Details coming soon. Network details stay in your Airbnb messages for now.'),
    ('hinesburg-hideaway-3', 'house_guide', 'One bedroom plus a queen pull-out, one bath, sleeps 4. Back patio with a serene view.'),
    ('hinesburg-hideaway-3', 'house_rules', 'Pets are allowed. Please use the marked guest parking.'),
    ('hinesburg-hideaway-3', 'things_to_do', 'Near The Pour House, Frost Beer Works, and Hinesburg Town Forest. Burlington is about 20 minutes away.'),
    ('hinesburg-hideaway-3', 'contact', 'Send us an Airbnb message. We usually reply soon.'),
    ('hinesburg-hideaway-3', 'stay_again', 'Book The Hinesburg Hideaway, Unit 3 again on Airbnb.'),
    ('hinesburg-hideaway-4', 'check_in', 'The door uses a code. Your code arrives in Airbnb messages. Check-in and checkout times: Details coming soon.'),
    ('hinesburg-hideaway-4', 'getting_here', 'Hinesburg. Guest parking is marked with a sign out front.'),
    ('hinesburg-hideaway-4', 'wifi', 'Details coming soon. Network details stay in your Airbnb messages for now.'),
    ('hinesburg-hideaway-4', 'house_guide', 'One bedroom plus a queen pull-out, one bath, sleeps 4. Back patio with a serene view.'),
    ('hinesburg-hideaway-4', 'house_rules', 'Pets are allowed. Please use the marked guest parking.'),
    ('hinesburg-hideaway-4', 'things_to_do', 'Near The Pour House, Frost Beer Works, and Hinesburg Town Forest. Burlington is about 20 minutes away.'),
    ('hinesburg-hideaway-4', 'contact', 'Send us an Airbnb message. We usually reply soon.'),
    ('hinesburg-hideaway-4', 'stay_again', 'Book The Hinesburg Hideaway, Unit 4 again on Airbnb.'),
    ('backyard-bungalow', 'check_in', 'The door uses a code. Your code arrives in Airbnb messages. Check-in and checkout times: Details coming soon.'),
    ('backyard-bungalow', 'getting_here', 'South Burlington, about half a mile from the interstate and the airport. Free driveway parking.'),
    ('backyard-bungalow', 'wifi', 'Details coming soon. Network details stay in your Airbnb messages for now.'),
    ('backyard-bungalow', 'house_guide', 'Two bedrooms plus a queen pull-out sofa, one bath, sleeps 5. Fully fenced backyard and in-unit laundry.'),
    ('backyard-bungalow', 'house_rules', 'Pets are welcome and must stay off furniture and be house-trained. Request sofa bed linens when booking.'),
    ('backyard-bungalow', 'things_to_do', 'Close to everything in Burlington. Open Explore for nearby favorites.'),
    ('backyard-bungalow', 'contact', 'Send us an Airbnb message. We usually reply soon.'),
    ('backyard-bungalow', 'stay_again', 'Book Backyard Bungalow again on Airbnb.'),
    ('landing-pad', 'check_in', 'The door uses a code. Your code arrives in Airbnb messages. Check-in and checkout times: Details coming soon.'),
    ('landing-pad', 'getting_here', 'South Burlington, about 2 minutes from the airport and 10 minutes to downtown Burlington. Free parking.'),
    ('landing-pad', 'wifi', 'Details coming soon. Network details stay in your Airbnb messages for now.'),
    ('landing-pad', 'house_guide', 'Three bedrooms plus a queen pull-out couch, one bath, sleeps 8. Full kitchen, washer, and dryer.'),
    ('landing-pad', 'house_rules', 'Pets are allowed. A good fit for family reunions and group trips.'),
    ('landing-pad', 'things_to_do', 'About 10 minutes to downtown Burlington. Open Explore for nearby favorites.'),
    ('landing-pad', 'contact', 'Send us an Airbnb message. We usually reply soon.'),
    ('landing-pad', 'stay_again', 'Book The Landing Pad again on Airbnb.'),
    ('tennisplace-a35', 'check_in', 'The door uses a code. Your code arrives in Airbnb messages. Check-in and checkout times: Details coming soon.'),
    ('tennisplace-a35', 'getting_here', 'Sanibel Island, in the Tennisplace complex. Dixie Beach is steps away.'),
    ('tennisplace-a35', 'wifi', 'Details coming soon. Network details stay in your Airbnb messages for now.'),
    ('tennisplace-a35', 'house_guide', 'Two bedrooms, 1.5 baths, sleeps 5. Bikes, shared pool, kayak, and a waterfront gas grill.'),
    ('tennisplace-a35', 'house_rules', 'A waterfront condo with shared Tennisplace amenities.'),
    ('tennisplace-a35', 'things_to_do', 'Island ideas are coming soon.'),
    ('tennisplace-a35', 'contact', 'Send us an Airbnb message. We usually reply soon.'),
    ('tennisplace-a35', 'stay_again', 'Book A35 Tennisplace again on Airbnb.'),
    ('sanibel-sunsets', 'check_in', 'The door uses a code. Your code arrives in Airbnb messages. Check-in and checkout times: Details coming soon.'),
    ('sanibel-sunsets', 'getting_here', 'Sanibel Island, in the Tennisplace complex. Dixie Beach is about a 5-minute walk.'),
    ('sanibel-sunsets', 'wifi', 'Details coming soon. Network details stay in your Airbnb messages for now.'),
    ('sanibel-sunsets', 'house_guide', 'Two bedrooms, three beds, 1.5 baths, sleeps 4. Shared pool and tennis courts.'),
    ('sanibel-sunsets', 'house_rules', 'A canal-side condo with shared Tennisplace amenities.'),
    ('sanibel-sunsets', 'things_to_do', 'Island ideas are coming soon.'),
    ('sanibel-sunsets', 'contact', 'Send us an Airbnb message. We usually reply soon.'),
    ('sanibel-sunsets', 'stay_again', 'Book Sanibel Sunsets again on Airbnb.')
) as v(slug, section_type, summary) on true
where s.property_id = p.id
  and site.key = 'dad'
  and p.slug = v.slug
  and s.section_type = v.section_type;

-- One published block per visible section (sort_order 10).
insert into public.guidebook_blocks (
  id, section_id, block_type, sort_order, title, body, published_at
)
select
  v.block_id,
  s.id,
  v.block_type,
  10,
  v.title,
  v.body,
  now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
join public.sites site on site.id = p.site_id
join (
  values
    -- The Cider Loft
    (
      'd4000000-0000-4000-8000-000000000101'::uuid,
      'cider-loft',
      'getting_here',
      'rich_text',
      'Finding the loft',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Cider Loft is in Waterbury Center, Vermont, right next to Cold Hollow Cider Mill and a minute up the road from Ben & Jerry's Factory.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000102'::uuid,
      'cider-loft',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park on site.',
            'detail', 'Parking is free.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
          )
        )
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000103'::uuid,
      'cider-loft',
      'wifi',
      'rich_text',
      'Wi-Fi and the TV',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon.

The loft has a 55-inch smart TV. The Wi-Fi network name and password stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000104'::uuid,
      'cider-loft',
      'house_guide',
      'rich_text',
      'The loft',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Cider Loft has 2 bedrooms with 2 queens, plus a futon or sofa bed in the living room, 1 bath, and sleeps 5.

There is a well-equipped kitchen and a spacious living area. The bathroom is small. Please take care on the steep stairs.

Window AC is available May through September.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000105'::uuid,
      'cider-loft',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Pets are allowed.

Please take care on the steep stairs, and treat the loft like your own.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000106'::uuid,
      'cider-loft',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Cold Hollow Cider Mill is walkable from the loft. Open Explore for Waterbury and Stowe places nearby.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000107'::uuid,
      'cider-loft',
      'contact',
      'rich_text',
      'Reach us',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Send us an Airbnb message anytime. Door codes, Wi-Fi details, and timing questions are easiest there.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000108'::uuid,
      'cider-loft',
      'stay_again',
      'rich_text',
      'Come back anytime',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Loved your stay? Book The Cider Loft again on Airbnb.$copy$
      )
    ),

    -- Switchback Suite
    (
      'd4000000-0000-4000-8000-000000000201'::uuid,
      'switchback-suite',
      'getting_here',
      'rich_text',
      'Finding the suite',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Switchback Suite is in Stowe, Vermont, at the base of the Cady Hill Forest mountain bike trails.

Stowe Village and the Vermont Ski & Snowboard Museum are about a 5-minute walk.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000202'::uuid,
      'switchback-suite',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park on site.',
            'detail', 'Parking is free.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
          )
        )
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000203'::uuid,
      'switchback-suite',
      'wifi',
      'rich_text',
      'Wi-Fi',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon.

The Wi-Fi network name and password stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000204'::uuid,
      'switchback-suite',
      'house_guide',
      'rich_text',
      'The suite',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Switchback Suite has 1 bedroom with a queen, 1 bath, and sleeps 3.

There is a patio and AC. Lunch is next door at Ranch Camp or Backyard Tavern, and Rimrocks Mountain Tavern and Alfie's Wild Ride are within walking distance.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000205'::uuid,
      'switchback-suite',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Please treat the suite like your own and keep evenings neighbor-friendly after a day on the trails.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000206'::uuid,
      'switchback-suite',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Open Explore for Stowe favorites, including walkable spots like Ranch Camp, Backyard Tavern, Rimrocks Mountain Tavern, Alfie's Wild Ride, and the Vermont Ski & Snowboard Museum.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000207'::uuid,
      'switchback-suite',
      'contact',
      'rich_text',
      'Reach us',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Send us an Airbnb message anytime. Door codes, Wi-Fi details, and timing questions are easiest there.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000208'::uuid,
      'switchback-suite',
      'stay_again',
      'rich_text',
      'Come back anytime',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Loved your stay? Book Switchback Suite again on Airbnb.$copy$
      )
    ),

    -- Hinesburg Hideaway Unit 3
    (
      'd4000000-0000-4000-8000-000000000301'::uuid,
      'hinesburg-hideaway-3',
      'getting_here',
      'rich_text',
      'Finding the hideaway',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Hinesburg Hideaway, Unit 3 is in Hinesburg, Vermont, in a charming sixplex.

Burlington is about 20 minutes away.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Guest parking is marked with a sign out front.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000302'::uuid,
      'hinesburg-hideaway-3',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park in a marked guest spot.',
            'detail', 'Guest parking is marked with a sign out front.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
          )
        )
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000303'::uuid,
      'hinesburg-hideaway-3',
      'wifi',
      'rich_text',
      'Wi-Fi and the TV',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon.

There is a smart TV. The Wi-Fi network name and password stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000304'::uuid,
      'hinesburg-hideaway-3',
      'house_guide',
      'rich_text',
      'The apartment',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Unit 3 has 1 bedroom with a queen plus a queen pull-out, 1 bath, and sleeps 4.

There is a back patio with a serene view. Window AC is available May through September.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000305'::uuid,
      'hinesburg-hideaway-3',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Pets are allowed.

Please use the marked guest parking and keep the shared building peaceful for neighbors.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000306'::uuid,
      'hinesburg-hideaway-3',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$You are near The Pour House, Frost Beer Works, and Hinesburg Town Forest bike trails. Open Explore for Burlington-area favorites too.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000307'::uuid,
      'hinesburg-hideaway-3',
      'contact',
      'rich_text',
      'Reach us',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Send us an Airbnb message anytime. Door codes, Wi-Fi details, and timing questions are easiest there.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000308'::uuid,
      'hinesburg-hideaway-3',
      'stay_again',
      'rich_text',
      'Come back anytime',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Loved your stay? Book The Hinesburg Hideaway, Unit 3 again on Airbnb.$copy$
      )
    ),

    -- Hinesburg Hideaway Unit 4
    (
      'd4000000-0000-4000-8000-000000000401'::uuid,
      'hinesburg-hideaway-4',
      'getting_here',
      'rich_text',
      'Finding the hideaway',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Hinesburg Hideaway, Unit 4 is in Hinesburg, Vermont, in a charming sixplex.

Burlington is about 20 minutes away.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Guest parking is marked with a sign out front.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000402'::uuid,
      'hinesburg-hideaway-4',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park in a marked guest spot.',
            'detail', 'Guest parking is marked with a sign out front.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
          )
        )
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000403'::uuid,
      'hinesburg-hideaway-4',
      'wifi',
      'rich_text',
      'Wi-Fi and the TV',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon.

There is a smart TV. The Wi-Fi network name and password stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000404'::uuid,
      'hinesburg-hideaway-4',
      'house_guide',
      'rich_text',
      'The apartment',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Unit 4 has 1 bedroom with a queen plus a queen pull-out, 1 bath, and sleeps 4.

There is a back patio with a serene view. Window AC is available May through September.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000405'::uuid,
      'hinesburg-hideaway-4',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Pets are allowed.

Please use the marked guest parking and keep the shared building peaceful for neighbors.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000406'::uuid,
      'hinesburg-hideaway-4',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$You are near The Pour House, Frost Beer Works, and Hinesburg Town Forest bike trails. Open Explore for Burlington-area favorites too.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000407'::uuid,
      'hinesburg-hideaway-4',
      'contact',
      'rich_text',
      'Reach us',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Send us an Airbnb message anytime. Door codes, Wi-Fi details, and timing questions are easiest there.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000408'::uuid,
      'hinesburg-hideaway-4',
      'stay_again',
      'rich_text',
      'Come back anytime',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Loved your stay? Book The Hinesburg Hideaway, Unit 4 again on Airbnb.$copy$
      )
    ),

    -- Backyard Bungalow
    (
      'd4000000-0000-4000-8000-000000000501'::uuid,
      'backyard-bungalow',
      'getting_here',
      'rich_text',
      'Finding the bungalow',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Backyard Bungalow is in South Burlington, Vermont, about half a mile from the interstate and the airport, and close to everything in Burlington.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free in the driveway.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000502'::uuid,
      'backyard-bungalow',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park in the driveway.',
            'detail', 'Parking is free in the driveway.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
          )
        )
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000503'::uuid,
      'backyard-bungalow',
      'wifi',
      'rich_text',
      'Wi-Fi and the TV',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon.

There is a smart TV. The Wi-Fi network name and password stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000504'::uuid,
      'backyard-bungalow',
      'house_guide',
      'rich_text',
      'The home',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Backyard Bungalow has 2 bedrooms plus a queen pull-out sofa, 1 bath, and sleeps 5.

There is a fully fenced backyard, a front porch, a fully stocked kitchen, a dining table, and in-unit laundry. Sofa bed linens must be requested when booking. Window AC is available May through September.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000505'::uuid,
      'backyard-bungalow',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Pets are welcome and must stay off furniture and be house-trained.

Please request sofa bed linens when booking if you need them.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000506'::uuid,
      'backyard-bungalow',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$You are close to Burlington. Open Explore for nearby places to eat, drink, and get outside.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000507'::uuid,
      'backyard-bungalow',
      'contact',
      'rich_text',
      'Reach us',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Send us an Airbnb message anytime. Door codes, Wi-Fi details, and timing questions are easiest there.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000508'::uuid,
      'backyard-bungalow',
      'stay_again',
      'rich_text',
      'Come back anytime',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Loved your stay? Book Backyard Bungalow again on Airbnb.$copy$
      )
    ),

    -- The Landing Pad
    (
      'd4000000-0000-4000-8000-000000000601'::uuid,
      'landing-pad',
      'getting_here',
      'rich_text',
      'Finding the home',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Landing Pad is in a family-friendly neighborhood in South Burlington, Vermont, about 2 minutes from the airport and 10 minutes to downtown Burlington.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000602'::uuid,
      'landing-pad',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park on site.',
            'detail', 'Parking is free.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
          )
        )
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000603'::uuid,
      'landing-pad',
      'wifi',
      'rich_text',
      'Wi-Fi',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon.

The Wi-Fi network name and password stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000604'::uuid,
      'landing-pad',
      'house_guide',
      'rich_text',
      'The home',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Landing Pad has 3 bedrooms (queen; two singles; queen) plus a queen pull-out couch, 1 bath, and sleeps 8.

There is a full kitchen, a washer and dryer, and plenty of room for family reunions and group trips.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000605'::uuid,
      'landing-pad',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Pets are allowed.

Please treat the home like your own, especially with a larger group.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000606'::uuid,
      'landing-pad',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Downtown Burlington is about 10 minutes away. Open Explore for nearby places to eat, drink, and get outside.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000607'::uuid,
      'landing-pad',
      'contact',
      'rich_text',
      'Reach us',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Send us an Airbnb message anytime. Door codes, Wi-Fi details, and timing questions are easiest there.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000608'::uuid,
      'landing-pad',
      'stay_again',
      'rich_text',
      'Come back anytime',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Loved your stay? Book The Landing Pad again on Airbnb.$copy$
      )
    ),

    -- A35 Tennisplace
    (
      'd4000000-0000-4000-8000-000000000701'::uuid,
      'tennisplace-a35',
      'getting_here',
      'rich_text',
      'Finding the condo',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$A35 Tennisplace is on Sanibel Island, Florida, in the Tennisplace complex.

Dixie Beach is steps away, with canal views and great sunrises.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking details: Details coming soon.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000702'::uuid,
      'tennisplace-a35',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Arrive at Tennisplace.',
            'detail', 'Parking details: Details coming soon. Check your Airbnb messages if you need them sooner.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
          )
        )
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000703'::uuid,
      'tennisplace-a35',
      'wifi',
      'rich_text',
      'Wi-Fi',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon.

The Wi-Fi network name and password stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000704'::uuid,
      'tennisplace-a35',
      'house_guide',
      'rich_text',
      'The condo',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$A35 Tennisplace has 2 bedrooms with 2 queens, 1.5 baths, and sleeps 5.

Bikes are included. Guests share a pool, a kayak, and a waterfront gas grill.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000705'::uuid,
      'tennisplace-a35',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Please treat the condo and shared Tennisplace spaces with care.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000706'::uuid,
      'tennisplace-a35',
      'things_to_do',
      'rich_text',
      'Island ideas',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Sanibel Things to Do are coming soon. For now, Dixie Beach is steps away.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000707'::uuid,
      'tennisplace-a35',
      'contact',
      'rich_text',
      'Reach us',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Send us an Airbnb message anytime. Door codes, Wi-Fi details, and timing questions are easiest there.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000708'::uuid,
      'tennisplace-a35',
      'stay_again',
      'rich_text',
      'Come back anytime',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Loved your stay? Book A35 Tennisplace again on Airbnb.$copy$
      )
    ),

    -- Sanibel Sunsets
    (
      'd4000000-0000-4000-8000-000000000801'::uuid,
      'sanibel-sunsets',
      'getting_here',
      'rich_text',
      'Finding the condo',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Sanibel Sunsets is on Sanibel Island, Florida, in the Tennisplace complex.

Dixie Beach is about a 5-minute walk, and bike paths are close by.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking details: Details coming soon.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000802'::uuid,
      'sanibel-sunsets',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Arrive at Tennisplace.',
            'detail', 'Parking details: Details coming soon. Check your Airbnb messages if you need them sooner.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
          )
        )
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000803'::uuid,
      'sanibel-sunsets',
      'wifi',
      'rich_text',
      'Wi-Fi',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon.

The Wi-Fi network name and password stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000804'::uuid,
      'sanibel-sunsets',
      'house_guide',
      'rich_text',
      'The condo',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Sanibel Sunsets has 2 bedrooms, 3 beds, 1.5 baths, and sleeps 4.

The condo was recently updated with stylish decor. Guests share a pool and tennis courts. Guests have spotted dolphins and manatees from the porch.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000805'::uuid,
      'sanibel-sunsets',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Please treat the condo and shared Tennisplace spaces with care.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000806'::uuid,
      'sanibel-sunsets',
      'things_to_do',
      'rich_text',
      'Island ideas',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Sanibel Things to Do are coming soon. For now, Dixie Beach is about a 5-minute walk.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000807'::uuid,
      'sanibel-sunsets',
      'contact',
      'rich_text',
      'Reach us',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Send us an Airbnb message anytime. Door codes, Wi-Fi details, and timing questions are easiest there.$copy$
      )
    ),
    (
      'd4000000-0000-4000-8000-000000000808'::uuid,
      'sanibel-sunsets',
      'stay_again',
      'rich_text',
      'Come back anytime',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Loved your stay? Book Sanibel Sunsets again on Airbnb.$copy$
      )
    )
) as v(block_id, slug, section_type, block_type, title, body) on true
where site.key = 'dad'
  and p.slug = v.slug
  and s.section_type = v.section_type
on conflict (id) do update
set
  section_id = excluded.section_id,
  block_type = excluded.block_type,
  sort_order = excluded.sort_order,
  title = excluded.title,
  body = excluded.body,
  published_at = now(),
  updated_at = now();

-- Contact channels (Airbnb message only).
insert into public.contact_channels (
  id, property_id, channel, label, value, is_public, sort_order
)
select
  v.id,
  p.id,
  'airbnb',
  'Message us on Airbnb',
  'https://www.airbnb.com/contact_host/' || v.listing_id || '/send_message',
  true,
  10
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('d5000000-0000-4000-8000-000000000001'::uuid, 'cider-loft', '1023460212381916818'),
    ('d5000000-0000-4000-8000-000000000002'::uuid, 'switchback-suite', '1761768336055441703'),
    ('d5000000-0000-4000-8000-000000000003'::uuid, 'hinesburg-hideaway-3', '1670342835514127170'),
    ('d5000000-0000-4000-8000-000000000004'::uuid, 'hinesburg-hideaway-4', '1112651278987100311'),
    ('d5000000-0000-4000-8000-000000000005'::uuid, 'backyard-bungalow', '1446658231727793804'),
    ('d5000000-0000-4000-8000-000000000006'::uuid, 'landing-pad', '1613844938721866124'),
    ('d5000000-0000-4000-8000-000000000007'::uuid, 'tennisplace-a35', '23935067'),
    ('d5000000-0000-4000-8000-000000000008'::uuid, 'sanibel-sunsets', '1243434481811937377')
) as v(id, slug, listing_id) on true
where s.key = 'dad'
  and p.slug = v.slug
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  value = excluded.value,
  is_public = true,
  sort_order = excluded.sort_order,
  updated_at = now();

-- Primary Airbnb booking links.
insert into public.booking_links (
  id, property_id, channel, label, url, is_primary, sort_order
)
select
  v.id,
  p.id,
  'airbnb',
  'Book ' || p.name || ' on Airbnb',
  'https://www.airbnb.com/rooms/' || v.listing_id,
  true,
  10
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('d6000000-0000-4000-8000-000000000001'::uuid, 'cider-loft', '1023460212381916818'),
    ('d6000000-0000-4000-8000-000000000002'::uuid, 'switchback-suite', '1761768336055441703'),
    ('d6000000-0000-4000-8000-000000000003'::uuid, 'hinesburg-hideaway-3', '1670342835514127170'),
    ('d6000000-0000-4000-8000-000000000004'::uuid, 'hinesburg-hideaway-4', '1112651278987100311'),
    ('d6000000-0000-4000-8000-000000000005'::uuid, 'backyard-bungalow', '1446658231727793804'),
    ('d6000000-0000-4000-8000-000000000006'::uuid, 'landing-pad', '1613844938721866124'),
    ('d6000000-0000-4000-8000-000000000007'::uuid, 'tennisplace-a35', '23935067'),
    ('d6000000-0000-4000-8000-000000000008'::uuid, 'sanibel-sunsets', '1243434481811937377')
) as v(id, slug, listing_id) on true
where s.key = 'dad'
  and p.slug = v.slug
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  url = excluded.url,
  is_primary = true,
  sort_order = excluded.sort_order,
  updated_at = now();

-- Nearby essentials by town.
insert into public.nearby_essentials (
  property_id, kind, label, search_query, note, sort_order, published_at
)
select
  p.id,
  item.kind,
  item.label,
  item.search_lead || ' ' || town.town,
  item.note,
  item.sort_order,
  now()
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('cider-loft', 'Waterbury Center VT'),
    ('switchback-suite', 'Stowe VT'),
    ('hinesburg-hideaway-3', 'Hinesburg VT'),
    ('hinesburg-hideaway-4', 'Hinesburg VT'),
    ('backyard-bungalow', 'South Burlington VT'),
    ('landing-pad', 'South Burlington VT'),
    ('tennisplace-a35', 'Sanibel FL'),
    ('sanibel-sunsets', 'Sanibel FL')
) as town(slug, town) on town.slug = p.slug
cross join (
  values
    ('grocery'::text, 'Grocery store'::text, 'grocery store near'::text, null::text, 10),
    ('pharmacy', 'Pharmacy', 'pharmacy near', null, 20),
    ('gas', 'Gas station', 'gas station near', null, 30),
    ('urgent_care', 'Urgent care', 'urgent care near', null, 40),
    ('hospital', 'Hospital (ER)', 'hospital near', 'For emergencies, call 911.', 50)
) as item(kind, label, search_lead, note, sort_order)
where s.key = 'dad'
on conflict (property_id, kind) do update
set
  label = excluded.label,
  search_query = excluded.search_query,
  note = excluded.note,
  sort_order = excluded.sort_order,
  published_at = coalesce(public.nearby_essentials.published_at, now()),
  updated_at = now();

-- Checkout items.
insert into public.checkout_items (
  id, property_id, sort_order, is_visible, label, details, published_at
)
select
  v.id,
  p.id,
  10,
  true,
  'Details coming soon',
  'Checkout steps, trash, and thermostat instructions are coming soon. Message us on Airbnb if you need them before then.',
  now()
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('d7000000-0000-4000-8000-000000000001'::uuid, 'cider-loft'),
    ('d7000000-0000-4000-8000-000000000002'::uuid, 'switchback-suite'),
    ('d7000000-0000-4000-8000-000000000003'::uuid, 'hinesburg-hideaway-3'),
    ('d7000000-0000-4000-8000-000000000004'::uuid, 'hinesburg-hideaway-4'),
    ('d7000000-0000-4000-8000-000000000005'::uuid, 'backyard-bungalow'),
    ('d7000000-0000-4000-8000-000000000006'::uuid, 'landing-pad'),
    ('d7000000-0000-4000-8000-000000000007'::uuid, 'tennisplace-a35'),
    ('d7000000-0000-4000-8000-000000000008'::uuid, 'sanibel-sunsets')
) as v(id, slug) on true
where s.key = 'dad'
  and p.slug = v.slug
on conflict (id) do update
set
  property_id = excluded.property_id,
  sort_order = excluded.sort_order,
  is_visible = true,
  label = excluded.label,
  details = excluded.details,
  published_at = coalesce(public.checkout_items.published_at, now()),
  updated_at = now();

-- Dad brand name.
insert into public.site_settings (site_id, key, value)
select
  s.id,
  'brand_name',
  '"The Far & Familiar Collection"'::jsonb
from public.sites s
where s.key = 'dad'
on conflict (site_id, key) do update
set
  value = excluded.value,
  updated_at = now();

do $check$
declare
  dad_count integer;
  roost_touched integer;
begin
  select count(*) into dad_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and p.slug in (
      'cider-loft',
      'switchback-suite',
      'hinesburg-hideaway-3',
      'hinesburg-hideaway-4',
      'backyard-bungalow',
      'landing-pad',
      'tennisplace-a35',
      'sanibel-sunsets'
    );

  if dad_count <> 8 then
    raise exception 'Expected 8 dad properties, found %', dad_count;
  end if;

  select count(*) into roost_touched
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'roost'
    and p.slug in (
      'cider-loft',
      'switchback-suite',
      'hinesburg-hideaway-3',
      'hinesburg-hideaway-4',
      'backyard-bungalow',
      'landing-pad',
      'tennisplace-a35',
      'sanibel-sunsets'
    );

  if roost_touched > 0 then
    raise exception 'Dad property slugs must not belong to the roost site';
  end if;
end
$check$;

notify pgrst, 'reload schema';
