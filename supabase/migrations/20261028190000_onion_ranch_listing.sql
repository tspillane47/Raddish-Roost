-- The Onion Ranch listing content, plus a location correction.
-- Paste once in the Supabase SQL Editor after the earlier files have already run.
-- The Raddish Roost is on its own on Main Street in Waterbury, Vermont.
-- The Onion Ranch and The Shallot Chalet share one building in Winooski, Vermont.
-- No street number is stored. No access code is stored. Wi-Fi network details stay in Airbnb messages.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'onion-ranch') then
    raise exception 'The Onion Ranch was not found. Paste the seed file before this one.';
  end if;
end;
$$;

update public.locations
set
  name = 'Main Street, Waterbury, Vermont',
  notes = 'The Raddish Roost is on its own on Main Street in Waterbury, Vermont. No street number yet.'
where id = 'a1000000-0000-4000-8000-000000000001';

update public.locations
set
  name = 'Winooski, Vermont',
  notes = 'The Shallot Chalet and The Onion Ranch share this building in Winooski, Vermont. No street address yet.'
where id = 'a1000000-0000-4000-8000-000000000002';

update public.properties
set location_id = 'a1000000-0000-4000-8000-000000000002'
where slug = 'onion-ranch';

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Raddish Roost is on Main Street in Waterbury, Vermont. It is on its own.

You can walk to downtown restaurants, cafes, and a grocery store.

The street number is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site. The driveway is shared with neighbors, so please park only in the designated spots.$copy$
  )
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'raddish-roost'
  and s.section_type = 'getting_here'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Shallot Chalet is in Winooski, Vermont. It shares the building with The Onion Ranch.

You can walk to the Winooski Circle, with shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails. Burlington is close by.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site for 1 vehicle. Additional cars can use free street parking.$copy$
  )
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'getting_here'
  and b.sort_order = 10;

-- The Reservoir, Prohibition Pig, Blackback Pub, and Hen of the Wood stay with The Raddish Roost only.
delete from public.property_recommendations pr
using public.properties p
where pr.property_id = p.id
  and p.slug = 'onion-ranch'
  and pr.recommendation_id in (
    'c3000000-0000-4000-8000-000000000001',
    'c3000000-0000-4000-8000-000000000002',
    'c3000000-0000-4000-8000-000000000003',
    'c3000000-0000-4000-8000-000000000004'
  );

update public.properties
set
  tagline = 'A cozy two-bedroom in the heart of downtown Winooski',
  description = 'A cozy, comfortable two-bedroom apartment right downtown, close to all the action.',
  welcome_title = 'Welcome to The Onion Ranch',
  welcome_message = 'We''re so glad you''re here. The Onion Ranch is a cozy, comfortable two-bedroom apartment right downtown, close to all the action.',
  address_line = null,
  locality = 'Winooski',
  region = 'VT',
  postal_code = null,
  google_maps_url = null,
  apple_maps_url = null,
  check_in_time = 'Details coming soon',
  check_out_time = 'Details coming soon',
  parking_summary = 'Free parking on site.',
  status = 'published',
  published_at = coalesce(published_at, now())
where slug = 'onion-ranch';

update public.guidebook_sections s
set
  summary = v.summary,
  is_visible = true,
  published_at = coalesce(s.published_at, now())
from public.properties p,
(
  values
    ('getting_here', 'Downtown Winooski, about a 5-minute walk from the Winooski Circle.'),
    ('check_in', 'The door uses a code. Your code arrives in your Airbnb messages.'),
    ('wifi', 'Wi-Fi details come with your reservation. The TV has Netflix and HBO, and there is a workspace with a monitor.'),
    ('house_guide', 'Two bedrooms, one bathroom up a flight of stairs, a full kitchen, and an office space. Sleeps up to 4.'),
    ('amenities', 'A full kitchen, a drip coffee maker, and a workspace with a monitor.'),
    ('recommendations', 'Restaurants, coffee, and a brewery near the Winooski Circle, plus the river and falls.'),
    ('things_to_do', 'Walk to the Winooski Circle, or drive about 10 minutes to Burlington and Lake Champlain.'),
    ('house_rules', 'Pets are welcome. No parties.'),
    ('checkout', 'Details coming soon.'),
    ('faq', 'Details coming soon.'),
    ('contact', 'Send us an Airbnb message. We usually reply within an hour.'),
    ('stay_again', 'Book The Onion Ranch again on Airbnb.')
) as v(section_type, summary)
where s.property_id = p.id
  and p.slug = 'onion-ranch'
  and s.section_type = v.section_type;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Finding the apartment',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Onion Ranch is in downtown Winooski, Vermont. It shares the building with The Shallot Chalet.

The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques. Burlington is about a 10-minute drive, with more places to eat, Lake Champlain, and lots to explore. The Winooski River and Winooski Falls are nearby.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
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
        'title', 'Park on site.',
        'detail', 'Parking is free on site.'
      ),
      jsonb_build_object(
        'title', 'Use the coded door.',
        'detail', 'You do not need a key. Your code comes through your Airbnb messages.'
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
  and p.slug = 'onion-ranch'
  and s.section_type = 'check_in'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Wi-Fi and the TV',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Wi-Fi is available. The network name and password come with your reservation for now, so they are not on this page.

There is a smart TV with Netflix and HBO.

There is also a dedicated workspace with a monitor for remote work.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'wifi'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'The apartment',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Onion Ranch sleeps up to 4.

Bedroom 1 has a double bed. Bedroom 2 has a queen bed. There is 1 bathroom, up a flight of stairs. The kitchen is a full kitchen. There is office space with a monitor for remote work.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'house_guide'
  and b.sort_order = 10;

insert into public.guidebook_blocks (id, section_id, block_type, sort_order, title, body, published_at)
select
  'd4000000-0000-4000-8000-000000000021',
  s.id,
  'callout',
  20,
  'Stairs to the bathroom',
  jsonb_build_object(
    'type', 'callout',
    'tone', 'important',
    'markdown', $copy$The bathroom is up a flight of stairs. The apartment is not accessible for guests who can't use stairs.$copy$
  ),
  now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.section_type = 'house_guide'
on conflict (id) do update
set
  section_id = excluded.section_id,
  block_type = excluded.block_type,
  sort_order = excluded.sort_order,
  title = excluded.title,
  body = excluded.body,
  published_at = excluded.published_at;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'What is here',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The kitchen is a full kitchen, with a stove, an oven, and a drip coffee maker.

There is office space with a monitor for remote work.

The smart TV has Netflix and HBO. Wi-Fi details come with your reservation.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'amenities'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Please keep in mind',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Pets are welcome.

No parties. The fine is $1,000.

Parking is free on site.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'house_rules'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Places we like',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$These are a few places we like around Winooski. Addresses, websites, and hours are details coming soon.

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'recommendations'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'While you are here',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques.

Burlington is about a 10-minute drive. You will find more places to eat, Lake Champlain, and lots to explore.

The Winooski River and Winooski Falls are nearby.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'things_to_do'
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
  and p.slug = 'onion-ranch'
  and s.section_type = 'checkout'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Questions',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$Details coming soon.

If you need an answer before then, send us an Airbnb message. We usually reply within an hour.$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'faq'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Message your hosts',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$The best way to reach us is an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/862913226430309914/send_message)$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'contact'
  and b.sort_order = 10;

update public.guidebook_blocks b
set
  block_type = 'rich_text',
  title = 'Come back',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $copy$We would love to host you again at The Onion Ranch.

[Book The Onion Ranch on Airbnb](https://www.airbnb.com/rooms/862913226430309914)$copy$
  ),
  published_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug = 'onion-ranch'
  and s.section_type = 'stay_again'
  and b.sort_order = 10;

update public.amenities a
set
  name = 'Full kitchen',
  description = 'Stove, oven, and a drip coffee maker.',
  sort_order = 10,
  is_visible = true,
  published_at = coalesce(a.published_at, now())
where a.property_id = (select id from public.properties where slug = 'onion-ranch')
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
    ('e5000000-0000-4000-8000-000000000021'::uuid, 20, 'Wi-Fi', 'Network details come with your reservation.'),
    ('e5000000-0000-4000-8000-000000000022'::uuid, 30, 'Smart TV', 'Netflix and HBO.'),
    ('e5000000-0000-4000-8000-000000000023'::uuid, 40, 'Workspace', 'Office space with a monitor for remote work.'),
    ('e5000000-0000-4000-8000-000000000024'::uuid, 50, 'Free parking', 'Free parking on site.')
) as v(id, sort_order, name, description) on true
where p.slug = 'onion-ranch'
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
  answer = 'Common questions are not posted yet. Send us an Airbnb message if you need something. We usually reply within an hour.',
  is_visible = true,
  published_at = coalesce(f.published_at, now())
where f.property_id = (select id from public.properties where slug = 'onion-ranch')
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
where c.property_id = (select id from public.properties where slug = 'onion-ranch')
  and c.sort_order = (
    select min(other.sort_order)
    from public.checkout_items other
    where other.property_id = c.property_id
  );

insert into public.contact_channels (id, property_id, channel, label, value, is_public, sort_order)
select
  'f6000000-0000-4000-8000-000000000021',
  p.id,
  'airbnb',
  'Message us on Airbnb',
  'https://www.airbnb.com/contact_host/862913226430309914/send_message',
  true,
  10
from public.properties p
where p.slug = 'onion-ranch'
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
  'f6000000-0000-4000-8000-000000000022',
  p.id,
  'airbnb',
  'Book The Onion Ranch on Airbnb',
  'https://www.airbnb.com/rooms/862913226430309914',
  true,
  10
from public.properties p
where p.slug = 'onion-ranch'
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
where p.slug in ('shallot-chalet', 'onion-ranch')
on conflict (property_id, recommendation_id) do update
set
  is_featured = true,
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now());

notify pgrst, 'reload schema';
