-- Dad check-in, checkout, arrival, parking, and late checkout portals.
-- Paste after dad properties (and VRBO links if you use them).
-- Dad-scoped only. Safe to run again. No door codes, Wi-Fi passwords, or street addresses.
-- No em dashes.

do $$
begin
  if not exists (select 1 from public.sites where key = 'dad') then
    raise exception 'Dad site is missing. Paste the sites migration before this one.';
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
        'landing-pad',
        'tennisplace-a35',
        'sanibel-sunsets'
      )
  ) <> 8 then
    raise exception 'Expected 8 dad properties. Paste the dad properties file before this one.';
  end if;
end;
$$;

-- Times and late checkout portals.
update public.properties p
set
  check_in_time = '4:00 PM',
  check_out_time = '10:00 AM',
  guest_portal_url = case p.slug
    when 'landing-pad' then 'https://stay.hospitable.com/6aed4c3b-8103-4db3-853f-5fd092dd3e52/upgrade?_t=sc_su'
    when 'backyard-bungalow' then 'https://stay.hospitable.com/46d5dd47-d2f7-465a-82e6-b0976953cb91/upgrade?_t=sc_su'
    else null
  end,
  parking_summary = case p.slug
    when 'backyard-bungalow' then 'Please park in front of the garage. Go through the gate and use the side door to get in.'
    when 'cider-loft' then 'Park anywhere behind the building. You are in Apartment 3, at the front of the building, up the stairs to the left.'
    when 'hinesburg-hideaway-4' then 'Please park in front of Apartment 4 only. The door locks automatically when it closes.'
    else p.parking_summary
  end,
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
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

-- Check-in section summaries.
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
    (
      'cider-loft',
      'check_in',
      'Your personal entry code arrives in your Airbnb messages on the day of check-in. Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
    ),
    (
      'switchback-suite',
      'check_in',
      'Your personal entry code arrives in your Airbnb messages on the day of check-in. Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
    ),
    (
      'hinesburg-hideaway-3',
      'check_in',
      'Your personal entry code arrives in your Airbnb messages on the day of check-in. Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
    ),
    (
      'hinesburg-hideaway-4',
      'check_in',
      'Your personal entry code arrives in your Airbnb messages on the day of check-in. Check-in is at 4:00 PM. Checkout is at 10:00 AM. The door locks automatically when it closes.'
    ),
    (
      'backyard-bungalow',
      'check_in',
      'Your personal entry code arrives in your Airbnb messages on the day of check-in. Check-in is at 4:00 PM. Checkout is at 10:00 AM. Park in front of the garage and enter through the side door.'
    ),
    (
      'landing-pad',
      'check_in',
      'Your personal entry code arrives in your Airbnb messages on the day of check-in. Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
    ),
    (
      'tennisplace-a35',
      'check_in',
      'Your personal entry code arrives in your Airbnb messages on the day of check-in. Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
    ),
    (
      'sanibel-sunsets',
      'check_in',
      'Your personal entry code arrives in your Airbnb messages on the day of check-in. Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
    ),
    (
      'backyard-bungalow',
      'getting_here',
      'South Burlington, about half a mile from the interstate and the airport. Park in front of the garage. Enter through the gate and side door.'
    ),
    (
      'cider-loft',
      'getting_here',
      'Waterbury Center, right next to Cold Hollow Cider Mill. Apartment 3 is at the front of the building, up the stairs to the left. Park behind the building.'
    ),
    (
      'hinesburg-hideaway-4',
      'getting_here',
      'Hinesburg. Please park in front of Apartment 4 only.'
    )
) as v(slug, section_type, summary) on true
where s.property_id = p.id
  and site.key = 'dad'
  and p.slug = v.slug
  and s.section_type = v.section_type;

-- Check-in arrival steps.
update public.guidebook_blocks b
set
  title = 'Arriving',
  body = v.body,
  published_at = coalesce(b.published_at, now()),
  updated_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
join public.sites site on site.id = p.site_id
join (
  values
    (
      'cider-loft',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Find Apartment 3.',
            'detail', 'You are in Apartment 3, at the front of the building, up the stairs to the left. There is no keypad on the outside entry door, so head on up.'
          ),
          jsonb_build_object(
            'title', 'Park behind the building.',
            'detail', 'Park anywhere behind the building. If your loft is ready before 4:00 PM, we will send you a message.'
          ),
          jsonb_build_object(
            'title', 'Use your entry code.',
            'detail', 'Your personal entry code arrives in your Airbnb messages on the day of check-in.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          )
        )
      )
    ),
    (
      'backyard-bungalow',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park in front of the garage.',
            'detail', 'Please park in front of the garage. Go through the gate and use the side door to get in.'
          ),
          jsonb_build_object(
            'title', 'Use your entry code.',
            'detail', 'Your personal entry code arrives in your Airbnb messages on the day of check-in.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          )
        )
      )
    ),
    (
      'hinesburg-hideaway-4',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park in front of Apartment 4.',
            'detail', 'Please park in front of Apartment 4 only.'
          ),
          jsonb_build_object(
            'title', 'Use your entry code.',
            'detail', 'Your personal entry code arrives in your Airbnb messages on the day of check-in. The door locks automatically when it closes. The knob on the inside controls whether it auto-locks.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          )
        )
      )
    ),
    (
      'switchback-suite',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park on site.',
            'detail', 'Parking is free.'
          ),
          jsonb_build_object(
            'title', 'Use your entry code.',
            'detail', 'Your personal entry code arrives in your Airbnb messages on the day of check-in.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          )
        )
      )
    ),
    (
      'hinesburg-hideaway-3',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park in the marked guest spot.',
            'detail', 'Guest parking is marked with a sign out front.'
          ),
          jsonb_build_object(
            'title', 'Use your entry code.',
            'detail', 'Your personal entry code arrives in your Airbnb messages on the day of check-in.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          )
        )
      )
    ),
    (
      'landing-pad',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park on site.',
            'detail', 'Parking is free.'
          ),
          jsonb_build_object(
            'title', 'Use your entry code.',
            'detail', 'Your personal entry code arrives in your Airbnb messages on the day of check-in.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          )
        )
      )
    ),
    (
      'tennisplace-a35',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Arrive at Tennisplace.',
            'detail', 'You are in the Tennisplace complex on Sanibel Island. Dixie Beach is steps away.'
          ),
          jsonb_build_object(
            'title', 'Use your entry code.',
            'detail', 'Your personal entry code arrives in your Airbnb messages on the day of check-in.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          )
        )
      )
    ),
    (
      'sanibel-sunsets',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Arrive at Tennisplace.',
            'detail', 'You are in the Tennisplace complex on Sanibel Island. Dixie Beach is about a 5-minute walk.'
          ),
          jsonb_build_object(
            'title', 'Use your entry code.',
            'detail', 'Your personal entry code arrives in your Airbnb messages on the day of check-in.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          )
        )
      )
    )
) as v(slug, body) on true
where b.section_id = s.id
  and site.key = 'dad'
  and p.slug = v.slug
  and s.section_type = 'check_in'
  and b.sort_order = 10
  and b.body->>'type' = 'steps';

-- Getting Here copy for the three stays with specific parking notes.
update public.guidebook_blocks b
set
  body = v.body,
  published_at = coalesce(b.published_at, now()),
  updated_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
join public.sites site on site.id = p.site_id
join (
  values
    (
      'cider-loft',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Cider Loft is in Waterbury Center, Vermont, right next to Cold Hollow Cider Mill and a minute up the road from Ben & Jerry's Factory.

You are in Apartment 3, at the front of the building, up the stairs to the left. There is no keypad on the outside entry door, so head on up.

Park anywhere behind the building. If your loft is ready before 4:00 PM, we will send you a message.

The full street address stays in your Airbnb messages.$copy$
      )
    ),
    (
      'backyard-bungalow',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$Backyard Bungalow is in South Burlington, about half a mile from the interstate and the airport.

Please park in front of the garage. Go through the gate and use the side door to get in.

The full street address stays in your Airbnb messages.$copy$
      )
    ),
    (
      'hinesburg-hideaway-4',
      jsonb_build_object(
        'type', 'rich_text',
        'markdown', $copy$The Hinesburg Hideaway, Unit 4 is in Hinesburg.

Please park in front of Apartment 4 only. The door locks automatically when it closes. The knob on the inside controls whether it auto-locks.

The full street address stays in your Airbnb messages.$copy$
      )
    )
) as v(slug, body) on true
where b.section_id = s.id
  and site.key = 'dad'
  and p.slug = v.slug
  and s.section_type = 'getting_here'
  and b.sort_order = 10
  and b.body->>'type' = 'rich_text';

-- Hide the old placeholder checkout items.
update public.checkout_items c
set
  is_visible = false,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where c.property_id = p.id
  and s.key = 'dad'
  and c.label = 'Details coming soon';

-- Real checkout checklist (3 items per stay).
insert into public.checkout_items (
  id, property_id, sort_order, is_visible, label, details, published_at
)
select
  v.id,
  p.id,
  v.sort_order,
  true,
  v.label,
  v.details,
  now()
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('d7a1b201-c10f-4e01-8a01-c0d1e2f3a101'::uuid, 'cider-loft', 10, 'Wash any dirty dishes.', null),
    ('d7a1b202-c10f-4e01-8a01-c0d1e2f3a101'::uuid, 'cider-loft', 20, 'Lock the door on your way out.', null),
    ('d7a1b203-c10f-4e01-8a01-c0d1e2f3a101'::uuid, 'cider-loft', 30, 'That''s it. We''ll handle the rest!', 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'),
    ('d7a1b201-c10f-4e01-8a01-c0d1e2f3a102'::uuid, 'switchback-suite', 10, 'Wash any dirty dishes.', null),
    ('d7a1b202-c10f-4e01-8a01-c0d1e2f3a102'::uuid, 'switchback-suite', 20, 'Lock the door on your way out.', null),
    ('d7a1b203-c10f-4e01-8a01-c0d1e2f3a102'::uuid, 'switchback-suite', 30, 'That''s it. We''ll handle the rest!', 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'),
    ('d7a1b201-c10f-4e01-8a01-c0d1e2f3a103'::uuid, 'hinesburg-hideaway-3', 10, 'Wash any dirty dishes.', null),
    ('d7a1b202-c10f-4e01-8a01-c0d1e2f3a103'::uuid, 'hinesburg-hideaway-3', 20, 'Lock the door on your way out.', null),
    ('d7a1b203-c10f-4e01-8a01-c0d1e2f3a103'::uuid, 'hinesburg-hideaway-3', 30, 'That''s it. We''ll handle the rest!', 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'),
    ('d7a1b201-c10f-4e01-8a01-c0d1e2f3a104'::uuid, 'hinesburg-hideaway-4', 10, 'Wash any dirty dishes.', null),
    ('d7a1b202-c10f-4e01-8a01-c0d1e2f3a104'::uuid, 'hinesburg-hideaway-4', 20, 'Lock the door on your way out.', null),
    ('d7a1b203-c10f-4e01-8a01-c0d1e2f3a104'::uuid, 'hinesburg-hideaway-4', 30, 'That''s it. We''ll handle the rest!', 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'),
    ('d7a1b201-c10f-4e01-8a01-c0d1e2f3a105'::uuid, 'backyard-bungalow', 10, 'Wash any dirty dishes.', null),
    ('d7a1b202-c10f-4e01-8a01-c0d1e2f3a105'::uuid, 'backyard-bungalow', 20, 'Lock the door on your way out.', null),
    ('d7a1b203-c10f-4e01-8a01-c0d1e2f3a105'::uuid, 'backyard-bungalow', 30, 'That''s it. We''ll handle the rest!', 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'),
    ('d7a1b201-c10f-4e01-8a01-c0d1e2f3a106'::uuid, 'landing-pad', 10, 'Wash any dirty dishes.', null),
    ('d7a1b202-c10f-4e01-8a01-c0d1e2f3a106'::uuid, 'landing-pad', 20, 'Lock the door on your way out.', null),
    ('d7a1b203-c10f-4e01-8a01-c0d1e2f3a106'::uuid, 'landing-pad', 30, 'That''s it. We''ll handle the rest!', 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'),
    ('d7a1b201-c10f-4e01-8a01-c0d1e2f3a107'::uuid, 'tennisplace-a35', 10, 'Wash any dirty dishes.', null),
    ('d7a1b202-c10f-4e01-8a01-c0d1e2f3a107'::uuid, 'tennisplace-a35', 20, 'Lock the door on your way out.', null),
    ('d7a1b203-c10f-4e01-8a01-c0d1e2f3a107'::uuid, 'tennisplace-a35', 30, 'That''s it. We''ll handle the rest!', 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'),
    ('d7a1b201-c10f-4e01-8a01-c0d1e2f3a108'::uuid, 'sanibel-sunsets', 10, 'Wash any dirty dishes.', null),
    ('d7a1b202-c10f-4e01-8a01-c0d1e2f3a108'::uuid, 'sanibel-sunsets', 20, 'Lock the door on your way out.', null),
    ('d7a1b203-c10f-4e01-8a01-c0d1e2f3a108'::uuid, 'sanibel-sunsets', 30, 'That''s it. We''ll handle the rest!', 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.')
) as v(id, slug, sort_order, label, details) on true
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

-- Brand name in site settings.
insert into public.site_settings (site_id, key, value)
select
  s.id,
  'brand_name',
  '"The Getaway Club"'::jsonb
from public.sites s
where s.key = 'dad'
on conflict (site_id, key) do update
set
  value = excluded.value,
  updated_at = now();

-- Spanish and French translations for the new copy.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', 'es', v.es
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('backyard-bungalow', $tr$Por favor aparca delante del garaje. Pasa por la puerta del patio y entra por la puerta lateral.$tr$),
    ('cider-loft', $tr$Aparca detrás del edificio. Estás en el Apartamento 3, al frente del edificio, subiendo las escaleras a la izquierda.$tr$),
    ('hinesburg-hideaway-4', $tr$Por favor aparca solo delante del Apartamento 4. La puerta se cierra con llave automáticamente al cerrarse.$tr$)
) as v(slug, es) on true
where s.key = 'dad' and p.slug = v.slug
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', 'fr', v.fr
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('backyard-bungalow', $tr$Veuillez vous garer devant le garage. Passez le portail et entrez par la porte latérale.$tr$),
    ('cider-loft', $tr$Garez-vous derrière le bâtiment. Vous êtes dans l'appartement 3, à l'avant du bâtiment, en montant les escaliers à gauche.$tr$),
    ('hinesburg-hideaway-4', $tr$Veuillez vous garer uniquement devant l'appartement 4. La porte se verrouille automatiquement quand elle se ferme.$tr$)
) as v(slug, fr) on true
where s.key = 'dad' and p.slug = v.slug
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('es', $tr$Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM.$tr$),
    ('fr', $tr$Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée. L'arrivée est à 4:00 PM. Le départ est à 10:00 AM.$tr$)
) as lang(language, text) on true
where s.key = 'dad'
  and sec.section_type = 'check_in'
  and p.slug in (
    'cider-loft',
    'switchback-suite',
    'hinesburg-hideaway-3',
    'landing-pad',
    'tennisplace-a35',
    'sanibel-sunsets'
  )
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'es', $tr$Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM. La puerta se cierra con llave automáticamente al cerrarse.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-4' and sec.section_type = 'check_in'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'fr', $tr$Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée. L'arrivée est à 4:00 PM. Le départ est à 10:00 AM. La porte se verrouille automatiquement quand elle se ferme.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-4' and sec.section_type = 'check_in'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'es', $tr$Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM. Aparca delante del garaje y entra por la puerta lateral.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'backyard-bungalow' and sec.section_type = 'check_in'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'fr', $tr$Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée. L'arrivée est à 4:00 PM. Le départ est à 10:00 AM. Garez-vous devant le garage et entrez par la porte latérale.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'backyard-bungalow' and sec.section_type = 'check_in'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

-- Checkout item translations (same labels for every dad stay).
insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Lava los platos sucios.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and c.label = 'Wash any dirty dishes.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$Lavez la vaisselle sale.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and c.label = 'Wash any dirty dishes.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Cierra la puerta con llave al salir.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and c.label = 'Lock the door on your way out.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$Verrouillez la porte en partant.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and c.label = 'Lock the door on your way out.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Eso es todo. Nosotros nos encargamos del resto.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and c.label = 'That''s it. We''ll handle the rest!'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$C'est tout. On s'occupe du reste !$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and c.label = 'That''s it. We''ll handle the rest!'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'es', $tr$¿Se te olvidó algo? Con gusto te lo enviamos por $15 más el costo del envío.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad'
  and c.details = 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'fr', $tr$Vous avez oublié quelque chose ? Nous sommes heureux de vous le renvoyer pour 15 $ plus les frais d'expédition.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad'
  and c.details = 'Left something behind? We''re happy to ship it back for a $15 fee plus the cost of shipping.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

-- Arriving block titles (all dad stays).
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', lang.language, lang.text
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('es', $tr$La llegada$tr$),
    ('fr', $tr$L'arrivée$tr$)
) as lang(language, text) on true
where s.key = 'dad'
  and sec.section_type = 'check_in'
  and b.title = 'Arriving'
  and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

-- Arrival steps: Backyard Bungalow.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Aparca delante del garaje.","detail":"Por favor aparca delante del garaje. Pasa por la puerta del patio y entra por la puerta lateral."},{"title":"Usa tu código de entrada.","detail":"Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'backyard-bungalow' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Garez-vous devant le garage.","detail":"Veuillez vous garer devant le garage. Passez le portail et entrez par la porte latérale."},{"title":"Utilisez votre code d'entrée.","detail":"Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'backyard-bungalow' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

-- Arrival steps: The Cider Loft.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Encuentra el Apartamento 3.","detail":"Estás en el Apartamento 3, al frente del edificio, subiendo las escaleras a la izquierda. No hay teclado en la puerta de entrada exterior, así que sube."},{"title":"Aparca detrás del edificio.","detail":"Aparca en cualquier sitio detrás del edificio. Si tu loft está listo antes de las 4:00 PM, te enviaremos un mensaje."},{"title":"Usa tu código de entrada.","detail":"Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'cider-loft' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Trouvez l'appartement 3.","detail":"Vous êtes dans l'appartement 3, à l'avant du bâtiment, en montant les escaliers à gauche. Il n'y a pas de clavier sur la porte d'entrée extérieure, alors montez."},{"title":"Garez-vous derrière le bâtiment.","detail":"Garez-vous n'importe où derrière le bâtiment. Si votre loft est prêt avant 4:00 PM, nous vous enverrons un message."},{"title":"Utilisez votre code d'entrée.","detail":"Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'cider-loft' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

-- Arrival steps: Hinesburg Hideaway Unit 4.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Aparca delante del Apartamento 4.","detail":"Por favor aparca solo delante del Apartamento 4."},{"title":"Usa tu código de entrada.","detail":"Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada. La puerta se cierra con llave automáticamente al cerrarse. El pomo del interior controla si se cierra sola."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-4' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Garez-vous devant l'appartement 4.","detail":"Veuillez vous garer uniquement devant l'appartement 4."},{"title":"Utilisez votre code d'entrée.","detail":"Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée. La porte se verrouille automatiquement quand elle se ferme. La poignée à l'intérieur contrôle le verrouillage automatique."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-4' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

-- Arrival steps: generic Vermont stays (switchback, hideaway 3, landing pad).
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Aparca en el lugar.","detail":"El aparcamiento es gratis."},{"title":"Usa tu código de entrada.","detail":"Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad'
  and p.slug in ('switchback-suite', 'landing-pad')
  and sec.section_type = 'check_in'
  and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Garez-vous sur place.","detail":"Le stationnement est gratuit."},{"title":"Utilisez votre code d'entrée.","detail":"Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad'
  and p.slug in ('switchback-suite', 'landing-pad')
  and sec.section_type = 'check_in'
  and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Aparca en el sitio de invitados marcado.","detail":"El aparcamiento de invitados está marcado con un cartel delante."},{"title":"Usa tu código de entrada.","detail":"Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-3' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Garez-vous sur la place invitée indiquée.","detail":"Le stationnement invité est marqué d'un panneau devant."},{"title":"Utilisez votre code d'entrée.","detail":"Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-3' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

-- Arrival steps: Sanibel stays.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Llega a Tennisplace.","detail":"Estás en el complejo Tennisplace en Sanibel Island. Dixie Beach está a unos pasos."},{"title":"Usa tu código de entrada.","detail":"Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'tennisplace-a35' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Arrivez à Tennisplace.","detail":"Vous êtes dans le complexe Tennisplace sur Sanibel Island. Dixie Beach est à quelques pas."},{"title":"Utilisez votre code d'entrée.","detail":"Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'tennisplace-a35' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Llega a Tennisplace.","detail":"Estás en el complejo Tennisplace en Sanibel Island. Dixie Beach está a unos 5 minutos a pie."},{"title":"Usa tu código de entrada.","detail":"Tu código de entrada personal llega en tus mensajes de Airbnb el día de la llegada."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'sanibel-sunsets' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Arrivez à Tennisplace.","detail":"Vous êtes dans le complexe Tennisplace sur Sanibel Island. Dixie Beach est à environ 5 minutes à pied."},{"title":"Utilisez votre code d'entrée.","detail":"Votre code d'entrée personnel arrive dans vos messages Airbnb le jour de l'arrivée."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'sanibel-sunsets' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

-- Getting Here summaries and markdown for the three stays with parking notes.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'es', $tr$South Burlington, a media milla de la autopista y el aeropuerto. Aparca delante del garaje. Entra por la puerta del patio y la puerta lateral.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'backyard-bungalow' and sec.section_type = 'getting_here'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'fr', $tr$South Burlington, à environ un demi-mille de l'autoroute et de l'aéroport. Garez-vous devant le garage. Entrez par le portail et la porte latérale.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'backyard-bungalow' and sec.section_type = 'getting_here'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'es', $tr$Waterbury Center, justo al lado de Cold Hollow Cider Mill. El Apartamento 3 está al frente del edificio, subiendo las escaleras a la izquierda. Aparca detrás del edificio.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'cider-loft' and sec.section_type = 'getting_here'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'fr', $tr$Waterbury Center, juste à côté de Cold Hollow Cider Mill. L'appartement 3 est à l'avant du bâtiment, en montant les escaliers à gauche. Garez-vous derrière le bâtiment.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'cider-loft' and sec.section_type = 'getting_here'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'es', $tr$Hinesburg. Por favor aparca solo delante del Apartamento 4.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-4' and sec.section_type = 'getting_here'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', 'fr', $tr$Hinesburg. Veuillez vous garer uniquement devant l'appartement 4.$tr$
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-4' and sec.section_type = 'getting_here'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Backyard Bungalow está en South Burlington, a media milla de la autopista y el aeropuerto.

Por favor aparca delante del garaje. Pasa por la puerta del patio y entra por la puerta lateral.

La dirección completa está en tus mensajes de Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'backyard-bungalow' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Backyard Bungalow est à South Burlington, à environ un demi-mille de l'autoroute et de l'aéroport.

Veuillez vous garer devant le garage. Passez le portail et entrez par la porte latérale.

L'adresse complète reste dans vos messages Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'backyard-bungalow' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$The Cider Loft está en Waterbury Center, Vermont, justo al lado de Cold Hollow Cider Mill y a un minuto de Ben & Jerry's Factory.

Estás en el Apartamento 3, al frente del edificio, subiendo las escaleras a la izquierda. No hay teclado en la puerta de entrada exterior, así que sube.

Aparca en cualquier sitio detrás del edificio. Si tu loft está listo antes de las 4:00 PM, te enviaremos un mensaje.

La dirección completa está en tus mensajes de Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'cider-loft' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$The Cider Loft est à Waterbury Center, Vermont, juste à côté de Cold Hollow Cider Mill et à une minute de Ben & Jerry's Factory.

Vous êtes dans l'appartement 3, à l'avant du bâtiment, en montant les escaliers à gauche. Il n'y a pas de clavier sur la porte d'entrée extérieure, alors montez.

Garez-vous n'importe où derrière le bâtiment. Si votre loft est prêt avant 4:00 PM, nous vous enverrons un message.

L'adresse complète reste dans vos messages Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'cider-loft' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$The Hinesburg Hideaway, Unit 4 está en Hinesburg.

Por favor aparca solo delante del Apartamento 4. La puerta se cierra con llave automáticamente al cerrarse. El pomo del interior controla si se cierra sola.

La dirección completa está en tus mensajes de Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-4' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$The Hinesburg Hideaway, Unit 4 est à Hinesburg.

Veuillez vous garer uniquement devant l'appartement 4. La porte se verrouille automatiquement quand elle se ferme. La poignée à l'intérieur contrôle le verrouillage automatique.

L'adresse complète reste dans vos messages Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'dad' and p.slug = 'hinesburg-hideaway-4' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

do $check$
declare
  timed integer;
  portals integer;
  checklist integer;
begin
  select count(*) into timed
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and p.check_in_time = '4:00 PM'
    and p.check_out_time = '10:00 AM'
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

  if timed <> 8 then
    raise exception 'Check-in and checkout times were not saved on every dad stay.';
  end if;

  select count(*) into portals
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and p.slug in ('landing-pad', 'backyard-bungalow')
    and p.guest_portal_url is not null;

  if portals <> 2 then
    raise exception 'Late checkout portal links were not saved for Landing Pad and Backyard Bungalow.';
  end if;

  select count(*) into checklist
  from public.checkout_items c
  join public.properties p on p.id = c.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and c.is_visible = true
    and c.label in (
      'Wash any dirty dishes.',
      'Lock the door on your way out.',
      'That''s it. We''ll handle the rest!'
    );

  if checklist <> 24 then
    raise exception 'Expected 24 visible dad checkout checklist items, found %', checklist;
  end if;
end
$check$;

notify pgrst, 'reload schema';
