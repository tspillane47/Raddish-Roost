-- Errin / Queen City Stays guidebook details.
-- Check-in, checkout, parking, entry, late checkout, and contact.
-- Scoped to sites.key = 'errin' only. Does not change roost or dad.
-- Safe to paste again. Wrapped in begin/commit. No em dashes.
-- No street addresses, door codes, Wi-Fi names, or Wi-Fi passwords.
-- Paste after 20261112140000_errin_direct_and_house.sql.
-- Slugs: mill-house (Apartment A), winooski-flat (Apartment B), maple-street-flat.

begin;

do $guard$
begin
  if not exists (select 1 from public.sites where key = 'errin') then
    raise exception 'Errin site is missing. Run 20261112000000_errin_site.sql before this file.';
  end if;
  if (
    select count(*)
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'errin'
      and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
  ) <> 3 then
    raise exception 'Errin properties are missing. Run 20261112120000_errin_properties.sql first.';
  end if;
end
$guard$;

update public.properties p
set
  check_in_time = '4:00 PM',
  check_out_time = '10:00 AM',
  guest_portal_url = 'https://stay.hospitable.com/e2832b80-e24c-4180-9b90-7073c53a6231',
  parking_summary = v.parking_summary,
  updated_at = now()
from public.sites s
join (
  values
    (
      'mill-house',
      'You have one reserved spot in the driveway behind the building, on the LEFT side only.'
    ),
    (
      'winooski-flat',
      'You have one reserved spot in the driveway behind the building, on the RIGHT side only.'
    ),
    (
      'maple-street-flat',
      'You have one reserved spot in the driveway on the left side of the building. Park in front of the shed marked #1, facing west. Free street parking is also nearby.'
    )
) as v(slug, parking_summary) on true
where s.id = p.site_id
  and s.key = 'errin'
  and p.slug = v.slug;

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
      'mill-house',
      'check_in',
      $copy$Check-in is at 4:00 PM. Checkout is at 10:00 AM. You have one reserved spot in the driveway behind the building, on the LEFT side only. Apartment A is on the bottom level. The entrance is on the porch. Use your personal entry code from your booking messages. Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.$copy$
    ),
    (
      'winooski-flat',
      'check_in',
      $copy$Heads up: the kitchen light switch is right above your head as you walk in the door. Check-in is at 4:00 PM. Checkout is at 10:00 AM. You have one reserved spot in the driveway behind the building, on the RIGHT side only. Apartment B is on the top level, up the stairs. Use the keypad on the apartment door, not the one on the building. Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.$copy$
    ),
    (
      'maple-street-flat',
      'check_in',
      $copy$Check-in is at 4:00 PM. Checkout is at 10:00 AM. You have one reserved spot in the driveway on the left side of the building. Park in front of the shed marked #1, facing west. Free street parking is also nearby. Your entrance is on the rounded front porch. There's a code for the stairway door and a separate personal code for your apartment, both in your booking messages. Turn the deadbolt to unlock. Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.$copy$
    ),
    (
      'mill-house',
      'getting_here',
      $copy$Winooski. You have one reserved spot in the driveway behind the building, on the LEFT side only. About a 5 minute walk to the Winooski River Walk and the Heritage Winooski Mill Museum.$copy$
    ),
    (
      'winooski-flat',
      'getting_here',
      $copy$Winooski, about one block from downtown. You have one reserved spot in the driveway behind the building, on the RIGHT side only.$copy$
    ),
    (
      'maple-street-flat',
      'getting_here',
      $copy$Burlington. You have one reserved spot in the driveway on the left side of the building. Park in front of the shed marked #1, facing west. Free street parking is also nearby.$copy$
    ),
    (
      'mill-house',
      'wifi',
      'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
    ),
    (
      'winooski-flat',
      'wifi',
      'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
    ),
    (
      'maple-street-flat',
      'wifi',
      'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
    ),
    (
      'winooski-flat',
      'house_guide',
      $copy$Heads up: the kitchen light switch is right above your head as you walk in the door. Entire 2-bedroom apartment, 1 bath, sleeps 4. Private patio, full kitchen, in-unit washer and dryer. Window AC May through September.$copy$
    ),
    (
      'mill-house',
      'contact',
      'Questions anytime? Message Errin through Airbnb or your booking platform.'
    ),
    (
      'winooski-flat',
      'contact',
      'Questions anytime? Message Errin through Airbnb or your booking platform.'
    ),
    (
      'maple-street-flat',
      'contact',
      'Questions anytime? Message Errin through Airbnb or your booking platform.'
    )
) as v(slug, section_type, summary) on true
where s.property_id = p.id
  and site.key = 'errin'
  and p.slug = v.slug
  and s.section_type = v.section_type;

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
      'mill-house',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park on the left.',
            'detail', 'You have one reserved spot in the driveway behind the building, on the LEFT side only.'
          ),
          jsonb_build_object(
            'title', 'Enter Apartment A.',
            'detail', 'Apartment A is on the bottom level. The entrance is on the porch. Use your personal entry code from your booking messages.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          ),
          jsonb_build_object(
            'title', 'Address, door code, and Wi-Fi.',
            'detail', 'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
          )
        )
      )
    ),
    (
      'winooski-flat',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Find the kitchen light.',
            'detail', 'Heads up: the kitchen light switch is right above your head as you walk in the door.'
          ),
          jsonb_build_object(
            'title', 'Park on the right.',
            'detail', 'You have one reserved spot in the driveway behind the building, on the RIGHT side only.'
          ),
          jsonb_build_object(
            'title', 'Enter Apartment B.',
            'detail', 'Apartment B is on the top level, up the stairs. Use the keypad on the apartment door, not the one on the building.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          ),
          jsonb_build_object(
            'title', 'Address, door code, and Wi-Fi.',
            'detail', 'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
          )
        )
      )
    ),
    (
      'maple-street-flat',
      jsonb_build_object(
        'type', 'steps',
        'steps', jsonb_build_array(
          jsonb_build_object(
            'title', 'Park by the shed.',
            'detail', 'You have one reserved spot in the driveway on the left side of the building. Park in front of the shed marked #1, facing west. Free street parking is also nearby.'
          ),
          jsonb_build_object(
            'title', 'Enter from the porch.',
            'detail', 'Your entrance is on the rounded front porch. There''s a code for the stairway door and a separate personal code for your apartment, both in your booking messages. Turn the deadbolt to unlock.'
          ),
          jsonb_build_object(
            'title', 'Check-in and checkout times.',
            'detail', 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'
          ),
          jsonb_build_object(
            'title', 'Address, door code, and Wi-Fi.',
            'detail', 'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
          )
        )
      )
    )
) as v(slug, body) on true
where b.section_id = s.id
  and site.key = 'errin'
  and p.slug = v.slug
  and s.section_type = 'check_in'
  and b.sort_order = 10
  and b.body->>'type' = 'steps';

insert into public.guidebook_blocks (
  id, section_id, block_type, sort_order, title, body, published_at
)
select
  'e4000000-0000-4000-8000-000000000109'::uuid,
  s.id,
  'callout',
  5,
  'Good to know',
  jsonb_build_object(
    'type', 'callout',
    'tone', 'important',
    'markdown', 'Heads up: the kitchen light switch is right above your head as you walk in the door.'
  ),
  now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
join public.sites site on site.id = p.site_id
where site.key = 'errin'
  and p.slug = 'winooski-flat'
  and s.section_type = 'check_in'
on conflict (id) do update
set
  section_id = excluded.section_id,
  block_type = excluded.block_type,
  sort_order = excluded.sort_order,
  title = excluded.title,
  body = excluded.body,
  published_at = coalesce(public.guidebook_blocks.published_at, now()),
  updated_at = now();

insert into public.guidebook_blocks (
  id, section_id, block_type, sort_order, title, body, published_at
)
select
  'e4000000-0000-4000-8000-000000000110'::uuid,
  s.id,
  'callout',
  1000,
  'Good to know',
  jsonb_build_object(
    'type', 'callout',
    'tone', 'important',
    'markdown', 'Heads up: the kitchen light switch is right above your head as you walk in the door.'
  ),
  now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
join public.sites site on site.id = p.site_id
where site.key = 'errin'
  and p.slug = 'winooski-flat'
  and s.section_type = 'house_guide'
on conflict (id) do update
set
  section_id = excluded.section_id,
  block_type = excluded.block_type,
  sort_order = excluded.sort_order,
  title = excluded.title,
  body = excluded.body,
  published_at = coalesce(public.guidebook_blocks.published_at, now()),
  updated_at = now();

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', v.markdown
  ),
  published_at = coalesce(b.published_at, now()),
  updated_at = now()
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
join public.sites site on site.id = p.site_id
join (
  values
    (
      'mill-house',
      'getting_here',
      $copy$The Mill House is in Winooski, Vermont, about a 5 minute walk to the Winooski River Walk and the Heritage Winooski Mill Museum.

You have one reserved spot in the driveway behind the building, on the LEFT side only.

Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.$copy$
    ),
    (
      'winooski-flat',
      'getting_here',
      $copy$The Winooski Flat is in Winooski, Vermont, on a quiet street about one block from downtown.

You have one reserved spot in the driveway behind the building, on the RIGHT side only.

Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.$copy$
    ),
    (
      'maple-street-flat',
      'getting_here',
      $copy$The Maple Street Flat is in Burlington, Vermont, about two blocks from Church Street and the waterfront.

You have one reserved spot in the driveway on the left side of the building. Park in front of the shed marked #1, facing west. Free street parking is also nearby.

Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.$copy$
    ),
    (
      'mill-house',
      'wifi',
      'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
    ),
    (
      'winooski-flat',
      'wifi',
      'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
    ),
    (
      'maple-street-flat',
      'wifi',
      'Your address, door code, and Wi-Fi details are sent in your Airbnb or booking messages before arrival.'
    ),
    (
      'mill-house',
      'contact',
      'Questions anytime? Message Errin through Airbnb or your booking platform.'
    ),
    (
      'winooski-flat',
      'contact',
      'Questions anytime? Message Errin through Airbnb or your booking platform.'
    ),
    (
      'maple-street-flat',
      'contact',
      'Questions anytime? Message Errin through Airbnb or your booking platform.'
    ),
    (
      'winooski-flat',
      'house_guide',
      $copy$Heads up: the kitchen light switch is right above your head as you walk in the door.

The Winooski Flat is an entire 2-bedroom apartment with 1 bath, and sleeps 4.

There is a private patio with seating, a full kitchen, and a washer and dryer in the unit. Window AC is available May through September.$copy$
    )
) as v(slug, section_type, markdown) on true
where b.section_id = s.id
  and site.key = 'errin'
  and p.slug = v.slug
  and s.section_type = v.section_type
  and b.sort_order = 10
  and b.body->>'type' = 'rich_text';

update public.checkout_items c
set
  is_visible = false,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where c.property_id = p.id
  and s.key = 'errin'
  and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
  and c.label = 'Details coming soon';

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
    ('e7100000-0000-4000-8000-000000000011'::uuid, 'mill-house', 10, 'Wash any dirty dishes.', null),
    ('e7100000-0000-4000-8000-000000000012'::uuid, 'mill-house', 20, 'Lock the door.', null),
    ('e7100000-0000-4000-8000-000000000013'::uuid, 'mill-house', 30, 'That''s it, we''ll handle the rest.', 'If something is left behind and needs to be shipped, there is a $15 fee plus shipping costs.'),
    ('e7100000-0000-4000-8000-000000000021'::uuid, 'winooski-flat', 10, 'Wash any dirty dishes.', null),
    ('e7100000-0000-4000-8000-000000000022'::uuid, 'winooski-flat', 20, 'Lock the door.', null),
    ('e7100000-0000-4000-8000-000000000023'::uuid, 'winooski-flat', 30, 'That''s it, we''ll handle the rest.', 'If something is left behind and needs to be shipped, there is a $15 fee plus shipping costs.'),
    ('e7100000-0000-4000-8000-000000000031'::uuid, 'maple-street-flat', 10, 'Wash any dirty dishes.', null),
    ('e7100000-0000-4000-8000-000000000032'::uuid, 'maple-street-flat', 20, 'Lock the door.', null),
    ('e7100000-0000-4000-8000-000000000033'::uuid, 'maple-street-flat', 30, 'That''s it, we''ll handle the rest.', 'If something is left behind and needs to be shipped, there is a $15 fee plus shipping costs.')
) as v(id, slug, sort_order, label, details) on true
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

-- Replace the old "details coming soon" time translations so they cannot override 4:00 PM and 10:00 AM.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, lang.field, lang.language, lang.text
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('check_in_time', 'es', '4:00 PM'),
    ('check_in_time', 'fr', '4:00 PM'),
    ('check_out_time', 'es', '10:00 AM'),
    ('check_out_time', 'fr', '10:00 AM')
) as lang(field, language, text) on true
where s.key = 'errin'
  and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', lang.language, lang.text
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    (
      'mill-house',
      'es',
      $tr$Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado IZQUIERDO.$tr$
    ),
    (
      'mill-house',
      'fr',
      $tr$Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté GAUCHE.$tr$
    ),
    (
      'winooski-flat',
      'es',
      $tr$Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado DERECHO.$tr$
    ),
    (
      'winooski-flat',
      'fr',
      $tr$Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté DROIT.$tr$
    ),
    (
      'maple-street-flat',
      'es',
      $tr$Tienes una plaza reservada en la entrada de coches del lado izquierdo del edificio. Aparca delante del cobertizo marcado #1, mirando al oeste. También hay aparcamiento gratis en la calle cerca.$tr$
    ),
    (
      'maple-street-flat',
      'fr',
      $tr$Vous avez une place réservée dans l'allée sur le côté gauche du bâtiment. Garez-vous devant l'abri marqué #1, face à l'ouest. Le stationnement gratuit dans la rue est aussi à proximité.$tr$
    )
) as lang(slug, language, text) on lang.slug = p.slug
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
    (
      'mill-house',
      'check_in',
      'es',
      $tr$La llegada es a las 4:00 PM. La salida es a las 10:00 AM. Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado IZQUIERDO. El Apartamento A está en el nivel de abajo. La entrada está en el porche. Usa tu código de entrada personal de tus mensajes de reserva. Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
    ),
    (
      'mill-house',
      'check_in',
      'fr',
      $tr$L'arrivée est à 4:00 PM. Le départ est à 10:00 AM. Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté GAUCHE. L'appartement A est au niveau du bas. L'entrée est sur le porche. Utilisez votre code d'entrée personnel envoyé dans vos messages de réservation. Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
    ),
    (
      'winooski-flat',
      'check_in',
      'es',
      $tr$Aviso: el interruptor de la luz de la cocina está justo encima de tu cabeza al entrar por la puerta. La llegada es a las 4:00 PM. La salida es a las 10:00 AM. Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado DERECHO. El Apartamento B está en el nivel de arriba, subiendo las escaleras. Usa el teclado de la puerta del apartamento, no el del edificio. Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
    ),
    (
      'winooski-flat',
      'check_in',
      'fr',
      $tr$À savoir: l'interrupteur de la cuisine est juste au-dessus de votre tête en entrant. L'arrivée est à 4:00 PM. Le départ est à 10:00 AM. Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté DROIT. L'appartement B est à l'étage, en haut des escaliers. Utilisez le clavier de la porte de l'appartement, pas celui du bâtiment. Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
    ),
    (
      'maple-street-flat',
      'check_in',
      'es',
      $tr$La llegada es a las 4:00 PM. La salida es a las 10:00 AM. Tienes una plaza reservada en la entrada de coches del lado izquierdo del edificio. Aparca delante del cobertizo marcado #1, mirando al oeste. También hay aparcamiento gratis en la calle cerca. Tu entrada está en el porche delantero redondeado. Hay un código para la puerta de la escalera y un código personal aparte para tu apartamento, ambos en tus mensajes de reserva. Gira el cerrojo para abrir. Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
    ),
    (
      'maple-street-flat',
      'check_in',
      'fr',
      $tr$L'arrivée est à 4:00 PM. Le départ est à 10:00 AM. Vous avez une place réservée dans l'allée sur le côté gauche du bâtiment. Garez-vous devant l'abri marqué #1, face à l'ouest. Le stationnement gratuit dans la rue est aussi à proximité. Votre entrée est sur le porche avant arrondi. Il y a un code pour la porte de l'escalier et un code personnel séparé pour votre appartement, tous les deux dans vos messages de réservation. Tournez le pêne dormant pour déverrouiller. Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
    ),
    (
      'mill-house',
      'getting_here',
      'es',
      $tr$Winooski. Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado IZQUIERDO. A unos 5 minutos a pie del Winooski River Walk y del Heritage Winooski Mill Museum.$tr$
    ),
    (
      'mill-house',
      'getting_here',
      'fr',
      $tr$Winooski. Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté GAUCHE. Environ 5 minutes à pied du Winooski River Walk et du Heritage Winooski Mill Museum.$tr$
    ),
    (
      'winooski-flat',
      'getting_here',
      'es',
      $tr$Winooski, a aproximadamente una cuadra del centro. Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado DERECHO.$tr$
    ),
    (
      'winooski-flat',
      'getting_here',
      'fr',
      $tr$Winooski, à environ un pâté de maisons du centre. Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté DROIT.$tr$
    ),
    (
      'maple-street-flat',
      'getting_here',
      'es',
      $tr$Burlington. Tienes una plaza reservada en la entrada de coches del lado izquierdo del edificio. Aparca delante del cobertizo marcado #1, mirando al oeste. También hay aparcamiento gratis en la calle cerca.$tr$
    ),
    (
      'maple-street-flat',
      'getting_here',
      'fr',
      $tr$Burlington. Vous avez une place réservée dans l'allée sur le côté gauche du bâtiment. Garez-vous devant l'abri marqué #1, face à l'ouest. Le stationnement gratuit dans la rue est aussi à proximité.$tr$
    ),
    (
      'mill-house',
      'wifi',
      'es',
      $tr$Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
    ),
    (
      'mill-house',
      'wifi',
      'fr',
      $tr$Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
    ),
    (
      'winooski-flat',
      'wifi',
      'es',
      $tr$Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
    ),
    (
      'winooski-flat',
      'wifi',
      'fr',
      $tr$Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
    ),
    (
      'maple-street-flat',
      'wifi',
      'es',
      $tr$Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
    ),
    (
      'maple-street-flat',
      'wifi',
      'fr',
      $tr$Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
    ),
    (
      'winooski-flat',
      'house_guide',
      'es',
      $tr$Aviso: el interruptor de la luz de la cocina está justo encima de tu cabeza al entrar por la puerta. Apartamento entero de 2 dormitorios, 1 baño, para 4. Patio privado, cocina completa, lavadora y secadora en la unidad. Aire de ventana de mayo a septiembre.$tr$
    ),
    (
      'winooski-flat',
      'house_guide',
      'fr',
      $tr$À savoir: l'interrupteur de la cuisine est juste au-dessus de votre tête en entrant. Appartement entier de 2 chambres, 1 salle de bain, pour 4. Patio privé, cuisine complète, laveuse et sécheuse dans l'unité. Clim de fenêtre de mai à septembre.$tr$
    ),
    (
      'mill-house',
      'contact',
      'es',
      $tr$¿Preguntas en cualquier momento? Escribe a Errin por Airbnb o tu plataforma de reserva.$tr$
    ),
    (
      'mill-house',
      'contact',
      'fr',
      $tr$Des questions à tout moment ? Écrivez à Errin via Airbnb ou votre plateforme de réservation.$tr$
    ),
    (
      'winooski-flat',
      'contact',
      'es',
      $tr$¿Preguntas en cualquier momento? Escribe a Errin por Airbnb o tu plataforma de reserva.$tr$
    ),
    (
      'winooski-flat',
      'contact',
      'fr',
      $tr$Des questions à tout moment ? Écrivez à Errin via Airbnb ou votre plateforme de réservation.$tr$
    ),
    (
      'maple-street-flat',
      'contact',
      'es',
      $tr$¿Preguntas en cualquier momento? Escribe a Errin por Airbnb o tu plataforma de reserva.$tr$
    ),
    (
      'maple-street-flat',
      'contact',
      'fr',
      $tr$Des questions à tout moment ? Écrivez à Errin via Airbnb ou votre plateforme de réservation.$tr$
    )
) as lang(slug, section_type, language, text)
  on lang.slug = p.slug and lang.section_type = gs.section_type
where s.key = 'errin'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

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
where s.key = 'errin'
  and sec.section_type = 'check_in'
  and b.title = 'Arriving'
  and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Aparca a la izquierda.","detail":"Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado IZQUIERDO."},{"title":"Entra al Apartamento A.","detail":"El Apartamento A está en el nivel de abajo. La entrada está en el porche. Usa tu código de entrada personal de tus mensajes de reserva."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."},{"title":"Dirección, código de la puerta y Wi-Fi.","detail":"Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'mill-house' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Garez-vous à gauche.","detail":"Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté GAUCHE."},{"title":"Entrez dans l'appartement A.","detail":"L'appartement A est au niveau du bas. L'entrée est sur le porche. Utilisez votre code d'entrée personnel envoyé dans vos messages de réservation."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."},{"title":"Adresse, code de la porte et Wi-Fi.","detail":"Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'mill-house' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Encuentra la luz de la cocina.","detail":"Aviso: el interruptor de la luz de la cocina está justo encima de tu cabeza al entrar por la puerta."},{"title":"Aparca a la derecha.","detail":"Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado DERECHO."},{"title":"Entra al Apartamento B.","detail":"El Apartamento B está en el nivel de arriba, subiendo las escaleras. Usa el teclado de la puerta del apartamento, no el del edificio."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."},{"title":"Dirección, código de la puerta y Wi-Fi.","detail":"Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'winooski-flat' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Trouvez la lumière de la cuisine.","detail":"À savoir: l'interrupteur de la cuisine est juste au-dessus de votre tête en entrant."},{"title":"Garez-vous à droite.","detail":"Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté DROIT."},{"title":"Entrez dans l'appartement B.","detail":"L'appartement B est à l'étage, en haut des escaliers. Utilisez le clavier de la porte de l'appartement, pas celui du bâtiment."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."},{"title":"Adresse, code de la porte et Wi-Fi.","detail":"Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'winooski-flat' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Aparca junto al cobertizo.","detail":"Tienes una plaza reservada en la entrada de coches del lado izquierdo del edificio. Aparca delante del cobertizo marcado #1, mirando al oeste. También hay aparcamiento gratis en la calle cerca."},{"title":"Entra por el porche.","detail":"Tu entrada está en el porche delantero redondeado. Hay un código para la puerta de la escalera y un código personal aparte para tu apartamento, ambos en tus mensajes de reserva. Gira el cerrojo para abrir."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."},{"title":"Dirección, código de la puerta y Wi-Fi.","detail":"Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'maple-street-flat' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Garez-vous près de l'abri.","detail":"Vous avez une place réservée dans l'allée sur le côté gauche du bâtiment. Garez-vous devant l'abri marqué #1, face à l'ouest. Le stationnement gratuit dans la rue est aussi à proximité."},{"title":"Entrez par le porche.","detail":"Votre entrée est sur le porche avant arrondi. Il y a un code pour la porte de l'escalier et un code personnel séparé pour votre appartement, tous les deux dans vos messages de réservation. Tournez le pêne dormant pour déverrouiller."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."},{"title":"Adresse, code de la porte et Wi-Fi.","detail":"Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'maple-street-flat' and sec.section_type = 'check_in' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', lang.language, lang.text
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('es', $tr$Conviene saber$tr$),
    ('fr', $tr$Bon à savoir$tr$)
) as lang(language, text) on true
where s.key = 'errin'
  and p.slug = 'winooski-flat'
  and b.title = 'Good to know'
  and b.id in (
    'e4000000-0000-4000-8000-000000000109'::uuid,
    'e4000000-0000-4000-8000-000000000110'::uuid
  )
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', lang.language, lang.text
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('es', $tr$Aviso: el interruptor de la luz de la cocina está justo encima de tu cabeza al entrar por la puerta.$tr$),
    ('fr', $tr$À savoir: l'interrupteur de la cuisine est juste au-dessus de votre tête en entrant.$tr$)
) as lang(language, text) on true
where s.key = 'errin'
  and p.slug = 'winooski-flat'
  and b.id in (
    'e4000000-0000-4000-8000-000000000109'::uuid,
    'e4000000-0000-4000-8000-000000000110'::uuid
  )
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$La Casa del Molino está en Winooski, Vermont, a unos 5 minutos a pie del Winooski River Walk y del Heritage Winooski Mill Museum.

Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado IZQUIERDO.

Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'mill-house' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$La Maison du Moulin est à Winooski, Vermont, à environ 5 minutes à pied du Winooski River Walk et du Heritage Winooski Mill Museum.

Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté GAUCHE.

Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'mill-house' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$El piso de Winooski está en Winooski, Vermont, en una calle tranquila a aproximadamente una cuadra del centro.

Tienes una plaza reservada en la entrada de coches detrás del edificio, solo en el lado DERECHO.

Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'winooski-flat' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$L'appartement de Winooski est à Winooski, Vermont, dans une rue calme à environ un pâté de maisons du centre.

Vous avez une place réservée dans l'allée derrière le bâtiment, uniquement du côté DROIT.

Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'winooski-flat' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$El piso de Maple Street está en Burlington, Vermont, a unas dos cuadras de Church Street y del waterfront.

Tienes una plaza reservada en la entrada de coches del lado izquierdo del edificio. Aparca delante del cobertizo marcado #1, mirando al oeste. También hay aparcamiento gratis en la calle cerca.

Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'maple-street-flat' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$L'appartement de Maple Street est à Burlington, Vermont, à environ deux pâtés de maisons de Church Street et du waterfront.

Vous avez une place réservée dans l'allée sur le côté gauche du bâtiment. Garez-vous devant l'abri marqué #1, face à l'ouest. Le stationnement gratuit dans la rue est aussi à proximité.

Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'maple-street-flat' and sec.section_type = 'getting_here' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', lang.language, lang.text
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('es', $tr$Tu dirección, el código de la puerta y los datos del Wi-Fi se envían en tus mensajes de Airbnb o de tu reserva antes de la llegada.$tr$),
    ('fr', $tr$Votre adresse, le code de la porte et les détails du Wi-Fi sont envoyés dans vos messages Airbnb ou de réservation avant l'arrivée.$tr$)
) as lang(language, text) on true
where s.key = 'errin'
  and sec.section_type = 'wifi'
  and b.sort_order = 10
  and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', lang.language, lang.text
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('es', $tr$¿Preguntas en cualquier momento? Escribe a Errin por Airbnb o tu plataforma de reserva.$tr$),
    ('fr', $tr$Des questions à tout moment ? Écrivez à Errin via Airbnb ou votre plateforme de réservation.$tr$)
) as lang(language, text) on true
where s.key = 'errin'
  and sec.section_type = 'contact'
  and b.sort_order = 10
  and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Aviso: el interruptor de la luz de la cocina está justo encima de tu cabeza al entrar por la puerta.

El piso de Winooski es un apartamento entero de 2 dormitorios con 1 baño, y duerme a 4 personas.

Hay un patio privado con asientos, una cocina completa, y lavadora y secadora en la unidad. El aire acondicionado de ventana está disponible de mayo a septiembre.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'winooski-flat' and sec.section_type = 'house_guide' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$À savoir: l'interrupteur de la cuisine est juste au-dessus de votre tête en entrant.

L'appartement de Winooski est un appartement entier de 2 chambres avec 1 salle de bain, pour 4 personnes.

Il y a un patio privé avec sièges, une cuisine complète, et une laveuse et une sécheuse dans l'unité. Le climatiseur de fenêtre est disponible de mai à septembre.$tr$
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and p.slug = 'winooski-flat' and sec.section_type = 'house_guide' and b.sort_order = 10
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Lava los platos sucios.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and c.label = 'Wash any dirty dishes.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$Lavez la vaisselle sale.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and c.label = 'Wash any dirty dishes.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Cierra la puerta con llave.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and c.label = 'Lock the door.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$Verrouillez la porte.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and c.label = 'Lock the door.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Eso es todo, nosotros nos encargamos del resto.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and c.label = 'That''s it, we''ll handle the rest.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$C'est tout, on s'occupe du reste.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin' and c.label = 'That''s it, we''ll handle the rest.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'es', $tr$Si se queda algo y hay que enviarlo, hay una tarifa de $15 más los gastos de envío.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin'
  and c.details = 'If something is left behind and needs to be shipped, there is a $15 fee plus shipping costs.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'fr', $tr$Si quelque chose est oublié et doit être expédié, il y a des frais de 15 $ plus les frais d'expédition.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
join public.sites s on s.id = p.site_id
where s.key = 'errin'
  and c.details = 'If something is left behind and needs to be shipped, there is a $15 fee plus shipping costs.'
on conflict (source_table, source_id, field, language) do update set text = excluded.text;

do $check$
declare
  timed integer;
  checklist integer;
  coming_soon integer;
  rules_left integer;
  light_notes integer;
  leaked integer;
begin
  select count(*) into timed
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
    and p.check_in_time = '4:00 PM'
    and p.check_out_time = '10:00 AM'
    and p.guest_portal_url = 'https://stay.hospitable.com/e2832b80-e24c-4180-9b90-7073c53a6231';

  if timed <> 3 then
    raise exception 'Check-in, checkout, and the late checkout portal were not saved on every Errin stay.';
  end if;

  select count(*) into checklist
  from public.checkout_items c
  join public.properties p on p.id = c.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and c.is_visible = true
    and c.label in (
      'Wash any dirty dishes.',
      'Lock the door.',
      'That''s it, we''ll handle the rest.'
    );

  if checklist <> 9 then
    raise exception 'Expected 9 visible Errin checkout steps, found %', checklist;
  end if;

  select count(*) into coming_soon
  from public.guidebook_blocks b
  join public.guidebook_sections sec on sec.id = b.section_id
  join public.properties p on p.id = sec.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
    and sec.section_type in ('check_in', 'wifi', 'getting_here')
    and b.body::text ilike '%Details coming soon%';

  if coming_soon <> 0 then
    raise exception 'Details coming soon is still in an Errin check-in, parking, or Wi-Fi block.';
  end if;

  select count(*) into rules_left
  from public.guidebook_sections sec
  join public.properties p on p.id = sec.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
    and sec.section_type = 'house_rules'
    and sec.summary ilike '%Details coming soon%';

  if rules_left <> 3 then
    raise exception 'House rules should still say details are coming soon.';
  end if;

  select count(*) into light_notes
  from public.guidebook_blocks b
  join public.properties p on p.id = (
    select sec.property_id from public.guidebook_sections sec where sec.id = b.section_id
  )
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'winooski-flat'
    and b.id in (
      'e4000000-0000-4000-8000-000000000109'::uuid,
      'e4000000-0000-4000-8000-000000000110'::uuid
    )
    and b.body->>'markdown' = 'Heads up: the kitchen light switch is right above your head as you walk in the door.';

  if light_notes <> 2 then
    raise exception 'The kitchen light note is missing from Check-In or The House.';
  end if;

  select count(*) into leaked
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key <> 'errin'
    and p.guest_portal_url = 'https://stay.hospitable.com/e2832b80-e24c-4180-9b90-7073c53a6231';

  if leaked <> 0 then
    raise exception 'The Errin late checkout portal was saved on another site.';
  end if;
end
$check$;

notify pgrst, 'reload schema';

commit;
