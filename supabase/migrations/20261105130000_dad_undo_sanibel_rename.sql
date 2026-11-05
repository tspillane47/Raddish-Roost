-- Dad: undo Sanibel condo rename (The Shell Game / Safe Harbor)
-- back to A35 Tennisplace / Sanibel Sunsets.
-- Does not touch Landing Pad pets, Book Direct, hero, or roost.
-- Dad-scoped only. Safe to paste again. No em dashes.

do $guard$
begin
  if not exists (select 1 from public.sites where key = 'dad') then
    raise exception 'Dad site is missing. Run the sites migration before this file.';
  end if;
end
$guard$;

-- Restore A35 Tennisplace (tennisplace-a35).
update public.properties p
set
  slug = 'tennisplace-a35',
  name = 'A35 Tennisplace',
  tagline = 'A waterfront condo steps from Dixie Beach',
  welcome_title = 'Welcome to A35 Tennisplace',
  welcome_message = $w$We're so glad you're here. A35 Tennisplace is a waterfront condo in the Tennisplace complex, with Dixie Beach just steps away. Make yourself at home.$w$,
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('shell-game', 'tennisplace-a35');

-- Restore Sanibel Sunsets (sanibel-sunsets).
update public.properties p
set
  slug = 'sanibel-sunsets',
  name = 'Sanibel Sunsets',
  tagline = 'A canal-side condo with stylish updates and island calm',
  welcome_title = 'Welcome to Sanibel Sunsets',
  welcome_message = $w$We're so glad you're here. Sanibel Sunsets is a recently updated canal-side condo in the Tennisplace complex, with Dixie Beach about a 5-minute walk away. Make yourself at home.$w$,
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('safe-harbor', 'sanibel-sunsets');

-- Restore ES/FR property copy that the rename migration overwrote.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, lang.field, lang.language, lang.text
from public.properties p
join public.sites s on s.id = p.site_id
join (
  values
    ('tennisplace-a35', 'tagline', 'es', $tr$Un condo frente al agua a pasos de Dixie Beach$tr$),
    ('tennisplace-a35', 'tagline', 'fr', $tr$Un condo au bord de l'eau à deux pas de Dixie Beach$tr$),
    ('tennisplace-a35', 'welcome_title', 'es', $tr$Bienvenida a A35 Tennisplace$tr$),
    ('tennisplace-a35', 'welcome_title', 'fr', $tr$Bienvenue à A35 Tennisplace$tr$),
    (
      'tennisplace-a35',
      'welcome_message',
      'es',
      $tr$Nos alegra que estés aquí. A35 Tennisplace es un condo frente al agua en el complejo Tennisplace, con Dixie Beach a unos pasos. Ponte cómodo.$tr$
    ),
    (
      'tennisplace-a35',
      'welcome_message',
      'fr',
      $tr$Nous sommes contents que vous soyez là. A35 Tennisplace est un condo au bord de l'eau dans le complexe Tennisplace, avec Dixie Beach à deux pas. Faites comme chez vous.$tr$
    ),
    ('sanibel-sunsets', 'tagline', 'es', $tr$Un condo junto al canal con detalles modernos y calma isleña$tr$),
    ('sanibel-sunsets', 'tagline', 'fr', $tr$Un condo au bord du canal, style rafraîchi et calme insulaire$tr$),
    ('sanibel-sunsets', 'welcome_title', 'es', $tr$Bienvenida a Sanibel Sunsets$tr$),
    ('sanibel-sunsets', 'welcome_title', 'fr', $tr$Bienvenue à Sanibel Sunsets$tr$),
    (
      'sanibel-sunsets',
      'welcome_message',
      'es',
      $tr$Nos alegra que estés aquí. Sanibel Sunsets es un condo junto al canal recién actualizado en el complejo Tennisplace, con Dixie Beach a unos 5 minutos a pie. Ponte cómodo.$tr$
    ),
    (
      'sanibel-sunsets',
      'welcome_message',
      'fr',
      $tr$Nous sommes contents que vous soyez là. Sanibel Sunsets est un condo récemment rafraîchi au bord du canal dans le complexe Tennisplace, avec Dixie Beach à environ 5 minutes à pied. Faites comme chez vous.$tr$
    )
) as lang(slug, field, language, text) on true
where s.key = 'dad'
  and p.slug = lang.slug
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Undo rename replacements in guidebook blocks, summaries, and descriptions.
update public.guidebook_blocks b
set
  body = jsonb_set(
    b.body,
    '{markdown}',
    to_jsonb(
      replace(
        replace(
          coalesce(b.body->>'markdown', ''),
          'The Shell Game',
          'A35 Tennisplace'
        ),
        'Safe Harbor',
        'Sanibel Sunsets'
      )
    )
  ),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and coalesce(b.body->>'markdown', '') ~ 'The Shell Game|Safe Harbor';

update public.guidebook_sections sec
set
  summary = replace(
    replace(sec.summary, 'The Shell Game', 'A35 Tennisplace'),
    'Safe Harbor',
    'Sanibel Sunsets'
  ),
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and sec.summary ~ 'The Shell Game|Safe Harbor';

update public.properties p
set
  description = replace(
    replace(coalesce(p.description, ''), 'The Shell Game', 'A35 Tennisplace'),
    'Safe Harbor',
    'Sanibel Sunsets'
  ),
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and coalesce(p.description, '') ~ 'The Shell Game|Safe Harbor';

-- Fix any hero image paths that still point at the renamed folders.
update public.properties p
set
  hero_image_path = replace(
    replace(coalesce(p.hero_image_path, ''), 'shell-game', 'tennisplace-a35'),
    'safe-harbor',
    'sanibel-sunsets'
  ),
  updated_at = now()
from public.sites s
where s.id = p.site_id
  and s.key = 'dad'
  and p.slug in ('tennisplace-a35', 'sanibel-sunsets')
  and coalesce(p.hero_image_path, '') ~ 'shell-game|safe-harbor';

do $check$
declare
  tennis_count integer;
  sunsets_count integer;
  new_count integer;
begin
  select count(*) into tennis_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad' and p.slug = 'tennisplace-a35' and p.name = 'A35 Tennisplace';

  select count(*) into sunsets_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad' and p.slug = 'sanibel-sunsets' and p.name = 'Sanibel Sunsets';

  select count(*) into new_count
  from public.properties p
  join public.sites s on s.id = p.site_id
  where s.key = 'dad' and p.slug in ('shell-game', 'safe-harbor');

  if tennis_count <> 1 or sunsets_count <> 1 or new_count <> 0 then
    raise exception 'Expected A35 Tennisplace and Sanibel Sunsets after undo rename.';
  end if;
end
$check$;
