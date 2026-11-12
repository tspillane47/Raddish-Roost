-- Errin / Queen City Stays: Hospitable direct booking + The House amenities.
-- Also keeps VRBO and Expedia links current. Scoped to sites.key = 'errin' only.
-- Safe to paste again. Wrapped in begin/commit. No em dashes.
-- Paste after 20261112130000_errin_vrbo_expedia_booking.sql.

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

alter table public.booking_links drop constraint if exists booking_links_channel;
alter table public.booking_links
  add constraint booking_links_channel check (
    channel in ('airbnb', 'vrbo', 'direct', 'expedia', 'other')
  );

-- Direct first (primary). Airbnb, VRBO, Expedia follow.
update public.booking_links bl
set
  label = 'Book Direct',
  url = v.url,
  is_primary = true,
  sort_order = 0,
  updated_at = now()
from (
  values
    (
      'winooski-flat',
      'https://enjoyvtliving.directbyhost.com/property/quiet-cozy-2bdrm-walk-anywhere-pet-friendly'
    ),
    (
      'mill-house',
      'https://enjoyvtliving.directbyhost.com/property/quiet-peaceful-2bdrm-walk-to-town-pet-friendly'
    ),
    (
      'maple-street-flat',
      'https://enjoyvtliving.directbyhost.com/property/cozy-maple-st-2-bedrm-apt-walk-anywhere-park-free'
    )
) as v(slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
where bl.property_id = p.id
  and bl.channel = 'direct';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'direct', 'Book Direct', v.url, true, 0
from (
  values
    (
      'e6000000-0000-4000-8000-000000000011'::uuid,
      'winooski-flat',
      'https://enjoyvtliving.directbyhost.com/property/quiet-cozy-2bdrm-walk-anywhere-pet-friendly'
    ),
    (
      'e6000000-0000-4000-8000-000000000012'::uuid,
      'mill-house',
      'https://enjoyvtliving.directbyhost.com/property/quiet-peaceful-2bdrm-walk-to-town-pet-friendly'
    ),
    (
      'e6000000-0000-4000-8000-000000000013'::uuid,
      'maple-street-flat',
      'https://enjoyvtliving.directbyhost.com/property/cozy-maple-st-2-bedrm-apt-walk-anywhere-park-free'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
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
  sort_order = excluded.sort_order,
  updated_at = now();

update public.booking_links bl
set
  is_primary = false,
  sort_order = 10,
  updated_at = now()
from public.properties p
join public.sites s on s.id = p.site_id
where bl.property_id = p.id
  and s.key = 'errin'
  and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
  and bl.channel = 'airbnb';

update public.booking_links bl
set
  label = 'Book on VRBO',
  url = v.url,
  is_primary = false,
  sort_order = 20,
  updated_at = now()
from (
  values
    ('winooski-flat', 'https://www.vrbo.com/3213347407ha'),
    ('mill-house', 'https://www.vrbo.com/3161258'),
    ('maple-street-flat', 'https://www.vrbo.com/1824841')
) as v(slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
where bl.property_id = p.id
  and bl.channel = 'vrbo';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'vrbo', 'Book on VRBO', v.url, false, 20
from (
  values
    ('e6100000-0000-4000-8000-000000000001'::uuid, 'winooski-flat', 'https://www.vrbo.com/3213347407ha'),
    ('e6100000-0000-4000-8000-000000000002'::uuid, 'mill-house', 'https://www.vrbo.com/3161258'),
    ('e6100000-0000-4000-8000-000000000003'::uuid, 'maple-street-flat', 'https://www.vrbo.com/1824841')
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
where not exists (
  select 1
  from public.booking_links existing
  where existing.property_id = p.id
    and existing.channel = 'vrbo'
)
on conflict (id) do update
set
  property_id = excluded.property_id,
  channel = excluded.channel,
  label = excluded.label,
  url = excluded.url,
  is_primary = false,
  sort_order = excluded.sort_order,
  updated_at = now();

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
      'winooski-flat',
      'https://www.expedia.com/Winooski-Hotels-Cozy-2bdrm-Apt-Walk-Downtown-Bring-Your-Pets.h92786475.Hotel-Information'
    ),
    (
      'mill-house',
      'https://www.expedia.com/Winooski-Hotels-Large-Cozy-And-Peaceful-Apartment-Walk-Anywhere.h89988135.Hotel-Information'
    ),
    (
      'maple-street-flat',
      'https://www.expedia.com/Burlington-Hotels-Cozy-2-Bedroom-Clean-And-Quiet-Maple-St-Walk-Anywhere.h44268702.Hotel-Information'
    )
) as v(slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
where bl.property_id = p.id
  and bl.channel = 'expedia';

insert into public.booking_links (id, property_id, channel, label, url, is_primary, sort_order)
select v.id, p.id, 'expedia', 'Book on Expedia', v.url, false, 30
from (
  values
    (
      'e6200000-0000-4000-8000-000000000001'::uuid,
      'winooski-flat',
      'https://www.expedia.com/Winooski-Hotels-Cozy-2bdrm-Apt-Walk-Downtown-Bring-Your-Pets.h92786475.Hotel-Information'
    ),
    (
      'e6200000-0000-4000-8000-000000000002'::uuid,
      'mill-house',
      'https://www.expedia.com/Winooski-Hotels-Large-Cozy-And-Peaceful-Apartment-Walk-Anywhere.h89988135.Hotel-Information'
    ),
    (
      'e6200000-0000-4000-8000-000000000003'::uuid,
      'maple-street-flat',
      'https://www.expedia.com/Burlington-Hotels-Cozy-2-Bedroom-Clean-And-Quiet-Maple-St-Walk-Anywhere.h44268702.Hotel-Information'
    )
) as v(id, slug, url)
join public.properties p on p.slug = v.slug
join public.sites s on s.id = p.site_id and s.key = 'errin'
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
  sort_order = excluded.sort_order,
  updated_at = now();

-- The House section summaries.
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
      'winooski-flat',
      'Wi-Fi, full kitchen, in-unit laundry, private patio, travel crib, and more. Window AC May through September. Pets welcome.'
    ),
    (
      'mill-house',
      'Wi-Fi, full kitchen, in-unit laundry, two large decks, dedicated workspace, travel crib, and more. Window AC May through September. Pets welcome. Keypad entry.'
    ),
    (
      'maple-street-flat',
      'Wi-Fi, full kitchen, private porch and entry, assigned parking, travel crib, and more. Coin laundry in the building. Window AC May through September.'
    )
) as v(slug, summary) on true
where s.property_id = p.id
  and site.key = 'errin'
  and p.slug = v.slug
  and s.section_type = 'house_guide';

-- Keep a short overview in How things work; What's here uses amenities below.
update public.guidebook_blocks b
set
  title = v.title,
  body = jsonb_build_object('type', 'rich_text', 'markdown', v.markdown),
  published_at = coalesce(b.published_at, now()),
  updated_at = now()
from public.guidebook_sections sec
join public.properties p on p.id = sec.property_id
join public.sites site on site.id = p.site_id
join (
  values
    (
      'e4000000-0000-4000-8000-000000000104'::uuid,
      'The flat',
      $copy$The Winooski Flat is an entire 2-bedroom apartment with 1 bath, and sleeps 4.

Open What's here for the full list of amenities. Window AC is available May through September. Pets are welcome.$copy$
    ),
    (
      'e4000000-0000-4000-8000-000000000204'::uuid,
      'The flat',
      $copy$The Mill House is a first-floor duplex flat with 2 bedrooms (king and queen), 1 bath, and sleeps 4.

Keypad entry; the code is sent the morning of check-in. Open What's here for the full list of amenities. Pets are welcome.$copy$
    ),
    (
      'e4000000-0000-4000-8000-000000000304'::uuid,
      'The flat',
      $copy$The Maple Street Flat is a ground-floor apartment in a historic building with 2 bedrooms (queen and double), 1 bath, and sleeps 4.

Open What's here for the full list of amenities. Window AC is available May through September.$copy$
    )
) as v(block_id, title, markdown) on true
where b.id = v.block_id
  and b.section_id = sec.id
  and site.key = 'errin'
  and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
  and sec.section_type = 'house_guide';

-- Amenities for What's here.
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
join public.sites s on s.id = p.site_id
join (
  values
    -- Winooski Flat
    ('e6300000-0000-4000-8000-000000000101'::uuid, 'winooski-flat', 10, 'Wi-Fi', null),
    ('e6300000-0000-4000-8000-000000000102'::uuid, 'winooski-flat', 20, 'TV', null),
    ('e6300000-0000-4000-8000-000000000103'::uuid, 'winooski-flat', 30, 'Central heat', null),
    ('e6300000-0000-4000-8000-000000000104'::uuid, 'winooski-flat', 40, 'Window AC', 'Available May through September.'),
    ('e6300000-0000-4000-8000-000000000105'::uuid, 'winooski-flat', 50, 'Full kitchen', 'Coffee maker, microwave, oven, stove, and fridge.'),
    ('e6300000-0000-4000-8000-000000000106'::uuid, 'winooski-flat', 60, 'Kettle and toaster', null),
    ('e6300000-0000-4000-8000-000000000107'::uuid, 'winooski-flat', 70, 'Wine glasses', null),
    ('e6300000-0000-4000-8000-000000000108'::uuid, 'winooski-flat', 80, 'Towels and linens', 'Extra pillows and blankets included.'),
    ('e6300000-0000-4000-8000-000000000109'::uuid, 'winooski-flat', 90, 'Hair dryer and iron', null),
    ('e6300000-0000-4000-8000-000000000110'::uuid, 'winooski-flat', 100, 'Bathroom basics', 'Shampoo, conditioner, and body soap.'),
    ('e6300000-0000-4000-8000-000000000111'::uuid, 'winooski-flat', 110, 'Bathtub', null),
    ('e6300000-0000-4000-8000-000000000112'::uuid, 'winooski-flat', 120, 'In-unit washer and dryer', 'Free to use.'),
    ('e6300000-0000-4000-8000-000000000113'::uuid, 'winooski-flat', 130, 'Travel crib', null),
    ('e6300000-0000-4000-8000-000000000114'::uuid, 'winooski-flat', 140, 'High chair', null),
    ('e6300000-0000-4000-8000-000000000115'::uuid, 'winooski-flat', 150, 'Room-darkening shades', null),
    ('e6300000-0000-4000-8000-000000000116'::uuid, 'winooski-flat', 160, 'Private patio', 'Outdoor seating.'),
    ('e6300000-0000-4000-8000-000000000117'::uuid, 'winooski-flat', 170, 'Portable fans', null),
    ('e6300000-0000-4000-8000-000000000118'::uuid, 'winooski-flat', 180, 'Free parking', null),
    ('e6300000-0000-4000-8000-000000000119'::uuid, 'winooski-flat', 190, 'Safety', 'Smoke and carbon monoxide detectors, fire extinguisher, and first aid kit.'),
    ('e6300000-0000-4000-8000-000000000120'::uuid, 'winooski-flat', 200, 'Pets welcome', null),
    -- Mill House
    ('e6300000-0000-4000-8000-000000000201'::uuid, 'mill-house', 10, 'Wi-Fi', null),
    ('e6300000-0000-4000-8000-000000000202'::uuid, 'mill-house', 20, 'TV', null),
    ('e6300000-0000-4000-8000-000000000203'::uuid, 'mill-house', 30, 'Central heat', null),
    ('e6300000-0000-4000-8000-000000000204'::uuid, 'mill-house', 40, 'Window AC', 'Available May through September.'),
    ('e6300000-0000-4000-8000-000000000205'::uuid, 'mill-house', 50, 'Full kitchen', 'Coffee maker, microwave, oven, stove, and fridge.'),
    ('e6300000-0000-4000-8000-000000000206'::uuid, 'mill-house', 60, 'Kettle and toaster', null),
    ('e6300000-0000-4000-8000-000000000207'::uuid, 'mill-house', 70, 'Wine glasses', null),
    ('e6300000-0000-4000-8000-000000000208'::uuid, 'mill-house', 80, 'Towels and linens', 'Extra pillows and blankets included.'),
    ('e6300000-0000-4000-8000-000000000209'::uuid, 'mill-house', 90, 'Hair dryer and iron', null),
    ('e6300000-0000-4000-8000-000000000210'::uuid, 'mill-house', 100, 'Bathroom basics', 'Shampoo, conditioner, and body soap.'),
    ('e6300000-0000-4000-8000-000000000211'::uuid, 'mill-house', 110, 'Bathtub', null),
    ('e6300000-0000-4000-8000-000000000212'::uuid, 'mill-house', 120, 'In-unit washer and dryer', null),
    ('e6300000-0000-4000-8000-000000000213'::uuid, 'mill-house', 130, 'Travel crib', null),
    ('e6300000-0000-4000-8000-000000000214'::uuid, 'mill-house', 140, 'High chair', null),
    ('e6300000-0000-4000-8000-000000000215'::uuid, 'mill-house', 150, 'Dedicated workspace', null),
    ('e6300000-0000-4000-8000-000000000216'::uuid, 'mill-house', 160, 'Two large decks', null),
    ('e6300000-0000-4000-8000-000000000217'::uuid, 'mill-house', 170, 'Private entrance', null),
    ('e6300000-0000-4000-8000-000000000218'::uuid, 'mill-house', 180, 'Portable fans', null),
    ('e6300000-0000-4000-8000-000000000219'::uuid, 'mill-house', 190, 'Free parking', null),
    ('e6300000-0000-4000-8000-000000000220'::uuid, 'mill-house', 200, 'Safety', 'Smoke and carbon monoxide detectors, fire extinguisher, and first aid kit.'),
    ('e6300000-0000-4000-8000-000000000221'::uuid, 'mill-house', 210, 'Pets welcome', null),
    ('e6300000-0000-4000-8000-000000000222'::uuid, 'mill-house', 220, 'Keypad entry', 'The code is sent the morning of check-in.'),
    -- Maple Street Flat
    ('e6300000-0000-4000-8000-000000000301'::uuid, 'maple-street-flat', 10, 'Wi-Fi', 'High-speed internet.'),
    ('e6300000-0000-4000-8000-000000000302'::uuid, 'maple-street-flat', 20, 'TV', null),
    ('e6300000-0000-4000-8000-000000000303'::uuid, 'maple-street-flat', 30, 'Central heat', null),
    ('e6300000-0000-4000-8000-000000000304'::uuid, 'maple-street-flat', 40, 'Window AC', 'Available May through September.'),
    ('e6300000-0000-4000-8000-000000000305'::uuid, 'maple-street-flat', 50, 'Full kitchen', 'Coffee maker, microwave, oven, stove, and fridge.'),
    ('e6300000-0000-4000-8000-000000000306'::uuid, 'maple-street-flat', 60, 'Towels and linens', 'Extra pillows and blankets included.'),
    ('e6300000-0000-4000-8000-000000000307'::uuid, 'maple-street-flat', 70, 'Hair dryer and iron', null),
    ('e6300000-0000-4000-8000-000000000308'::uuid, 'maple-street-flat', 80, 'Bathroom basics', 'Shampoo, conditioner, and body soap.'),
    ('e6300000-0000-4000-8000-000000000309'::uuid, 'maple-street-flat', 90, 'Travel crib', null),
    ('e6300000-0000-4000-8000-000000000310'::uuid, 'maple-street-flat', 100, 'Private entrance and front porch', null),
    ('e6300000-0000-4000-8000-000000000311'::uuid, 'maple-street-flat', 110, 'Parking', 'One assigned off-street parking spot, plus free street parking.'),
    ('e6300000-0000-4000-8000-000000000312'::uuid, 'maple-street-flat', 120, 'Coin-operated washer and dryer', 'In the building.'),
    ('e6300000-0000-4000-8000-000000000313'::uuid, 'maple-street-flat', 130, 'Safety', 'Smoke and carbon monoxide detectors, fire extinguisher, and first aid kit.')
) as v(id, slug, sort_order, name, description) on true
where s.key = 'errin'
  and p.slug = v.slug
on conflict (id) do update
set
  property_id = excluded.property_id,
  sort_order = excluded.sort_order,
  is_visible = true,
  name = excluded.name,
  description = excluded.description,
  published_at = coalesce(public.amenities.published_at, now()),
  updated_at = now();

-- Spanish and French: section summaries, overview blocks, amenities.
insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', gs.id, 'summary', lang.language, lang.text
from public.guidebook_sections gs
join public.properties p on p.id = gs.property_id
join public.sites s on s.id = p.site_id
join (
  values
    ('winooski-flat', 'es', $tr$Wi-Fi, cocina completa, lavandería en la unidad, patio privado, cuna de viaje y más. Aire de ventana de mayo a septiembre. Se admiten mascotas.$tr$),
    ('winooski-flat', 'fr', $tr$Wi-Fi, cuisine complète, buanderie dans l'unité, patio privé, lit de voyage et plus. Clim de fenêtre de mai à septembre. Animaux bienvenus.$tr$),
    ('mill-house', 'es', $tr$Wi-Fi, cocina completa, lavandería en la unidad, dos terrazas grandes, espacio de trabajo, cuna de viaje y más. Aire de ventana de mayo a septiembre. Se admiten mascotas. Entrada con teclado.$tr$),
    ('mill-house', 'fr', $tr$Wi-Fi, cuisine complète, buanderie dans l'unité, deux grandes terrasses, espace de travail, lit de voyage et plus. Clim de fenêtre de mai à septembre. Animaux bienvenus. Entrée à clavier.$tr$),
    ('maple-street-flat', 'es', $tr$Wi-Fi, cocina completa, porche y entrada privados, aparcamiento asignado, cuna de viaje y más. Lavandería de monedas en el edificio. Aire de ventana de mayo a septiembre.$tr$),
    ('maple-street-flat', 'fr', $tr$Wi-Fi, cuisine complète, porche et entrée privés, stationnement assigné, lit de voyage et plus. Buanderie à monnaies dans l'immeuble. Clim de fenêtre de mai à septembre.$tr$)
) as lang(slug, language, text) on lang.slug = p.slug
where s.key = 'errin'
  and gs.section_type = 'house_guide'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', v.block_id, lang.field, lang.language, lang.text
from (
  values
    ('e4000000-0000-4000-8000-000000000104'::uuid, 'title', 'es', $tr$El piso$tr$),
    ('e4000000-0000-4000-8000-000000000104'::uuid, 'title', 'fr', $tr$L'appartement$tr$),
    ('e4000000-0000-4000-8000-000000000104'::uuid, 'markdown', 'es', $tr$El piso de Winooski es un apartamento entero de 2 dormitorios con 1 baño, para 4 personas.

Abre Qué hay aquí para la lista completa de comodidades. Hay aire acondicionado de ventana de mayo a septiembre. Se admiten mascotas.$tr$),
    ('e4000000-0000-4000-8000-000000000104'::uuid, 'markdown', 'fr', $tr$L'appartement de Winooski est un logement entier de 2 chambres avec 1 salle de bain, pour 4 personnes.

Ouvrez Ce qu'il y a ici pour la liste complète des équipements. La clim de fenêtre est disponible de mai à septembre. Animaux bienvenus.$tr$),
    ('e4000000-0000-4000-8000-000000000204'::uuid, 'title', 'es', $tr$El piso$tr$),
    ('e4000000-0000-4000-8000-000000000204'::uuid, 'title', 'fr', $tr$L'appartement$tr$),
    ('e4000000-0000-4000-8000-000000000204'::uuid, 'markdown', 'es', $tr$La Casa del Molino es un piso en dúplex de planta baja con 2 dormitorios (king y queen), 1 baño, para 4 personas.

Entrada con teclado; el código se envía la mañana del check-in. Abre Qué hay aquí para la lista completa de comodidades. Se admiten mascotas.$tr$),
    ('e4000000-0000-4000-8000-000000000204'::uuid, 'markdown', 'fr', $tr$La Maison du Moulin est un appartement au rez-de-chaussée d'un duplex avec 2 chambres (king et queen), 1 salle de bain, pour 4 personnes.

Entrée à clavier; le code est envoyé le matin de l'arrivée. Ouvrez Ce qu'il y a ici pour la liste complète des équipements. Animaux bienvenus.$tr$),
    ('e4000000-0000-4000-8000-000000000304'::uuid, 'title', 'es', $tr$El piso$tr$),
    ('e4000000-0000-4000-8000-000000000304'::uuid, 'title', 'fr', $tr$L'appartement$tr$),
    ('e4000000-0000-4000-8000-000000000304'::uuid, 'markdown', 'es', $tr$El piso de Maple Street es un apartamento de planta baja en un edificio histórico con 2 dormitorios (queen y doble), 1 baño, para 4 personas.

Abre Qué hay aquí para la lista completa de comodidades. Hay aire acondicionado de ventana de mayo a septiembre.$tr$),
    ('e4000000-0000-4000-8000-000000000304'::uuid, 'markdown', 'fr', $tr$L'appartement de Maple Street est un logement au rez-de-chaussée dans un immeuble historique avec 2 chambres (queen et double), 1 salle de bain, pour 4 personnes.

Ouvrez Ce qu'il y a ici pour la liste complète des équipements. La clim de fenêtre est disponible de mai à septembre.$tr$)
) as lang(block_id, field, language, text)
join (
  values
    ('e4000000-0000-4000-8000-000000000104'::uuid),
    ('e4000000-0000-4000-8000-000000000204'::uuid),
    ('e4000000-0000-4000-8000-000000000304'::uuid)
) as v(block_id) on v.block_id = lang.block_id
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, lang.field, lang.language, lang.text
from public.amenities a
join (
  values
    -- Shared-style names repeated per property id
    ('e6300000-0000-4000-8000-000000000101'::uuid, 'name', 'es', 'Wi-Fi'),
    ('e6300000-0000-4000-8000-000000000101'::uuid, 'name', 'fr', 'Wi-Fi'),
    ('e6300000-0000-4000-8000-000000000102'::uuid, 'name', 'es', 'TV'),
    ('e6300000-0000-4000-8000-000000000102'::uuid, 'name', 'fr', 'TV'),
    ('e6300000-0000-4000-8000-000000000103'::uuid, 'name', 'es', 'Calefacción central'),
    ('e6300000-0000-4000-8000-000000000103'::uuid, 'name', 'fr', 'Chauffage central'),
    ('e6300000-0000-4000-8000-000000000104'::uuid, 'name', 'es', 'Aire de ventana'),
    ('e6300000-0000-4000-8000-000000000104'::uuid, 'name', 'fr', 'Clim de fenêtre'),
    ('e6300000-0000-4000-8000-000000000104'::uuid, 'description', 'es', 'Disponible de mayo a septiembre.'),
    ('e6300000-0000-4000-8000-000000000104'::uuid, 'description', 'fr', 'Disponible de mai à septembre.'),
    ('e6300000-0000-4000-8000-000000000105'::uuid, 'name', 'es', 'Cocina completa'),
    ('e6300000-0000-4000-8000-000000000105'::uuid, 'name', 'fr', 'Cuisine complète'),
    ('e6300000-0000-4000-8000-000000000105'::uuid, 'description', 'es', 'Cafetera, microondas, horno, cocina y nevera.'),
    ('e6300000-0000-4000-8000-000000000105'::uuid, 'description', 'fr', 'Cafetière, micro-ondes, four, cuisinière et frigo.'),
    ('e6300000-0000-4000-8000-000000000106'::uuid, 'name', 'es', 'Hervidor y tostadora'),
    ('e6300000-0000-4000-8000-000000000106'::uuid, 'name', 'fr', 'Bouilloire et grille-pain'),
    ('e6300000-0000-4000-8000-000000000107'::uuid, 'name', 'es', 'Copas de vino'),
    ('e6300000-0000-4000-8000-000000000107'::uuid, 'name', 'fr', 'Verres à vin'),
    ('e6300000-0000-4000-8000-000000000108'::uuid, 'name', 'es', 'Toallas y ropa de cama'),
    ('e6300000-0000-4000-8000-000000000108'::uuid, 'name', 'fr', 'Serviettes et draps'),
    ('e6300000-0000-4000-8000-000000000108'::uuid, 'description', 'es', 'Incluye almohadas y mantas extra.'),
    ('e6300000-0000-4000-8000-000000000108'::uuid, 'description', 'fr', 'Oreillers et couvertures supplémentaires inclus.'),
    ('e6300000-0000-4000-8000-000000000109'::uuid, 'name', 'es', 'Secador y plancha'),
    ('e6300000-0000-4000-8000-000000000109'::uuid, 'name', 'fr', 'Sèche-cheveux et fer'),
    ('e6300000-0000-4000-8000-000000000110'::uuid, 'name', 'es', 'Básicos de baño'),
    ('e6300000-0000-4000-8000-000000000110'::uuid, 'name', 'fr', 'Essentiels de salle de bain'),
    ('e6300000-0000-4000-8000-000000000110'::uuid, 'description', 'es', 'Champú, acondicionador y jabón corporal.'),
    ('e6300000-0000-4000-8000-000000000110'::uuid, 'description', 'fr', 'Shampooing, revitalisant et savon pour le corps.'),
    ('e6300000-0000-4000-8000-000000000111'::uuid, 'name', 'es', 'Bañera'),
    ('e6300000-0000-4000-8000-000000000111'::uuid, 'name', 'fr', 'Baignoire'),
    ('e6300000-0000-4000-8000-000000000112'::uuid, 'name', 'es', 'Lavadora y secadora en la unidad'),
    ('e6300000-0000-4000-8000-000000000112'::uuid, 'name', 'fr', 'Laveuse et sécheuse dans l''unité'),
    ('e6300000-0000-4000-8000-000000000112'::uuid, 'description', 'es', 'Gratis.'),
    ('e6300000-0000-4000-8000-000000000112'::uuid, 'description', 'fr', 'Gratuit.'),
    ('e6300000-0000-4000-8000-000000000113'::uuid, 'name', 'es', 'Cuna de viaje'),
    ('e6300000-0000-4000-8000-000000000113'::uuid, 'name', 'fr', 'Lit de voyage'),
    ('e6300000-0000-4000-8000-000000000114'::uuid, 'name', 'es', 'Trona'),
    ('e6300000-0000-4000-8000-000000000114'::uuid, 'name', 'fr', 'Chaise haute'),
    ('e6300000-0000-4000-8000-000000000115'::uuid, 'name', 'es', 'Estores oscurecedores'),
    ('e6300000-0000-4000-8000-000000000115'::uuid, 'name', 'fr', 'Stores occultants'),
    ('e6300000-0000-4000-8000-000000000116'::uuid, 'name', 'es', 'Patio privado'),
    ('e6300000-0000-4000-8000-000000000116'::uuid, 'name', 'fr', 'Patio privé'),
    ('e6300000-0000-4000-8000-000000000116'::uuid, 'description', 'es', 'Asientos al aire libre.'),
    ('e6300000-0000-4000-8000-000000000116'::uuid, 'description', 'fr', $tr$Sièges à l'extérieur.$tr$),
    ('e6300000-0000-4000-8000-000000000117'::uuid, 'name', 'es', 'Ventiladores portátiles'),
    ('e6300000-0000-4000-8000-000000000117'::uuid, 'name', 'fr', 'Ventilateurs portatifs'),
    ('e6300000-0000-4000-8000-000000000118'::uuid, 'name', 'es', 'Aparcamiento gratis'),
    ('e6300000-0000-4000-8000-000000000118'::uuid, 'name', 'fr', 'Stationnement gratuit'),
    ('e6300000-0000-4000-8000-000000000119'::uuid, 'name', 'es', 'Seguridad'),
    ('e6300000-0000-4000-8000-000000000119'::uuid, 'name', 'fr', 'Sécurité'),
    ('e6300000-0000-4000-8000-000000000119'::uuid, 'description', 'es', 'Detectores de humo y monóxido de carbono, extintor y botiquín.'),
    ('e6300000-0000-4000-8000-000000000119'::uuid, 'description', 'fr', 'Détecteurs de fumée et de monoxyde de carbone, extincteur et trousse de premiers soins.'),
    ('e6300000-0000-4000-8000-000000000120'::uuid, 'name', 'es', 'Se admiten mascotas'),
    ('e6300000-0000-4000-8000-000000000120'::uuid, 'name', 'fr', 'Animaux bienvenus'),
    -- Mill House translations (same wording where shared)
    ('e6300000-0000-4000-8000-000000000201'::uuid, 'name', 'es', 'Wi-Fi'),
    ('e6300000-0000-4000-8000-000000000201'::uuid, 'name', 'fr', 'Wi-Fi'),
    ('e6300000-0000-4000-8000-000000000202'::uuid, 'name', 'es', 'TV'),
    ('e6300000-0000-4000-8000-000000000202'::uuid, 'name', 'fr', 'TV'),
    ('e6300000-0000-4000-8000-000000000203'::uuid, 'name', 'es', 'Calefacción central'),
    ('e6300000-0000-4000-8000-000000000203'::uuid, 'name', 'fr', 'Chauffage central'),
    ('e6300000-0000-4000-8000-000000000204'::uuid, 'name', 'es', 'Aire de ventana'),
    ('e6300000-0000-4000-8000-000000000204'::uuid, 'name', 'fr', 'Clim de fenêtre'),
    ('e6300000-0000-4000-8000-000000000204'::uuid, 'description', 'es', 'Disponible de mayo a septiembre.'),
    ('e6300000-0000-4000-8000-000000000204'::uuid, 'description', 'fr', 'Disponible de mai à septembre.'),
    ('e6300000-0000-4000-8000-000000000205'::uuid, 'name', 'es', 'Cocina completa'),
    ('e6300000-0000-4000-8000-000000000205'::uuid, 'name', 'fr', 'Cuisine complète'),
    ('e6300000-0000-4000-8000-000000000205'::uuid, 'description', 'es', 'Cafetera, microondas, horno, cocina y nevera.'),
    ('e6300000-0000-4000-8000-000000000205'::uuid, 'description', 'fr', 'Cafetière, micro-ondes, four, cuisinière et frigo.'),
    ('e6300000-0000-4000-8000-000000000206'::uuid, 'name', 'es', 'Hervidor y tostadora'),
    ('e6300000-0000-4000-8000-000000000206'::uuid, 'name', 'fr', 'Bouilloire et grille-pain'),
    ('e6300000-0000-4000-8000-000000000207'::uuid, 'name', 'es', 'Copas de vino'),
    ('e6300000-0000-4000-8000-000000000207'::uuid, 'name', 'fr', 'Verres à vin'),
    ('e6300000-0000-4000-8000-000000000208'::uuid, 'name', 'es', 'Toallas y ropa de cama'),
    ('e6300000-0000-4000-8000-000000000208'::uuid, 'name', 'fr', 'Serviettes et draps'),
    ('e6300000-0000-4000-8000-000000000208'::uuid, 'description', 'es', 'Incluye almohadas y mantas extra.'),
    ('e6300000-0000-4000-8000-000000000208'::uuid, 'description', 'fr', 'Oreillers et couvertures supplémentaires inclus.'),
    ('e6300000-0000-4000-8000-000000000209'::uuid, 'name', 'es', 'Secador y plancha'),
    ('e6300000-0000-4000-8000-000000000209'::uuid, 'name', 'fr', 'Sèche-cheveux et fer'),
    ('e6300000-0000-4000-8000-000000000210'::uuid, 'name', 'es', 'Básicos de baño'),
    ('e6300000-0000-4000-8000-000000000210'::uuid, 'name', 'fr', 'Essentiels de salle de bain'),
    ('e6300000-0000-4000-8000-000000000210'::uuid, 'description', 'es', 'Champú, acondicionador y jabón corporal.'),
    ('e6300000-0000-4000-8000-000000000210'::uuid, 'description', 'fr', 'Shampooing, revitalisant et savon pour le corps.'),
    ('e6300000-0000-4000-8000-000000000211'::uuid, 'name', 'es', 'Bañera'),
    ('e6300000-0000-4000-8000-000000000211'::uuid, 'name', 'fr', 'Baignoire'),
    ('e6300000-0000-4000-8000-000000000212'::uuid, 'name', 'es', 'Lavadora y secadora en la unidad'),
    ('e6300000-0000-4000-8000-000000000212'::uuid, 'name', 'fr', 'Laveuse et sécheuse dans l''unité'),
    ('e6300000-0000-4000-8000-000000000213'::uuid, 'name', 'es', 'Cuna de viaje'),
    ('e6300000-0000-4000-8000-000000000213'::uuid, 'name', 'fr', 'Lit de voyage'),
    ('e6300000-0000-4000-8000-000000000214'::uuid, 'name', 'es', 'Trona'),
    ('e6300000-0000-4000-8000-000000000214'::uuid, 'name', 'fr', 'Chaise haute'),
    ('e6300000-0000-4000-8000-000000000215'::uuid, 'name', 'es', 'Espacio de trabajo'),
    ('e6300000-0000-4000-8000-000000000215'::uuid, 'name', 'fr', 'Espace de travail'),
    ('e6300000-0000-4000-8000-000000000216'::uuid, 'name', 'es', 'Dos terrazas grandes'),
    ('e6300000-0000-4000-8000-000000000216'::uuid, 'name', 'fr', 'Deux grandes terrasses'),
    ('e6300000-0000-4000-8000-000000000217'::uuid, 'name', 'es', 'Entrada privada'),
    ('e6300000-0000-4000-8000-000000000217'::uuid, 'name', 'fr', 'Entrée privée'),
    ('e6300000-0000-4000-8000-000000000218'::uuid, 'name', 'es', 'Ventiladores portátiles'),
    ('e6300000-0000-4000-8000-000000000218'::uuid, 'name', 'fr', 'Ventilateurs portatifs'),
    ('e6300000-0000-4000-8000-000000000219'::uuid, 'name', 'es', 'Aparcamiento gratis'),
    ('e6300000-0000-4000-8000-000000000219'::uuid, 'name', 'fr', 'Stationnement gratuit'),
    ('e6300000-0000-4000-8000-000000000220'::uuid, 'name', 'es', 'Seguridad'),
    ('e6300000-0000-4000-8000-000000000220'::uuid, 'name', 'fr', 'Sécurité'),
    ('e6300000-0000-4000-8000-000000000220'::uuid, 'description', 'es', 'Detectores de humo y monóxido de carbono, extintor y botiquín.'),
    ('e6300000-0000-4000-8000-000000000220'::uuid, 'description', 'fr', 'Détecteurs de fumée et de monoxyde de carbone, extincteur et trousse de premiers soins.'),
    ('e6300000-0000-4000-8000-000000000221'::uuid, 'name', 'es', 'Se admiten mascotas'),
    ('e6300000-0000-4000-8000-000000000221'::uuid, 'name', 'fr', 'Animaux bienvenus'),
    ('e6300000-0000-4000-8000-000000000222'::uuid, 'name', 'es', 'Entrada con teclado'),
    ('e6300000-0000-4000-8000-000000000222'::uuid, 'name', 'fr', 'Entrée à clavier'),
    ('e6300000-0000-4000-8000-000000000222'::uuid, 'description', 'es', 'El código se envía la mañana del check-in.'),
    ('e6300000-0000-4000-8000-000000000222'::uuid, 'description', 'fr', 'Le code est envoyé le matin de l''arrivée.'),
    -- Maple Street Flat
    ('e6300000-0000-4000-8000-000000000301'::uuid, 'name', 'es', 'Wi-Fi'),
    ('e6300000-0000-4000-8000-000000000301'::uuid, 'name', 'fr', 'Wi-Fi'),
    ('e6300000-0000-4000-8000-000000000301'::uuid, 'description', 'es', 'Internet de alta velocidad.'),
    ('e6300000-0000-4000-8000-000000000301'::uuid, 'description', 'fr', 'Internet haute vitesse.'),
    ('e6300000-0000-4000-8000-000000000302'::uuid, 'name', 'es', 'TV'),
    ('e6300000-0000-4000-8000-000000000302'::uuid, 'name', 'fr', 'TV'),
    ('e6300000-0000-4000-8000-000000000303'::uuid, 'name', 'es', 'Calefacción central'),
    ('e6300000-0000-4000-8000-000000000303'::uuid, 'name', 'fr', 'Chauffage central'),
    ('e6300000-0000-4000-8000-000000000304'::uuid, 'name', 'es', 'Aire de ventana'),
    ('e6300000-0000-4000-8000-000000000304'::uuid, 'name', 'fr', 'Clim de fenêtre'),
    ('e6300000-0000-4000-8000-000000000304'::uuid, 'description', 'es', 'Disponible de mayo a septiembre.'),
    ('e6300000-0000-4000-8000-000000000304'::uuid, 'description', 'fr', 'Disponible de mai à septembre.'),
    ('e6300000-0000-4000-8000-000000000305'::uuid, 'name', 'es', 'Cocina completa'),
    ('e6300000-0000-4000-8000-000000000305'::uuid, 'name', 'fr', 'Cuisine complète'),
    ('e6300000-0000-4000-8000-000000000305'::uuid, 'description', 'es', 'Cafetera, microondas, horno, cocina y nevera.'),
    ('e6300000-0000-4000-8000-000000000305'::uuid, 'description', 'fr', 'Cafetière, micro-ondes, four, cuisinière et frigo.'),
    ('e6300000-0000-4000-8000-000000000306'::uuid, 'name', 'es', 'Toallas y ropa de cama'),
    ('e6300000-0000-4000-8000-000000000306'::uuid, 'name', 'fr', 'Serviettes et draps'),
    ('e6300000-0000-4000-8000-000000000306'::uuid, 'description', 'es', 'Incluye almohadas y mantas extra.'),
    ('e6300000-0000-4000-8000-000000000306'::uuid, 'description', 'fr', 'Oreillers et couvertures supplémentaires inclus.'),
    ('e6300000-0000-4000-8000-000000000307'::uuid, 'name', 'es', 'Secador y plancha'),
    ('e6300000-0000-4000-8000-000000000307'::uuid, 'name', 'fr', 'Sèche-cheveux et fer'),
    ('e6300000-0000-4000-8000-000000000308'::uuid, 'name', 'es', 'Básicos de baño'),
    ('e6300000-0000-4000-8000-000000000308'::uuid, 'name', 'fr', 'Essentiels de salle de bain'),
    ('e6300000-0000-4000-8000-000000000308'::uuid, 'description', 'es', 'Champú, acondicionador y jabón corporal.'),
    ('e6300000-0000-4000-8000-000000000308'::uuid, 'description', 'fr', 'Shampooing, revitalisant et savon pour le corps.'),
    ('e6300000-0000-4000-8000-000000000309'::uuid, 'name', 'es', 'Cuna de viaje'),
    ('e6300000-0000-4000-8000-000000000309'::uuid, 'name', 'fr', 'Lit de voyage'),
    ('e6300000-0000-4000-8000-000000000310'::uuid, 'name', 'es', 'Entrada privada y porche delantero'),
    ('e6300000-0000-4000-8000-000000000310'::uuid, 'name', 'fr', 'Entrée privée et porche avant'),
    ('e6300000-0000-4000-8000-000000000311'::uuid, 'name', 'es', 'Aparcamiento'),
    ('e6300000-0000-4000-8000-000000000311'::uuid, 'name', 'fr', 'Stationnement'),
    ('e6300000-0000-4000-8000-000000000311'::uuid, 'description', 'es', 'Una plaza asignada fuera de la calle, más aparcamiento gratis en la calle.'),
    ('e6300000-0000-4000-8000-000000000311'::uuid, 'description', 'fr', 'Une place assignée hors rue, plus stationnement gratuit dans la rue.'),
    ('e6300000-0000-4000-8000-000000000312'::uuid, 'name', 'es', 'Lavadora y secadora de monedas'),
    ('e6300000-0000-4000-8000-000000000312'::uuid, 'name', 'fr', 'Laveuse et sécheuse à monnaies'),
    ('e6300000-0000-4000-8000-000000000312'::uuid, 'description', 'es', 'En el edificio.'),
    ('e6300000-0000-4000-8000-000000000312'::uuid, 'description', 'fr', 'Dans l''immeuble.'),
    ('e6300000-0000-4000-8000-000000000313'::uuid, 'name', 'es', 'Seguridad'),
    ('e6300000-0000-4000-8000-000000000313'::uuid, 'name', 'fr', 'Sécurité'),
    ('e6300000-0000-4000-8000-000000000313'::uuid, 'description', 'es', 'Detectores de humo y monóxido de carbono, extintor y botiquín.'),
    ('e6300000-0000-4000-8000-000000000313'::uuid, 'description', 'fr', 'Détecteurs de fumée et de monoxyde de carbone, extincteur et trousse de premiers soins.')
) as lang(id, field, language, text) on lang.id = a.id
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

do $check$
declare
  direct_count integer;
  amenity_count integer;
begin
  select count(*) into direct_count
  from public.booking_links bl
  join public.properties p on p.id = bl.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and bl.channel = 'direct'
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat');

  if direct_count <> 3 then
    raise exception 'Expected 3 errin direct booking links, found %.', direct_count;
  end if;

  select count(*) into amenity_count
  from public.amenities a
  join public.properties p on p.id = a.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and a.is_visible
    and a.published_at is not null
    and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat');

  if amenity_count < 50 then
    raise exception 'Expected at least 50 visible errin amenities, found %.', amenity_count;
  end if;
end
$check$;

notify pgrst, 'reload schema';

commit;
