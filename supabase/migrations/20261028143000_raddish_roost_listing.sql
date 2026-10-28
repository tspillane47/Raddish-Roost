-- The Raddish Roost listing content.
-- Paste once in the Supabase SQL Editor after the original three files have already run.
-- This updates existing rows. It does not change the seed file and it does not rewrite
-- The Shallot Chalet. The shared building location is updated, and the four Main Street
-- favorites are linked to both The Raddish Roost and The Onion Ranch.
-- The spelling "The Raddish Roost" is intentional.
-- No door code is stored. Wi-Fi network details stay in the guest's Airbnb messages.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'raddish-roost') then
    raise exception 'The Raddish Roost was not found. Paste the seed file before this one.';
  end if;
end;
$$;

update public.locations
set
  name = 'Main Street, Waterbury, Vermont',
  notes = 'The Raddish Roost and The Onion Ranch share this building on Main Street in Waterbury, Vermont. No street number yet.'
where id = (
  select location_id from public.properties where slug = 'raddish-roost'
);

update public.properties
set
  tagline = 'A restored 1899 farmhouse right on Main Street in Waterbury',
  description = 'Cozy, rustic, cabin-style farmhouse built in 1899 and newly restored while keeping its charm. Great for couples, families, or friends. In the heart of Waterbury but still feels like your own private retreat.',
  welcome_title = 'Welcome to The Raddish Roost',
  welcome_message = 'We''re so glad you''re here. The Raddish Roost is a cozy, rustic, cabin-style farmhouse built in 1899 and newly restored while keeping its charm. It is great for couples, families, or friends. You are in the heart of Waterbury, and the house still feels like your own private retreat.',
  address_line = 'Main Street',
  locality = 'Waterbury',
  region = 'VT',
  postal_code = null,
  google_maps_url = null,
  apple_maps_url = null,
  check_in_time = 'Details coming soon',
  check_out_time = 'Details coming soon',
  parking_summary = 'Free parking on site. The driveway is shared with neighbors, so please only park in the designated spots.',
  status = 'published',
  published_at = coalesce(published_at, now())
where slug = 'raddish-roost';

update public.guidebook_sections s
set
  summary = v.summary,
  is_visible = true,
  published_at = coalesce(s.published_at, now())
from public.properties p,
(
  values
    ('getting_here', 'On Main Street in Waterbury, a walk from downtown restaurants, cafes, and a grocery store.'),
    ('check_in', 'The door uses a code. Your code arrives in Airbnb messages on the day of check-in.'),
    ('wifi', 'High-speed Wi-Fi, with the network details in your reservation, plus a smart TV.'),
    ('house_guide', 'Three bedrooms, and a note about the steep stairs.'),
    ('amenities', 'Kitchen, fireplace, heat, laundry, porch, and a smart TV.'),
    ('recommendations', 'Host favorites on Main Street, all within walking distance.'),
    ('things_to_do', 'Walk to downtown. More ideas are coming soon.'),
    ('house_rules', 'Dogs, extra guests, parties, and where to park.'),
    ('checkout', 'Details coming soon.'),
    ('faq', 'Details coming soon.'),
    ('contact', 'Send us an Airbnb message. Phone and email are not posted yet.'),
    ('stay_again', 'Book The Raddish Roost again on Airbnb.')
) as v(section_type, summary)
where s.property_id = p.id
  and p.slug = 'raddish-roost'
  and s.section_type = v.section_type;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Finding the house',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Raddish Roost is on Main Street in Waterbury, Vermont. It shares the building with The Onion Ranch.

You can walk to downtown restaurants, cafes, and a grocery store.

The street number is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site. The driveway is shared with neighbors, so please park only in the designated spots.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
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
        'title', 'Park in a designated spot.',
        'detail', 'Parking is free on site. The driveway is shared with neighbors, so please only park in the designated spots.'
      ),
      jsonb_build_object(
        'title', 'Use the coded door.',
        'detail', 'Your unique code is sent through Airbnb messages on the day of check-in.'
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
  and p.slug = 'raddish-roost'
  and s.section_type = 'check_in'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Wi-Fi and the TV',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The house has high-speed Wi-Fi. The network name and password come with your reservation for now. Check your Airbnb messages for those details.

The living room has a smart TV, with Netflix and HBO included.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'wifi'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'The house',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Raddish Roost has 3 bedrooms, 3 beds, and 1 full bathroom. There is a living area, a separate dining room, a laundry room, and a front porch. The house sleeps up to 6.

The kitchen is fully equipped, with a gas stove and a dishwasher. The living room has an electric fireplace. The house has propane heat and air conditioning. The laundry room has a washer and a dryer. The front porch is for morning coffee or evening drinks.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'house_guide'
  and b.sort_order = 10;

insert into public.guidebook_blocks (id, section_id, block_type, sort_order, title, body, published_at)
select
  'd4000000-0000-4000-8000-000000000001',
  s.id,
  'callout',
  20,
  'Please take care on the stairs',
  jsonb_build_object(
    'type', 'callout',
    'tone', 'important',
    'markdown', 'This is an old home. The stairs to the bedrooms are steep, so please take care, especially with kids or anyone unsteady on stairs.'
  ),
  now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
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
    'markdown', $copy$- Fully equipped kitchen with a gas stove and a dishwasher
- Electric fireplace in the living room
- Propane heat
- Air conditioning
- Washer and dryer in the laundry room
- Front porch for morning coffee or evening drinks
- Smart TV in the living room, with Netflix and HBO included$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'amenities'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Our favorites',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$These are our favorites, all walking distance on Main Street:

- The Reservoir
- Prohibition Pig
- Blackback Pub
- Hen of the Wood

Address, website, and hours are details coming soon.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'recommendations'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Around town',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$You can walk to downtown restaurants, cafes, and a grocery store. Our favorite places to eat and drink are in Local Recommendations.

Details coming soon for more things to do.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'things_to_do'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'House rules',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Dogs are welcome. The pet fee is $100, and it is arranged through Airbnb.

Extra guests beyond the booking are $25 per person.

No parties. The penalty is $1,000.

Please park only in the designated spots. The driveway is shared with neighbors.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
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
  and p.slug = 'raddish-roost'
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
  and p.slug = 'raddish-roost'
  and s.section_type = 'faq'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Message your hosts',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$You can reach us with an Airbnb message. We do not have a phone number or email on this page yet.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1477625352327415954/send_message)$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'contact'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Come back',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$We would love to host you again at The Raddish Roost.

[Book The Raddish Roost on Airbnb](https://www.airbnb.com/rooms/1477625352327415954)$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'stay_again'
  and b.sort_order = 10;

update public.amenities a
set
  name = 'Kitchen',
  description = 'Fully equipped kitchen with a gas stove and a dishwasher.',
  sort_order = 10,
  is_visible = true,
  published_at = coalesce(a.published_at, now())
where a.property_id = (select id from public.properties where slug = 'raddish-roost')
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
    ('e5000000-0000-4000-8000-000000000002'::uuid, 20, 'Electric fireplace', 'In the living room.'),
    ('e5000000-0000-4000-8000-000000000003'::uuid, 30, 'Propane heat', 'The house is heated with propane.'),
    ('e5000000-0000-4000-8000-000000000004'::uuid, 40, 'Air conditioning', 'The house has air conditioning.'),
    ('e5000000-0000-4000-8000-000000000005'::uuid, 50, 'Washer and dryer', 'In the laundry room.'),
    ('e5000000-0000-4000-8000-000000000006'::uuid, 60, 'Front porch', 'For morning coffee or evening drinks.'),
    ('e5000000-0000-4000-8000-000000000007'::uuid, 70, 'Smart TV', 'In the living room, with Netflix and HBO included.')
) as v(id, sort_order, name, description) on true
where p.slug = 'raddish-roost'
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
where f.property_id = (select id from public.properties where slug = 'raddish-roost')
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
where c.property_id = (select id from public.properties where slug = 'raddish-roost')
  and c.sort_order = (
    select min(other.sort_order)
    from public.checkout_items other
    where other.property_id = c.property_id
  );

insert into public.contact_channels (id, property_id, channel, label, value, is_public, sort_order)
select
  'f6000000-0000-4000-8000-000000000001',
  p.id,
  'airbnb',
  'Message us on Airbnb',
  'https://www.airbnb.com/contact_host/1477625352327415954/send_message',
  true,
  10
from public.properties p
where p.slug = 'raddish-roost'
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
  'f6000000-0000-4000-8000-000000000002',
  p.id,
  'airbnb',
  'Book The Raddish Roost on Airbnb',
  'https://www.airbnb.com/rooms/1477625352327415954',
  true,
  10
from public.properties p
where p.slug = 'raddish-roost'
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
    'c3000000-0000-4000-8000-000000000001',
    'food_drink',
    true,
    'The Reservoir',
    'Walking distance on Main Street in Waterbury.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000002',
    'food_drink',
    true,
    'Prohibition Pig',
    'Walking distance on Main Street in Waterbury.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000003',
    'food_drink',
    true,
    'Blackback Pub',
    'Walking distance on Main Street in Waterbury.',
    'A host favorite.',
    null,
    null,
    null,
    now()
  ),
  (
    'c3000000-0000-4000-8000-000000000004',
    'food_drink',
    true,
    'Hen of the Wood',
    'Walking distance on Main Street in Waterbury.',
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
    ('c3000000-0000-4000-8000-000000000001'::uuid, 10),
    ('c3000000-0000-4000-8000-000000000002'::uuid, 20),
    ('c3000000-0000-4000-8000-000000000003'::uuid, 30),
    ('c3000000-0000-4000-8000-000000000004'::uuid, 40)
) as r(recommendation_id, sort_order) on true
where p.slug in ('raddish-roost', 'onion-ranch')
on conflict (property_id, recommendation_id) do update
set
  is_featured = true,
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now());

notify pgrst, 'reload schema';
