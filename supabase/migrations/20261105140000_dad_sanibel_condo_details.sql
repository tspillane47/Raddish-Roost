-- Dad: Sanibel condo stay details for A35 Tennisplace and Sanibel Sunsets
-- (same complex, same facts). Keeps current names and slugs.
-- Dad-scoped only. Safe to paste again. No em dashes. No roost changes.
-- Paste after 20261105130000_dad_undo_sanibel_rename.sql.

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
      and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  ) <> 2 then
    raise exception 'Dad Sanibel properties are missing. Run the dad properties migration first.';
  end if;
end
$guard$;

-- About the location (top of property page).
update public.properties p
set
  tagline = 'Tennisplace is one of the best locations on Sanibel. It''s central and easy to get on and off the island, and Dixie Beach is about a 5 minute walk.',
  parking_summary = 'You have one dedicated covered parking space. Extra visitor spaces are available in the lot too.',
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets');

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, lang.field, lang.language, lang.text
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    (
      'tagline',
      'es',
      $tr$Tennisplace es una de las mejores ubicaciones de Sanibel. Está en un punto céntrico, fácil para entrar y salir de la isla, y Dixie Beach queda a unos 5 minutos a pie.$tr$
    ),
    (
      'tagline',
      'fr',
      $tr$Tennisplace est l'un des meilleurs emplacements de Sanibel. C'est central, facile pour entrer et sortir de l'île, et Dixie Beach est à environ 5 minutes à pied.$tr$
    ),
    (
      'parking_summary',
      'es',
      $tr$Tienes una plaza de aparcamiento cubierta dedicada. También hay plazas extra para visitas en el parking.$tr$
    ),
    (
      'parking_summary',
      'fr',
      $tr$Vous avez une place de stationnement couverte dédiée. Des places visiteurs supplémentaires sont aussi disponibles sur le stationnement.$tr$
    )
) as lang(field, language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Getting Here: location + parking.
update public.guidebook_sections sec
set
  summary = $sum$Tennisplace is one of the best locations on Sanibel. It's central and easy to get on and off the island, and Dixie Beach is about a 5 minute walk. You have one dedicated covered parking space. Extra visitor spaces are available in the lot too.$sum$,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'getting_here';

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'es',
      $tr$Tennisplace es una de las mejores ubicaciones de Sanibel. Está en un punto céntrico, fácil para entrar y salir de la isla, y Dixie Beach queda a unos 5 minutos a pie. Tienes una plaza de aparcamiento cubierta dedicada. También hay plazas extra para visitas en el parking.$tr$
    ),
    (
      'fr',
      $tr$Tennisplace est l'un des meilleurs emplacements de Sanibel. C'est central, facile pour entrer et sortir de l'île, et Dixie Beach est à environ 5 minutes à pied. Vous avez une place de stationnement couverte dédiée. Des places visiteurs supplémentaires sont aussi disponibles sur le stationnement.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'getting_here'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown',
    v.markdown
  ),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'tennisplace-a35',
      $md$A35 Tennisplace is on Sanibel Island, Florida, in the Tennisplace complex.

Tennisplace is one of the best locations on Sanibel. It's central and easy to get on and off the island, and Dixie Beach is about a 5 minute walk.

You have one dedicated covered parking space. Extra visitor spaces are available in the lot too.

The street address is in your booking messages.$md$
    ),
    (
      'sanibel-sunsets',
      $md$Sanibel Sunsets is on Sanibel Island, Florida, in the Tennisplace complex.

Tennisplace is one of the best locations on Sanibel. It's central and easy to get on and off the island, and Dixie Beach is about a 5 minute walk.

You have one dedicated covered parking space. Extra visitor spaces are available in the lot too.

The street address is in your booking messages.$md$
    )
) as v(slug, markdown) on true
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug = v.slug
  and sec.section_type = 'getting_here'
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
      'tennisplace-a35',
      'es',
      $tr$A35 Tennisplace está en Sanibel Island, Florida, en el complejo Tennisplace.

Tennisplace es una de las mejores ubicaciones de Sanibel. Está en un punto céntrico, fácil para entrar y salir de la isla, y Dixie Beach queda a unos 5 minutos a pie.

Tienes una plaza de aparcamiento cubierta dedicada. También hay plazas extra para visitas en el parking.

La dirección completa está en los mensajes de tu reserva.$tr$
    ),
    (
      'tennisplace-a35',
      'fr',
      $tr$A35 Tennisplace se trouve à Sanibel Island, Floride, dans le complexe Tennisplace.

Tennisplace est l'un des meilleurs emplacements de Sanibel. C'est central, facile pour entrer et sortir de l'île, et Dixie Beach est à environ 5 minutes à pied.

Vous avez une place de stationnement couverte dédiée. Des places visiteurs supplémentaires sont aussi disponibles sur le stationnement.

L'adresse complète est dans les messages de votre réservation.$tr$
    ),
    (
      'sanibel-sunsets',
      'es',
      $tr$Sanibel Sunsets está en Sanibel Island, Florida, en el complejo Tennisplace.

Tennisplace es una de las mejores ubicaciones de Sanibel. Está en un punto céntrico, fácil para entrar y salir de la isla, y Dixie Beach queda a unos 5 minutos a pie.

Tienes una plaza de aparcamiento cubierta dedicada. También hay plazas extra para visitas en el parking.

La dirección completa está en los mensajes de tu reserva.$tr$
    ),
    (
      'sanibel-sunsets',
      'fr',
      $tr$Sanibel Sunsets se trouve à Sanibel Island, Floride, dans le complexe Tennisplace.

Tennisplace est l'un des meilleurs emplacements de Sanibel. C'est central, facile pour entrer et sortir de l'île, et Dixie Beach est à environ 5 minutes à pied.

Vous avez une place de stationnement couverte dédiée. Des places visiteurs supplémentaires sont aussi disponibles sur le stationnement.

L'adresse complète est dans les messages de votre réservation.$tr$
    )
) as lang(slug, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
  and sec.section_type = 'getting_here'
  and b.block_type = 'rich_text'
  and b.sort_order < 1000
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Wi-Fi section summary + Wi-Fi body + TV block (also mirrored under The House).
update public.guidebook_sections sec
set
  summary = $sum$Wi-Fi is included. There's a smart TV, but no cable or streaming plans are included.$sum$,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'wifi';

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'es',
      $tr$El Wi-Fi está incluido. Hay un smart TV, pero no hay cable ni planes de streaming incluidos.$tr$
    ),
    (
      'fr',
      $tr$Le Wi-Fi est inclus. Il y a une smart TV, mais ni câble ni forfaits de streaming ne sont inclus.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'wifi'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

update public.guidebook_blocks b
set
  title = 'Wi-Fi',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown',
    $md$Wi-Fi is included. The network name and password stay in your booking messages.$md$
  ),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'wifi'
  and b.block_type = 'rich_text'
  and b.sort_order < 20;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', lang.language, lang.text
from public.guidebook_blocks b
join public.guidebook_sections sec on sec.id = b.section_id
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'es',
      $tr$El Wi-Fi está incluido. El nombre de la red y la contraseña están en los mensajes de tu reserva.$tr$
    ),
    (
      'fr',
      $tr$Le Wi-Fi est inclus. Le nom du réseau et le mot de passe restent dans les messages de votre réservation.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'wifi'
  and b.block_type = 'rich_text'
  and b.sort_order < 20
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

update public.guidebook_blocks b
set
  title = 'TV',
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown',
    $md$There's a smart TV, but no cable or streaming plans are included. Sign in with your own accounts (Netflix, Hulu, etc.) and remember to sign out before you leave.$md$
  ),
  updated_at = now()
where b.id in (
  'd3500000-0000-4000-8000-000000000107'::uuid,
  'd3500000-0000-4000-8000-000000000108'::uuid
);

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, lang.field, lang.language, lang.text
from public.guidebook_blocks b
join (
  values
    (
      'd3500000-0000-4000-8000-000000000107'::uuid,
      'markdown',
      'es',
      $tr$Hay un smart TV, pero no hay cable ni planes de streaming incluidos. Inicia sesión con tus propias cuentas (Netflix, Hulu, etc.) y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000107'::uuid,
      'markdown',
      'fr',
      $tr$Il y a une smart TV, mais ni câble ni forfaits de streaming ne sont inclus. Connectez-vous avec vos propres comptes (Netflix, Hulu, etc.) et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000108'::uuid,
      'markdown',
      'es',
      $tr$Hay un smart TV, pero no hay cable ni planes de streaming incluidos. Inicia sesión con tus propias cuentas (Netflix, Hulu, etc.) y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3500000-0000-4000-8000-000000000108'::uuid,
      'markdown',
      'fr',
      $tr$Il y a une smart TV, mais ni câble ni forfaits de streaming ne sont inclus. Connectez-vous avec vos propres comptes (Netflix, Hulu, etc.) et pensez à vous déconnecter avant de partir.$tr$
    )
) as lang(id, field, language, text) on b.id = lang.id
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- The House: Wi-Fi and TV, pool, tennis/pickleball, laundry wording.
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
      'd3600000-0000-4000-8000-000000000001'::uuid,
      'tennisplace-a35',
      1005,
      'Wi-Fi and TV',
      $md$Wi-Fi is included. There's a smart TV, but no cable or streaming plans are included. Sign in with your own accounts (Netflix, Hulu, etc.) and remember to sign out before you leave.$md$
    ),
    (
      'd3600000-0000-4000-8000-000000000002'::uuid,
      'sanibel-sunsets',
      1005,
      'Wi-Fi and TV',
      $md$Wi-Fi is included. There's a smart TV, but no cable or streaming plans are included. Sign in with your own accounts (Netflix, Hulu, etc.) and remember to sign out before you leave.$md$
    ),
    (
      'd3600000-0000-4000-8000-000000000011'::uuid,
      'tennisplace-a35',
      1030,
      'Shared pool',
      $md$Guests share the Tennisplace pool.$md$
    ),
    (
      'd3600000-0000-4000-8000-000000000012'::uuid,
      'sanibel-sunsets',
      1030,
      'Shared pool',
      $md$Guests share the Tennisplace pool.$md$
    ),
    (
      'd3600000-0000-4000-8000-000000000021'::uuid,
      'tennisplace-a35',
      1040,
      'Tennis and pickleball courts',
      $md$Tennis courts and pickleball courts are on site for guests.$md$
    ),
    (
      'd3600000-0000-4000-8000-000000000022'::uuid,
      'sanibel-sunsets',
      1040,
      'Tennis and pickleball courts',
      $md$Tennis courts and pickleball courts are on site for guests.$md$
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

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown',
    $md$Coin-operated washer and dryer on site.$md$
  ),
  updated_at = now()
where b.id in (
  'd3500000-0000-4000-8000-000000000062'::uuid,
  'd3500000-0000-4000-8000-000000000072'::uuid
);

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', lang.language, lang.text
from public.guidebook_blocks b
join (
  values
    ('d3600000-0000-4000-8000-000000000001'::uuid, 'es', $tr$Wi-Fi y TV$tr$),
    ('d3600000-0000-4000-8000-000000000001'::uuid, 'fr', $tr$Wi-Fi et TV$tr$),
    ('d3600000-0000-4000-8000-000000000002'::uuid, 'es', $tr$Wi-Fi y TV$tr$),
    ('d3600000-0000-4000-8000-000000000002'::uuid, 'fr', $tr$Wi-Fi et TV$tr$),
    ('d3600000-0000-4000-8000-000000000011'::uuid, 'es', $tr$Piscina compartida$tr$),
    ('d3600000-0000-4000-8000-000000000011'::uuid, 'fr', $tr$Piscine partagée$tr$),
    ('d3600000-0000-4000-8000-000000000012'::uuid, 'es', $tr$Piscina compartida$tr$),
    ('d3600000-0000-4000-8000-000000000012'::uuid, 'fr', $tr$Piscine partagée$tr$),
    ('d3600000-0000-4000-8000-000000000021'::uuid, 'es', $tr$Pistas de tenis y pickleball$tr$),
    ('d3600000-0000-4000-8000-000000000021'::uuid, 'fr', $tr$Courts de tennis et de pickleball$tr$),
    ('d3600000-0000-4000-8000-000000000022'::uuid, 'es', $tr$Pistas de tenis y pickleball$tr$),
    ('d3600000-0000-4000-8000-000000000022'::uuid, 'fr', $tr$Courts de tennis et de pickleball$tr$)
) as lang(id, language, text) on b.id = lang.id
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', lang.language, lang.text
from public.guidebook_blocks b
join (
  values
    (
      'd3600000-0000-4000-8000-000000000001'::uuid,
      'es',
      $tr$El Wi-Fi está incluido. Hay un smart TV, pero no hay cable ni planes de streaming incluidos. Inicia sesión con tus propias cuentas (Netflix, Hulu, etc.) y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000001'::uuid,
      'fr',
      $tr$Le Wi-Fi est inclus. Il y a une smart TV, mais ni câble ni forfaits de streaming ne sont inclus. Connectez-vous avec vos propres comptes (Netflix, Hulu, etc.) et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000002'::uuid,
      'es',
      $tr$El Wi-Fi está incluido. Hay un smart TV, pero no hay cable ni planes de streaming incluidos. Inicia sesión con tus propias cuentas (Netflix, Hulu, etc.) y recuerda cerrar sesión antes de irte.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000002'::uuid,
      'fr',
      $tr$Le Wi-Fi est inclus. Il y a une smart TV, mais ni câble ni forfaits de streaming ne sont inclus. Connectez-vous avec vos propres comptes (Netflix, Hulu, etc.) et pensez à vous déconnecter avant de partir.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000011'::uuid,
      'es',
      $tr$Los huéspedes comparten la piscina de Tennisplace.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000011'::uuid,
      'fr',
      $tr$Les hôtes partagent la piscine de Tennisplace.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000012'::uuid,
      'es',
      $tr$Los huéspedes comparten la piscina de Tennisplace.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000012'::uuid,
      'fr',
      $tr$Les hôtes partagent la piscine de Tennisplace.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000021'::uuid,
      'es',
      $tr$Hay pistas de tenis y pickleball en el complejo para los huéspedes.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000021'::uuid,
      'fr',
      $tr$Des courts de tennis et de pickleball sont sur place pour les hôtes.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000022'::uuid,
      'es',
      $tr$Hay pistas de tenis y pickleball en el complejo para los huéspedes.$tr$
    ),
    (
      'd3600000-0000-4000-8000-000000000022'::uuid,
      'fr',
      $tr$Des courts de tennis et de pickleball sont sur place pour les hôtes.$tr$
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

-- House guide summary for amenities + included gear.
update public.guidebook_sections sec
set
  summary = v.summary,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    (
      'tennisplace-a35',
      $sum$Two bedrooms, 1.5 baths, sleeps 5. Kayak, bikes, boat slip, shared pool, tennis and pickleball, and coin-op laundry on site.$sum$
    ),
    (
      'sanibel-sunsets',
      $sum$Two bedrooms, three beds, 1.5 baths, sleeps 4. Kayak, bikes, boat slip, shared pool, tennis and pickleball, and coin-op laundry on site.$sum$
    )
) as v(slug, summary) on true
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug = v.slug
  and sec.section_type = 'house_guide';

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'tennisplace-a35',
      'es',
      $tr$Dos dormitorios, 1.5 baños, hasta 5 personas. Kayak, bicis, amarre, piscina compartida, tenis y pickleball, y lavandería de monedas en el edificio.$tr$
    ),
    (
      'tennisplace-a35',
      'fr',
      $tr$Deux chambres, 1,5 salle de bain, jusqu'à 5 personnes. Kayak, vélos, place de bateau, piscine partagée, tennis et pickleball, et buanderie à monnaies sur place.$tr$
    ),
    (
      'sanibel-sunsets',
      'es',
      $tr$Dos dormitorios, tres camas, 1.5 baños, hasta 4 personas. Kayak, bicis, amarre, piscina compartida, tenis y pickleball, y lavandería de monedas en el edificio.$tr$
    ),
    (
      'sanibel-sunsets',
      'fr',
      $tr$Deux chambres, trois lits, 1,5 salle de bain, jusqu'à 4 personnes. Kayak, vélos, place de bateau, piscine partagée, tennis et pickleball, et buanderie à monnaies sur place.$tr$
    )
) as lang(slug, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
  and sec.section_type = 'house_guide'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Pets (HOA) with wildlife company note.
update public.guidebook_sections sec
set
  summary = $sum$The HOA doesn't allow pets on the property. But you'll have plenty of animal company: iguanas, dolphins, and manatees can be spotted every day.$sum$,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'house_rules';

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'es',
      $tr$La HOA no permite mascotas en la propiedad. Pero tendrás compañía animal de sobra: iguanas, delfines y manatíes se ven cada día.$tr$
    ),
    (
      'fr',
      $tr$L'HOA n'autorise pas les animaux sur la propriété. Mais vous aurez de la compagnie: iguanes, dauphins et lamantins se voient chaque jour.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'house_rules'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown',
    $md$The HOA doesn't allow pets on the property. But you'll have plenty of animal company: iguanas, dolphins, and manatees can be spotted every day.

Weekly stays only. 2-week minimum in February, March, and April. 1-week minimum the rest of the year.$md$
  ),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
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
      'es',
      $tr$La HOA no permite mascotas en la propiedad. Pero tendrás compañía animal de sobra: iguanas, delfines y manatíes se ven cada día.

Solo estancias semanales. Mínimo de 2 semanas en febrero, marzo y abril. Mínimo de 1 semana el resto del año.$tr$
    ),
    (
      'fr',
      $tr$L'HOA n'autorise pas les animaux sur la propriété. Mais vous aurez de la compagnie: iguanes, dauphins et lamantins se voient chaque jour.

Séjours hebdomadaires seulement. Minimum de 2 semaines en février, mars et avril. Minimum d'1 semaine le reste de l'année.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.section_type = 'house_rules'
  and b.block_type = 'rich_text'
  and b.sort_order < 1000
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- On the Water: Sanibel Marina and Jensen's Marina.
do $marinas$
declare
  rec record;
  maps text;
  query_text text;
begin
  for rec in
    select *
    from (
      values
        (
          'd3100000-0000-4000-8000-000000000027'::uuid,
          'Sanibel Marina',
          'outdoors',
          'on_the_water',
          'year_round',
          'Sanibel',
          '634 North Yachtsman Drive, Sanibel',
          'Boat rentals near the lighthouse on the east end of the island.'
        ),
        (
          'd3100000-0000-4000-8000-000000000028'::uuid,
          'Jensen''s Marina',
          'outdoors',
          'on_the_water',
          'year_round',
          'Captiva',
          '15107 Captiva Drive, Captiva',
          'Historic marina with boat rentals, kayak rentals, fishing charters, and water taxis to North Captiva.'
        )
    ) as v(id, name, category, subcategory, season, town, address, description)
  loop
    query_text := rec.name || ' ' || rec.address || ' Florida';
    maps := 'https://www.google.com/maps/search/?api=1&query=' || replace(
      replace(
        replace(
          replace(
            replace(
              replace(query_text, '%', '%25'),
              '#', '%23'
            ),
            '&', '%26'
          ),
          '+', '%2B'
        ),
        '/', '%2F'
      ),
      ' ', '%20'
    );

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
      rec.address,
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
      description = excluded.description,
      address = excluded.address,
      maps_url = excluded.maps_url,
      town = excluded.town,
      published_at = coalesce(public.recommendations.published_at, now()),
      updated_at = now();
  end loop;
end
$marinas$;

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
  false,
  wanted.sort_order,
  now(),
  wanted.host_note,
  wanted.guest_tags
from public.properties dad
join public.sites dad_site on dad_site.id = dad.site_id
join (
  values
    (
      'Sanibel Marina',
      270,
      array['kid_friendly']::text[],
      $tip$Rent a boat here and dock it right in front of the condo at slip #6.$tip$
    ),
    (
      'Jensen''s Marina',
      280,
      array['kid_friendly']::text[],
      null::text
    )
) as wanted(name, sort_order, guest_tags, host_note) on true
join public.recommendations place
  on place.name = wanted.name
 and place.is_active
where dad_site.key = 'dad'
  and dad.slug in ('tennisplace-a35', 'sanibel-sunsets')
on conflict (property_id, recommendation_id) do update
set
  sort_order = excluded.sort_order,
  published_at = coalesce(public.property_recommendations.published_at, now()),
  host_note = excluded.host_note,
  guest_tags = excluded.guest_tags,
  custom_description = null;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', lang.language, lang.text
from public.recommendations r
join (
  values
    (
      'Sanibel Marina',
      'es',
      $tr$Alquiler de barcos cerca del faro, en el extremo este de la isla.$tr$
    ),
    (
      'Sanibel Marina',
      'fr',
      $tr$Location de bateaux près du phare, à l'extrémité est de l'île.$tr$
    ),
    (
      'Jensen''s Marina',
      'es',
      $tr$Marina histórica con alquiler de barcos y kayaks, charters de pesca y taxis acuáticos a North Captiva.$tr$
    ),
    (
      'Jensen''s Marina',
      'fr',
      $tr$Marina historique avec location de bateaux et kayaks, sorties de pêche et taxis aquatiques vers North Captiva.$tr$
    )
) as lang(name, language, text) on r.name = lang.name
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'property_recommendations', pr.id, 'host_note', lang.language, lang.text
from public.property_recommendations pr
join public.recommendations r on r.id = pr.recommendation_id
join public.properties p on p.id = pr.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'es',
      $tr$Alquila un barco aquí y atrácalo justo delante del condo en el slip #6.$tr$
    ),
    (
      'fr',
      $tr$Louez un bateau ici et amarez-le juste devant le condo au slip #6.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and r.name = 'Sanibel Marina'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

do $check$
declare
  tagline_count integer;
  marina_count integer;
  link_count integer;
  wifi_block_count integer;
begin
  select count(*) into tagline_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
    and p.tagline like 'Tennisplace is one of the best locations on Sanibel%';

  select count(*) into marina_count
  from public.recommendations
  where id in (
    'd3100000-0000-4000-8000-000000000027'::uuid,
    'd3100000-0000-4000-8000-000000000028'::uuid
  )
    and is_active;

  select count(*) into link_count
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  join public.recommendations r on r.id = pr.recommendation_id
  where s.key = 'dad'
    and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
    and r.name in ('Sanibel Marina', 'Jensen''s Marina');

  select count(*) into wifi_block_count
  from public.guidebook_blocks
  where id in (
    'd3600000-0000-4000-8000-000000000001'::uuid,
    'd3600000-0000-4000-8000-000000000002'::uuid
  );

  if tagline_count <> 2 or marina_count <> 2 or link_count <> 4 or wifi_block_count <> 2 then
    raise exception 'Sanibel condo details migration checks failed.';
  end if;
end
$check$;
