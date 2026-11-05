-- Dad stay essentials from host notes: times, entry, parking, pets, laundry,
-- thermostat, TV, good-to-know, and Sanibel minimum stay copy in guidebooks.
-- Dad-scoped only. Safe to paste again. No em dashes. No roost changes.
-- Paste after 20261104150000_dad_area_guidebooks.sql.

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
        'landing-pad',
        'tennisplace-a35',
        'sanibel-sunsets'
      )
  ) <> 8 then
    raise exception 'Expected 8 dad properties. Run the dad properties migration first.';
  end if;
end
$guard$;

-- Check-in / checkout times for every dad stay.
update public.properties p
set
  check_in_time = '4:00 PM',
  check_out_time = '10:00 AM',
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad';

-- Parking summaries.
update public.properties p
set
  parking_summary = v.parking,
  updated_at = now()
from public.sites s
join (
  values
    ('cider-loft', $p$Park out back by the fence. Look for the Airbnb parking sign.$p$),
    ('switchback-suite', $p$Park anywhere in the back lot. Parking is shared with the other businesses on site.$p$),
    ('hinesburg-hideaway-3', $p$Park in front of your unit only.$p$),
    ('hinesburg-hideaway-4', $p$Park in front of your unit only.$p$),
    (
      'backyard-bungalow',
      $p$Please park in front of the garage. Go through the gate and use the side door to get in.$p$
    ),
    ('landing-pad', $p$Park in the driveway.$p$),
    ('tennisplace-a35', $p$Use your one dedicated parking spot.$p$),
    ('sanibel-sunsets', $p$Use your one dedicated parking spot.$p$)
) as v(slug, parking) on true
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug = v.slug;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', lang.language, lang.text
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('cider-loft', 'es', $tr$Aparca detrás, junto a la valla. Busca el cartel de aparcamiento de Airbnb.$tr$),
    ('cider-loft', 'fr', $tr$Stationnez derrière, près de la clôture. Cherchez le panneau de stationnement Airbnb.$tr$),
    ('switchback-suite', 'es', $tr$Aparca en cualquier sitio del aparcamiento de atrás. Se comparte con los otros negocios del lugar.$tr$),
    ('switchback-suite', 'fr', $tr$Stationnez n'importe où dans le stationnement arrière. Il est partagé avec les autres commerces sur place.$tr$),
    ('hinesburg-hideaway-3', 'es', $tr$Aparca solo delante de tu unidad.$tr$),
    ('hinesburg-hideaway-3', 'fr', $tr$Stationnez seulement devant votre unité.$tr$),
    ('hinesburg-hideaway-4', 'es', $tr$Aparca solo delante de tu unidad.$tr$),
    ('hinesburg-hideaway-4', 'fr', $tr$Stationnez seulement devant votre unité.$tr$),
    (
      'backyard-bungalow',
      'es',
      $tr$Por favor aparca delante del garaje. Pasa por la puerta del patio y entra por la puerta lateral.$tr$
    ),
    (
      'backyard-bungalow',
      'fr',
      $tr$Veuillez vous garer devant le garage. Passez le portail et entrez par la porte latérale.$tr$
    ),
    ('landing-pad', 'es', $tr$Aparca en la entrada.$tr$),
    ('landing-pad', 'fr', $tr$Stationnez dans l'allée.$tr$),
    ('tennisplace-a35', 'es', $tr$Usa tu única plaza de aparcamiento dedicada.$tr$),
    ('tennisplace-a35', 'fr', $tr$Utilisez votre seule place de stationnement dédiée.$tr$),
    ('sanibel-sunsets', 'es', $tr$Usa tu única plaza de aparcamiento dedicada.$tr$),
    ('sanibel-sunsets', 'fr', $tr$Utilisez votre seule place de stationnement dédiée.$tr$)
) as lang(slug, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Check-in section summaries: entry method + times.
update public.guidebook_sections sec
set
  summary = v.summary,
  is_visible = true,
  published_at = coalesce(sec.published_at, now()),
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    (
      'cider-loft',
      $sum$Keypad entry. Your entry code is sent through your Airbnb or VRBO messages before arrival. Check-in is at 4:00 PM. Checkout is at 10:00 AM.$sum$
    ),
    (
      'switchback-suite',
      $sum$Keypad entry. Your entry code is sent through your Airbnb or VRBO messages before arrival. Check-in is at 4:00 PM. Checkout is at 10:00 AM.$sum$
    ),
    (
      'hinesburg-hideaway-3',
      $sum$Keypad entry. Your entry code is sent through your Airbnb or VRBO messages before arrival. Check-in is at 4:00 PM. Checkout is at 10:00 AM.$sum$
    ),
    (
      'hinesburg-hideaway-4',
      $sum$Keypad entry. Your entry code is sent through your Airbnb or VRBO messages before arrival. Check-in is at 4:00 PM. Checkout is at 10:00 AM.$sum$
    ),
    (
      'backyard-bungalow',
      $sum$Keypad entry. Your entry code is sent through your Airbnb or VRBO messages before arrival. Check-in is at 4:00 PM. Checkout is at 10:00 AM. Park in front of the garage and enter through the side door.$sum$
    ),
    (
      'landing-pad',
      $sum$Keypad entry. Your entry code is sent through your Airbnb or VRBO messages before arrival. Check-in is at 4:00 PM. Checkout is at 10:00 AM.$sum$
    ),
    (
      'tennisplace-a35',
      $sum$Lockbox entry. Your lockbox code is sent through your Airbnb or VRBO messages before arrival. Check-in is at 4:00 PM. Checkout is at 10:00 AM.$sum$
    ),
    (
      'sanibel-sunsets',
      $sum$Lockbox entry. Your lockbox code is sent through your Airbnb or VRBO messages before arrival. Check-in is at 4:00 PM. Checkout is at 10:00 AM.$sum$
    )
) as v(slug, summary) on true
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug = v.slug
  and sec.section_type = 'check_in';

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'cider-loft',
      'es',
      $tr$Entrada con teclado. Tu código de entrada se envía por Airbnb o VRBO antes de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM.$tr$
    ),
    (
      'cider-loft',
      'fr',
      $tr$Entrée par clavier. Votre code d'entrée est envoyé via Airbnb ou VRBO avant l'arrivée. Arrivée à 4:00 PM. Départ à 10:00 AM.$tr$
    ),
    (
      'switchback-suite',
      'es',
      $tr$Entrada con teclado. Tu código de entrada se envía por Airbnb o VRBO antes de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM.$tr$
    ),
    (
      'switchback-suite',
      'fr',
      $tr$Entrée par clavier. Votre code d'entrée est envoyé via Airbnb ou VRBO avant l'arrivée. Arrivée à 4:00 PM. Départ à 10:00 AM.$tr$
    ),
    (
      'hinesburg-hideaway-3',
      'es',
      $tr$Entrada con teclado. Tu código de entrada se envía por Airbnb o VRBO antes de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM.$tr$
    ),
    (
      'hinesburg-hideaway-3',
      'fr',
      $tr$Entrée par clavier. Votre code d'entrée est envoyé via Airbnb ou VRBO avant l'arrivée. Arrivée à 4:00 PM. Départ à 10:00 AM.$tr$
    ),
    (
      'hinesburg-hideaway-4',
      'es',
      $tr$Entrada con teclado. Tu código de entrada se envía por Airbnb o VRBO antes de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM.$tr$
    ),
    (
      'hinesburg-hideaway-4',
      'fr',
      $tr$Entrée par clavier. Votre code d'entrée est envoyé via Airbnb ou VRBO avant l'arrivée. Arrivée à 4:00 PM. Départ à 10:00 AM.$tr$
    ),
    (
      'backyard-bungalow',
      'es',
      $tr$Entrada con teclado. Tu código de entrada se envía por Airbnb o VRBO antes de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM. Aparca delante del garaje y entra por la puerta lateral.$tr$
    ),
    (
      'backyard-bungalow',
      'fr',
      $tr$Entrée par clavier. Votre code d'entrée est envoyé via Airbnb ou VRBO avant l'arrivée. Arrivée à 4:00 PM. Départ à 10:00 AM. Garez-vous devant le garage et entrez par la porte latérale.$tr$
    ),
    (
      'landing-pad',
      'es',
      $tr$Entrada con teclado. Tu código de entrada se envía por Airbnb o VRBO antes de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM.$tr$
    ),
    (
      'landing-pad',
      'fr',
      $tr$Entrée par clavier. Votre code d'entrée est envoyé via Airbnb ou VRBO avant l'arrivée. Arrivée à 4:00 PM. Départ à 10:00 AM.$tr$
    ),
    (
      'tennisplace-a35',
      'es',
      $tr$Entrada con caja de llaves. Tu código de la caja se envía por Airbnb o VRBO antes de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM.$tr$
    ),
    (
      'tennisplace-a35',
      'fr',
      $tr$Entrée par boîte à clés. Votre code de boîte est envoyé via Airbnb ou VRBO avant l'arrivée. Arrivée à 4:00 PM. Départ à 10:00 AM.$tr$
    ),
    (
      'sanibel-sunsets',
      'es',
      $tr$Entrada con caja de llaves. Tu código de la caja se envía por Airbnb o VRBO antes de la llegada. La llegada es a las 4:00 PM. La salida es a las 10:00 AM.$tr$
    ),
    (
      'sanibel-sunsets',
      'fr',
      $tr$Entrée par boîte à clés. Votre code de boîte est envoyé via Airbnb ou VRBO avant l'arrivée. Arrivée à 4:00 PM. Départ à 10:00 AM.$tr$
    )
) as lang(slug, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
  and sec.section_type = 'check_in'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Getting Here summaries, including good-to-know for Cider Loft and Backyard Bungalow.
update public.guidebook_sections sec
set
  summary = v.summary,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    (
      'cider-loft',
      $sum$Waterbury Center, next to Cold Hollow Cider Mill. Park out back by the fence. Heads up: several steep stairs up to the unit.$sum$
    ),
    (
      'switchback-suite',
      $sum$Stowe, at the base of the Cady Hill Forest trails. Park anywhere in the shared back lot.$sum$
    ),
    (
      'hinesburg-hideaway-3',
      $sum$Hinesburg. Park in front of your unit only.$sum$
    ),
    (
      'hinesburg-hideaway-4',
      $sum$Hinesburg. Park in front of your unit only.$sum$
    ),
    (
      'backyard-bungalow',
      $sum$South Burlington, about half a mile from the interstate and the airport. Park in front of the garage and enter through the side door. The Bungalow is on a main road, so you may hear some traffic noise.$sum$
    ),
    (
      'landing-pad',
      $sum$South Burlington, about 2 minutes from BTV. Park in the driveway.$sum$
    ),
    (
      'tennisplace-a35',
      $sum$Sanibel Island, in the Tennisplace complex. Use your one dedicated parking spot.$sum$
    ),
    (
      'sanibel-sunsets',
      $sum$Sanibel Island, in the Tennisplace complex. Use your one dedicated parking spot.$sum$
    )
) as v(slug, summary) on true
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug = v.slug
  and sec.section_type = 'getting_here';

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'cider-loft',
      'es',
      $tr$Waterbury Center, junto a Cold Hollow Cider Mill. Aparca detrás, junto a la valla. Aviso: varias escaleras empinadas hasta la unidad.$tr$
    ),
    (
      'cider-loft',
      'fr',
      $tr$Waterbury Center, à côté de Cold Hollow Cider Mill. Stationnez derrière, près de la clôture. Attention: plusieurs escaliers raides jusqu'à l'unité.$tr$
    ),
    (
      'switchback-suite',
      'es',
      $tr$Stowe, al pie de los senderos de Cady Hill Forest. Aparca en el aparcamiento compartido de atrás.$tr$
    ),
    (
      'switchback-suite',
      'fr',
      $tr$Stowe, au pied des sentiers de Cady Hill Forest. Stationnez dans le stationnement arrière partagé.$tr$
    ),
    ('hinesburg-hideaway-3', 'es', $tr$Hinesburg. Aparca solo delante de tu unidad.$tr$),
    ('hinesburg-hideaway-3', 'fr', $tr$Hinesburg. Stationnez seulement devant votre unité.$tr$),
    ('hinesburg-hideaway-4', 'es', $tr$Hinesburg. Aparca solo delante de tu unidad.$tr$),
    ('hinesburg-hideaway-4', 'fr', $tr$Hinesburg. Stationnez seulement devant votre unité.$tr$),
    (
      'backyard-bungalow',
      'es',
      $tr$South Burlington, a media milla de la autopista y el aeropuerto. Aparca delante del garaje y entra por la puerta lateral. El Bungalow está en una carretera principal, así que puede oírse algo de tráfico.$tr$
    ),
    (
      'backyard-bungalow',
      'fr',
      $tr$South Burlington, à environ un demi-mille de l'autoroute et de l'aéroport. Garez-vous devant le garage et entrez par la porte latérale. Le Bungalow donne sur une route principale, vous pouvez donc entendre un peu de circulation.$tr$
    ),
    (
      'landing-pad',
      'es',
      $tr$South Burlington, a unos 2 minutos de BTV. Aparca en la entrada.$tr$
    ),
    (
      'landing-pad',
      'fr',
      $tr$South Burlington, à environ 2 minutes de BTV. Stationnez dans l'allée.$tr$
    ),
    (
      'tennisplace-a35',
      'es',
      $tr$Sanibel Island, en el complejo Tennisplace. Usa tu única plaza de aparcamiento dedicada.$tr$
    ),
    (
      'tennisplace-a35',
      'fr',
      $tr$Sanibel Island, dans le complexe Tennisplace. Utilisez votre seule place de stationnement dédiée.$tr$
    ),
    (
      'sanibel-sunsets',
      'es',
      $tr$Sanibel Island, en el complejo Tennisplace. Usa tu única plaza de aparcamiento dedicada.$tr$
    ),
    (
      'sanibel-sunsets',
      'fr',
      $tr$Sanibel Island, dans le complexe Tennisplace. Utilisez votre seule place de stationnement dédiée.$tr$
    )
) as lang(slug, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
  and sec.section_type = 'getting_here'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Thermostat + laundry blocks in The House (What's here).
insert into public.guidebook_blocks (
  id,
  section_id,
  block_type,
  sort_order,
  title,
  body,
  published_at
)
select
  v.id,
  sec.id,
  'rich_text',
  v.sort_order,
  v.title,
  jsonb_build_object('type', 'rich_text', 'markdown', v.markdown),
  now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'd3500000-0000-4000-8000-000000000001'::uuid,
      'cider-loft',
      1010,
      'Thermostat',
      $md$Use the thermostat to set a comfortable temperature. Please turn it down when you leave.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000002'::uuid,
      'cider-loft',
      1020,
      'Laundry',
      $md$Coin-operated washer and dryer on the premises.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000011'::uuid,
      'switchback-suite',
      1010,
      'Thermostat',
      $md$Use the thermostat to set a comfortable temperature. Please turn it down when you leave.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000012'::uuid,
      'switchback-suite',
      1020,
      'Laundry',
      $md$There is no laundry at this stay.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000021'::uuid,
      'hinesburg-hideaway-3',
      1010,
      'Thermostat',
      $md$Use the thermostat to set a comfortable temperature. Please turn it down when you leave.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000022'::uuid,
      'hinesburg-hideaway-3',
      1020,
      'Laundry',
      $md$There is no laundry at this stay.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000031'::uuid,
      'hinesburg-hideaway-4',
      1010,
      'Thermostat',
      $md$Use the thermostat to set a comfortable temperature. Please turn it down when you leave.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000032'::uuid,
      'hinesburg-hideaway-4',
      1020,
      'Laundry',
      $md$There is no laundry at this stay.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000041'::uuid,
      'backyard-bungalow',
      1010,
      'Thermostat',
      $md$Use the thermostat to set a comfortable temperature. Please turn it down when you leave.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000042'::uuid,
      'backyard-bungalow',
      1020,
      'Laundry',
      $md$Washer and dryer in the unit.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000051'::uuid,
      'landing-pad',
      1010,
      'Thermostat',
      $md$Use the thermostat to set a comfortable temperature. Please turn it down when you leave.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000052'::uuid,
      'landing-pad',
      1020,
      'Laundry',
      $md$There is no laundry at this stay.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000061'::uuid,
      'tennisplace-a35',
      1010,
      'Thermostat',
      $md$Use the thermostat to set a comfortable temperature. Please turn it down when you leave.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000062'::uuid,
      'tennisplace-a35',
      1020,
      'Laundry',
      $md$Coin-operated washer and dryer on the premises.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000071'::uuid,
      'sanibel-sunsets',
      1010,
      'Thermostat',
      $md$Use the thermostat to set a comfortable temperature. Please turn it down when you leave.$md$
    ),
    (
      'd3500000-0000-4000-8000-000000000072'::uuid,
      'sanibel-sunsets',
      1020,
      'Laundry',
      $md$Coin-operated washer and dryer on the premises.$md$
    )
) as v(id, slug, sort_order, title, markdown) on true
where s.key = 'dad'
  and p.slug = v.slug
  and sec.section_type = 'house_guide'
on conflict (id) do update
set
  section_id = excluded.section_id,
  block_type = excluded.block_type,
  sort_order = excluded.sort_order,
  title = excluded.title,
  body = excluded.body,
  published_at = coalesce(public.guidebook_blocks.published_at, now()),
  updated_at = now();

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', lang.language, lang.text
from public.guidebook_blocks b
join (
  values
    ('d3500000-0000-4000-8000-000000000001'::uuid, 'es', $tr$Termostato$tr$),
    ('d3500000-0000-4000-8000-000000000001'::uuid, 'fr', $tr$Thermostat$tr$),
    ('d3500000-0000-4000-8000-000000000002'::uuid, 'es', $tr$Lavandería$tr$),
    ('d3500000-0000-4000-8000-000000000002'::uuid, 'fr', $tr$Buanderie$tr$),
    ('d3500000-0000-4000-8000-000000000011'::uuid, 'es', $tr$Termostato$tr$),
    ('d3500000-0000-4000-8000-000000000011'::uuid, 'fr', $tr$Thermostat$tr$),
    ('d3500000-0000-4000-8000-000000000012'::uuid, 'es', $tr$Lavandería$tr$),
    ('d3500000-0000-4000-8000-000000000012'::uuid, 'fr', $tr$Buanderie$tr$),
    ('d3500000-0000-4000-8000-000000000021'::uuid, 'es', $tr$Termostato$tr$),
    ('d3500000-0000-4000-8000-000000000021'::uuid, 'fr', $tr$Thermostat$tr$),
    ('d3500000-0000-4000-8000-000000000022'::uuid, 'es', $tr$Lavandería$tr$),
    ('d3500000-0000-4000-8000-000000000022'::uuid, 'fr', $tr$Buanderie$tr$),
    ('d3500000-0000-4000-8000-000000000031'::uuid, 'es', $tr$Termostato$tr$),
    ('d3500000-0000-4000-8000-000000000031'::uuid, 'fr', $tr$Thermostat$tr$),
    ('d3500000-0000-4000-8000-000000000032'::uuid, 'es', $tr$Lavandería$tr$),
    ('d3500000-0000-4000-8000-000000000032'::uuid, 'fr', $tr$Buanderie$tr$),
    ('d3500000-0000-4000-8000-000000000041'::uuid, 'es', $tr$Termostato$tr$),
    ('d3500000-0000-4000-8000-000000000041'::uuid, 'fr', $tr$Thermostat$tr$),
    ('d3500000-0000-4000-8000-000000000042'::uuid, 'es', $tr$Lavandería$tr$),
    ('d3500000-0000-4000-8000-000000000042'::uuid, 'fr', $tr$Buanderie$tr$),
    ('d3500000-0000-4000-8000-000000000051'::uuid, 'es', $tr$Termostato$tr$),
    ('d3500000-0000-4000-8000-000000000051'::uuid, 'fr', $tr$Thermostat$tr$),
    ('d3500000-0000-4000-8000-000000000052'::uuid, 'es', $tr$Lavandería$tr$),
    ('d3500000-0000-4000-8000-000000000052'::uuid, 'fr', $tr$Buanderie$tr$),
    ('d3500000-0000-4000-8000-000000000061'::uuid, 'es', $tr$Termostato$tr$),
    ('d3500000-0000-4000-8000-000000000061'::uuid, 'fr', $tr$Thermostat$tr$),
    ('d3500000-0000-4000-8000-000000000062'::uuid, 'es', $tr$Lavandería$tr$),
    ('d3500000-0000-4000-8000-000000000062'::uuid, 'fr', $tr$Buanderie$tr$),
    ('d3500000-0000-4000-8000-000000000071'::uuid, 'es', $tr$Termostato$tr$),
    ('d3500000-0000-4000-8000-000000000071'::uuid, 'fr', $tr$Thermostat$tr$),
    ('d3500000-0000-4000-8000-000000000072'::uuid, 'es', $tr$Lavandería$tr$),
    ('d3500000-0000-4000-8000-000000000072'::uuid, 'fr', $tr$Buanderie$tr$)
) as lang(id, language, text) on b.id = lang.id
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', lang.language, lang.text
from public.guidebook_blocks b
join (
  values
    (
      'd3500000-0000-4000-8000-000000000001'::uuid,
      'es',
      $tr$Usa el termostato para poner una temperatura cómoda. Por favor bájalo al salir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000001'::uuid,
      'fr',
      $tr$Utilisez le thermostat pour régler une température confortable. Baissez-le en partant, s'il vous plaît.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000002'::uuid,
      'es',
      $tr$Lavadora y secadora de monedas en el edificio.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000002'::uuid,
      'fr',
      $tr$Laveuse et sécheuse à monnaies sur place.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000011'::uuid,
      'es',
      $tr$Usa el termostato para poner una temperatura cómoda. Por favor bájalo al salir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000011'::uuid,
      'fr',
      $tr$Utilisez le thermostat pour régler une température confortable. Baissez-le en partant, s'il vous plaît.$tr$
    ),
    ('d3500000-0000-4000-8000-000000000012'::uuid, 'es', $tr$No hay lavandería en esta estancia.$tr$),
    ('d3500000-0000-4000-8000-000000000012'::uuid, 'fr', $tr$Il n'y a pas de buanderie dans ce séjour.$tr$),
    (
      'd3500000-0000-4000-8000-000000000021'::uuid,
      'es',
      $tr$Usa el termostato para poner una temperatura cómoda. Por favor bájalo al salir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000021'::uuid,
      'fr',
      $tr$Utilisez le thermostat pour régler une température confortable. Baissez-le en partant, s'il vous plaît.$tr$
    ),
    ('d3500000-0000-4000-8000-000000000022'::uuid, 'es', $tr$No hay lavandería en esta estancia.$tr$),
    ('d3500000-0000-4000-8000-000000000022'::uuid, 'fr', $tr$Il n'y a pas de buanderie dans ce séjour.$tr$),
    (
      'd3500000-0000-4000-8000-000000000031'::uuid,
      'es',
      $tr$Usa el termostato para poner una temperatura cómoda. Por favor bájalo al salir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000031'::uuid,
      'fr',
      $tr$Utilisez le thermostat pour régler une température confortable. Baissez-le en partant, s'il vous plaît.$tr$
    ),
    ('d3500000-0000-4000-8000-000000000032'::uuid, 'es', $tr$No hay lavandería en esta estancia.$tr$),
    ('d3500000-0000-4000-8000-000000000032'::uuid, 'fr', $tr$Il n'y a pas de buanderie dans ce séjour.$tr$),
    (
      'd3500000-0000-4000-8000-000000000041'::uuid,
      'es',
      $tr$Usa el termostato para poner una temperatura cómoda. Por favor bájalo al salir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000041'::uuid,
      'fr',
      $tr$Utilisez le thermostat pour régler une température confortable. Baissez-le en partant, s'il vous plaît.$tr$
    ),
    ('d3500000-0000-4000-8000-000000000042'::uuid, 'es', $tr$Lavadora y secadora en la unidad.$tr$),
    ('d3500000-0000-4000-8000-000000000042'::uuid, 'fr', $tr$Laveuse et sécheuse dans l'unité.$tr$),
    (
      'd3500000-0000-4000-8000-000000000051'::uuid,
      'es',
      $tr$Usa el termostato para poner una temperatura cómoda. Por favor bájalo al salir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000051'::uuid,
      'fr',
      $tr$Utilisez le thermostat pour régler une température confortable. Baissez-le en partant, s'il vous plaît.$tr$
    ),
    ('d3500000-0000-4000-8000-000000000052'::uuid, 'es', $tr$No hay lavandería en esta estancia.$tr$),
    ('d3500000-0000-4000-8000-000000000052'::uuid, 'fr', $tr$Il n'y a pas de buanderie dans ce séjour.$tr$),
    (
      'd3500000-0000-4000-8000-000000000061'::uuid,
      'es',
      $tr$Usa el termostato para poner una temperatura cómoda. Por favor bájalo al salir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000061'::uuid,
      'fr',
      $tr$Utilisez le thermostat pour régler une température confortable. Baissez-le en partant, s'il vous plaît.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000062'::uuid,
      'es',
      $tr$Lavadora y secadora de monedas en el edificio.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000062'::uuid,
      'fr',
      $tr$Laveuse et sécheuse à monnaies sur place.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000071'::uuid,
      'es',
      $tr$Usa el termostato para poner una temperatura cómoda. Por favor bájalo al salir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000071'::uuid,
      'fr',
      $tr$Utilisez le thermostat pour régler une température confortable. Baissez-le en partant, s'il vous plaît.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000072'::uuid,
      'es',
      $tr$Lavadora y secadora de monedas en el edificio.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000072'::uuid,
      'fr',
      $tr$Laveuse et sécheuse à monnaies sur place.$tr$
    )
) as lang(id, language, text) on b.id = lang.id
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- TV streaming note as its own Wi-Fi section block (translated below).
insert into public.guidebook_blocks (
  id,
  section_id,
  block_type,
  sort_order,
  title,
  body,
  published_at
)
select
  v.id,
  sec.id,
  'rich_text',
  20,
  'TV',
  jsonb_build_object(
    'type', 'rich_text',
    'markdown',
    $md$We don't provide streaming subscriptions. Feel free to sign in with your own accounts, and remember to sign out before you leave.$md$
  ),
  now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('d3500000-0000-4000-8000-000000000101'::uuid, 'cider-loft'),
    ('d3500000-0000-4000-8000-000000000102'::uuid, 'switchback-suite'),
    ('d3500000-0000-4000-8000-000000000103'::uuid, 'hinesburg-hideaway-3'),
    ('d3500000-0000-4000-8000-000000000104'::uuid, 'hinesburg-hideaway-4'),
    ('d3500000-0000-4000-8000-000000000105'::uuid, 'backyard-bungalow'),
    ('d3500000-0000-4000-8000-000000000106'::uuid, 'landing-pad'),
    ('d3500000-0000-4000-8000-000000000107'::uuid, 'tennisplace-a35'),
    ('d3500000-0000-4000-8000-000000000108'::uuid, 'sanibel-sunsets')
) as v(id, slug) on true
where s.key = 'dad'
  and p.slug = v.slug
  and sec.section_type = 'wifi'
on conflict (id) do update
set
  section_id = excluded.section_id,
  block_type = excluded.block_type,
  sort_order = excluded.sort_order,
  title = excluded.title,
  body = excluded.body,
  published_at = coalesce(public.guidebook_blocks.published_at, now()),
  updated_at = now();

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', lang.language, lang.text
from public.guidebook_blocks b
join (
  values
    ('d3500000-0000-4000-8000-000000000101'::uuid, 'es', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000101'::uuid, 'fr', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000102'::uuid, 'es', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000102'::uuid, 'fr', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000103'::uuid, 'es', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000103'::uuid, 'fr', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000104'::uuid, 'es', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000104'::uuid, 'fr', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000105'::uuid, 'es', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000105'::uuid, 'fr', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000106'::uuid, 'es', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000106'::uuid, 'fr', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000107'::uuid, 'es', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000107'::uuid, 'fr', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000108'::uuid, 'es', $tr$TV$tr$),
    ('d3500000-0000-4000-8000-000000000108'::uuid, 'fr', $tr$TV$tr$)
) as lang(id, language, text) on b.id = lang.id
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', lang.language, lang.text
from public.guidebook_blocks b
join (
  values
    (
      'd3500000-0000-4000-8000-000000000101'::uuid,
      'es',
      $tr$No ofrecemos suscripciones de streaming. Puedes iniciar sesión con tus propias cuentas, y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000101'::uuid,
      'fr',
      $tr$Nous ne fournissons pas d'abonnements de streaming. Connectez-vous avec vos propres comptes, et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000102'::uuid,
      'es',
      $tr$No ofrecemos suscripciones de streaming. Puedes iniciar sesión con tus propias cuentas, y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000102'::uuid,
      'fr',
      $tr$Nous ne fournissons pas d'abonnements de streaming. Connectez-vous avec vos propres comptes, et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000103'::uuid,
      'es',
      $tr$No ofrecemos suscripciones de streaming. Puedes iniciar sesión con tus propias cuentas, y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000103'::uuid,
      'fr',
      $tr$Nous ne fournissons pas d'abonnements de streaming. Connectez-vous avec vos propres comptes, et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000104'::uuid,
      'es',
      $tr$No ofrecemos suscripciones de streaming. Puedes iniciar sesión con tus propias cuentas, y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000104'::uuid,
      'fr',
      $tr$Nous ne fournissons pas d'abonnements de streaming. Connectez-vous avec vos propres comptes, et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000105'::uuid,
      'es',
      $tr$No ofrecemos suscripciones de streaming. Puedes iniciar sesión con tus propias cuentas, y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000105'::uuid,
      'fr',
      $tr$Nous ne fournissons pas d'abonnements de streaming. Connectez-vous avec vos propres comptes, et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000106'::uuid,
      'es',
      $tr$No ofrecemos suscripciones de streaming. Puedes iniciar sesión con tus propias cuentas, y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000106'::uuid,
      'fr',
      $tr$Nous ne fournissons pas d'abonnements de streaming. Connectez-vous avec vos propres comptes, et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000107'::uuid,
      'es',
      $tr$No ofrecemos suscripciones de streaming. Puedes iniciar sesión con tus propias cuentas, y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000107'::uuid,
      'fr',
      $tr$Nous ne fournissons pas d'abonnements de streaming. Connectez-vous avec vos propres comptes, et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000108'::uuid,
      'es',
      $tr$No ofrecemos suscripciones de streaming. Puedes iniciar sesión con tus propias cuentas, y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000108'::uuid,
      'fr',
      $tr$Nous ne fournissons pas d'abonnements de streaming. Connectez-vous avec vos propres comptes, et pensez à vous déconnecter avant de partir.$tr$
    )
) as lang(id, language, text) on b.id = lang.id
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Pets in house rules summaries (keep Cider Loft dog details from earlier migration).
update public.guidebook_sections sec
set
  summary = v.summary,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    (
      'cider-loft',
      $sum$Dogs welcome (one dog, 30 pounds or less, house-trained). Marijuana is not permitted in the apartment.$sum$
    ),
    ('switchback-suite', $sum$Pets are not allowed.$sum$),
    ('hinesburg-hideaway-3', $sum$Pets are allowed. Please use the marked guest parking.$sum$),
    ('hinesburg-hideaway-4', $sum$Pets are allowed. Please park in front of your unit only.$sum$),
    (
      'backyard-bungalow',
      $sum$Pets are welcome and must stay off furniture and be house-trained. Request sofa bed linens when booking.$sum$
    ),
    ('landing-pad', $sum$Pets are not allowed.$sum$),
    ('tennisplace-a35', $sum$Pets are not allowed.$sum$),
    ('sanibel-sunsets', $sum$Pets are not allowed.$sum$)
) as v(slug, summary) on true
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug = v.slug
  and sec.section_type = 'house_rules';

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'cider-loft',
      'es',
      $tr$Perros bienvenidos (uno, de 30 libras o menos, y educado). No se permite marihuana en el apartamento.$tr$
    ),
    (
      'cider-loft',
      'fr',
      $tr$Chiens bienvenus (un seul, 30 livres ou moins, et propre). La marijuana n'est pas autorisée dans l'appartement.$tr$
    ),
    ('switchback-suite', 'es', $tr$No se admiten mascotas.$tr$),
    ('switchback-suite', 'fr', $tr$Les animaux ne sont pas acceptés.$tr$),
    (
      'hinesburg-hideaway-3',
      'es',
      $tr$Se admiten mascotas. Por favor usa el aparcamiento de huéspedes señalado.$tr$
    ),
    (
      'hinesburg-hideaway-3',
      'fr',
      $tr$Les animaux sont acceptés. Merci d'utiliser le stationnement invité indiqué.$tr$
    ),
    (
      'hinesburg-hideaway-4',
      'es',
      $tr$Se admiten mascotas. Por favor aparca solo delante de tu unidad.$tr$
    ),
    (
      'hinesburg-hideaway-4',
      'fr',
      $tr$Les animaux sont acceptés. Merci de stationner seulement devant votre unité.$tr$
    ),
    (
      'backyard-bungalow',
      'es',
      $tr$Se admiten mascotas; deben estar educadas y no subirse a los muebles. Pide la ropa de cama del sofá cama al reservar.$tr$
    ),
    (
      'backyard-bungalow',
      'fr',
      $tr$Les animaux sont les bienvenus; ils doivent être propres et rester hors des meubles. Demandez le linge du sofa-lit à la réservation.$tr$
    ),
    ('landing-pad', 'es', $tr$No se admiten mascotas.$tr$),
    ('landing-pad', 'fr', $tr$Les animaux ne sont pas acceptés.$tr$),
    ('tennisplace-a35', 'es', $tr$No se admiten mascotas.$tr$),
    ('tennisplace-a35', 'fr', $tr$Les animaux ne sont pas acceptés.$tr$),
    ('sanibel-sunsets', 'es', $tr$No se admiten mascotas.$tr$),
    ('sanibel-sunsets', 'fr', $tr$Les animaux ne sont pas acceptés.$tr$)
) as lang(slug, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
  and sec.section_type = 'house_rules'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Fix Landing Pad house-rules body (was pets allowed) and Switchback / Sanibel bodies.
update public.guidebook_blocks b
set
  body = jsonb_build_object('type', 'rich_text', 'markdown', v.markdown),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('switchback-suite', $md$Pets are not allowed.

Please treat the suite like your own and keep evenings neighbor-friendly after a day on the trails.$md$),
    ('landing-pad', $md$Pets are not allowed.

A good fit for family reunions and group trips. Please treat the house like your own.$md$),
    ('tennisplace-a35', $md$Pets are not allowed.

Weekly stays only. 2-week minimum in February, March, and April. 1-week minimum the rest of the year.$md$),
    ('sanibel-sunsets', $md$Pets are not allowed.

Weekly stays only. 2-week minimum in February, March, and April. 1-week minimum the rest of the year.$md$)
) as v(slug, markdown) on true
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug = v.slug
  and sec.section_type = 'house_rules'
  and b.block_type = 'rich_text'
  and b.sort_order < 1000;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', lang.language, lang.text
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'switchback-suite',
      'es',
      $tr$No se admiten mascotas.

Por favor trata la suite como si fuera tuya y mantén las noches tranquilas después de un día en los senderos.$tr$
    ),
    (
      'switchback-suite',
      'fr',
      $tr$Les animaux ne sont pas acceptés.

Traitez la suite comme la vôtre et gardez les soirées calmes après une journée sur les sentiers.$tr$
    ),
    (
      'landing-pad',
      'es',
      $tr$No se admiten mascotas.

Ideal para reuniones familiares y viajes en grupo. Por favor trata la casa como si fuera tuya.$tr$
    ),
    (
      'landing-pad',
      'fr',
      $tr$Les animaux ne sont pas acceptés.

Idéal pour les réunions de famille et les voyages en groupe. Traitez la maison comme la vôtre.$tr$
    ),
    (
      'tennisplace-a35',
      'es',
      $tr$No se admiten mascotas.

Solo estancias semanales. Mínimo de 2 semanas en febrero, marzo y abril. Mínimo de 1 semana el resto del año.$tr$
    ),
    (
      'tennisplace-a35',
      'fr',
      $tr$Les animaux ne sont pas acceptés.

Séjours hebdomadaires seulement. Minimum de 2 semaines en février, mars et avril. Minimum d'1 semaine le reste de l'année.$tr$
    ),
    (
      'sanibel-sunsets',
      'es',
      $tr$No se admiten mascotas.

Solo estancias semanales. Mínimo de 2 semanas en febrero, marzo y abril. Mínimo de 1 semana el resto del año.$tr$
    ),
    (
      'sanibel-sunsets',
      'fr',
      $tr$Les animaux ne sont pas acceptés.

Séjours hebdomadaires seulement. Minimum de 2 semaines en février, mars et avril. Minimum d'1 semaine le reste de l'année.$tr$
    )
) as lang(slug, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
  and sec.section_type = 'house_rules'
  and b.block_type = 'rich_text'
  and b.sort_order < 1000
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Fix Landing Pad house_guide summary (no in-unit laundry).
update public.guidebook_sections sec
set
  summary = 'Three bedrooms plus a queen pull-out couch, one bath, sleeps 8. Full kitchen. No laundry on site.',
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug = 'landing-pad'
  and sec.section_type = 'house_guide';

do $check$
declare
  wrong_times integer;
  thermostat_blocks integer;
  bungalow_checkout text;
begin
  select count(*) into wrong_times
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and (
      p.check_in_time is distinct from '4:00 PM'
      or p.check_out_time is distinct from '10:00 AM'
    );

  if wrong_times <> 0 then
    raise exception 'Every dad property should check in at 4:00 PM and out at 10:00 AM.';
  end if;

  select p.check_out_time into bungalow_checkout
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad' and p.slug = 'backyard-bungalow';

  if bungalow_checkout is distinct from '10:00 AM' then
    raise exception 'Backyard Bungalow checkout must be 10:00 AM.';
  end if;

  select count(*) into thermostat_blocks
  from public.guidebook_blocks b
  where b.id in (
    'd3500000-0000-4000-8000-000000000001'::uuid,
    'd3500000-0000-4000-8000-000000000011'::uuid,
    'd3500000-0000-4000-8000-000000000021'::uuid,
    'd3500000-0000-4000-8000-000000000031'::uuid,
    'd3500000-0000-4000-8000-000000000041'::uuid,
    'd3500000-0000-4000-8000-000000000051'::uuid,
    'd3500000-0000-4000-8000-000000000061'::uuid,
    'd3500000-0000-4000-8000-000000000071'::uuid
  );

  if thermostat_blocks <> 8 then
    raise exception 'Expected thermostat blocks for all 8 dad stays, found %.', thermostat_blocks;
  end if;
end
$check$;

notify pgrst, 'reload schema';
