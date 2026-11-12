-- Errin / Queen City Stays properties, guidebook sections, Airbnb booking,
-- nearby essentials, Things to Do links, and Perfect Day clones.
-- Scoped to sites.key = 'errin' only. Does not change roost or dad properties.
-- Does not update shared recommendations rows. Safe to paste again. Wrapped in begin/commit so a failure rolls everything back.
-- Property migration had not been run yet, so slugs are the Queen City names:
-- winooski-flat, mill-house, maple-street-flat. No em dashes.

begin;

do $guard$
begin
  if not exists (select 1 from public.sites where key = 'errin') then
    raise exception 'Errin site is missing. Run 20261112000000_errin_site.sql before this file.';
  end if;
  if not exists (select 1 from public.properties where slug = 'shallot-chalet') then
    raise exception 'shallot-chalet is missing. Run roost seeds before linking Things to Do.';
  end if;
end
$guard$;

insert into public.locations (id, name, notes)
values
  (
    'e1000000-0000-4000-8000-000000000001',
    'Winooski, Vermont',
    'Home of The Winooski Flat and The Mill House.'
  ),
  (
    'e1000000-0000-4000-8000-000000000002',
    'Burlington, Vermont',
    'Home of The Maple Street Flat, on Maple Street.'
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
  'Details coming soon. Message Errin on Airbnb if you need anything before then.',
  'Details coming soon. Message Errin on Airbnb if you need anything before then.',
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
      'e2000000-0000-4000-8000-000000000001'::uuid,
      'e1000000-0000-4000-8000-000000000001'::uuid,
      'winooski-flat',
      'The Winooski Flat',
      'A quiet two-bedroom flat one block from downtown Winooski',
      $d$Entire 2-bedroom apartment with 1 bath, sleeps 4. Quiet street about one block from downtown Winooski. Private patio with seating. Full kitchen. Washer and dryer in the unit. Off-street parking. Pets welcome. Window AC May through September.$d$,
      'Welcome to The Winooski Flat',
      $w$Glad you are here. The Winooski Flat is a calm apartment just a short walk from downtown Winooski. Door codes always come through Airbnb messages. Make yourself at home.$w$,
      'Winooski',
      'VT',
      'vermont',
      'Off-street parking.',
      44.4914::numeric,
      -73.1854::numeric,
      1
    ),
    (
      'e2000000-0000-4000-8000-000000000002'::uuid,
      'e1000000-0000-4000-8000-000000000001'::uuid,
      'mill-house',
      'The Mill House',
      'A first-floor duplex flat with decks on both sides',
      $d$First-floor apartment in a duplex. 2 bedrooms (king and queen), 1 bath, sleeps 4. Two large decks, one on each side. Full kitchen, washer and dryer, dedicated workspace. Free parking on site. Pets welcome. Keypad entry; the code is sent the morning of check-in through Airbnb messages. About a 5 minute walk to the Winooski River Walk and the Heritage Winooski Mill Museum.$d$,
      'Welcome to The Mill House',
      $w$Glad you are here. The Mill House is a first-floor duplex flat with decks on both sides, a short walk from the river. Door codes always come through Airbnb messages. Make yourself at home.$w$,
      'Winooski',
      'VT',
      'vermont',
      'Free parking on site.',
      44.4914::numeric,
      -73.1854::numeric,
      2
    ),
    (
      'e2000000-0000-4000-8000-000000000003'::uuid,
      'e1000000-0000-4000-8000-000000000002'::uuid,
      'maple-street-flat',
      'The Maple Street Flat',
      'A ground-floor flat on Maple Street near Church Street',
      $d$Ground-floor apartment in a historic building on Maple Street. 2 bedrooms (queen and double), 1 bath, sleeps 4. Private porch and entry, great for morning coffee. Full kitchen and coffee maker. Assigned off-street parking spot. Coin-operated washer and dryer in the building. Pack 'n play available. Window AC May through September. About two blocks to Church Street and the waterfront.$d$,
      'Welcome to The Maple Street Flat',
      $w$Glad you are here. The Maple Street Flat is a ground-floor apartment in a historic building, about two blocks from Church Street and the waterfront. Door codes always come through Airbnb messages. Make yourself at home.$w$,
      'Burlington',
      'VT',
      'vermont',
      'Assigned off-street parking spot.',
      44.4759::numeric,
      -73.2121::numeric,
      3
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
where s.key = 'errin'
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
  select id from public.sites where key = 'errin'
);

do $seed$
declare
  prop record;
begin
  for prop in
    select p.id
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'errin'
      and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
  loop
    perform public.seed_guidebook_sections(prop.id);
  end loop;
end
$seed$;

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
    ('winooski-flat', 'check_in', 'Door codes come through Airbnb messages. Check-in and checkout times: Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('winooski-flat', 'getting_here', 'Winooski, about one block from downtown. Off-street parking.'),
    ('winooski-flat', 'wifi', 'Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('winooski-flat', 'house_guide', 'Entire 2-bedroom apartment, 1 bath, sleeps 4. Private patio, full kitchen, in-unit washer and dryer. Window AC May through September.'),
    ('winooski-flat', 'house_rules', 'Pets welcome. Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('winooski-flat', 'things_to_do', 'Open Explore for Winooski and Burlington favorites.'),
    ('winooski-flat', 'contact', 'Message Errin on Airbnb. Door codes always come through Airbnb messages.'),
    ('winooski-flat', 'stay_again', 'Book The Winooski Flat again on Airbnb.'),
    ('mill-house', 'check_in', 'Keypad entry; the code is sent the morning of check-in through Airbnb messages. Check-in and checkout times: Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('mill-house', 'getting_here', 'Winooski. Free parking on site. About a 5 minute walk to the Winooski River Walk and the Heritage Winooski Mill Museum.'),
    ('mill-house', 'wifi', 'Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('mill-house', 'house_guide', 'First-floor duplex flat. 2 bedrooms (king and queen), 1 bath, sleeps 4. Two large decks, full kitchen, washer and dryer, dedicated workspace.'),
    ('mill-house', 'house_rules', 'Pets welcome. Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('mill-house', 'things_to_do', 'Open Explore for Winooski and Burlington favorites.'),
    ('mill-house', 'contact', 'Message Errin on Airbnb. Door codes always come through Airbnb messages.'),
    ('mill-house', 'stay_again', 'Book The Mill House again on Airbnb.'),
    ('maple-street-flat', 'check_in', 'Door codes come through Airbnb messages. Check-in and checkout times: Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('maple-street-flat', 'getting_here', 'Burlington, on Maple Street. Assigned off-street parking spot. About two blocks to Church Street and the waterfront.'),
    ('maple-street-flat', 'wifi', 'Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('maple-street-flat', 'house_guide', 'Ground-floor apartment in a historic building. 2 bedrooms (queen and double), 1 bath, sleeps 4. Private porch and entry, full kitchen, coffee maker, pack ''n play. Coin-operated washer and dryer in the building. Window AC May through September.'),
    ('maple-street-flat', 'house_rules', 'Details coming soon. Message Errin on Airbnb if you need anything before then.'),
    ('maple-street-flat', 'things_to_do', 'Open Explore for Burlington favorites near Church Street and the waterfront.'),
    ('maple-street-flat', 'contact', 'Message Errin on Airbnb. Door codes always come through Airbnb messages.'),
    ('maple-street-flat', 'stay_again', 'Book The Maple Street Flat again on Airbnb.')
) as v(slug, section_type, summary) on true
where s.property_id = p.id
  and site.key = 'errin'
  and p.slug = v.slug
  and s.section_type = v.section_type;

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
    (
      'e4000000-0000-4000-8000-000000000101'::uuid,
      'winooski-flat',
      'getting_here',
      'rich_text',
      'Finding the flat',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Winooski Flat is in Winooski, Vermont, on a quiet street about one block from downtown.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Off-street parking is available.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000102'::uuid,
      'winooski-flat',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park off street.',
            'detail', 'Off-street parking is available.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. Message Errin on Airbnb if you need anything before then.'
          )
        )
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000103'::uuid,
      'winooski-flat',
      'wifi',
      'rich_text',
      'Wi-Fi',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon. Message Errin on Airbnb if you need anything before then.

Network details stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000104'::uuid,
      'winooski-flat',
      'house_guide',
      'rich_text',
      'The flat',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Winooski Flat is an entire 2-bedroom apartment with 1 bath, and sleeps 4.

There is a private patio with seating, a full kitchen, and a washer and dryer in the unit. Window AC is available May through September.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000105'::uuid,
      'winooski-flat',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Pets are welcome.

Details coming soon. Message Errin on Airbnb if you need anything before then.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000106'::uuid,
      'winooski-flat',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Open Explore for places to eat, drink, and explore in Winooski and Burlington.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000107'::uuid,
      'winooski-flat',
      'contact',
      'rich_text',
      'Reach Errin',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Message Errin on Airbnb. Door codes always come through Airbnb messages.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000108'::uuid,
      'winooski-flat',
      'stay_again',
      'rich_text',
      'Book again',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Ready for another visit? Book The Winooski Flat again on Airbnb.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000201'::uuid,
      'mill-house',
      'getting_here',
      'rich_text',
      'Finding the flat',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Mill House is in Winooski, Vermont, about a 5 minute walk to the Winooski River Walk and the Heritage Winooski Mill Museum.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Free parking is available on site.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000202'::uuid,
      'mill-house',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park on site.',
            'detail', 'Free parking is available on site.'
          ),
          jsonb_build_object(
            'title', 'Use the keypad.',
            'detail', 'The code is sent the morning of check-in through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. Message Errin on Airbnb if you need anything before then.'
          )
        )
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000203'::uuid,
      'mill-house',
      'wifi',
      'rich_text',
      'Wi-Fi',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon. Message Errin on Airbnb if you need anything before then.

Network details stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000204'::uuid,
      'mill-house',
      'house_guide',
      'rich_text',
      'The flat',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Mill House is a first-floor apartment in a duplex with 2 bedrooms (king and queen), 1 bath, and sleeps 4.

There are two large decks, a full kitchen, a washer and dryer, and a dedicated workspace.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000205'::uuid,
      'mill-house',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Pets are welcome.

Details coming soon. Message Errin on Airbnb if you need anything before then.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000206'::uuid,
      'mill-house',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Open Explore for places to eat, drink, and explore in Winooski and Burlington.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000207'::uuid,
      'mill-house',
      'contact',
      'rich_text',
      'Reach Errin',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Message Errin on Airbnb. Door codes always come through Airbnb messages.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000208'::uuid,
      'mill-house',
      'stay_again',
      'rich_text',
      'Book again',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Ready for another visit? Book The Mill House again on Airbnb.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000301'::uuid,
      'maple-street-flat',
      'getting_here',
      'rich_text',
      'Finding the flat',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Maple Street Flat is on Maple Street in Burlington, Vermont, about two blocks from Church Street and the waterfront.

The street address is not on this page yet. Check your Airbnb messages for the full address.

There is an assigned off-street parking spot.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000302'::uuid,
      'maple-street-flat',
      'check_in',
      'steps',
      'Arriving',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Use the assigned parking spot.',
            'detail', 'There is an assigned off-street parking spot.'
          ),
          jsonb_build_object(
            'title', 'Use the coded door.',
            'detail', 'Your unique code is sent through Airbnb messages. Door codes are never posted on this site.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Details coming soon. Message Errin on Airbnb if you need anything before then.'
          )
        )
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000303'::uuid,
      'maple-street-flat',
      'wifi',
      'rich_text',
      'Wi-Fi',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon. Message Errin on Airbnb if you need anything before then.

Network details stay in your Airbnb messages for now.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000304'::uuid,
      'maple-street-flat',
      'house_guide',
      'rich_text',
      'The flat',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Maple Street Flat is a ground-floor apartment in a historic building with 2 bedrooms (queen and double), 1 bath, and sleeps 4.

There is a private porch and entry, a full kitchen with a coffee maker, and a pack 'n play available. Coin-operated washer and dryer are in the building. Window AC is available May through September.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000305'::uuid,
      'maple-street-flat',
      'house_rules',
      'rich_text',
      'House rules',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Details coming soon. Message Errin on Airbnb if you need anything before then.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000306'::uuid,
      'maple-street-flat',
      'things_to_do',
      'rich_text',
      'Nearby favorites',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Open Explore for Church Street, the waterfront, and other Burlington favorites.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000307'::uuid,
      'maple-street-flat',
      'contact',
      'rich_text',
      'Reach Errin',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Message Errin on Airbnb. Door codes always come through Airbnb messages.$copy$
      )
    ),
    (
      'e4000000-0000-4000-8000-000000000308'::uuid,
      'maple-street-flat',
      'stay_again',
      'rich_text',
      'Book again',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Ready for another visit? Book The Maple Street Flat again on Airbnb.$copy$
      )
    )
) as v(block_id, slug, section_type, block_type, title, body) on true
where site.key = 'errin'
  and p.slug = v.slug
  and s.section_type = v.section_type
on conflict (id) do update
set
  section_id = excluded.section_id,
  block_type = excluded.block_type,
  sort_order = excluded.sort_order,
  title = excluded.title,
  body = excluded.body,
  published_at = coalesce(public.guidebook_blocks.published_at, now()),
  updated_at = now();

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
    ('e6000000-0000-4000-8000-000000000001'::uuid, 'winooski-flat', '713480623074475985'),
    ('e6000000-0000-4000-8000-000000000002'::uuid, 'mill-house', '708762878064619345'),
    ('e6000000-0000-4000-8000-000000000003'::uuid, 'maple-street-flat', '39766625')
) as v(id, slug, listing_id) on true
where s.key = 'errin'
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
    ('winooski-flat', 'Winooski VT'),
    ('mill-house', 'Winooski VT'),
    ('maple-street-flat', 'Burlington VT')
) as town(slug, town) on town.slug = p.slug
cross join (
  values
    ('grocery'::text, 'Grocery store'::text, 'grocery store near'::text, null::text, 10),
    ('pharmacy', 'Pharmacy', 'pharmacy near', null, 20),
    ('gas', 'Gas station', 'gas station near', null, 30),
    ('urgent_care', 'Urgent care', 'urgent care near', null, 40),
    ('hospital', 'Hospital (ER)', 'hospital near', 'For emergencies, call 911.', 50)
) as item(kind, label, search_lead, note, sort_order)
where s.key = 'errin'
on conflict (property_id, kind) do update
set
  label = excluded.label,
  search_query = excluded.search_query,
  note = excluded.note,
  sort_order = excluded.sort_order,
  published_at = coalesce(public.nearby_essentials.published_at, now()),
  updated_at = now();

insert into public.checkout_items (
  id, property_id, sort_order, is_visible, label, details, published_at
)
select
  v.id,
  p.id,
  10,
  true,
  'Details coming soon',
  'Details coming soon. Message Errin on Airbnb if you need anything before then.',
  now()
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('e7000000-0000-4000-8000-000000000001'::uuid, 'winooski-flat'),
    ('e7000000-0000-4000-8000-000000000002'::uuid, 'mill-house'),
    ('e7000000-0000-4000-8000-000000000003'::uuid, 'maple-street-flat')
) as v(id, slug) on true
where s.key = 'errin'
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

insert into public.site_settings (site_id, key, value)
select s.id, 'brand_name', '"Queen City Stays"'::jsonb
from public.sites s
where s.key = 'errin'
on conflict (site_id, key) do update
set value = excluded.value, updated_at = now();

update public.sites
set name = 'Queen City Stays', updated_at = now()
where key = 'errin';

-- Neutral Errin host tips by place name (not Tucker's wording).
-- Drop first so a partial earlier paste cannot leave a stuck tip table behind.
drop table if exists errin_host_tips;
create temporary table errin_host_tips (
  place_name text primary key,
  tip text not null,
  tip_es text not null,
  tip_fr text not null
) on commit drop;

insert into errin_host_tips (place_name, tip, tip_es, tip_fr) values
('Waterworks Food + Drink', 'Classic steak frites in Winooski. Easy dinner walk from the flat.', 'Clásico steak frites en Winooski. Cena a pie desde el piso.', 'Steak frites classique à Winooski. Dîner à pied depuis l''appartement.'),
('Pho Hong', 'Reliable Vietnamese in Burlington. Locals love it for takeout too.', 'Vietnamita de confianza en Burlington. Ideal también para llevar.', 'Vietnamien fiable à Burlington. Les locaux l''aiment aussi à emporter.'),
('Trattoria Delia', 'Cozy Italian in Burlington. Sotto next door if you want a wine stop.', 'Italiano acogedor en Burlington. Sotto al lado si quieres vino.', 'Italien chaleureux à Burlington. Sotto à côté pour un verre de vin.'),
('Restaurant Poco', 'Small tapas spot. Walk-ins only, so go early.', 'Tapas en local pequeño. Solo sin reserva; ve temprano.', 'Petites tapas. Sans réservation seulement; venez tôt.'),
('Santiago''s Cuban Cuisine', 'Cuban plates and drinks with a lively feel.', 'Platos y bebidas cubanas con buen ambiente.', 'Plats et boissons cubains, ambiance vive.'),
('Honey Road', 'Mediterranean small plates. Reserve ahead when you can.', 'Platos pequeños mediterráneos. Reserva con antelación.', 'Petites assiettes méditerranéennes. Réservez à l''avance.'),
('Hen of the Wood (Burlington)', 'Elevated Vermont dining. Book ahead for dinner.', 'Cocina de Vermont de alto nivel. Reserva para cenar.', 'Table Vermont soignée. Réservez pour le dîner.'),
('Shanty on the Shore', 'Seafood with a waterfront setting.', 'Mariscos junto al agua.', 'Fruits de mer au bord de l''eau.'),
('Onion City Chicken & Oysters', 'Chicken or oysters, plus solid cocktails in Winooski.', 'Pollo u ostras, y buenos cócteles en Winooski.', 'Poulet ou huîtres, et bons cocktails à Winooski.'),
('Taco Gordo', 'Casual tacos in the Burlington area.', 'Tacos sencillos en la zona de Burlington.', 'Tacos simples dans la région de Burlington.'),
('Farmhouse Tap & Grill', 'Fireplace vibe in winter, patio in summer.', 'Chimenea en invierno, terraza en verano.', 'Cheminée en hiver, terrasse en été.'),
('Pascolo Ristorante', 'Italian right on Church Street.', 'Italiano justo en Church Street.', 'Italien directement sur Church Street.'),
('A Single Pebble', 'Thoughtful Chinese cooking in Burlington.', 'Cocina china cuidada en Burlington.', 'Cuisine chinoise soignée à Burlington.'),
('Leunig''s Bistro', 'French bistro feel on Church Street.', 'Ambiente de bistró francés en Church Street.', 'Ambiance bistrot français sur Church Street.'),
('May Day', 'A solid Burlington dinner option.', 'Buena opción para cenar en Burlington.', 'Bonne option pour dîner à Burlington.'),
('Spot on the Dock', 'Cocktails on the water. Especially nice at sunset.', 'Cócteles junto al agua. Especialmente al atardecer.', 'Cocktails au bord de l''eau. Superbe au coucher du soleil.'),
('Four Quarters Brewing', 'Craft beer and food in a relaxed Winooski spot. Dog friendly.', 'Cerveza artesanal y comida en Winooski. Admite perros.', 'Bière artisanale et nourriture à Winooski. Chiens bienvenus.'),
('Foam Brewers', 'Craft beer near the lake, with live music and a summer patio.', 'Cerveza artesanal cerca del lago, música en vivo y terraza.', 'Bière artisanale près du lac, musique live et terrasse.'),
('Burlington Beer Co.', 'Big beer hall with good food for groups.', 'Gran sala de cerveza con buena comida para grupos.', 'Grande hall à bière, bonne nourriture pour les groupes.'),
('Devil Takes a Holiday', 'Date-night cocktails done carefully.', 'Cócteles para una cita, hechos con cuidado.', 'Cocktails soignés pour une soirée à deux.'),
('Zero Gravity Brewery', 'Local craft beer in Burlington.', 'Cerveza artesanal local en Burlington.', 'Bière artisanale locale à Burlington.'),
('The 126', 'Speakeasy energy with live music.', 'Ambiente de speakeasy con música en vivo.', 'Ambiance speakeasy avec musique live.'),
('Smugglers'' Notch', 'Local mountain for skiing and riding.', 'Montaña local para esquiar o snowboard.', 'Montagne locale pour skier ou surfer.'),
('Stowe Mountain Resort', 'Epic Pass mountain with plenty nearby on Mountain Road.', 'Montaña Epic Pass con mucho cerca en Mountain Road.', 'Montagne Epic Pass, beaucoup à proximité sur Mountain Road.'),
('Sugarbush Resort', 'Ikon Pass mountain for a full ski day.', 'Montaña Ikon Pass para un día de esquí.', 'Montagne Ikon Pass pour une journée de ski.'),
('Bolton Valley Resort', 'Friendly for beginners and kids, with night skiing.', 'Ideal para principiantes y niños, con esquí nocturno.', 'Idéal débutants et enfants, avec ski de nuit.'),
('Trapp Family Lodge', 'Cross-country trails and a brewery on site.', 'Pistas de fondo y una cervecería en el lugar.', 'Pistes de fond et brasserie sur place.'),
('Shelburne Farms', 'Trails and lake views. No dogs. Summer drinks at the Inn are lovely.', 'Senderos y vistas al lago. Sin perros. Bebidas de verano en el Inn.', 'Sentiers et vue sur le lac. Pas de chiens. Boissons d''été à l''Inn.'),
('Church Street', 'Pedestrian street for restaurants, shops, and an evening stroll.', 'Calle peatonal con restaurantes, tiendas y paseo nocturno.', 'Rue piétonne pour restos, boutiques et balade du soir.'),
('Spirit of Ethan Allen', 'Dinner cruise on the lake in summer.', 'Crucero con cena en el lago en verano.', 'Croisière-dîner sur le lac en été.'),
('Upper Hollow Road', 'Scenic Stowe drive, especially in fall.', 'Ruta panorámica por Stowe, sobre todo en otoño.', 'Route panoramique à Stowe, surtout en automne.'),
('Mount Philo', 'Easy hike with lake views. Dogs on a leash.', 'Caminata fácil con vistas al lago. Perros con correa.', 'Randonnée facile avec vue sur le lac. Chiens en laisse.'),
('Indian Brook Reservoir', 'Easy trails and a dog-friendly outdoor stop.', 'Senderos fáciles y parada al aire libre que admite perros.', 'Sentiers faciles et arrêt outdoor dog-friendly.'),
('Sterling Pond Trail', 'A classic hike near Smugglers'' Notch.', 'Caminata clásica cerca de Smugglers'' Notch.', 'Randonnée classique près de Smugglers'' Notch.'),
('Burnt Rock Mountain', 'A more serious hike when you want a challenge.', 'Caminata más exigente si quieres un reto.', 'Randonnée plus exigeante si vous voulez un défi.'),
('Camel''s Hump', 'Famous Vermont hike. Not for beginners.', 'Caminata famosa de Vermont. No para principiantes.', 'Randonnée mythique du Vermont. Pas pour débutants.'),
('Vermont Comedy Club', 'Catch a show in Burlington.', 'Ve un espectáculo en Burlington.', 'Assistez à un spectacle à Burlington.'),
('Catamount Outdoor Family Center', 'Four-season trails with rentals available.', 'Senderos las cuatro estaciones con alquiler de equipo.', 'Sentiers quatre saisons avec location.'),
('Shy Guy Gelato', 'Gelato stop in Burlington.', 'Parada de helado en Burlington.', 'Arrêt gelato à Burlington.'),
('Mr. Creemee Stand', 'Soft-serve stop in the Burlington area.', 'Helado suave en la zona de Burlington.', 'Crème glacée molle dans la région de Burlington.'),
('Scout Coffee', 'Coffee to start the morning in Winooski.', 'Café para empezar la mañana en Winooski.', 'Café pour commencer la matinée à Winooski.'),
('Winooski Falls and river trails', 'A short walk along the falls and river paths.', 'Un paseo corto por la cascada y los senderos del río.', 'Une courte promenade le long de la cascade et des sentiers.');

-- Winooski Flat + Mill House: clone Shallot/Onion links with Errin tips and tags.
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
  errin.id,
  place.id,
  null,
  src.is_featured,
  src.sort_order,
  now(),
  coalesce(tip.tip, 'A local favorite nearby. Ask Errin if you want help planning.'),
  src.guest_tags
from public.properties errin
join public.sites errin_site on errin_site.id = errin.site_id
join public.property_recommendations src on true
join public.properties shallot
  on shallot.id = src.property_id
 and shallot.slug = 'shallot-chalet'
join public.recommendations place
  on place.id = src.recommendation_id
 and place.is_active
left join errin_host_tips tip on tip.place_name = place.name
where errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
on conflict (property_id, recommendation_id) do update
set
  custom_description = null,
  is_featured = excluded.is_featured,
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = excluded.host_note,
  guest_tags = excluded.guest_tags;

-- All three get Burlington-area links; Maple Street Flat sorts Burlington first.
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
  errin.id,
  place.id,
  null,
  src.is_featured,
  case
    when errin.slug = 'maple-street-flat' and coalesce(place.town, '') in ('Burlington', 'Burlington area')
      then src.sort_order
    when errin.slug = 'maple-street-flat'
      then src.sort_order + 500
    else src.sort_order
  end,
  now(),
  coalesce(tip.tip, 'A local favorite nearby. Ask Errin if you want help planning.'),
  src.guest_tags
from public.properties errin
join public.sites errin_site on errin_site.id = errin.site_id
join public.property_recommendations src on true
join public.properties shallot
  on shallot.id = src.property_id
 and shallot.slug = 'shallot-chalet'
join public.recommendations place
  on place.id = src.recommendation_id
 and place.is_active
left join errin_host_tips tip on tip.place_name = place.name
where errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
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
on conflict (property_id, recommendation_id) do update
set
  custom_description = null,
  is_featured = excluded.is_featured,
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = excluded.host_note,
  guest_tags = excluded.guest_tags;

-- Perfect Day itineraries for the two Winooski stays (clone Shallot).
insert into public.itineraries (
  property_id, season, title, sort_order, is_visible, published_at
)
select
  errin.id,
  i.season,
  i.title,
  i.sort_order,
  true,
  now()
from public.itineraries i
join public.properties shallot on shallot.id = i.property_id and shallot.slug = 'shallot-chalet'
join public.properties errin on true
join public.sites errin_site on errin_site.id = errin.site_id
where errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
on conflict (property_id, season) do update
set
  title = excluded.title,
  sort_order = excluded.sort_order,
  is_visible = true,
  published_at = coalesce(public.itineraries.published_at, now()),
  updated_at = now();

insert into public.itinerary_stops (
  itinerary_id, recommendation_id, time_label, name, detail, sort_order
)
select
  dest.id,
  src_stop.recommendation_id,
  src_stop.time_label,
  src_stop.name,
  src_stop.detail,
  src_stop.sort_order
from public.itinerary_stops src_stop
join public.itineraries src on src.id = src_stop.itinerary_id
join public.properties shallot on shallot.id = src.property_id and shallot.slug = 'shallot-chalet'
join public.properties errin on true
join public.sites errin_site on errin_site.id = errin.site_id
join public.itineraries dest
  on dest.property_id = errin.id
 and dest.season = src.season
where errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
  and not exists (
    select 1
    from public.itinerary_stops existing
    where existing.itinerary_id = dest.id
      and existing.sort_order = src_stop.sort_order
  );

update public.itinerary_stops dest_stop
set
  recommendation_id = src_stop.recommendation_id,
  time_label = src_stop.time_label,
  name = src_stop.name,
  detail = src_stop.detail,
  updated_at = now()
from public.itineraries dest
join public.properties errin on errin.id = dest.property_id
join public.sites errin_site on errin_site.id = errin.site_id
join public.properties shallot on shallot.slug = 'shallot-chalet'
join public.itineraries src on src.property_id = shallot.id and src.season = dest.season
join public.itinerary_stops src_stop
  on src_stop.itinerary_id = src.id
 and src_stop.sort_order = dest_stop.sort_order
where dest_stop.itinerary_id = dest.id
  and errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house');

-- Copy Perfect Day stop translations onto the Errin clones.
insert into public.content_translations (source_table, source_id, field, language, text)
select
  'itinerary_stops',
  dest_stop.id,
  ct.field,
  ct.language,
  ct.text
from public.content_translations ct
join public.itinerary_stops src_stop on src_stop.id = ct.source_id
join public.itineraries src on src.id = src_stop.itinerary_id
join public.properties shallot on shallot.id = src.property_id and shallot.slug = 'shallot-chalet'
join public.properties errin on true
join public.sites errin_site on errin_site.id = errin.site_id
join public.itineraries dest
  on dest.property_id = errin.id
 and dest.season = src.season
join public.itinerary_stops dest_stop
  on dest_stop.itinerary_id = dest.id
 and dest_stop.sort_order = src_stop.sort_order
where ct.source_table = 'itinerary_stops'
  and errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select
  'itineraries',
  dest.id,
  ct.field,
  ct.language,
  ct.text
from public.content_translations ct
join public.itineraries src on src.id = ct.source_id
join public.properties shallot on shallot.id = src.property_id and shallot.slug = 'shallot-chalet'
join public.properties errin on true
join public.sites errin_site on errin_site.id = errin.site_id
join public.itineraries dest
  on dest.property_id = errin.id
 and dest.season = src.season
where ct.source_table = 'itineraries'
  and errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Host tip translations for Errin links.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'property_recommendations', pr.id, 'host_note', lang.language, lang.text
from public.property_recommendations pr
join public.properties p on p.id = pr.property_id
join public.sites s on s.id = p.site_id
join public.recommendations place on place.id = pr.recommendation_id
join errin_host_tips tip on tip.place_name = place.name
cross join lateral (
  values
    ('es', tip.tip_es),
    ('fr', tip.tip_fr)
) as lang(language, text)
where s.key = 'errin'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Property field translations.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, lang.field, lang.language, lang.text
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('winooski-flat', 'name', 'es', 'El piso de Winooski'),
    ('winooski-flat', 'name', 'fr', 'L''appartement de Winooski'),
    ('winooski-flat', 'tagline', 'es', 'Un piso tranquilo de dos dormitorios a una cuadra del centro de Winooski'),
    ('winooski-flat', 'tagline', 'fr', 'Un appartement calme de deux chambres à un pâté de maisons du centre de Winooski'),
    ('winooski-flat', 'description', 'es', 'Apartamento entero de 2 dormitorios con 1 baño, para 4 personas. Calle tranquila a aproximadamente una cuadra del centro de Winooski. Patio privado con asientos. Cocina completa. Lavadora y secadora en la unidad. Aparcamiento fuera de la calle. Se admiten mascotas. Aire acondicionado de ventana de mayo a septiembre.'),
    ('winooski-flat', 'description', 'fr', 'Appartement entier de 2 chambres avec 1 salle de bain, pour 4 personnes. Rue calme à environ un pâté de maisons du centre de Winooski. Patio privé avec sièges. Cuisine complète. Laveuse et sécheuse dans l''unité. Stationnement hors rue. Animaux bienvenus. Climatiseur de fenêtre de mai à septembre.'),
    ('winooski-flat', 'welcome_title', 'es', 'Bienvenido al piso de Winooski'),
    ('winooski-flat', 'welcome_title', 'fr', 'Bienvenue à l''appartement de Winooski'),
    ('winooski-flat', 'welcome_message', 'es', 'Qué bien que estés aquí. El piso de Winooski es un apartamento tranquilo a poca distancia del centro. Los códigos de la puerta siempre llegan por mensajes de Airbnb. Siéntete como en casa.'),
    ('winooski-flat', 'welcome_message', 'fr', 'Content de vous accueillir. L''appartement de Winooski est un logement calme à deux pas du centre. Les codes de porte arrivent toujours par messages Airbnb. Faites comme chez vous.'),
    ('winooski-flat', 'check_in_time', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('winooski-flat', 'check_in_time', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('winooski-flat', 'check_out_time', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('winooski-flat', 'check_out_time', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('winooski-flat', 'parking_summary', 'es', 'Aparcamiento fuera de la calle.'),
    ('winooski-flat', 'parking_summary', 'fr', 'Stationnement hors rue.'),
    ('mill-house', 'name', 'es', 'La Casa del Molino'),
    ('mill-house', 'name', 'fr', 'La Maison du Moulin'),
    ('mill-house', 'tagline', 'es', 'Un piso en dúplex de planta baja con terrazas a ambos lados'),
    ('mill-house', 'tagline', 'fr', 'Un appartement au rez-de-chaussée d''un duplex avec terrasses des deux côtés'),
    ('mill-house', 'description', 'es', 'Apartamento de planta baja en un dúplex. 2 dormitorios (king y queen), 1 baño, para 4 personas. Dos terrazas grandes, una a cada lado. Cocina completa, lavadora y secadora, espacio de trabajo. Aparcamiento gratis en el lugar. Se admiten mascotas. Entrada con teclado; el código se envía la mañana del check-in por mensajes de Airbnb. A unos 5 minutos a pie del Winooski River Walk y del Heritage Winooski Mill Museum.'),
    ('mill-house', 'description', 'fr', 'Appartement au rez-de-chaussée d''un duplex. 2 chambres (king et queen), 1 salle de bain, pour 4 personnes. Deux grandes terrasses, une de chaque côté. Cuisine complète, laveuse et sécheuse, espace de travail. Stationnement gratuit sur place. Animaux bienvenus. Entrée à clavier; le code est envoyé le matin de l''arrivée par messages Airbnb. Environ 5 minutes à pied du Winooski River Walk et du Heritage Winooski Mill Museum.'),
    ('mill-house', 'welcome_title', 'es', 'Bienvenido a la Casa del Molino'),
    ('mill-house', 'welcome_title', 'fr', 'Bienvenue à la Maison du Moulin'),
    ('mill-house', 'welcome_message', 'es', 'Qué bien que estés aquí. La Casa del Molino es un piso de planta baja con terrazas a ambos lados, cerca del río. Los códigos de la puerta siempre llegan por mensajes de Airbnb. Siéntete como en casa.'),
    ('mill-house', 'welcome_message', 'fr', 'Content de vous accueillir. La Maison du Moulin est un appartement au rez-de-chaussée avec terrasses des deux côtés, près de la rivière. Les codes de porte arrivent toujours par messages Airbnb. Faites comme chez vous.'),
    ('mill-house', 'check_in_time', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('mill-house', 'check_in_time', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('mill-house', 'check_out_time', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('mill-house', 'check_out_time', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('mill-house', 'parking_summary', 'es', 'Aparcamiento gratis en el lugar.'),
    ('mill-house', 'parking_summary', 'fr', 'Stationnement gratuit sur place.'),
    ('maple-street-flat', 'name', 'es', 'El piso de Maple Street'),
    ('maple-street-flat', 'name', 'fr', 'L''appartement de Maple Street'),
    ('maple-street-flat', 'tagline', 'es', 'Un piso de planta baja en Maple Street cerca de Church Street'),
    ('maple-street-flat', 'tagline', 'fr', 'Un appartement au rez-de-chaussée sur Maple Street près de Church Street'),
    ('maple-street-flat', 'description', 'es', 'Apartamento de planta baja en un edificio histórico en Maple Street. 2 dormitorios (queen y doble), 1 baño, para 4 personas. Porche y entrada privados, ideal para el café de la mañana. Cocina completa y cafetera. Plaza de aparcamiento asignada fuera de la calle. Lavadora y secadora de monedas en el edificio. Pack ''n play disponible. Aire acondicionado de ventana de mayo a septiembre. A unas dos cuadras de Church Street y del waterfront.'),
    ('maple-street-flat', 'description', 'fr', 'Appartement au rez-de-chaussée dans un immeuble historique sur Maple Street. 2 chambres (queen et double), 1 salle de bain, pour 4 personnes. Porche et entrée privés, parfait pour le café du matin. Cuisine complète et cafetière. Place de stationnement assignée hors rue. Laveuse et sécheuse à monnaies dans l''immeuble. Pack ''n play disponible. Climatiseur de fenêtre de mai à septembre. À environ deux pâtés de maisons de Church Street et du waterfront.'),
    ('maple-street-flat', 'welcome_title', 'es', 'Bienvenido al piso de Maple Street'),
    ('maple-street-flat', 'welcome_title', 'fr', 'Bienvenue à l''appartement de Maple Street'),
    ('maple-street-flat', 'welcome_message', 'es', 'Qué bien que estés aquí. El piso de Maple Street es un apartamento de planta baja en un edificio histórico, a unas dos cuadras de Church Street y del waterfront. Los códigos de la puerta siempre llegan por mensajes de Airbnb. Siéntete como en casa.'),
    ('maple-street-flat', 'welcome_message', 'fr', 'Content de vous accueillir. L''appartement de Maple Street est un logement au rez-de-chaussée dans un immeuble historique, à environ deux pâtés de maisons de Church Street et du waterfront. Les codes de porte arrivent toujours par messages Airbnb. Faites comme chez vous.'),
    ('maple-street-flat', 'check_in_time', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('maple-street-flat', 'check_in_time', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('maple-street-flat', 'check_out_time', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('maple-street-flat', 'check_out_time', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('maple-street-flat', 'parking_summary', 'es', 'Plaza de aparcamiento asignada fuera de la calle.'),
    ('maple-street-flat', 'parking_summary', 'fr', 'Place de stationnement assignée hors rue.')
) as lang(slug, field, language, text) on lang.slug = p.slug
where s.key = 'errin'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', gs.id, 'summary', lang.language, lang.text
from public.guidebook_sections gs
join public.properties p on p.id = gs.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('winooski-flat', 'check_in', 'es', 'Los códigos de la puerta llegan por mensajes de Airbnb. Horarios de entrada y salida: Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('winooski-flat', 'check_in', 'fr', 'Les codes de porte arrivent par messages Airbnb. Heures d''arrivée et de départ: Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('winooski-flat', 'getting_here', 'es', 'Winooski, a aproximadamente una cuadra del centro. Aparcamiento fuera de la calle.'),
    ('winooski-flat', 'getting_here', 'fr', 'Winooski, à environ un pâté de maisons du centre. Stationnement hors rue.'),
    ('winooski-flat', 'wifi', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('winooski-flat', 'wifi', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('winooski-flat', 'house_guide', 'es', 'Apartamento entero de 2 dormitorios, 1 baño, para 4. Patio privado, cocina completa, lavadora y secadora en la unidad. Aire de ventana de mayo a septiembre.'),
    ('winooski-flat', 'house_guide', 'fr', 'Appartement entier de 2 chambres, 1 salle de bain, pour 4. Patio privé, cuisine complète, laveuse et sécheuse dans l''unité. Clim de fenêtre de mai à septembre.'),
    ('winooski-flat', 'house_rules', 'es', 'Se admiten mascotas. Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('winooski-flat', 'house_rules', 'fr', 'Animaux bienvenus. Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('winooski-flat', 'things_to_do', 'es', 'Abre Explorar para favoritos de Winooski y Burlington.'),
    ('winooski-flat', 'things_to_do', 'fr', 'Ouvrez Explorer pour les favoris de Winooski et Burlington.'),
    ('winooski-flat', 'contact', 'es', 'Escribe a Errin en Airbnb. Los códigos de la puerta siempre llegan por mensajes de Airbnb.'),
    ('winooski-flat', 'contact', 'fr', 'Écrivez à Errin sur Airbnb. Les codes de porte arrivent toujours par messages Airbnb.'),
    ('winooski-flat', 'stay_again', 'es', 'Vuelve a reservar El piso de Winooski en Airbnb.'),
    ('winooski-flat', 'stay_again', 'fr', 'Réservez à nouveau L''appartement de Winooski sur Airbnb.'),
    ('mill-house', 'check_in', 'es', 'Entrada con teclado; el código se envía la mañana del check-in por mensajes de Airbnb. Horarios: Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('mill-house', 'check_in', 'fr', 'Entrée à clavier; le code est envoyé le matin de l''arrivée par messages Airbnb. Horaires: Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('mill-house', 'getting_here', 'es', 'Winooski. Aparcamiento gratis en el lugar. A unos 5 minutos a pie del Winooski River Walk y del Heritage Winooski Mill Museum.'),
    ('mill-house', 'getting_here', 'fr', 'Winooski. Stationnement gratuit sur place. Environ 5 minutes à pied du Winooski River Walk et du Heritage Winooski Mill Museum.'),
    ('mill-house', 'wifi', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('mill-house', 'wifi', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('mill-house', 'house_guide', 'es', 'Piso en dúplex de planta baja. 2 dormitorios (king y queen), 1 baño, para 4. Dos terrazas grandes, cocina completa, lavadora y secadora, espacio de trabajo.'),
    ('mill-house', 'house_guide', 'fr', 'Appartement duplex au rez-de-chaussée. 2 chambres (king et queen), 1 salle de bain, pour 4. Deux grandes terrasses, cuisine complète, laveuse et sécheuse, espace de travail.'),
    ('mill-house', 'house_rules', 'es', 'Se admiten mascotas. Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('mill-house', 'house_rules', 'fr', 'Animaux bienvenus. Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('mill-house', 'things_to_do', 'es', 'Abre Explorar para favoritos de Winooski y Burlington.'),
    ('mill-house', 'things_to_do', 'fr', 'Ouvrez Explorer pour les favoris de Winooski et Burlington.'),
    ('mill-house', 'contact', 'es', 'Escribe a Errin en Airbnb. Los códigos de la puerta siempre llegan por mensajes de Airbnb.'),
    ('mill-house', 'contact', 'fr', 'Écrivez à Errin sur Airbnb. Les codes de porte arrivent toujours par messages Airbnb.'),
    ('mill-house', 'stay_again', 'es', 'Vuelve a reservar La Casa del Molino en Airbnb.'),
    ('mill-house', 'stay_again', 'fr', 'Réservez à nouveau La Maison du Moulin sur Airbnb.'),
    ('maple-street-flat', 'check_in', 'es', 'Los códigos de la puerta llegan por mensajes de Airbnb. Horarios de entrada y salida: Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('maple-street-flat', 'check_in', 'fr', 'Les codes de porte arrivent par messages Airbnb. Heures d''arrivée et de départ: Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('maple-street-flat', 'getting_here', 'es', 'Burlington, en Maple Street. Plaza de aparcamiento asignada. A unas dos cuadras de Church Street y del waterfront.'),
    ('maple-street-flat', 'getting_here', 'fr', 'Burlington, sur Maple Street. Place de stationnement assignée. À environ deux pâtés de maisons de Church Street et du waterfront.'),
    ('maple-street-flat', 'wifi', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('maple-street-flat', 'wifi', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('maple-street-flat', 'house_guide', 'es', 'Apartamento de planta baja en un edificio histórico. 2 dormitorios (queen y doble), 1 baño, para 4. Porche privado, cocina completa, cafetera, pack ''n play. Lavandería de monedas en el edificio. Aire de ventana de mayo a septiembre.'),
    ('maple-street-flat', 'house_guide', 'fr', 'Appartement au rez-de-chaussée dans un immeuble historique. 2 chambres (queen et double), 1 salle de bain, pour 4. Porche privé, cuisine complète, cafetière, pack ''n play. Buanderie à monnaies dans l''immeuble. Clim de fenêtre de mai à septembre.'),
    ('maple-street-flat', 'house_rules', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('maple-street-flat', 'house_rules', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.'),
    ('maple-street-flat', 'things_to_do', 'es', 'Abre Explorar para favoritos de Burlington cerca de Church Street y el waterfront.'),
    ('maple-street-flat', 'things_to_do', 'fr', 'Ouvrez Explorer pour les favoris de Burlington près de Church Street et du waterfront.'),
    ('maple-street-flat', 'contact', 'es', 'Escribe a Errin en Airbnb. Los códigos de la puerta siempre llegan por mensajes de Airbnb.'),
    ('maple-street-flat', 'contact', 'fr', 'Écrivez à Errin sur Airbnb. Les codes de porte arrivent toujours par messages Airbnb.'),
    ('maple-street-flat', 'stay_again', 'es', 'Vuelve a reservar El piso de Maple Street en Airbnb.'),
    ('maple-street-flat', 'stay_again', 'fr', 'Réservez à nouveau L''appartement de Maple Street sur Airbnb.')
) as lang(slug, section_type, language, text)
  on lang.slug = p.slug and lang.section_type = gs.section_type
where s.key = 'errin'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, lang.field, lang.language, lang.text
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('label', 'es', 'Detalles próximamente'),
    ('label', 'fr', 'Détails à venir'),
    ('details', 'es', 'Detalles próximamente. Escribe a Errin en Airbnb si necesitas algo antes.'),
    ('details', 'fr', 'Détails à venir. Écrivez à Errin sur Airbnb si vous avez besoin de quoi que ce soit avant.')
) as lang(field, language, text) on true
where s.key = 'errin'
  and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

do $check$
declare
  errin_count integer;
  sections_count integer;
  roost_touched integer;
  dad_touched integer;
  winooski_links integer;
  maple_links integer;
  fall_stops integer;
begin
  select count(*) into errin_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat');

  if errin_count <> 3 then
    raise exception 'Expected 3 errin properties, found %', errin_count;
  end if;

  select count(*) into sections_count
  from public.guidebook_sections gs
  join public.properties p on p.id = gs.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
    and gs.is_visible;

  if sections_count < 24 then
    raise exception 'Expected at least 24 visible errin guidebook sections, found %', sections_count;
  end if;

  select count(*) into roost_touched
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'roost'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat');

  if roost_touched > 0 then
    raise exception 'Errin property slugs must not belong to the roost site';
  end if;

  select count(*) into dad_touched
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat');

  if dad_touched > 0 then
    raise exception 'Errin property slugs must not belong to the dad site';
  end if;

  select count(*) into winooski_links
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'winooski-flat';

  if winooski_links = 0 then
    raise exception 'winooski-flat has zero Things to Do links';
  end if;

  select count(*) into maple_links
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'maple-street-flat';

  if maple_links = 0 then
    raise exception 'maple-street-flat has zero Things to Do links';
  end if;

  select count(*) into fall_stops
  from public.itinerary_stops st
  join public.itineraries i on i.id = st.itinerary_id
  join public.properties p on p.id = i.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'winooski-flat'
    and i.season = 'fall';

  if fall_stops < 9 then
    raise exception 'winooski-flat fall Perfect Day should have at least 9 stops, found %', fall_stops;
  end if;
end
$check$;

notify pgrst, 'reload schema';

commit;
