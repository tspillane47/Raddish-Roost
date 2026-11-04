-- Dad-scoped direct and Expedia booking links, plus Cider Loft house rules.
-- Paste after 20261104120000_dad_sanibel_guide.sql (or after dad VRBO links).
-- Safe to paste again. Does not touch roost properties.

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
        'landing-pad',
        'backyard-bungalow',
        'hinesburg-hideaway-3',
        'hinesburg-hideaway-4'
      )
  ) <> 6 then
    raise exception 'Dad Vermont properties are missing. Run the dad properties migration first.';
  end if;
end
$guard$;

-- Allow Expedia as a booking channel (and in booking click analytics).
alter table public.booking_links drop constraint if exists booking_links_channel;
alter table public.booking_links
  add constraint booking_links_channel check (
    channel in ('airbnb', 'vrbo', 'direct', 'expedia', 'other')
  );

alter table public.analytics_events drop constraint if exists analytics_events_platform;
alter table public.analytics_events
  add constraint analytics_events_platform check (
    platform is null or platform in ('direct', 'airbnb', 'vrbo', 'expedia')
  );

drop policy if exists analytics_events_public_insert on public.analytics_events;
create policy analytics_events_public_insert on public.analytics_events
  for insert to anon
  with check (
    event_name = 'booking_click'
    and platform in ('direct', 'airbnb', 'vrbo', 'expedia')
    and property_slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'
  );

-- Direct booking links (sort ahead of Airbnb / VRBO / Expedia).
update public.booking_links bl
set
  label = 'Book Direct',
  url = v.url,
  is_primary = true,
  sort_order = 5,
  updated_at = now()
from (
  values
    (
      'cider-loft',
      'https://vermontstays.hospitable.rentals/property/the-cider-loft'
    ),
    (
      'backyard-bungalow',
      'https://vermontstays.hospitable.rentals/property/backyard-bungalow-2br-near-btv-fenced-yard'
    ),
    (
      'hinesburg-hideaway-4',
      'https://vermontstays.hospitable.rentals/property/the-hideaway'
    ),
    (
      'hinesburg-hideaway-3',
      'https://vermontstays.hospitable.rentals/property/the-hinesburg-hideaway-unit-3'
    ),
    (
      'switchback-suite',
      'https://vermontstays.hospitable.rentals/property/switchback-suite-at-cady-hill-forest-trailhead'
    )
) as v(slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'dad'
where bl.property_id = p.id
  and bl.channel = 'direct';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'direct', 'Book Direct', v.url, true, 5
from (
  values
    (
      'd8000000-0000-4000-8000-000000000001'::uuid,
      'cider-loft',
      'https://vermontstays.hospitable.rentals/property/the-cider-loft'
    ),
    (
      'd8000000-0000-4000-8000-000000000002'::uuid,
      'backyard-bungalow',
      'https://vermontstays.hospitable.rentals/property/backyard-bungalow-2br-near-btv-fenced-yard'
    ),
    (
      'd8000000-0000-4000-8000-000000000003'::uuid,
      'hinesburg-hideaway-4',
      'https://vermontstays.hospitable.rentals/property/the-hideaway'
    ),
    (
      'd8000000-0000-4000-8000-000000000004'::uuid,
      'hinesburg-hideaway-3',
      'https://vermontstays.hospitable.rentals/property/the-hinesburg-hideaway-unit-3'
    ),
    (
      'd8000000-0000-4000-8000-000000000005'::uuid,
      'switchback-suite',
      'https://vermontstays.hospitable.rentals/property/switchback-suite-at-cady-hill-forest-trailhead'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'dad'
where not exists (
  select 1
  from public.booking_links existing
  where existing.property_id = p.id
    and existing.channel = 'direct'
)
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  url = excluded.url,
  is_primary = true,
  sort_order = 5,
  updated_at = now();

-- When a stay has a direct link, keep Airbnb as a secondary option.
update public.booking_links bl
set
  is_primary = false,
  sort_order = 10,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where bl.property_id = p.id
  and s.key = 'dad'
  and bl.channel = 'airbnb'
  and exists (
    select 1
    from public.booking_links direct_link
    where direct_link.property_id = p.id
      and direct_link.channel = 'direct'
  );

update public.booking_links bl
set
  sort_order = 20,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where bl.property_id = p.id
  and s.key = 'dad'
  and bl.channel = 'vrbo';

-- Expedia booking links.
update public.booking_links bl
set
  label = 'Book on Expedia',
  url = v.url,
  is_primary = false,
  sort_order = 30,
  updated_at = now()
from (
  values
    (
      'cider-loft',
      'https://www.expedia.com/Waterbury-Center-Hotels-The-Cider-Loft.h113672317.Hotel-Information'
    ),
    (
      'landing-pad',
      'https://www.expedia.com/South-Burlington-Hotels-The-Landing-Pad.h113672332.Hotel-Information'
    ),
    (
      'backyard-bungalow',
      'https://www.expedia.com/South-Burlington-Hotels-Backyard-Bungalow-2BR-Near-BTV-Fenced-Yard.h118004012.Hotel-Information'
    ),
    (
      'hinesburg-hideaway-3',
      'https://www.expedia.com/h131678123.Hotel-Information'
    ),
    (
      'hinesburg-hideaway-4',
      'https://www.expedia.com/h113672351.Hotel-Information'
    )
) as v(slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'dad'
where bl.property_id = p.id
  and bl.channel = 'expedia';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'expedia', 'Book on Expedia', v.url, false, 30
from (
  values
    (
      'd8100000-0000-4000-8000-000000000001'::uuid,
      'cider-loft',
      'https://www.expedia.com/Waterbury-Center-Hotels-The-Cider-Loft.h113672317.Hotel-Information'
    ),
    (
      'd8100000-0000-4000-8000-000000000002'::uuid,
      'landing-pad',
      'https://www.expedia.com/South-Burlington-Hotels-The-Landing-Pad.h113672332.Hotel-Information'
    ),
    (
      'd8100000-0000-4000-8000-000000000003'::uuid,
      'backyard-bungalow',
      'https://www.expedia.com/South-Burlington-Hotels-Backyard-Bungalow-2BR-Near-BTV-Fenced-Yard.h118004012.Hotel-Information'
    ),
    (
      'd8100000-0000-4000-8000-000000000004'::uuid,
      'hinesburg-hideaway-3',
      'https://www.expedia.com/h131678123.Hotel-Information'
    ),
    (
      'd8100000-0000-4000-8000-000000000005'::uuid,
      'hinesburg-hideaway-4',
      'https://www.expedia.com/h113672351.Hotel-Information'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'dad'
where not exists (
  select 1
  from public.booking_links existing
  where existing.property_id = p.id
    and existing.channel = 'expedia'
)
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  url = excluded.url,
  is_primary = false,
  sort_order = 30,
  updated_at = now();

-- Cider Loft house rules: dogs and marijuana policy.
update public.guidebook_sections sec
set
  summary = $sum$Dogs welcome (one dog, 30 pounds or less, house-trained). Marijuana is not permitted in the apartment.$sum$,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where sec.property_id = p.id
  and s.key = 'dad'
  and p.slug = 'cider-loft'
  and sec.section_type = 'house_rules';

update public.guidebook_blocks b
set
  body = jsonb_build_object(
    'type', 'rich_text',
    'markdown', $md$Dogs welcome: one dog of 30 pounds or less. The apartment has carpet, so dogs must be house-trained. An extra cleaning fee applies if we find a urine spot.

Marijuana is legal in Vermont but not permitted in the apartment. There is an automatic $250 fine if the apartment smells like marijuana.

Please take care on the steep stairs, and treat the loft like your own.$md$
  ),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
where b.section_id = sec.id
  and s.key = 'dad'
  and p.slug = 'cider-loft'
  and sec.section_type = 'house_rules'
  and b.block_type = 'rich_text';

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', sec.id, 'summary', lang.language, lang.text
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites s on s.id = p.site_id
join (
  values
    (
      'es',
      $tr$Perros bienvenidos (uno, de 30 libras o menos, y educado). No se permite marihuana en el apartamento.$tr$
    ),
    (
      'fr',
      $tr$Chiens bienvenus (un seul, 30 livres ou moins, et propre). La marijuana n'est pas autorisée dans l'appartement.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug = 'cider-loft'
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
      $tr$Perros bienvenidos: un perro de 30 libras o menos. El apartamento tiene moqueta, así que el perro debe estar educado. Se aplica una tarifa de limpieza extra si encontramos un rastro de orina.

La marihuana es legal en Vermont, pero no está permitida en el apartamento. Hay una multa automática de $250 si el apartamento huele a marihuana.

Por favor ten cuidado en las escaleras empinadas, y trata el loft como si fuera tuyo.$tr$
    ),
    (
      'fr',
      $tr$Chiens bienvenus: un chien de 30 livres ou moins. L'appartement a de la moquette, donc le chien doit être propre. Des frais de ménage supplémentaires s'appliquent si nous trouvons une trace d'urine.

La marijuana est légale au Vermont, mais elle n'est pas autorisée dans l'appartement. Il y a une amende automatique de $250 si l'appartement sent la marijuana.

Faites attention sur les escaliers raides, et traitez le loft comme le vôtre.$tr$
    )
) as lang(language, text) on true
where s.key = 'dad'
  and p.slug = 'cider-loft'
  and sec.section_type = 'house_rules'
  and b.block_type = 'rich_text'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

-- Sanity checks.
do $check$
declare
  direct_count integer;
  expedia_count integer;
begin
  select count(*) into direct_count
  from public.booking_links bl
  join public.properties p on p.id = bl.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and bl.channel = 'direct'
    and p.slug in (
      'cider-loft',
      'backyard-bungalow',
      'hinesburg-hideaway-3',
      'hinesburg-hideaway-4',
      'switchback-suite'
    );

  if direct_count <> 5 then
    raise exception 'Expected 5 dad direct booking links, found %.', direct_count;
  end if;

  select count(*) into expedia_count
  from public.booking_links bl
  join public.properties p on p.id = bl.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'dad'
    and bl.channel = 'expedia'
    and p.slug in (
      'cider-loft',
      'landing-pad',
      'backyard-bungalow',
      'hinesburg-hideaway-3',
      'hinesburg-hideaway-4'
    );

  if expedia_count <> 5 then
    raise exception 'Expected 5 dad Expedia booking links, found %.', expedia_count;
  end if;
end
$check$;

notify pgrst, 'reload schema';
