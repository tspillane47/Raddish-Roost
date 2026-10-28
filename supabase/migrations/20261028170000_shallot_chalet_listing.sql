-- The Shallot Chalet listing content.
-- Paste once in the Supabase SQL Editor after the earlier files have already run.
-- This updates existing Shallot Chalet rows only. It does not change the seed,
-- The Raddish Roost, or The Onion Ranch.
-- Access details stay in the guest's Airbnb messages. Wi-Fi network details stay there too.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'shallot-chalet') then
    raise exception 'The Shallot Chalet was not found. Paste the seed file before this one.';
  end if;
end;
$$;

update public.locations
set
  name = 'Winooski, Vermont',
  notes = 'The Shallot Chalet is in Winooski, Vermont. No street address yet. It does not share a building with the other stays.'
where id = (
  select location_id from public.properties where slug = 'shallot-chalet'
);

update public.properties
set
  tagline = 'A cozy two-level stay steps from the Winooski Circle',
  description = 'A budget-friendly, newly renovated unit in an old house, close to Burlington. It has some quirks of an older home. Not a luxury stay, but comfortable, convenient, and a great value.',
  welcome_title = 'Welcome to The Shallot Chalet',
  welcome_message = 'We''re so glad you''re here. The Shallot Chalet is a budget-friendly, newly renovated unit in an old house, close to Burlington. It has some quirks of an older home. It is not a luxury stay, but it is comfortable, convenient, and a great value.',
  address_line = null,
  locality = 'Winooski',
  region = 'VT',
  postal_code = null,
  google_maps_url = null,
  apple_maps_url = null,
  check_in_time = 'Details coming soon',
  check_out_time = 'Details coming soon',
  parking_summary = 'Free on-site parking for 1 vehicle. Additional cars can use free street parking.',
  status = 'published',
  published_at = coalesce(published_at, now())
where slug = 'shallot-chalet';

update public.guidebook_sections s
set
  summary = v.summary,
  is_visible = true,
  published_at = coalesce(s.published_at, now())
from public.properties p,
(
  values
    ('getting_here', 'Walking distance to the Winooski Circle, near the river and the falls, and close to Burlington.'),
    ('check_in', 'Access instructions are in your Airbnb messages. Check-in details are coming soon.'),
    ('wifi', 'Wi-Fi and a TV are available. Network details come with your reservation.'),
    ('house_guide', 'Two levels, three bedrooms, one bathroom, and a note about the steep stairs.'),
    ('amenities', 'Kitchen, bathroom, Wi-Fi, TV, earplugs, and parking for one vehicle.'),
    ('recommendations', 'Host favorites in Winooski.'),
    ('things_to_do', 'The Winooski Circle, the river, and the falls.'),
    ('house_rules', 'Dogs are welcome. No cats. Fee details are coming soon.'),
    ('checkout', 'Details coming soon.'),
    ('faq', 'Details coming soon.'),
    ('contact', 'Send us an Airbnb message. We usually reply within an hour.'),
    ('stay_again', 'Book The Shallot Chalet again on Airbnb.')
) as v(section_type, summary)
where s.property_id = p.id
  and p.slug = 'shallot-chalet'
  and s.section_type = v.section_type;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Finding the house',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Shallot Chalet is in Winooski, Vermont. It does not share a building with the other stays.

You can walk to the Winooski Circle, with shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails. Burlington is close by.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site for 1 vehicle. Additional cars can use free street parking.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'getting_here'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'steps',
  title = 'Arriving',
  body = jsonb_build_object(
    'type', 'steps',
    'steps', jsonb_build_array(
      jsonb_build_object(
        'title', 'Check your Airbnb messages.',
        'detail', 'Access instructions are in your Airbnb messages. Details coming soon for the arrival steps on this page.'
      ),
      jsonb_build_object(
        'title', 'Park.',
        'detail', 'Free on-site parking for 1 vehicle. Additional cars can use free street parking.'
      ),
      jsonb_build_object(
        'title', 'Check-in and checkout times.',
        'detail', 'Details coming soon. If you need the times before then, check your Airbnb messages.'
      )
    )
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'check_in'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Wi-Fi and the TV',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Wi-Fi and a TV are available.

The network name and password come with your reservation for now. Check your Airbnb messages for those details.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'wifi'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'The house',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Shallot Chalet has two levels and sleeps up to 6. There is 1 bathroom.

On the ground floor you will find the kitchen, the bathroom, and Bedroom 1 with a queen bed.

Upstairs you will find the living room, Bedroom 2 with a queen bed, and Bedroom 3 with a double bed.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'house_guide'
  and b.sort_order = 10;

insert into public.guidebook_blocks (id, section_id, block_type, sort_order, title, body, published_at)
select
  'd4000000-0000-4000-8000-000000000011',
  s.id,
  'callout',
  20,
  'A few things to know',
  jsonb_build_object(
    'type', 'callout',
    'tone', 'important',
    'markdown', $copy$The stairs are steep. They may not suit young children or older guests.

The street is busy and can be noisy at night. Two of the three bedrooms face the main street. Earplugs are provided.

Two security cameras are on the property. They are exterior only.$copy$
  ),
  now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.section_type = 'house_guide'
on conflict (id) do update
set
  section_id = excluded.section_id,
  block_type = excluded.block_type,
  sort_order = excluded.sort_order,
  title = excluded.title,
  body = excluded.body,
  published_at = now();

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'What is here',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$- Kitchen on the ground floor
- One bathroom
- Wi-Fi
- TV
- Earplugs
- Free on-site parking for 1 vehicle$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'amenities'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Our favorites',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$These are our favorites in Winooski:

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails

Address, website, and hours are details coming soon.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'recommendations'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Around town',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$You can walk to the Winooski Circle for shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails.

Our favorite places are in Local Recommendations.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'things_to_do'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'House rules',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Dogs are welcome. Cats are not. If you have animal allergies, this may not be the best fit. Details on fees are coming soon.

Please use the on-site parking for 1 vehicle. Additional cars can use free street parking.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'house_rules'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Before you leave',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'checkout'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Questions',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Details coming soon.

If you need an answer before then, send us an Airbnb message.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'faq'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Message your hosts',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$You can reach us with an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1064639214342902592/send_message)$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'contact'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Come back',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$We would love to host you again at The Shallot Chalet.

[Book The Shallot Chalet on Airbnb](https://www.airbnb.com/rooms/1064639214342902592)$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'stay_again'
  and b.sort_order = 10;

update public.amenities a
set
  name = 'Kitchen',
  description = 'On the ground floor.',
  sort_order = 10,
  is_visible = true,
  published_at = coalesce(a.published_at, now())
where a.property_id = (select id from public.properties where slug = 'shallot-chalet')
  and a.sort_order = (
    select min(other.sort_order)
    from public.amenities other
    where other.property_id = a.property_id
  );

insert into public.amenities (id, property_id, sort_order, is_visible, name, description, published_at)
select
  v.id,
  p.id,
  v.sort_order,
  true,
  v.name,
  v.description,
  now()
from public.properties p
join (
  values
    ('e5000000-0000-4000-8000-000000000011'::uuid, 20, 'TV', 'A TV is available.'),
    ('e5000000-0000-4000-8000-000000000012'::uuid, 30, 'Wi-Fi', 'Network details come with your reservation.'),
    ('e5000000-0000-4000-8000-000000000013'::uuid, 40, 'Earplugs', 'Provided. Two bedrooms face the main street, and the street can be noisy at night.'),
    ('e5000000-0000-4000-8000-000000000014'::uuid, 50, 'Parking', 'Free on-site parking for 1 vehicle. Additional cars can use free street parking.')
) as v(id, sort_order, name, description) on true
where p.slug = 'shallot-chalet'
on conflict (id) do update
set
  property_id = excluded.property_id,
  sort_order = excluded.sort_order,
  is_visible = true,
  name = excluded.name,
  description = excluded.description,
  published_at = coalesce(public.amenities.published_at, now());

update public.faqs f
set
  question = 'Details coming soon',
  answer = 'Common questions are not posted yet. Send us an Airbnb message if you need something.',
  is_visible = true,
  published_at = coalesce(f.published_at, now())
where f.property_id = (select id from public.properties where slug = 'shallot-chalet')
  and f.sort_order = (
    select min(other.sort_order)
    from public.faqs other
    where other.property_id = f.property_id
  );

update public.checkout_items c
set
  label = 'Details coming soon',
  details = 'Checkout steps, trash, and thermostat instructions are coming soon. Message us on Airbnb if you need them before then.',
  is_visible = true,
  published_at = coalesce(c.published_at, now())
where c.property_id = (select id from public.properties where slug = 'shallot-chalet')
  and c.sort_order = (
    select min(other.sort_order)
    from public.checkout_items other
    where other.property_id = c.property_id
  );

insert into public.contact_channels (id, property_id, channel, label, value, is_public, sort_order)
select
  'f6000000-0000-4000-8000-000000000011',
  p.id,
  'airbnb',
  'Message us on Airbnb',
  'https://www.airbnb.com/contact_host/1064639214342902592/send_message',
  true,
  10
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  value = excluded.value,
  is_public = true,
  sort_order = excluded.sort_order;

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select
  'f6000000-0000-4000-8000-000000000012',
  p.id,
  'airbnb',
  'Book The Shallot Chalet on Airbnb',
  'https://www.airbnb.com/rooms/1064639214342902592',
  true,
  10
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  url = excluded.url,
  is_primary = true,
  sort_order = excluded.sort_order;

insert into public.recommendations (
  id, category, is_active, name, description, host_note, address, website_url, maps_url, published_at
)
values
  (
    'c3000000-0000-4000-8000-000000000011',
    'food_drink',
    true,
    'Waterworks',
    'A host favorite in Winooski.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000012',
    'food_drink',
    true,
    'Our House',
    'A host favorite in Winooski.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000013',
    'food_drink',
    true,
    'Mule Bar',
    'A host favorite in Winooski.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000014',
    'food_drink',
    true,
    'Onion City Chicken & Oysters',
    'A host favorite in Winooski.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000015',
    'food_drink',
    true,
    'Four Quarters Brewery',
    'A host favorite in Winooski.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000016',
    'food_drink',
    true,
    'Scout Coffee',
    'Coffee in Winooski. A host favorite.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000017',
    'outdoors',
    true,
    'Winooski Falls and river trails',
    'Waterfalls and river trails in Winooski.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  )
on conflict (id) do update
set
  category = excluded.category,
  is_active = true,
  name = excluded.name,
  description = excluded.description,
  host_note = excluded.host_note,
  address = null,
  website_url = null,
  maps_url = null,
  published_at = coalesce(public.recommendations.published_at, now());

insert into public.property_recommendations (
  property_id, recommendation_id, is_featured, sort_order, published_at
)
select
  p.id,
  r.recommendation_id,
  true,
  r.sort_order,
  now()
from public.properties p
join (
  values
    ('c3000000-0000-4000-8000-000000000011'::uuid, 10),
    ('c3000000-0000-4000-8000-000000000012'::uuid, 20),
    ('c3000000-0000-4000-8000-000000000013'::uuid, 30),
    ('c3000000-0000-4000-8000-000000000014'::uuid, 40),
    ('c3000000-0000-4000-8000-000000000015'::uuid, 50),
    ('c3000000-0000-4000-8000-000000000016'::uuid, 60),
    ('c3000000-0000-4000-8000-000000000017'::uuid, 70)
) as r(recommendation_id, sort_order) on true
where p.slug = 'shallot-chalet'
on conflict (property_id, recommendation_id) do update
set
  is_featured = true,
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now());

notify pgrst, 'reload schema';
