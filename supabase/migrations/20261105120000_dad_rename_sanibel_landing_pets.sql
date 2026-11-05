-- Dad: rename Sanibel condos to The Shell Game / Safe Harbor,
-- mark Landing Pad dog friendly, and refresh related copy.
-- Dad-scoped only. Safe to paste again. No em dashes. No roost changes.
-- Paste after 20261104160000_dad_stay_essentials.sql.
-- App redirects: tennisplace-a35 -> shell-game, sanibel-sunsets -> safe-harbor.

do $guard$
begin
  if not exists (select 1 from public.sites where key = 'dad') then
    raise exception 'Dad site is missing. Run the sites migration before this file.';
  end if;
end
$guard$;

-- Rename A35 Tennisplace -> The Shell Game (shell-game).
update public.properties p
set
  slug = 'shell-game',
  name = 'The Shell Game',
  tagline = 'Steps from Dixie Beach. Kayak, bikes, and a pool.',
  welcome_title = 'Welcome to The Shell Game',
  welcome_message = $w$We're so glad you're here. The Shell Game is a waterfront condo in the Tennisplace complex, with Dixie Beach just steps away. Make yourself at home.$w$,
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'shell-game');

-- Rename Sanibel Sunsets -> Safe Harbor (safe-harbor).
update public.properties p
set
  slug = 'safe-harbor',
  name = 'Safe Harbor',
  tagline = 'Canal views, a pool, and dolphins from the porch.',
  welcome_title = 'Welcome to Safe Harbor',
  welcome_message = $w$We're so glad you're here. Safe Harbor is a recently updated canal-side condo in the Tennisplace complex, with Dixie Beach about a 5-minute walk away. Make yourself at home.$w$,
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('sanibel-sunsets', 'safe-harbor');

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, lang.field, lang.language, lang.text
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('shell-game', 'tagline', 'es', $tr$A pasos de Dixie Beach. Kayak, bicis y piscina.$tr$),
    ('shell-game', 'tagline', 'fr', $tr$À deux pas de Dixie Beach. Kayak, vélos et piscine.$tr$),
    ('shell-game', 'welcome_title', 'es', $tr$Bienvenida a The Shell Game$tr$),
    ('shell-game', 'welcome_title', 'fr', $tr$Bienvenue à The Shell Game$tr$),
    (
      'shell-game',
      'welcome_message',
      'es',
      $tr$Nos alegra que estés aquí. The Shell Game es un condo frente al agua en el complejo Tennisplace, con Dixie Beach a unos pasos. Ponte cómodo.$tr$
    ),
    (
      'shell-game',
      'welcome_message',
      'fr',
      $tr$Nous sommes contents que vous soyez là. The Shell Game est un condo au bord de l'eau dans le complexe Tennisplace, avec Dixie Beach à deux pas. Faites comme chez vous.$tr$
    ),
    ('safe-harbor', 'tagline', 'es', $tr$Vistas al canal, piscina y delfines desde el porche.$tr$),
    ('safe-harbor', 'tagline', 'fr', $tr$Vue sur le canal, une piscine, et des dauphins depuis le porche.$tr$),
    ('safe-harbor', 'welcome_title', 'es', $tr$Bienvenida a Safe Harbor$tr$),
    ('safe-harbor', 'welcome_title', 'fr', $tr$Bienvenue à Safe Harbor$tr$),
    (
      'safe-harbor',
      'welcome_message',
      'es',
      $tr$Nos alegra que estés aquí. Safe Harbor es un condo junto al canal recién actualizado en el complejo Tennisplace, con Dixie Beach a unos 5 minutos a pie. Ponte cómodo.$tr$
    ),
    (
      'safe-harbor',
      'welcome_message',
      'fr',
      $tr$Nous sommes contents que vous soyez là. Safe Harbor est un condo récemment rafraîchi au bord du canal dans le complexe Tennisplace, avec Dixie Beach à environ 5 minutes à pied. Faites comme chez vous.$tr$
    )
) as lang(slug, field, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Stay-again guidebook blurbs that still name the old titles.
update public.guidebook_blocks b
set
  body = jsonb_set(
    b.body,
    '{markdown}',
    to_jsonb(
      replace(
        replace(
          coalesce(b.body->>'markdown', ''),
          'A35 Tennisplace',
          'The Shell Game'
        ),
        'Sanibel Sunsets',
        'Safe Harbor'
      )
    )
  ),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug in ('shell-game', 'safe-harbor')
  and coalesce(b.body->>'markdown', '') ~ 'A35 Tennisplace|Sanibel Sunsets';

update public.guidebook_sections sec
set
  summary = replace(
    replace(sec.summary, 'A35 Tennisplace', 'The Shell Game'),
    'Sanibel Sunsets',
    'Safe Harbor'
  ),
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug in ('shell-game', 'safe-harbor')
  and sec.summary ~ 'A35 Tennisplace|Sanibel Sunsets';

update public.properties p
set
  description = replace(
    replace(coalesce(p.description, ''), 'A35 Tennisplace', 'The Shell Game'),
    'Sanibel Sunsets',
    'Safe Harbor'
  ),
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('shell-game', 'safe-harbor')
  and coalesce(p.description, '') ~ 'A35 Tennisplace|Sanibel Sunsets';

-- Landing Pad: dogs allowed (1 dog).
update public.guidebook_sections sec
set
  summary = 'Dogs welcome (one dog). Please treat the house like your own.',
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug = 'landing-pad'
  and sec.section_type = 'house_rules';

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown',
    $md$Dogs welcome: one dog. Please keep pets off furniture and treat the house like your own.

A good fit for family reunions and group trips.$md$
  ),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug = 'landing-pad'
  and sec.section_type = 'house_rules'
  and b.block_type = 'rich_text'
  and b.sort_order < 1000;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('es', $tr$Perros bienvenidos (uno). Por favor trata la casa como si fuera tuya.$tr$),
    ('fr', $tr$Chiens bienvenus (un seul). Traitez la maison comme la vôtre.$tr$)
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug = 'landing-pad'
  and sec.section_type = 'house_rules'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

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
      $tr$Perros bienvenidos: un perro. Mantén a las mascotas fuera de los muebles y trata la casa como si fuera tuya.

Ideal para reuniones familiares y viajes en grupo.$tr$
    ),
    (
      'fr',
      $tr$Chiens bienvenus: un chien. Gardez les animaux hors des meubles et traitez la maison comme la vôtre.

Idéal pour les réunions de famille et les voyages en groupe.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug = 'landing-pad'
  and sec.section_type = 'house_rules'
  and b.block_type = 'rich_text'
  and b.sort_order < 1000
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

do $check$
declare
  shell_count integer;
  harbor_count integer;
  old_count integer;
begin
  select count(*) into shell_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad' and p.slug = 'shell-game' and p.name = 'The Shell Game';

  select count(*) into harbor_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad' and p.slug = 'safe-harbor' and p.name = 'Safe Harbor';

  select count(*) into old_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad' and p.slug in ('tennisplace-a35', 'sanibel-sunsets');

  if shell_count <> 1 or harbor_count <> 1 then
    raise exception 'Expected The Shell Game and Safe Harbor after rename.';
  end if;

  if old_count <> 0 then
    raise exception 'Old Sanibel slugs should be gone after rename.';
  end if;
end
$check$;

notify pgrst, 'reload schema';
