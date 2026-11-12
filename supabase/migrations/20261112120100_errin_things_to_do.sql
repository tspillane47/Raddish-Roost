-- Errin Things to Do links.
-- Links existing Winooski and Burlington recommendations to Errin stays with Errin host tips.
-- Does not update shared recommendations rows. Scoped to sites.key = 'errin' only.
-- Safe to paste again. Wrapped in begin/commit. Tips live in CTEs only (no tip table). No em dashes.
-- Paste after 20261112120000_errin_properties.sql.

begin;

do $guard$
begin
  if (
    select count(*)
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'errin'
      and p.slug in ('winooski-flat', 'mill-house', 'maple-street-flat')
  ) <> 3 then
    raise exception 'Errin properties are missing. Run 20261112120000_errin_properties.sql first.';
  end if;
  if not exists (select 1 from public.properties where slug = 'shallot-chalet') then
    raise exception 'shallot-chalet is missing. Run roost seeds before linking Things to Do.';
  end if;
end
$guard$;

-- Clean up any leftover permanent tip table from an earlier failed paste.
drop table if exists public.errin_host_tips;

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
with errin_host_tips(place_name, tip, tip_es, tip_fr) as (
  values
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
('Winooski Falls and river trails', 'A short walk along the falls and river paths.', 'Un paseo corto por la cascada y los senderos del río.', 'Une courte promenade le long de la cascade et des sentiers.')
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
with errin_host_tips(place_name, tip, tip_es, tip_fr) as (
  values
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
('Winooski Falls and river trails', 'A short walk along the falls and river paths.', 'Un paseo corto por la cascada y los senderos del río.', 'Une courte promenade le long de la cascade et des sentiers.')
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

-- Host tip translations for Errin links.
insert into public.content_translations (source_table, source_id, field, language, text)
with errin_host_tips(place_name, tip, tip_es, tip_fr) as (
  values
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
('Winooski Falls and river trails', 'A short walk along the falls and river paths.', 'Un paseo corto por la cascada y los senderos del río.', 'Une courte promenade le long de la cascade et des sentiers.')
)
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

do $check$
declare
  winooski_links integer;
  mill_links integer;
  maple_links integer;
  tip_count integer;
begin
  select count(*) into winooski_links
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'winooski-flat';

  if winooski_links = 0 then
    raise exception 'winooski-flat has zero Things to Do links';
  end if;

  select count(*) into mill_links
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'mill-house';

  if mill_links = 0 then
    raise exception 'mill-house has zero Things to Do links';
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

  select count(*) into tip_count
  from public.property_recommendations pr
  join public.properties p on p.id = pr.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and pr.host_note is not null
    and char_length(btrim(pr.host_note)) > 0;

  if tip_count = 0 then
    raise exception 'errin Things to Do links are missing host tips';
  end if;
end
$check$;

notify pgrst, 'reload schema';

commit;
