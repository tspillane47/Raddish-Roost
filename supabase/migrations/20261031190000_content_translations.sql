-- Spanish and French copy for published guidebook content.
-- English stays on the original rows. A missing translation falls back to English.
-- Names, URLs, and clock times stay as they are. Safe to paste again.
-- Michael's on the Hill is inactive and is not translated.

create table if not exists public.content_translations (
  source_table text not null,
  source_id uuid not null,
  field text not null,
  language text not null,
  text text not null,
  primary key (source_table, source_id, field, language),
  constraint content_translations_language check (language in ('es', 'fr')),
  constraint content_translations_text check (char_length(btrim(text)) between 1 and 8000)
);

alter table public.content_translations enable row level security;

revoke all on table public.content_translations from anon, authenticated;

grant select (source_table, source_id, field, language, text) on public.content_translations to anon;
grant select, insert, update, delete on public.content_translations to authenticated;

drop policy if exists content_translations_public_read on public.content_translations;
create policy content_translations_public_read on public.content_translations
  for select to anon
  using (true);

drop policy if exists content_translations_staff on public.content_translations;
create policy content_translations_staff on public.content_translations
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'tagline', 'es', $tr$Una granja de 1899 restaurada, justo en Main Street en Waterbury$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'tagline', 'fr', $tr$Une ferme de 1899 restaurée, en plein sur Main Street à Waterbury$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'description', 'es', $tr$Una granja acogedora, rústica y con aire de cabaña, construida en 1899 y recién restaurada sin perder su encanto. Ideal para parejas, familias o amigos. En el corazón de Waterbury, y aun así se siente como tu propio refugio.$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'description', 'fr', $tr$Une ferme chaleureuse, rustique, dans l'esprit d'un chalet, construite en 1899 et récemment restaurée sans perdre son charme. Parfaite pour un couple, une famille ou des amis. Au cœur de Waterbury, et pourtant elle reste votre refuge à vous.$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_title', 'es', $tr$Bienvenida a The Raddish Roost$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_title', 'fr', $tr$Bienvenue à The Raddish Roost$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_message', 'es', $tr$Nos alegra mucho que estés aquí. The Raddish Roost es una granja acogedora, rústica y con aire de cabaña, construida en 1899 y recién restaurada sin perder su encanto. Va muy bien para parejas, familias o amigos. Estás en el corazón de Waterbury, y la casa se siente igual como tu propio refugio.$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_message', 'fr', $tr$Nous sommes ravis de vous accueillir. The Raddish Roost est une ferme chaleureuse, rustique, dans l'esprit d'un chalet, construite en 1899 et récemment restaurée sans perdre son charme. Elle convient très bien à un couple, une famille ou des amis. Vous êtes au cœur de Waterbury, et la maison reste votre refuge à vous.$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', 'es', $tr$Aparcamiento gratis en la casa. El camino de entrada se comparte con los vecinos, así que aparca solo en los sitios marcados.$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', 'fr', $tr$Stationnement gratuit sur place. L'allée est partagée avec les voisins, alors garez-vous seulement sur les places indiquées.$tr$
from public.properties p
where p.slug = 'raddish-roost'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'tagline', 'es', $tr$Una estancia acogedora de dos niveles, a unos pasos del Winooski Circle$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'tagline', 'fr', $tr$Un séjour chaleureux sur deux niveaux, à deux pas du Winooski Circle$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'description', 'es', $tr$Un alojamiento recién renovado en una casa antigua, a buen precio y cerca de Burlington. Tiene algunos detalles de una casa vieja. No es un lujo, pero es cómodo, práctico y una muy buena opción.$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'description', 'fr', $tr$Un logement récemment rénové dans une vieille maison, à bon prix et proche de Burlington. Il garde quelques particularités d'une maison ancienne. Ce n'est pas un séjour de luxe, mais il est confortable, pratique, et vraiment avantageux.$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_title', 'es', $tr$Bienvenida a The Shallot Chalet$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_title', 'fr', $tr$Bienvenue à The Shallot Chalet$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_message', 'es', $tr$Nos alegra mucho que estés aquí. The Shallot Chalet es un alojamiento recién renovado en una casa antigua, a buen precio y cerca de Burlington. Tiene algunos detalles de una casa vieja. No es un lujo, pero es cómodo, práctico y una muy buena opción.$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_message', 'fr', $tr$Nous sommes ravis de vous accueillir. The Shallot Chalet est un logement récemment rénové dans une vieille maison, à bon prix et proche de Burlington. Il garde quelques particularités d'une maison ancienne. Ce n'est pas un séjour de luxe, mais il est confortable, pratique, et vraiment avantageux.$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', 'es', $tr$Aparcamiento gratis en la casa para 1 vehículo. Los coches de más pueden usar el aparcamiento gratis en la calle.$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', 'fr', $tr$Stationnement gratuit sur place pour 1 véhicule. Les voitures supplémentaires peuvent se garer gratuitement dans la rue.$tr$
from public.properties p
where p.slug = 'shallot-chalet'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'tagline', 'es', $tr$Un apartamento acogedor de dos dormitorios en el centro de Winooski$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'tagline', 'fr', $tr$Un deux-pièces chaleureux au cœur du centre de Winooski$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'description', 'es', $tr$Un apartamento acogedor y cómodo de dos dormitorios, en pleno centro y cerca de todo.$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'description', 'fr', $tr$Un appartement chaleureux et confortable de deux chambres, en plein centre et proche de tout.$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_title', 'es', $tr$Bienvenida a The Onion Ranch$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_title', 'fr', $tr$Bienvenue à The Onion Ranch$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_message', 'es', $tr$Nos alegra mucho que estés aquí. The Onion Ranch es un apartamento acogedor y cómodo de dos dormitorios, en pleno centro y cerca de todo.$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'welcome_message', 'fr', $tr$Nous sommes ravis de vous accueillir. The Onion Ranch est un appartement chaleureux et confortable de deux chambres, en plein centre et proche de tout.$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', 'es', $tr$Aparcamiento gratis en la casa.$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'properties', p.id, 'parking_summary', 'fr', $tr$Stationnement gratuit sur place.$tr$
from public.properties p
where p.slug = 'onion-ranch'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'es', $tr$Llegada y salida$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'check-in-checkout'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'fr', $tr$Arrivée et départ$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'check-in-checkout'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'es', $tr$Cómo llegar y aparcamiento$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'getting-here'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'fr', $tr$Venir et se garer$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'getting-here'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'es', $tr$Wi-Fi y TV$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'wifi'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'fr', $tr$Wi-Fi et TV$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'wifi'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'es', $tr$La casa$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'the-house'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'fr', $tr$La maison$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'the-house'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'es', $tr$Normas de la casa$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'house-rules'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'fr', $tr$Règles de la maison$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'house-rules'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'es', $tr$Qué hacer$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'things-to-do'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'fr', $tr$Que faire$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'things-to-do'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'es', $tr$Contacto y emergencias$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'contact'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'fr', $tr$Contact et urgences$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'contact'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'es', $tr$Quédate con nosotros otra vez$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'stay-again'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'title', 'fr', $tr$Revenez séjourner chez nous$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where s.slug = 'stay-again'
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$La puerta tiene un código. Tu código llega en los mensajes de Airbnb el día de la llegada.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'check-in-checkout'
  and s.summary = $tr$The door uses a code. Your code arrives in Airbnb messages on the day of check-in.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$La porte a un code. Votre code arrive dans les messages Airbnb le jour de l'arrivée.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'check-in-checkout'
  and s.summary = $tr$The door uses a code. Your code arrives in Airbnb messages on the day of check-in.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Las instrucciones de acceso están en tus mensajes de Airbnb. La llegada es a las 4:00 PM.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'check-in-checkout'
  and s.summary = $tr$Access instructions are in your Airbnb messages. Check-in is at 4:00 PM.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Les instructions d'accès sont dans vos messages Airbnb. L'arrivée est à 4:00 PM.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'check-in-checkout'
  and s.summary = $tr$Access instructions are in your Airbnb messages. Check-in is at 4:00 PM.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$La puerta tiene un código. Tu código llega en tus mensajes de Airbnb.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'check-in-checkout'
  and s.summary = $tr$The door uses a code. Your code arrives in your Airbnb messages.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$La porte a un code. Votre code arrive dans vos messages Airbnb.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'check-in-checkout'
  and s.summary = $tr$The door uses a code. Your code arrives in your Airbnb messages.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$En Main Street en Waterbury, a un paseo de los restaurantes, cafés y un supermercado del centro.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'getting-here'
  and s.summary = $tr$On Main Street in Waterbury, a walk from downtown restaurants, cafes, and a grocery store.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Sur Main Street à Waterbury, à une courte marche des restaurants, cafés et d'une épicerie du centre.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'getting-here'
  and s.summary = $tr$On Main Street in Waterbury, a walk from downtown restaurants, cafes, and a grocery store.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$A un paseo del Winooski Circle, cerca del río y de la cascada, y cerca de Burlington.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'getting-here'
  and s.summary = $tr$Walking distance to the Winooski Circle, near the river and the falls, and close to Burlington.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$À distance de marche du Winooski Circle, près de la rivière et de la cascade, et proche de Burlington.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'getting-here'
  and s.summary = $tr$Walking distance to the Winooski Circle, near the river and the falls, and close to Burlington.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$En el centro de Winooski, a unos 5 minutos a pie del Winooski Circle.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'getting-here'
  and s.summary = $tr$Downtown Winooski, about a 5-minute walk from the Winooski Circle.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Au centre de Winooski, à environ 5 minutes à pied du Winooski Circle.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'getting-here'
  and s.summary = $tr$Downtown Winooski, about a 5-minute walk from the Winooski Circle.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Wi-Fi rápido, con los datos de la red en tu reserva, y una smart TV.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'wifi'
  and s.summary = $tr$High-speed Wi-Fi, with the network details in your reservation, plus a smart TV.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Wi-Fi haut débit, avec les détails du réseau dans votre réservation, plus une smart TV.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'wifi'
  and s.summary = $tr$High-speed Wi-Fi, with the network details in your reservation, plus a smart TV.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Hay Wi-Fi y una TV. Los datos de la red vienen con tu reserva.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'wifi'
  and s.summary = $tr$Wi-Fi and a TV are available. Network details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Le Wi-Fi et une TV sont là. Les détails du réseau arrivent avec votre réservation.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'wifi'
  and s.summary = $tr$Wi-Fi and a TV are available. Network details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Los datos del Wi-Fi vienen con tu reserva. La TV tiene Netflix y HBO, y hay un espacio de trabajo con un monitor.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'wifi'
  and s.summary = $tr$Wi-Fi details come with your reservation. The TV has Netflix and HBO, and there is a workspace with a monitor.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Les détails du Wi-Fi arrivent avec votre réservation. La TV a Netflix et HBO, et il y a un espace de travail avec un écran.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'wifi'
  and s.summary = $tr$Wi-Fi details come with your reservation. The TV has Netflix and HBO, and there is a workspace with a monitor.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Tres dormitorios, y una nota sobre la escalera empinada. Cocina, chimenea, calefacción, lavandería, porche y una smart TV.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'the-house'
  and s.summary = $tr$Three bedrooms, and a note about the steep stairs. Kitchen, fireplace, heat, laundry, porch, and a smart TV.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Trois chambres, et une note sur l'escalier raide. Cuisine, cheminée, chauffage, buanderie, porche et une smart TV.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'the-house'
  and s.summary = $tr$Three bedrooms, and a note about the steep stairs. Kitchen, fireplace, heat, laundry, porch, and a smart TV.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Dos niveles, tres dormitorios, un baño, y una nota sobre la escalera empinada. Cocina, baño, Wi-Fi, TV, tapones para los oídos y aparcamiento para un vehículo.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'the-house'
  and s.summary = $tr$Two levels, three bedrooms, one bathroom, and a note about the steep stairs. Kitchen, bathroom, Wi-Fi, TV, earplugs, and parking for one vehicle.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Deux niveaux, trois chambres, une salle de bain, et une note sur l'escalier raide. Cuisine, salle de bain, Wi-Fi, TV, bouchons d'oreilles et stationnement pour un véhicule.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'the-house'
  and s.summary = $tr$Two levels, three bedrooms, one bathroom, and a note about the steep stairs. Kitchen, bathroom, Wi-Fi, TV, earplugs, and parking for one vehicle.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Dos dormitorios, un baño al final de un tramo de escaleras, una cocina completa y un espacio de oficina. Duermen hasta 4. Cocina completa, cafetera de filtro y un espacio de trabajo con un monitor.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'the-house'
  and s.summary = $tr$Two bedrooms, one bathroom up a flight of stairs, a full kitchen, and an office space. Sleeps up to 4. A full kitchen, a drip coffee maker, and a workspace with a monitor.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Deux chambres, une salle de bain en haut d'un escalier, une cuisine complète et un espace bureau. Jusqu'à 4 personnes. Cuisine complète, cafetière filtre et un espace de travail avec un écran.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'the-house'
  and s.summary = $tr$Two bedrooms, one bathroom up a flight of stairs, a full kitchen, and an office space. Sleeps up to 4. A full kitchen, a drip coffee maker, and a workspace with a monitor.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Perros, huéspedes de más, fiestas y dónde aparcar.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'house-rules'
  and s.summary = $tr$Dogs, extra guests, parties, and where to park.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Chiens, invités en plus, fêtes, et où se garer.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'house-rules'
  and s.summary = $tr$Dogs, extra guests, parties, and where to park.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Los perros son bienvenidos. No gatos. Los detalles de las tarifas llegarán pronto.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'house-rules'
  and s.summary = $tr$Dogs are welcome. No cats. Fee details are coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Les chiens sont les bienvenus. Pas de chats. Les détails des frais arrivent bientôt.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'house-rules'
  and s.summary = $tr$Dogs are welcome. No cats. Fee details are coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Las mascotas son bienvenidas. No hay fiestas.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'house-rules'
  and s.summary = $tr$Pets are welcome. No parties.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Les animaux sont les bienvenus. Pas de fêtes.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'house-rules'
  and s.summary = $tr$Pets are welcome. No parties.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Los favoritos de tus anfitriones en Main Street, todos a un paseo.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'things-to-do'
  and s.summary = $tr$Host favorites on Main Street, all within walking distance.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Les favoris de vos hôtes sur Main Street, tous à distance de marche.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'things-to-do'
  and s.summary = $tr$Host favorites on Main Street, all within walking distance.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$El Winooski Circle, el río y la cascada. Los favoritos de tus anfitriones en Winooski.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'things-to-do'
  and s.summary = $tr$The Winooski Circle, the river, and the falls. Host favorites in Winooski.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Le Winooski Circle, la rivière et la cascade. Les favoris de vos hôtes à Winooski.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'things-to-do'
  and s.summary = $tr$The Winooski Circle, the river, and the falls. Host favorites in Winooski.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Camina hasta el Winooski Circle, o conduce unos 10 minutos hasta Burlington y Lake Champlain. Restaurantes, café y una cervecería cerca del Winooski Circle, además del río y la cascada.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'things-to-do'
  and s.summary = $tr$Walk to the Winooski Circle, or drive about 10 minutes to Burlington and Lake Champlain. Restaurants, coffee, and a brewery near the Winooski Circle, plus the river and falls.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Marchez jusqu'au Winooski Circle, ou roulez environ 10 minutes jusqu'à Burlington et Lake Champlain. Restaurants, café et une brasserie près du Winooski Circle, plus la rivière et la cascade.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'things-to-do'
  and s.summary = $tr$Walk to the Winooski Circle, or drive about 10 minutes to Burlington and Lake Champlain. Restaurants, coffee, and a brewery near the Winooski Circle, plus the river and falls.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Escríbenos un mensaje de Airbnb. El teléfono y el correo todavía no están publicados.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'contact'
  and s.summary = $tr$Send us an Airbnb message. Phone and email are not posted yet.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Envoyez-nous un message Airbnb. Le téléphone et l'e-mail ne sont pas encore indiqués.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'contact'
  and s.summary = $tr$Send us an Airbnb message. Phone and email are not posted yet.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Escríbenos un mensaje de Airbnb. Normalmente respondemos en una hora.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'contact'
  and s.summary = $tr$Send us an Airbnb message. We usually reply within an hour.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Envoyez-nous un message Airbnb. Nous répondons en général dans l'heure.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'contact'
  and s.summary = $tr$Send us an Airbnb message. We usually reply within an hour.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Escríbenos un mensaje de Airbnb. Normalmente respondemos en una hora.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'contact'
  and s.summary = $tr$Send us an Airbnb message. We usually reply within an hour.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Envoyez-nous un message Airbnb. Nous répondons en général dans l'heure.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'contact'
  and s.summary = $tr$Send us an Airbnb message. We usually reply within an hour.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Reserva The Raddish Roost otra vez en Airbnb.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'stay-again'
  and s.summary = $tr$Book The Raddish Roost again on Airbnb.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Réservez à nouveau The Raddish Roost sur Airbnb.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and s.slug = 'stay-again'
  and s.summary = $tr$Book The Raddish Roost again on Airbnb.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Reserva The Shallot Chalet otra vez en Airbnb.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'stay-again'
  and s.summary = $tr$Book The Shallot Chalet again on Airbnb.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Réservez à nouveau The Shallot Chalet sur Airbnb.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and s.slug = 'stay-again'
  and s.summary = $tr$Book The Shallot Chalet again on Airbnb.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'es', $tr$Reserva The Onion Ranch otra vez en Airbnb.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'stay-again'
  and s.summary = $tr$Book The Onion Ranch again on Airbnb.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_sections', s.id, 'summary', 'fr', $tr$Réservez à nouveau The Onion Ranch sur Airbnb.$tr$
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and s.slug = 'stay-again'
  and s.summary = $tr$Book The Onion Ranch again on Airbnb.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Cómo encontrar la casa$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Finding the house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Raddish Roost is on Main Street in Waterbury, Vermont. It is on its own.

You can walk to downtown restaurants, cafes, and a grocery store.

The street number is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site. The driveway is shared with neighbors, so please park only in the designated spots.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$The Raddish Roost está en Main Street en Waterbury, Vermont. Está sola.

Puedes caminar hasta los restaurantes, cafés y un supermercado del centro.

El número de la calle todavía no está en esta página. Revisa tus mensajes de Airbnb para la dirección completa.

El aparcamiento es gratis en la casa. El camino de entrada se comparte con los vecinos, así que aparca solo en los sitios marcados.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Finding the house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Raddish Roost is on Main Street in Waterbury, Vermont. It is on its own.

You can walk to downtown restaurants, cafes, and a grocery store.

The street number is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site. The driveway is shared with neighbors, so please park only in the designated spots.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Trouver la maison$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Finding the house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Raddish Roost is on Main Street in Waterbury, Vermont. It is on its own.

You can walk to downtown restaurants, cafes, and a grocery store.

The street number is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site. The driveway is shared with neighbors, so please park only in the designated spots.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$The Raddish Roost est sur Main Street à Waterbury, Vermont. Elle est seule.

Vous pouvez marcher jusqu'aux restaurants, cafés et à une épicerie du centre.

Le numéro de rue n'est pas encore sur cette page. Regardez vos messages Airbnb pour l'adresse complète.

Le stationnement est gratuit sur place. L'allée est partagée avec les voisins, alors garez-vous seulement sur les places indiquées.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Finding the house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Raddish Roost is on Main Street in Waterbury, Vermont. It is on its own.

You can walk to downtown restaurants, cafes, and a grocery store.

The street number is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site. The driveway is shared with neighbors, so please park only in the designated spots.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Wi-Fi y la TV$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The house has high-speed Wi-Fi. The network name and password come with your reservation for now. Check your Airbnb messages for those details.

The living room has a smart TV, with Netflix and HBO included.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$La casa tiene Wi-Fi rápido. Por ahora, el nombre de la red y la contraseña vienen con tu reserva. Revisa tus mensajes de Airbnb para esos datos.

El salón tiene una smart TV, con Netflix y HBO incluidos.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The house has high-speed Wi-Fi. The network name and password come with your reservation for now. Check your Airbnb messages for those details.

The living room has a smart TV, with Netflix and HBO included.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Wi-Fi et la TV$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The house has high-speed Wi-Fi. The network name and password come with your reservation for now. Check your Airbnb messages for those details.

The living room has a smart TV, with Netflix and HBO included.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$La maison a le Wi-Fi haut débit. Pour l'instant, le nom du réseau et le mot de passe arrivent avec votre réservation. Regardez vos messages Airbnb pour ces détails.

Le salon a une smart TV, avec Netflix et HBO inclus.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The house has high-speed Wi-Fi. The network name and password come with your reservation for now. Check your Airbnb messages for those details.

The living room has a smart TV, with Netflix and HBO included.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$La casa$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$The house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Raddish Roost has 3 bedrooms, 3 beds, and 1 full bathroom. There is a living area, a separate dining room, a laundry room, and a front porch. The house sleeps up to 6.

The kitchen is fully equipped, with a gas stove and a dishwasher. The living room has an electric fireplace. The house has propane heat and air conditioning. The laundry room has a washer and a dryer. The front porch is for morning coffee or evening drinks.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$The Raddish Roost tiene 3 dormitorios, 3 camas y 1 baño completo. Hay una sala, un comedor aparte, un lavadero y un porche delantero. La casa duerme hasta 6.

La cocina está completa, con cocina de gas y lavavajillas. El salón tiene una chimenea eléctrica. La casa tiene calefacción de propano y aire acondicionado. El lavadero tiene lavadora y secadora. El porche es para el café de la mañana o una copa por la noche.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$The house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Raddish Roost has 3 bedrooms, 3 beds, and 1 full bathroom. There is a living area, a separate dining room, a laundry room, and a front porch. The house sleeps up to 6.

The kitchen is fully equipped, with a gas stove and a dishwasher. The living room has an electric fireplace. The house has propane heat and air conditioning. The laundry room has a washer and a dryer. The front porch is for morning coffee or evening drinks.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$La maison$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$The house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Raddish Roost has 3 bedrooms, 3 beds, and 1 full bathroom. There is a living area, a separate dining room, a laundry room, and a front porch. The house sleeps up to 6.

The kitchen is fully equipped, with a gas stove and a dishwasher. The living room has an electric fireplace. The house has propane heat and air conditioning. The laundry room has a washer and a dryer. The front porch is for morning coffee or evening drinks.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$The Raddish Roost a 3 chambres, 3 lits et 1 salle de bain complète. Il y a un séjour, une salle à manger à part, une buanderie et un porche. La maison accueille jusqu'à 6 personnes.

La cuisine est complète, avec une cuisinière au gaz et un lave-vaisselle. Le salon a une cheminée électrique. La maison a un chauffage au propane et la climatisation. La buanderie a un lave-linge et un sèche-linge. Le porche est fait pour le café du matin ou un verre le soir.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$The house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Raddish Roost has 3 bedrooms, 3 beds, and 1 full bathroom. There is a living area, a separate dining room, a laundry room, and a front porch. The house sleeps up to 6.

The kitchen is fully equipped, with a gas stove and a dishwasher. The living room has an electric fireplace. The house has propane heat and air conditioning. The laundry room has a washer and a dryer. The front porch is for morning coffee or evening drinks.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Qué hay aquí$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$- Fully equipped kitchen with a gas stove and a dishwasher
- Electric fireplace in the living room
- Propane heat
- Air conditioning
- Washer and dryer in the laundry room
- Front porch for morning coffee or evening drinks
- Smart TV in the living room, with Netflix and HBO included$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$- Cocina completa con cocina de gas y lavavajillas
- Chimenea eléctrica en el salón
- Calefacción de propano
- Aire acondicionado
- Lavadora y secadora en el lavadero
- Porche delantero para el café de la mañana o una copa por la noche
- Smart TV en el salón, con Netflix y HBO incluidos$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$- Fully equipped kitchen with a gas stove and a dishwasher
- Electric fireplace in the living room
- Propane heat
- Air conditioning
- Washer and dryer in the laundry room
- Front porch for morning coffee or evening drinks
- Smart TV in the living room, with Netflix and HBO included$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Ce qu'il y a ici$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$- Fully equipped kitchen with a gas stove and a dishwasher
- Electric fireplace in the living room
- Propane heat
- Air conditioning
- Washer and dryer in the laundry room
- Front porch for morning coffee or evening drinks
- Smart TV in the living room, with Netflix and HBO included$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$- Cuisine complète avec cuisinière au gaz et lave-vaisselle
- Cheminée électrique dans le salon
- Chauffage au propane
- Climatisation
- Lave-linge et sèche-linge dans la buanderie
- Porche pour le café du matin ou un verre le soir
- Smart TV dans le salon, avec Netflix et HBO inclus$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$- Fully equipped kitchen with a gas stove and a dishwasher
- Electric fireplace in the living room
- Propane heat
- Air conditioning
- Washer and dryer in the laundry room
- Front porch for morning coffee or evening drinks
- Smart TV in the living room, with Netflix and HBO included$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Nuestros favoritos$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Our favorites$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are our favorites, all walking distance on Main Street:

- The Reservoir
- Prohibition Pig
- Blackback Pub
- Hen of the Wood

Address, website, and hours are details coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Estos son nuestros favoritos, todos a un paseo por Main Street:

- The Reservoir
- Prohibition Pig
- Blackback Pub
- Hen of the Wood

La dirección, la web y los horarios llegarán pronto.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Our favorites$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are our favorites, all walking distance on Main Street:

- The Reservoir
- Prohibition Pig
- Blackback Pub
- Hen of the Wood

Address, website, and hours are details coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Nos favoris$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Our favorites$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are our favorites, all walking distance on Main Street:

- The Reservoir
- Prohibition Pig
- Blackback Pub
- Hen of the Wood

Address, website, and hours are details coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Voici nos favoris, tous à distance de marche sur Main Street :

- The Reservoir
- Prohibition Pig
- Blackback Pub
- Hen of the Wood

L'adresse, le site et les horaires arrivent bientôt.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Our favorites$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are our favorites, all walking distance on Main Street:

- The Reservoir
- Prohibition Pig
- Blackback Pub
- Hen of the Wood

Address, website, and hours are details coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Por el pueblo$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Around town$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can walk to downtown restaurants, cafes, and a grocery store. Our favorite places to eat and drink are in Local Recommendations.

Details coming soon for more things to do.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Puedes caminar hasta los restaurantes, cafés y un supermercado del centro. Nuestros lugares favoritos para comer y beber están en Local Recommendations.

Pronto habrá más ideas de qué hacer.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Around town$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can walk to downtown restaurants, cafes, and a grocery store. Our favorite places to eat and drink are in Local Recommendations.

Details coming soon for more things to do.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Dans le coin$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Around town$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can walk to downtown restaurants, cafes, and a grocery store. Our favorite places to eat and drink are in Local Recommendations.

Details coming soon for more things to do.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Vous pouvez marcher jusqu'aux restaurants, cafés et à une épicerie du centre. Nos endroits préférés pour manger et boire sont dans Local Recommendations.

D'autres idées arrivent bientôt.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Around town$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can walk to downtown restaurants, cafes, and a grocery store. Our favorite places to eat and drink are in Local Recommendations.

Details coming soon for more things to do.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Normas de la casa$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$House rules$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Dogs are welcome. The pet fee is $100, and it is arranged through Airbnb.

Extra guests beyond the booking are $25 per person.

No parties. The penalty is $1,000.

Please park only in the designated spots. The driveway is shared with neighbors.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Los perros son bienvenidos. La tarifa de mascota es $100 y se organiza por Airbnb.

Los huéspedes de más, fuera de la reserva, son $25 por persona.

No hay fiestas. La penalización es $1,000.

Aparca solo en los sitios marcados. El camino de entrada se comparte con los vecinos.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$House rules$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Dogs are welcome. The pet fee is $100, and it is arranged through Airbnb.

Extra guests beyond the booking are $25 per person.

No parties. The penalty is $1,000.

Please park only in the designated spots. The driveway is shared with neighbors.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Règles de la maison$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$House rules$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Dogs are welcome. The pet fee is $100, and it is arranged through Airbnb.

Extra guests beyond the booking are $25 per person.

No parties. The penalty is $1,000.

Please park only in the designated spots. The driveway is shared with neighbors.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les chiens sont les bienvenus. Les frais pour l'animal sont de $100, et cela se règle par Airbnb.

Les invités en plus de la réservation sont à $25 par personne.

Pas de fêtes. La pénalité est de $1,000.

Garez-vous seulement sur les places indiquées. L'allée est partagée avec les voisins.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$House rules$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Dogs are welcome. The pet fee is $100, and it is arranged through Airbnb.

Extra guests beyond the booking are $25 per person.

No parties. The penalty is $1,000.

Please park only in the designated spots. The driveway is shared with neighbors.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Cuidado con la escalera$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Please take care on the stairs$tr$
  and coalesce(b.body->>'markdown', '') = $tr$This is an old home. The stairs to the bedrooms are steep, so please take care, especially with kids or anyone unsteady on stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Es una casa antigua. La escalera hacia los dormitorios es empinada, así que ve con cuidado, sobre todo con niños o con alguien que no se sienta firme en las escaleras.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Please take care on the stairs$tr$
  and coalesce(b.body->>'markdown', '') = $tr$This is an old home. The stairs to the bedrooms are steep, so please take care, especially with kids or anyone unsteady on stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Attention à l'escalier$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Please take care on the stairs$tr$
  and coalesce(b.body->>'markdown', '') = $tr$This is an old home. The stairs to the bedrooms are steep, so please take care, especially with kids or anyone unsteady on stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$C'est une vieille maison. L'escalier vers les chambres est raide, alors faites attention, surtout avec des enfants ou quelqu'un qui n'est pas à l'aise dans les escaliers.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Please take care on the stairs$tr$
  and coalesce(b.body->>'markdown', '') = $tr$This is an old home. The stairs to the bedrooms are steep, so please take care, especially with kids or anyone unsteady on stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Antes de irte$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Pronto estarán los pasos de salida, la basura y el termostato.

Escríbenos por Airbnb si necesitas algo de eso antes de que esté publicado.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Avant de partir$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les étapes de départ, les poubelles et le thermostat arrivent bientôt.

Écrivez-nous sur Airbnb si vous en avez besoin avant que ce soit publié.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Preguntas$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Los detalles llegarán pronto.

Si necesitas una respuesta antes, envíanos un mensaje de Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Questions$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les détails arrivent bientôt.

Si vous avez besoin d'une réponse avant, envoyez-nous un message Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Escribe a tus anfitriones$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can reach us with an Airbnb message. We do not have a phone number or email on this page yet.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1477625352327415954/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Puedes escribirnos por Airbnb. Todavía no hay teléfono ni correo en esta página.

[Escríbenos por Airbnb](https://www.airbnb.com/contact_host/1477625352327415954/send_message)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can reach us with an Airbnb message. We do not have a phone number or email on this page yet.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1477625352327415954/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Écrivez à vos hôtes$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can reach us with an Airbnb message. We do not have a phone number or email on this page yet.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1477625352327415954/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Vous pouvez nous écrire par Airbnb. Il n'y a pas encore de téléphone ni d'e-mail sur cette page.

[Écrivez-nous sur Airbnb](https://www.airbnb.com/contact_host/1477625352327415954/send_message)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can reach us with an Airbnb message. We do not have a phone number or email on this page yet.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1477625352327415954/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Vuelve$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Raddish Roost.

[Book The Raddish Roost on Airbnb](https://www.airbnb.com/rooms/1477625352327415954)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Nos encantaría recibirte otra vez en The Raddish Roost.

[Reserva The Raddish Roost en Airbnb](https://www.airbnb.com/rooms/1477625352327415954)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Raddish Roost.

[Book The Raddish Roost on Airbnb](https://www.airbnb.com/rooms/1477625352327415954)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Revenez$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Raddish Roost.

[Book The Raddish Roost on Airbnb](https://www.airbnb.com/rooms/1477625352327415954)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Nous serions ravis de vous recevoir à nouveau à The Raddish Roost.

[Réservez The Raddish Roost sur Airbnb](https://www.airbnb.com/rooms/1477625352327415954)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Raddish Roost.

[Book The Raddish Roost on Airbnb](https://www.airbnb.com/rooms/1477625352327415954)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Cómo encontrar la casa$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Finding the house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Shallot Chalet is in Winooski, Vermont. It shares the building with The Onion Ranch.

You can walk to the Winooski Circle, with shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails. Burlington is close by.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$The Shallot Chalet está en Winooski, Vermont. Comparte el edificio con The Onion Ranch.

Puedes caminar hasta el Winooski Circle, con tiendas, bares, restaurantes y cafeterías. El Winooski River y Winooski Falls están cerca, con cascadas y senderos. Burlington queda cerca.

La dirección todavía no está en esta página. Revisa tus mensajes de Airbnb para la dirección completa.

El aparcamiento es gratis en la casa para 1 vehículo. Los coches de más pueden usar el aparcamiento gratis en la calle.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Finding the house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Shallot Chalet is in Winooski, Vermont. It shares the building with The Onion Ranch.

You can walk to the Winooski Circle, with shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails. Burlington is close by.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Trouver la maison$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Finding the house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Shallot Chalet is in Winooski, Vermont. It shares the building with The Onion Ranch.

You can walk to the Winooski Circle, with shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails. Burlington is close by.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$The Shallot Chalet est à Winooski, Vermont. Il partage le bâtiment avec The Onion Ranch.

Vous pouvez marcher jusqu'au Winooski Circle, avec des boutiques, des bars, des restaurants et des cafés. Le Winooski River et Winooski Falls sont tout près, avec des cascades et des sentiers. Burlington est proche.

L'adresse n'est pas encore sur cette page. Regardez vos messages Airbnb pour l'adresse complète.

Le stationnement est gratuit sur place pour 1 véhicule. Les voitures supplémentaires peuvent se garer gratuitement dans la rue.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Finding the house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Shallot Chalet is in Winooski, Vermont. It shares the building with The Onion Ranch.

You can walk to the Winooski Circle, with shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails. Burlington is close by.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Wi-Fi y la TV$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Wi-Fi and a TV are available.

The network name and password come with your reservation for now. Check your Airbnb messages for those details.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Hay Wi-Fi y una TV.

Por ahora, el nombre de la red y la contraseña vienen con tu reserva. Revisa tus mensajes de Airbnb para esos datos.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Wi-Fi and a TV are available.

The network name and password come with your reservation for now. Check your Airbnb messages for those details.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Wi-Fi et la TV$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Wi-Fi and a TV are available.

The network name and password come with your reservation for now. Check your Airbnb messages for those details.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Le Wi-Fi et une TV sont là.

Pour l'instant, le nom du réseau et le mot de passe arrivent avec votre réservation. Regardez vos messages Airbnb pour ces détails.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Wi-Fi and a TV are available.

The network name and password come with your reservation for now. Check your Airbnb messages for those details.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$La casa$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$The house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Shallot Chalet has two levels and sleeps up to 6. There is 1 bathroom.

On the ground floor you will find the kitchen, the bathroom, and Bedroom 1 with a queen bed.

Upstairs you will find the living room, Bedroom 2 with a queen bed, and Bedroom 3 with a double bed.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$The Shallot Chalet tiene dos niveles y duerme hasta 6. Hay 1 baño.

En la planta baja están la cocina, el baño y el Dormitorio 1 con una cama queen.

Arriba están el salón, el Dormitorio 2 con una cama queen y el Dormitorio 3 con una cama doble.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$The house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Shallot Chalet has two levels and sleeps up to 6. There is 1 bathroom.

On the ground floor you will find the kitchen, the bathroom, and Bedroom 1 with a queen bed.

Upstairs you will find the living room, Bedroom 2 with a queen bed, and Bedroom 3 with a double bed.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$La maison$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$The house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Shallot Chalet has two levels and sleeps up to 6. There is 1 bathroom.

On the ground floor you will find the kitchen, the bathroom, and Bedroom 1 with a queen bed.

Upstairs you will find the living room, Bedroom 2 with a queen bed, and Bedroom 3 with a double bed.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$The Shallot Chalet a deux niveaux et accueille jusqu'à 6 personnes. Il y a 1 salle de bain.

Au rez-de-chaussée, vous trouverez la cuisine, la salle de bain et la Chambre 1 avec un lit queen.

À l'étage, le séjour, la Chambre 2 avec un lit queen, et la Chambre 3 avec un lit double.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$The house$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Shallot Chalet has two levels and sleeps up to 6. There is 1 bathroom.

On the ground floor you will find the kitchen, the bathroom, and Bedroom 1 with a queen bed.

Upstairs you will find the living room, Bedroom 2 with a queen bed, and Bedroom 3 with a double bed.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Qué hay aquí$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$- Kitchen on the ground floor
- One bathroom
- Wi-Fi
- TV
- Earplugs
- Free on-site parking for 1 vehicle$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$- Cocina en la planta baja
- Un baño
- Wi-Fi
- TV
- Tapones para los oídos
- Aparcamiento gratis en la casa para 1 vehículo$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$- Kitchen on the ground floor
- One bathroom
- Wi-Fi
- TV
- Earplugs
- Free on-site parking for 1 vehicle$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Ce qu'il y a ici$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$- Kitchen on the ground floor
- One bathroom
- Wi-Fi
- TV
- Earplugs
- Free on-site parking for 1 vehicle$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$- Cuisine au rez-de-chaussée
- Une salle de bain
- Wi-Fi
- TV
- Bouchons d'oreilles
- Stationnement gratuit sur place pour 1 véhicule$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$- Kitchen on the ground floor
- One bathroom
- Wi-Fi
- TV
- Earplugs
- Free on-site parking for 1 vehicle$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Nuestros favoritos$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Our favorites$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are our favorites in Winooski:

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails

Address, website, and hours are details coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Estos son nuestros favoritos en Winooski:

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails

La dirección, la web y los horarios llegarán pronto.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Our favorites$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are our favorites in Winooski:

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails

Address, website, and hours are details coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Nos favoris$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Our favorites$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are our favorites in Winooski:

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails

Address, website, and hours are details coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Voici nos favoris à Winooski :

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails

L'adresse, le site et les horaires arrivent bientôt.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Our favorites$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are our favorites in Winooski:

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails

Address, website, and hours are details coming soon.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Por el pueblo$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Around town$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can walk to the Winooski Circle for shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails.

Our favorite places are in Local Recommendations.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Puedes caminar hasta el Winooski Circle para tiendas, bares, restaurantes y cafeterías. El Winooski River y Winooski Falls están cerca, con cascadas y senderos.

Nuestros lugares favoritos están en Local Recommendations.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Around town$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can walk to the Winooski Circle for shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails.

Our favorite places are in Local Recommendations.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Dans le coin$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Around town$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can walk to the Winooski Circle for shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails.

Our favorite places are in Local Recommendations.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Vous pouvez marcher jusqu'au Winooski Circle pour les boutiques, les bars, les restaurants et les cafés. Le Winooski River et Winooski Falls sont tout près, avec des cascades et des sentiers.

Nos endroits préférés sont dans Local Recommendations.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Around town$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can walk to the Winooski Circle for shops, bars, restaurants, and coffee shops. The Winooski River and Winooski Falls are nearby, with waterfalls and trails.

Our favorite places are in Local Recommendations.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Normas de la casa$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$House rules$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Dogs are welcome. Cats are not. If you have animal allergies, this may not be the best fit. Details on fees are coming soon.

Please use the on-site parking for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Los perros son bienvenidos. Los gatos no. Si tienes alergia a los animales, puede que no sea el mejor sitio. Los detalles de las tarifas llegarán pronto.

Usa el aparcamiento de la casa para 1 vehículo. Los coches de más pueden usar el aparcamiento gratis en la calle.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$House rules$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Dogs are welcome. Cats are not. If you have animal allergies, this may not be the best fit. Details on fees are coming soon.

Please use the on-site parking for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Règles de la maison$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$House rules$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Dogs are welcome. Cats are not. If you have animal allergies, this may not be the best fit. Details on fees are coming soon.

Please use the on-site parking for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les chiens sont les bienvenus. Pas les chats. Si vous avez des allergies aux animaux, ce n'est peut-être pas le meilleur choix. Les détails des frais arrivent bientôt.

Utilisez le stationnement sur place pour 1 véhicule. Les voitures supplémentaires peuvent se garer gratuitement dans la rue.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$House rules$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Dogs are welcome. Cats are not. If you have animal allergies, this may not be the best fit. Details on fees are coming soon.

Please use the on-site parking for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Algunas cosas que debes saber$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$A few things to know$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The stairs are steep. They may not suit young children or older guests.

The street is busy and can be noisy at night. Two of the three bedrooms face the main street. Earplugs are provided.

Two security cameras are on the property. They are exterior only.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$La escalera es empinada. Puede que no sea cómoda para niños pequeños o huéspedes mayores.

La calle tiene movimiento y puede ser ruidosa por la noche. Dos de los tres dormitorios dan a la calle principal. Hay tapones para los oídos.

Hay dos cámaras de seguridad en la propiedad. Solo están en el exterior.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$A few things to know$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The stairs are steep. They may not suit young children or older guests.

The street is busy and can be noisy at night. Two of the three bedrooms face the main street. Earplugs are provided.

Two security cameras are on the property. They are exterior only.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Quelques choses à savoir$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$A few things to know$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The stairs are steep. They may not suit young children or older guests.

The street is busy and can be noisy at night. Two of the three bedrooms face the main street. Earplugs are provided.

Two security cameras are on the property. They are exterior only.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$L'escalier est raide. Il peut ne pas convenir aux jeunes enfants ou aux invités plus âgés.

La rue est passante et peut être bruyante la nuit. Deux des trois chambres donnent sur la rue principale. Des bouchons d'oreilles sont fournis.

Deux caméras de sécurité sont sur la propriété. Elles sont uniquement à l'extérieur.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$A few things to know$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The stairs are steep. They may not suit young children or older guests.

The street is busy and can be noisy at night. Two of the three bedrooms face the main street. Earplugs are provided.

Two security cameras are on the property. They are exterior only.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Antes de irte$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Pronto estarán los pasos de salida, la basura y el termostato.

Escríbenos por Airbnb si necesitas algo de eso antes de que esté publicado.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Avant de partir$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les étapes de départ, les poubelles et le thermostat arrivent bientôt.

Écrivez-nous sur Airbnb si vous en avez besoin avant que ce soit publié.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Preguntas$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Los detalles llegarán pronto.

Si necesitas una respuesta antes, envíanos un mensaje de Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Questions$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les détails arrivent bientôt.

Si vous avez besoin d'une réponse avant, envoyez-nous un message Airbnb.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Escribe a tus anfitriones$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can reach us with an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1064639214342902592/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Puedes escribirnos por Airbnb. Normalmente respondemos en una hora.

[Escríbenos por Airbnb](https://www.airbnb.com/contact_host/1064639214342902592/send_message)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can reach us with an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1064639214342902592/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Écrivez à vos hôtes$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can reach us with an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1064639214342902592/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Vous pouvez nous écrire par Airbnb. Nous répondons en général dans l'heure.

[Écrivez-nous sur Airbnb](https://www.airbnb.com/contact_host/1064639214342902592/send_message)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$You can reach us with an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/1064639214342902592/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Vuelve$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Shallot Chalet.

[Book The Shallot Chalet on Airbnb](https://www.airbnb.com/rooms/1064639214342902592)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Nos encantaría recibirte otra vez en The Shallot Chalet.

[Reserva The Shallot Chalet en Airbnb](https://www.airbnb.com/rooms/1064639214342902592)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Shallot Chalet.

[Book The Shallot Chalet on Airbnb](https://www.airbnb.com/rooms/1064639214342902592)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Revenez$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Shallot Chalet.

[Book The Shallot Chalet on Airbnb](https://www.airbnb.com/rooms/1064639214342902592)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Nous serions ravis de vous recevoir à nouveau à The Shallot Chalet.

[Réservez The Shallot Chalet sur Airbnb](https://www.airbnb.com/rooms/1064639214342902592)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Shallot Chalet.

[Book The Shallot Chalet on Airbnb](https://www.airbnb.com/rooms/1064639214342902592)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Cómo encontrar el apartamento$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Finding the apartment$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Onion Ranch is in downtown Winooski, Vermont. It shares the building with The Shallot Chalet.

The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques. Burlington is about a 10-minute drive, with more places to eat, Lake Champlain, and lots to explore. The Winooski River and Winooski Falls are nearby.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$The Onion Ranch está en el centro de Winooski, Vermont. Comparte el edificio con The Shallot Chalet.

El Winooski Circle queda a unos 5 minutos a pie, con restaurantes, cafeterías, bares y tiendas. Burlington está a unos 10 minutos en coche, con más sitios para comer, Lake Champlain y mucho por explorar. El Winooski River y Winooski Falls están cerca.

La dirección todavía no está en esta página. Revisa tus mensajes de Airbnb para la dirección completa.

El aparcamiento es gratis en la casa.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Finding the apartment$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Onion Ranch is in downtown Winooski, Vermont. It shares the building with The Shallot Chalet.

The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques. Burlington is about a 10-minute drive, with more places to eat, Lake Champlain, and lots to explore. The Winooski River and Winooski Falls are nearby.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Trouver l'appartement$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Finding the apartment$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Onion Ranch is in downtown Winooski, Vermont. It shares the building with The Shallot Chalet.

The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques. Burlington is about a 10-minute drive, with more places to eat, Lake Champlain, and lots to explore. The Winooski River and Winooski Falls are nearby.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$The Onion Ranch est au centre de Winooski, Vermont. Il partage le bâtiment avec The Shallot Chalet.

Le Winooski Circle est à environ 5 minutes à pied, avec des restaurants, des cafés, des bars et des boutiques. Burlington est à environ 10 minutes en voiture, avec d'autres endroits pour manger, Lake Champlain et beaucoup à explorer. Le Winooski River et Winooski Falls sont tout près.

L'adresse n'est pas encore sur cette page. Regardez vos messages Airbnb pour l'adresse complète.

Le stationnement est gratuit sur place.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Finding the apartment$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Onion Ranch is in downtown Winooski, Vermont. It shares the building with The Shallot Chalet.

The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques. Burlington is about a 10-minute drive, with more places to eat, Lake Champlain, and lots to explore. The Winooski River and Winooski Falls are nearby.

The street address is not on this page yet. Check your Airbnb messages for the full address.

Parking is free on site.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Wi-Fi y la TV$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Wi-Fi is available. The network name and password come with your reservation for now, so they are not on this page.

There is a smart TV with Netflix and HBO.

There is also a dedicated workspace with a monitor for remote work.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Hay Wi-Fi. Por ahora, el nombre de la red y la contraseña vienen con tu reserva, así que no están en esta página.

Hay una smart TV con Netflix y HBO.

También hay un espacio de trabajo con un monitor para trabajar a distancia.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Wi-Fi is available. The network name and password come with your reservation for now, so they are not on this page.

There is a smart TV with Netflix and HBO.

There is also a dedicated workspace with a monitor for remote work.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Wi-Fi et la TV$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Wi-Fi is available. The network name and password come with your reservation for now, so they are not on this page.

There is a smart TV with Netflix and HBO.

There is also a dedicated workspace with a monitor for remote work.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Le Wi-Fi est là. Pour l'instant, le nom du réseau et le mot de passe arrivent avec votre réservation, ils ne sont donc pas sur cette page.

Il y a une smart TV avec Netflix et HBO.

Il y a aussi un espace de travail avec un écran pour le travail à distance.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Wi-Fi and the TV$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Wi-Fi is available. The network name and password come with your reservation for now, so they are not on this page.

There is a smart TV with Netflix and HBO.

There is also a dedicated workspace with a monitor for remote work.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$El apartamento$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$The apartment$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Onion Ranch sleeps up to 4.

Bedroom 1 has a double bed. Bedroom 2 has a queen bed. There is 1 bathroom, up a flight of stairs. The kitchen is a full kitchen. There is office space with a monitor for remote work.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$The Onion Ranch duerme hasta 4.

El Dormitorio 1 tiene una cama doble. El Dormitorio 2 tiene una cama queen. Hay 1 baño, al final de un tramo de escaleras. La cocina está completa. Hay un espacio de oficina con un monitor para trabajar a distancia.

El baño está al final de un tramo de escaleras, así que el apartamento no es accesible para quien no pueda usar escaleras.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$The apartment$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Onion Ranch sleeps up to 4.

Bedroom 1 has a double bed. Bedroom 2 has a queen bed. There is 1 bathroom, up a flight of stairs. The kitchen is a full kitchen. There is office space with a monitor for remote work.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$L'appartement$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$The apartment$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Onion Ranch sleeps up to 4.

Bedroom 1 has a double bed. Bedroom 2 has a queen bed. There is 1 bathroom, up a flight of stairs. The kitchen is a full kitchen. There is office space with a monitor for remote work.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$The Onion Ranch accueille jusqu'à 4 personnes.

La Chambre 1 a un lit double. La Chambre 2 a un lit queen. Il y a 1 salle de bain, en haut d'un escalier. La cuisine est complète. Il y a un espace bureau avec un écran pour le travail à distance.

La salle de bain est en haut d'un escalier, donc l'appartement n'est pas accessible aux personnes qui ne peuvent pas utiliser d'escalier.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$The apartment$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Onion Ranch sleeps up to 4.

Bedroom 1 has a double bed. Bedroom 2 has a queen bed. There is 1 bathroom, up a flight of stairs. The kitchen is a full kitchen. There is office space with a monitor for remote work.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Qué hay aquí$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The kitchen is a full kitchen, with a stove, an oven, and a drip coffee maker.

There is office space with a monitor for remote work.

The smart TV has Netflix and HBO. Wi-Fi details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$La cocina está completa, con fogones, horno y una cafetera de filtro.

Hay un espacio de oficina con un monitor para trabajar a distancia.

La smart TV tiene Netflix y HBO. Los datos del Wi-Fi vienen con tu reserva.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The kitchen is a full kitchen, with a stove, an oven, and a drip coffee maker.

There is office space with a monitor for remote work.

The smart TV has Netflix and HBO. Wi-Fi details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Ce qu'il y a ici$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The kitchen is a full kitchen, with a stove, an oven, and a drip coffee maker.

There is office space with a monitor for remote work.

The smart TV has Netflix and HBO. Wi-Fi details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$La cuisine est complète, avec une cuisinière, un four et une cafetière filtre.

Il y a un espace bureau avec un écran pour le travail à distance.

La smart TV a Netflix et HBO. Les détails du Wi-Fi arrivent avec votre réservation.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$What is here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The kitchen is a full kitchen, with a stove, an oven, and a drip coffee maker.

There is office space with a monitor for remote work.

The smart TV has Netflix and HBO. Wi-Fi details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Ten en cuenta$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Please keep in mind$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Pets are welcome.

No parties. The fine is $1,000.

Parking is free on site.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Las mascotas son bienvenidas.

No hay fiestas. La multa es $1,000.

El aparcamiento es gratis en la casa.

El baño está al final de un tramo de escaleras, así que el apartamento no es accesible para quien no pueda usar escaleras.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Please keep in mind$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Pets are welcome.

No parties. The fine is $1,000.

Parking is free on site.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$À garder en tête$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Please keep in mind$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Pets are welcome.

No parties. The fine is $1,000.

Parking is free on site.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les animaux sont les bienvenus.

Pas de fêtes. L'amende est de $1,000.

Le stationnement est gratuit sur place.

La salle de bain est en haut d'un escalier, donc l'appartement n'est pas accessible aux personnes qui ne peuvent pas utiliser d'escalier.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Please keep in mind$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Pets are welcome.

No parties. The fine is $1,000.

Parking is free on site.

The bathroom is up a flight of stairs, so the apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Lugares que nos gustan$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Places we like$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are a few places we like around Winooski. Addresses, websites, and hours are details coming soon.

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Estos son algunos lugares que nos gustan por Winooski. Las direcciones, las webs y los horarios llegarán pronto.

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Places we like$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are a few places we like around Winooski. Addresses, websites, and hours are details coming soon.

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Des endroits qu'on aime$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Places we like$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are a few places we like around Winooski. Addresses, websites, and hours are details coming soon.

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Voici quelques endroits qu'on aime autour de Winooski. Les adresses, les sites et les horaires arrivent bientôt.

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Places we like$tr$
  and coalesce(b.body->>'markdown', '') = $tr$These are a few places we like around Winooski. Addresses, websites, and hours are details coming soon.

- Waterworks
- Our House
- Mule Bar
- Onion City Chicken & Oysters
- Four Quarters Brewery
- Scout Coffee
- Winooski Falls and river trails$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Mientras estés aquí$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$While you are here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques.

Burlington is about a 10-minute drive. You will find more places to eat, Lake Champlain, and lots to explore.

The Winooski River and Winooski Falls are nearby.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$El Winooski Circle queda a unos 5 minutos a pie, con restaurantes, cafeterías, bares y tiendas.

Burlington está a unos 10 minutos en coche. Encontrarás más sitios para comer, Lake Champlain y mucho por explorar.

El Winooski River y Winooski Falls están cerca.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$While you are here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques.

Burlington is about a 10-minute drive. You will find more places to eat, Lake Champlain, and lots to explore.

The Winooski River and Winooski Falls are nearby.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Pendant votre séjour$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$While you are here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques.

Burlington is about a 10-minute drive. You will find more places to eat, Lake Champlain, and lots to explore.

The Winooski River and Winooski Falls are nearby.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Le Winooski Circle est à environ 5 minutes à pied, avec des restaurants, des cafés, des bars et des boutiques.

Burlington est à environ 10 minutes en voiture. Vous y trouverez d'autres endroits pour manger, Lake Champlain et beaucoup à explorer.

Le Winooski River et Winooski Falls sont tout près.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$While you are here$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The Winooski Circle is about a 5-minute walk, with restaurants, coffee shops, bars, and boutiques.

Burlington is about a 10-minute drive. You will find more places to eat, Lake Champlain, and lots to explore.

The Winooski River and Winooski Falls are nearby.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Escaleras hasta el baño$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Stairs to the bathroom$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The bathroom is up a flight of stairs. The apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$El baño está al final de un tramo de escaleras. El apartamento no es accesible para quien no pueda usar escaleras.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Stairs to the bathroom$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The bathroom is up a flight of stairs. The apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Escaliers jusqu'à la salle de bain$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Stairs to the bathroom$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The bathroom is up a flight of stairs. The apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$La salle de bain est en haut d'un escalier. L'appartement n'est pas accessible aux personnes qui ne peuvent pas utiliser d'escalier.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Stairs to the bathroom$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The bathroom is up a flight of stairs. The apartment is not accessible for guests who can't use stairs.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Antes de irte$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Pronto estarán los pasos de salida, la basura y el termostato.

Escríbenos por Airbnb si necesitas algo de eso antes de que esté publicado.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Avant de partir$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les étapes de départ, les poubelles et le thermostat arrivent bientôt.

Écrivez-nous sur Airbnb si vous en avez besoin avant que ce soit publié.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Before you leave$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon for checkout steps, trash, and the thermostat.

Message us on Airbnb if you need any of that before it is posted.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Preguntas$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message. We usually reply within an hour.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Los detalles llegarán pronto.

Si necesitas una respuesta antes, envíanos un mensaje de Airbnb. Normalmente respondemos en una hora.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message. We usually reply within an hour.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Questions$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message. We usually reply within an hour.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Les détails arrivent bientôt.

Si vous avez besoin d'une réponse avant, envoyez-nous un message Airbnb. Nous répondons en général dans l'heure.$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Questions$tr$
  and coalesce(b.body->>'markdown', '') = $tr$Details coming soon.

If you need an answer before then, send us an Airbnb message. We usually reply within an hour.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Escribe a tus anfitriones$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The best way to reach us is an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/862913226430309914/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$La mejor forma de escribirnos es un mensaje de Airbnb. Normalmente respondemos en una hora.

[Escríbenos por Airbnb](https://www.airbnb.com/contact_host/862913226430309914/send_message)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The best way to reach us is an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/862913226430309914/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Écrivez à vos hôtes$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The best way to reach us is an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/862913226430309914/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Le meilleur moyen de nous joindre est un message Airbnb. Nous répondons en général dans l'heure.

[Écrivez-nous sur Airbnb](https://www.airbnb.com/contact_host/862913226430309914/send_message)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Message your hosts$tr$
  and coalesce(b.body->>'markdown', '') = $tr$The best way to reach us is an Airbnb message. We usually reply within an hour.

[Message us on Airbnb](https://www.airbnb.com/contact_host/862913226430309914/send_message)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$Vuelve$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Onion Ranch.

[Book The Onion Ranch on Airbnb](https://www.airbnb.com/rooms/862913226430309914)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'es', $tr$Nos encantaría recibirte otra vez en The Onion Ranch.

[Reserva The Onion Ranch en Airbnb](https://www.airbnb.com/rooms/862913226430309914)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Onion Ranch.

[Book The Onion Ranch on Airbnb](https://www.airbnb.com/rooms/862913226430309914)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$Revenez$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Onion Ranch.

[Book The Onion Ranch on Airbnb](https://www.airbnb.com/rooms/862913226430309914)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'markdown', 'fr', $tr$Nous serions ravis de vous recevoir à nouveau à The Onion Ranch.

[Réservez The Onion Ranch sur Airbnb](https://www.airbnb.com/rooms/862913226430309914)$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = $tr$Come back$tr$
  and coalesce(b.body->>'markdown', '') = $tr$We would love to host you again at The Onion Ranch.

[Book The Onion Ranch on Airbnb](https://www.airbnb.com/rooms/862913226430309914)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Cocina$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Kitchen$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Cocina completa con cocina de gas y lavavajillas.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Kitchen$tr$ and a.description = $tr$Fully equipped kitchen with a gas stove and a dishwasher.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Cuisine$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Kitchen$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Cuisine complète avec cuisinière au gaz et lave-vaisselle.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Kitchen$tr$ and a.description = $tr$Fully equipped kitchen with a gas stove and a dishwasher.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Chimenea eléctrica$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Electric fireplace$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$En el salón.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Electric fireplace$tr$ and a.description = $tr$In the living room.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Cheminée électrique$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Electric fireplace$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Dans le salon.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Electric fireplace$tr$ and a.description = $tr$In the living room.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Calefacción de propano$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Propane heat$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$La casa se calienta con propano.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Propane heat$tr$ and a.description = $tr$The house is heated with propane.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Chauffage au propane$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Propane heat$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$La maison est chauffée au propane.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Propane heat$tr$ and a.description = $tr$The house is heated with propane.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Aire acondicionado$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Air conditioning$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$La casa tiene aire acondicionado.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Air conditioning$tr$ and a.description = $tr$The house has air conditioning.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Climatisation$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Air conditioning$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$La maison a la climatisation.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Air conditioning$tr$ and a.description = $tr$The house has air conditioning.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Lavadora y secadora$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Washer and dryer$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$En el lavadero.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Washer and dryer$tr$ and a.description = $tr$In the laundry room.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Lave-linge et sèche-linge$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Washer and dryer$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Dans la buanderie.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Washer and dryer$tr$ and a.description = $tr$In the laundry room.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Porche delantero$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Front porch$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Para el café de la mañana o una copa por la noche.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Front porch$tr$ and a.description = $tr$For morning coffee or evening drinks.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Porche$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Front porch$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Pour le café du matin ou un verre le soir.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Front porch$tr$ and a.description = $tr$For morning coffee or evening drinks.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Smart TV$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Smart TV$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$En el salón, con Netflix y HBO incluidos.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Smart TV$tr$ and a.description = $tr$In the living room, with Netflix and HBO included.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Smart TV$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Smart TV$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Dans le salon, avec Netflix et HBO inclus.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'raddish-roost' and a.name = $tr$Smart TV$tr$ and a.description = $tr$In the living room, with Netflix and HBO included.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Cocina$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Kitchen$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$En la planta baja.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Kitchen$tr$ and a.description = $tr$On the ground floor.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Cuisine$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Kitchen$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Au rez-de-chaussée.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Kitchen$tr$ and a.description = $tr$On the ground floor.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$TV$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$TV$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Hay una TV.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$TV$tr$ and a.description = $tr$A TV is available.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$TV$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$TV$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Une TV est là.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$TV$tr$ and a.description = $tr$A TV is available.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Wi-Fi$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Wi-Fi$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Los datos de la red vienen con tu reserva.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Wi-Fi$tr$ and a.description = $tr$Network details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Wi-Fi$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Wi-Fi$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Les détails du réseau arrivent avec votre réservation.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Wi-Fi$tr$ and a.description = $tr$Network details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Tapones para los oídos$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Earplugs$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Los tienes a mano. Dos dormitorios dan a la calle principal, y la calle puede ser ruidosa por la noche.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Earplugs$tr$ and a.description = $tr$Provided. Two bedrooms face the main street, and the street can be noisy at night.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Bouchons d'oreilles$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Earplugs$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Ils sont fournis. Deux chambres donnent sur la rue principale, et la rue peut être bruyante la nuit.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Earplugs$tr$ and a.description = $tr$Provided. Two bedrooms face the main street, and the street can be noisy at night.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Aparcamiento$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Parking$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Aparcamiento gratis en la casa para 1 vehículo. Los coches de más pueden usar el aparcamiento gratis en la calle.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Parking$tr$ and a.description = $tr$Free on-site parking for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Stationnement$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Parking$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Stationnement gratuit sur place pour 1 véhicule. Les voitures supplémentaires peuvent se garer gratuitement dans la rue.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'shallot-chalet' and a.name = $tr$Parking$tr$ and a.description = $tr$Free on-site parking for 1 vehicle. Additional cars can use free street parking.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Cocina completa$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Full kitchen$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Fogones, horno y una cafetera de filtro.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Full kitchen$tr$ and a.description = $tr$Stove, oven, and a drip coffee maker.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Cuisine complète$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Full kitchen$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Cuisinière, four et une cafetière filtre.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Full kitchen$tr$ and a.description = $tr$Stove, oven, and a drip coffee maker.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Wi-Fi$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Wi-Fi$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Los datos de la red vienen con tu reserva.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Wi-Fi$tr$ and a.description = $tr$Network details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Wi-Fi$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Wi-Fi$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Les détails du réseau arrivent avec votre réservation.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Wi-Fi$tr$ and a.description = $tr$Network details come with your reservation.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Smart TV$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Smart TV$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Netflix y HBO.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Smart TV$tr$ and a.description = $tr$Netflix and HBO.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Smart TV$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Smart TV$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Netflix et HBO.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Smart TV$tr$ and a.description = $tr$Netflix and HBO.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Espacio de trabajo$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Workspace$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Un espacio de oficina con un monitor para trabajar a distancia.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Workspace$tr$ and a.description = $tr$Office space with a monitor for remote work.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Espace de travail$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Workspace$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Un espace bureau avec un écran pour le travail à distance.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Workspace$tr$ and a.description = $tr$Office space with a monitor for remote work.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'es', $tr$Aparcamiento gratis$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Free parking$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'es', $tr$Aparcamiento gratis en la casa.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Free parking$tr$ and a.description = $tr$Free parking on site.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'name', 'fr', $tr$Stationnement gratuit$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Free parking$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'amenities', a.id, 'description', 'fr', $tr$Stationnement gratuit sur place.$tr$
from public.amenities a
join public.properties p on p.id = a.property_id
where p.slug = 'onion-ranch' and a.name = $tr$Free parking$tr$ and a.description = $tr$Free parking on site.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Los detalles llegarán pronto$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'raddish-roost' and c.label = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'es', $tr$Los pasos de salida, la basura y las instrucciones del termostato llegarán pronto. Escríbenos por Airbnb si los necesitas antes.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'raddish-roost' and c.details = 'Checkout steps, trash, and thermostat instructions are coming soon. Message us on Airbnb if you need them before then.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$Les détails arrivent bientôt$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'raddish-roost' and c.label = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'fr', $tr$Les étapes de départ, les poubelles et les instructions du thermostat arrivent bientôt. Écrivez-nous sur Airbnb si vous en avez besoin avant.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'raddish-roost' and c.details = 'Checkout steps, trash, and thermostat instructions are coming soon. Message us on Airbnb if you need them before then.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Los detalles llegarán pronto$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'shallot-chalet' and c.label = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'es', $tr$Los pasos de salida, la basura y las instrucciones del termostato llegarán pronto. Escríbenos por Airbnb si los necesitas antes.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'shallot-chalet' and c.details = 'Checkout steps, trash, and thermostat instructions are coming soon. Message us on Airbnb if you need them before then.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$Les détails arrivent bientôt$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'shallot-chalet' and c.label = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'fr', $tr$Les étapes de départ, les poubelles et les instructions du thermostat arrivent bientôt. Écrivez-nous sur Airbnb si vous en avez besoin avant.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'shallot-chalet' and c.details = 'Checkout steps, trash, and thermostat instructions are coming soon. Message us on Airbnb if you need them before then.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'es', $tr$Los detalles llegarán pronto$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'onion-ranch' and c.label = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'es', $tr$Los pasos de salida, la basura y las instrucciones del termostato llegarán pronto. Escríbenos por Airbnb si los necesitas antes.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'onion-ranch' and c.details = 'Checkout steps, trash, and thermostat instructions are coming soon. Message us on Airbnb if you need them before then.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'label', 'fr', $tr$Les détails arrivent bientôt$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'onion-ranch' and c.label = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'checkout_items', c.id, 'details', 'fr', $tr$Les étapes de départ, les poubelles et les instructions du thermostat arrivent bientôt. Écrivez-nous sur Airbnb si vous en avez besoin avant.$tr$
from public.checkout_items c
join public.properties p on p.id = c.property_id
where p.slug = 'onion-ranch' and c.details = 'Checkout steps, trash, and thermostat instructions are coming soon. Message us on Airbnb if you need them before then.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'contact_channels', c.id, 'label', 'es', $tr$Escríbenos por Airbnb$tr$
from public.contact_channels c
join public.properties p on p.id = c.property_id
where p.slug = 'raddish-roost' and c.label = 'Message us on Airbnb'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'contact_channels', c.id, 'label', 'fr', $tr$Écrivez-nous sur Airbnb$tr$
from public.contact_channels c
join public.properties p on p.id = c.property_id
where p.slug = 'raddish-roost' and c.label = 'Message us on Airbnb'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'question', 'es', $tr$Los detalles llegarán pronto$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'raddish-roost' and f.question = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'answer', 'es', $tr$Las preguntas frecuentes todavía no están publicadas. Envíanos un mensaje de Airbnb si necesitas algo.$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'raddish-roost' and f.answer = 'Common questions are not posted yet. Send us an Airbnb message if you need something.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'question', 'fr', $tr$Les détails arrivent bientôt$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'raddish-roost' and f.question = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'answer', 'fr', $tr$Les questions fréquentes ne sont pas encore publiées. Envoyez-nous un message Airbnb si vous avez besoin de quelque chose.$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'raddish-roost' and f.answer = 'Common questions are not posted yet. Send us an Airbnb message if you need something.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'contact_channels', c.id, 'label', 'es', $tr$Escríbenos por Airbnb$tr$
from public.contact_channels c
join public.properties p on p.id = c.property_id
where p.slug = 'shallot-chalet' and c.label = 'Message us on Airbnb'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'contact_channels', c.id, 'label', 'fr', $tr$Écrivez-nous sur Airbnb$tr$
from public.contact_channels c
join public.properties p on p.id = c.property_id
where p.slug = 'shallot-chalet' and c.label = 'Message us on Airbnb'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'question', 'es', $tr$Los detalles llegarán pronto$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'shallot-chalet' and f.question = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'answer', 'es', $tr$Las preguntas frecuentes todavía no están publicadas. Envíanos un mensaje de Airbnb si necesitas algo.$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'shallot-chalet' and f.answer = 'Common questions are not posted yet. Send us an Airbnb message if you need something.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'question', 'fr', $tr$Les détails arrivent bientôt$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'shallot-chalet' and f.question = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'answer', 'fr', $tr$Les questions fréquentes ne sont pas encore publiées. Envoyez-nous un message Airbnb si vous avez besoin de quelque chose.$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'shallot-chalet' and f.answer = 'Common questions are not posted yet. Send us an Airbnb message if you need something.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'contact_channels', c.id, 'label', 'es', $tr$Escríbenos por Airbnb$tr$
from public.contact_channels c
join public.properties p on p.id = c.property_id
where p.slug = 'onion-ranch' and c.label = 'Message us on Airbnb'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'contact_channels', c.id, 'label', 'fr', $tr$Écrivez-nous sur Airbnb$tr$
from public.contact_channels c
join public.properties p on p.id = c.property_id
where p.slug = 'onion-ranch' and c.label = 'Message us on Airbnb'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'question', 'es', $tr$Los detalles llegarán pronto$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'onion-ranch' and f.question = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'answer', 'es', $tr$Las preguntas frecuentes todavía no están publicadas. Envíanos un mensaje de Airbnb si necesitas algo.$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'onion-ranch' and f.answer = 'Common questions are not posted yet. Send us an Airbnb message if you need something.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'question', 'fr', $tr$Les détails arrivent bientôt$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'onion-ranch' and f.question = 'Details coming soon'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'faqs', f.id, 'answer', 'fr', $tr$Les questions fréquentes ne sont pas encore publiées. Envoyez-nous un message Airbnb si vous avez besoin de quelque chose.$tr$
from public.faqs f
join public.properties p on p.id = f.property_id
where p.slug = 'onion-ranch' and f.answer = 'Common questions are not posted yet. Send us an Airbnb message if you need something.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'es', $tr$Supermercado$tr$
from public.nearby_essentials n
where n.kind = 'grocery' and n.label = $tr$Grocery store$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'fr', $tr$Épicerie$tr$
from public.nearby_essentials n
where n.kind = 'grocery' and n.label = $tr$Grocery store$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'es', $tr$Farmacia$tr$
from public.nearby_essentials n
where n.kind = 'pharmacy' and n.label = $tr$Pharmacy$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'fr', $tr$Pharmacie$tr$
from public.nearby_essentials n
where n.kind = 'pharmacy' and n.label = $tr$Pharmacy$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'es', $tr$Gasolinera$tr$
from public.nearby_essentials n
where n.kind = 'gas' and n.label = $tr$Gas station$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'fr', $tr$Station-service$tr$
from public.nearby_essentials n
where n.kind = 'gas' and n.label = $tr$Gas station$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'es', $tr$Urgencias menores$tr$
from public.nearby_essentials n
where n.kind = 'urgent_care' and n.label = $tr$Urgent care$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'fr', $tr$Soins urgents$tr$
from public.nearby_essentials n
where n.kind = 'urgent_care' and n.label = $tr$Urgent care$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'es', $tr$Hospital (urgencias)$tr$
from public.nearby_essentials n
where n.kind = 'hospital' and n.label = $tr$Hospital (ER)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'label', 'fr', $tr$Hôpital (urgences)$tr$
from public.nearby_essentials n
where n.kind = 'hospital' and n.label = $tr$Hospital (ER)$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'note', 'es', $tr$En una emergencia, llama al 911.$tr$
from public.nearby_essentials n
where n.note = 'For emergencies, call 911.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'nearby_essentials', n.id, 'note', 'fr', $tr$En cas d'urgence, appelez le 911.$tr$
from public.nearby_essentials n
where n.note = 'For emergencies, call 911.'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Mañana$tr$
from public.itinerary_stops st
where st.time_label = $tr$Morning$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Matin$tr$
from public.itinerary_stops st
where st.time_label = $tr$Morning$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Media mañana$tr$
from public.itinerary_stops st
where st.time_label = $tr$Mid-morning$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Milieu de matinée$tr$
from public.itinerary_stops st
where st.time_label = $tr$Mid-morning$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Final de la mañana$tr$
from public.itinerary_stops st
where st.time_label = $tr$Late morning$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Fin de matinée$tr$
from public.itinerary_stops st
where st.time_label = $tr$Late morning$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Comida$tr$
from public.itinerary_stops st
where st.time_label = $tr$Lunch$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Déjeuner$tr$
from public.itinerary_stops st
where st.time_label = $tr$Lunch$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Tarde$tr$
from public.itinerary_stops st
where st.time_label = $tr$Afternoon$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Après-midi$tr$
from public.itinerary_stops st
where st.time_label = $tr$Afternoon$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Final de la tarde$tr$
from public.itinerary_stops st
where st.time_label = $tr$Late afternoon$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Fin d'après-midi$tr$
from public.itinerary_stops st
where st.time_label = $tr$Late afternoon$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Cena$tr$
from public.itinerary_stops st
where st.time_label = $tr$Dinner$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Dîner$tr$
from public.itinerary_stops st
where st.time_label = $tr$Dinner$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Día$tr$
from public.itinerary_stops st
where st.time_label = $tr$Day$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Journée$tr$
from public.itinerary_stops st
where st.time_label = $tr$Day$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Après$tr$
from public.itinerary_stops st
where st.time_label = $tr$Après$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Après$tr$
from public.itinerary_stops st
where st.time_label = $tr$Après$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Noche$tr$
from public.itinerary_stops st
where st.time_label = $tr$Night$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Soir$tr$
from public.itinerary_stops st
where st.time_label = $tr$Night$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Atardecer$tr$
from public.itinerary_stops st
where st.time_label = $tr$Sunset$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Coucher du soleil$tr$
from public.itinerary_stops st
where st.time_label = $tr$Sunset$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Última copa$tr$
from public.itinerary_stops st
where st.time_label = $tr$Nightcap$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Dernier verre$tr$
from public.itinerary_stops st
where st.time_label = $tr$Nightcap$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'es', $tr$Después de cenar$tr$
from public.itinerary_stops st
where st.time_label = $tr$After dinner$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'time_label', 'fr', $tr$Après le dîner$tr$
from public.itinerary_stops st
where st.time_label = $tr$After dinner$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itineraries', i.id, 'title', 'es', $tr$Nuestro día perfecto$tr$
from public.itineraries i
where i.title = 'Our perfect day'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itineraries', i.id, 'title', 'fr', $tr$Notre journée parfaite$tr$
from public.itineraries i
where i.title = 'Our perfect day'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Un café y un pastel, a un paseo corto de la casa.$tr$
from public.itinerary_stops st
where st.detail = $tr$Coffee and a pastry, a short walk from the house.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Un café et une pâtisserie, à une courte marche de la maison.$tr$
from public.itinerary_stops st
where st.detail = $tr$Coffee and a pastry, a short walk from the house.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Sidra fresca y donuts de sidra.$tr$
from public.itinerary_stops st
where st.detail = $tr$Fresh cider and cider donuts.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Du cidre frais et des beignets au cidre.$tr$
from public.itinerary_stops st
where st.detail = $tr$Fresh cider and cider donuts.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Una caminata con grandes vistas del follaje.$tr$
from public.itinerary_stops st
where st.detail = $tr$Hike for big foliage views.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Une randonnée pour de belles vues sur le feuillage.$tr$
from public.itinerary_stops st
where st.detail = $tr$Hike for big foliage views.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Pasta fresca.$tr$
from public.itinerary_stops st
where st.detail = $tr$Fresh pasta.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Des pâtes fraîches.$tr$
from public.itinerary_stops st
where st.detail = $tr$Fresh pasta.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Un paseo en coche por Stowe.$tr$
from public.itinerary_stops st
where st.detail = $tr$A scenic drive through Stowe.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Une route panoramique à travers Stowe.$tr$
from public.itinerary_stops st
where st.detail = $tr$A scenic drive through Stowe.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Una parada después del paseo.$tr$
from public.itinerary_stops st
where st.detail = $tr$A stop after the drive.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Un arrêt après la route.$tr$
from public.itinerary_stops st
where st.detail = $tr$A stop after the drive.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Una visita y muestras.$tr$
from public.itinerary_stops st
where st.detail = $tr$A tour and samples.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Une visite et des dégustations.$tr$
from public.itinerary_stops st
where st.detail = $tr$A tour and samples.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Cena, y después una cerveza en la cervecería de atrás.$tr$
from public.itinerary_stops st
where st.detail = $tr$Dinner, then a beer at the brewery around the back.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Le dîner, puis une bière à la brasserie derrière.$tr$
from public.itinerary_stops st
where st.detail = $tr$Dinner, then a beer at the brewery around the back.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Bagels para empezar el día.$tr$
from public.itinerary_stops st
where st.detail = $tr$Bagels to start the day.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Des bagels pour commencer la journée.$tr$
from public.itinerary_stops st
where st.detail = $tr$Bagels to start the day.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Esquía o haz snowboard todo el día.$tr$
from public.itinerary_stops st
where st.detail = $tr$Ski or ride for the day.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Skiez ou surfez toute la journée.$tr$
from public.itinerary_stops st
where st.detail = $tr$Ski or ride for the day.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Una pinta y algo sencillo para picar.$tr$
from public.itinerary_stops st
where st.detail = $tr$A pint and casual bites.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Une pinte et de quoi grignoter.$tr$
from public.itinerary_stops st
where st.detail = $tr$A pint and casual bites.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Cena en el pub.$tr$
from public.itinerary_stops st
where st.detail = $tr$Dinner at the pub.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Dîner au pub.$tr$
from public.itinerary_stops st
where st.detail = $tr$Dinner at the pub.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Esquiar de noche es una buena alternativa a acostarte pronto.$tr$
from public.itinerary_stops st
where st.detail = $tr$Night skiing is a fun alternative to an early night.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Le ski de nuit est une belle alternative à une soirée tranquille.$tr$
from public.itinerary_stops st
where st.detail = $tr$Night skiing is a fun alternative to an early night.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Un café para empezar la mañana.$tr$
from public.itinerary_stops st
where st.detail = $tr$Coffee to start the morning.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Un café pour commencer la matinée.$tr$
from public.itinerary_stops st
where st.detail = $tr$Coffee to start the morning.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Un paseo junto a la cascada y los senderos del río.$tr$
from public.itinerary_stops st
where st.detail = $tr$A walk along the falls and the river trails.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Une promenade le long de la cascade et des sentiers de la rivière.$tr$
from public.itinerary_stops st
where st.detail = $tr$A walk along the falls and the river trails.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Camina los senderos y los jardines junto al lago.$tr$
from public.itinerary_stops st
where st.detail = $tr$Walk the trails and gardens on the lake.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Marchez les sentiers et les jardins au bord du lac.$tr$
from public.itinerary_stops st
where st.detail = $tr$Walk the trails and gardens on the lake.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Comida en Church Street.$tr$
from public.itinerary_stops st
where st.detail = $tr$Lunch on Church Street.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Déjeuner sur Church Street.$tr$
from public.itinerary_stops st
where st.detail = $tr$Lunch on Church Street.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Pasea por Church Street después de comer.$tr$
from public.itinerary_stops st
where st.detail = $tr$Stroll Church Street after lunch.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Flânez sur Church Street après le déjeuner.$tr$
from public.itinerary_stops st
where st.detail = $tr$Stroll Church Street after lunch.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Una caminata con vistas a Lake Champlain.$tr$
from public.itinerary_stops st
where st.detail = $tr$A hike with Lake Champlain views.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Une randonnée avec vue sur Lake Champlain.$tr$
from public.itinerary_stops st
where st.detail = $tr$A hike with Lake Champlain views.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Una copa al atardecer.$tr$
from public.itinerary_stops st
where st.detail = $tr$Drinks at sunset.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Un verre au coucher du soleil.$tr$
from public.itinerary_stops st
where st.detail = $tr$Drinks at sunset.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Cena de vuelta en Winooski.$tr$
from public.itinerary_stops st
where st.detail = $tr$Dinner back in Winooski.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Dîner de retour à Winooski.$tr$
from public.itinerary_stops st
where st.detail = $tr$Dinner back in Winooski.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Música en vivo.$tr$
from public.itinerary_stops st
where st.detail = $tr$Live music.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Musique live.$tr$
from public.itinerary_stops st
where st.detail = $tr$Live music.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Caminar con raquetas por los senderos.$tr$
from public.itinerary_stops st
where st.detail = $tr$Snowshoe the trails.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Raquettes sur les sentiers.$tr$
from public.itinerary_stops st
where st.detail = $tr$Snowshoe the trails.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Cerveza artesanal.$tr$
from public.itinerary_stops st
where st.detail = $tr$Craft beer.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Bière artisanale.$tr$
from public.itinerary_stops st
where st.detail = $tr$Craft beer.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Cena. Reserva con tiempo.$tr$
from public.itinerary_stops st
where st.detail = $tr$Dinner. Book well in advance.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Dîner. Réservez bien à l'avance.$tr$
from public.itinerary_stops st
where st.detail = $tr$Dinner. Book well in advance.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'es', $tr$Un espectáculo.$tr$
from public.itinerary_stops st
where st.detail = $tr$A show.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'itinerary_stops', st.id, 'detail', 'fr', $tr$Un spectacle.$tr$
from public.itinerary_stops st
where st.detail = $tr$A show.$tr$
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$La llegada$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Aparca en un sitio marcado.","detail":"El aparcamiento es gratis en la casa. El camino de entrada se comparte con los vecinos, así que aparca solo en los sitios marcados."},{"title":"Usa la puerta con código.","detail":"Tu código llega por los mensajes de Airbnb el día de la llegada."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$L'arrivée$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Garez-vous sur une place indiquée.","detail":"Le stationnement est gratuit sur place. L'allée est partagée avec les voisins, alors garez-vous seulement sur les places indiquées."},{"title":"Utilisez la porte à code.","detail":"Votre code arrive dans les messages Airbnb le jour de l'arrivée."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'raddish-roost'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$La llegada$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Revisa tus mensajes de Airbnb.","detail":"Las instrucciones de acceso están en tus mensajes de Airbnb. Los pasos de llegada en esta página llegarán pronto."},{"title":"Aparca.","detail":"Aparcamiento gratis en la casa para 1 vehículo. Los coches de más pueden usar el aparcamiento gratis en la calle."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$L'arrivée$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Regardez vos messages Airbnb.","detail":"Les instructions d'accès sont dans vos messages Airbnb. Les étapes d'arrivée sur cette page arrivent bientôt."},{"title":"Garez-vous.","detail":"Stationnement gratuit sur place pour 1 véhicule. Les voitures supplémentaires peuvent se garer gratuitement dans la rue."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'shallot-chalet'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'es', $tr$La llegada$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'es', $tr$[{"title":"Aparca en la casa.","detail":"El aparcamiento es gratis en la casa."},{"title":"Usa la puerta con código.","detail":"No necesitas llave. Tu código llega por tus mensajes de Airbnb."},{"title":"Horarios de llegada y salida.","detail":"La llegada es a las 4:00 PM. La salida es a las 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'title', 'fr', $tr$L'arrivée$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'guidebook_blocks', b.id, 'steps', 'fr', $tr$[{"title":"Garez-vous sur place.","detail":"Le stationnement est gratuit sur place."},{"title":"Utilisez la porte à code.","detail":"Vous n'avez pas besoin de clé. Votre code arrive dans vos messages Airbnb."},{"title":"Horaires d'arrivée et de départ.","detail":"L'arrivée est à 4:00 PM. Le départ est à 10:00 AM."}]$tr$
from public.guidebook_blocks b
join public.guidebook_sections s on s.id = b.section_id
join public.properties p on p.id = s.property_id
where p.slug = 'onion-ranch'
  and b.title = 'Arriving'
  and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un restaurante animado en un molino restaurado, justo junto al río Winooski, con ventanales que dan a la cascada. Ideal para cenar, tomar algo o alargar la comida.$tr$
from public.recommendations r
where r.name = $tr$Waterworks Food + Drink$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Las steak frites están para morirse. Pide una mesa junto a las ventanas.$tr$
from public.recommendations r
where r.name = $tr$Waterworks Food + Drink$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un restaurant animé dans un moulin restauré, juste au bord de la rivière Winooski, avec de grandes fenêtres sur la cascade. Parfait pour dîner, boire un verre ou prolonger le déjeuner.$tr$
from public.recommendations r
where r.name = $tr$Waterworks Food + Drink$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Les steak frites sont à tomber. Demandez une table près des fenêtres.$tr$
from public.recommendations r
where r.name = $tr$Waterworks Food + Drink$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un local vietnamita sin pretensiones que la gente del pueblo recomienda para boles grandes y reconfortantes de pho y platos clásicos.$tr$
from public.recommendations r
where r.name = $tr$Pho Hong$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$El mejor vietnamita del pueblo. Sobre todo gente local, y va muy bien para llevar en una noche fría.$tr$
from public.recommendations r
where r.name = $tr$Pho Hong$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse vietnamienne simple, que les gens du coin recommandent pour de grands bols réconfortants de pho et des plats classiques.$tr$
from public.recommendations r
where r.name = $tr$Pho Hong$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Le meilleur vietnamien du coin. Surtout des habitués, et c'est parfait à emporter par une nuit froide.$tr$
from public.recommendations r
where r.name = $tr$Pho Hong$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un italiano acogedor, a la luz de las velas, con cocina rústica del norte de Italia y un aire cálido de otro tiempo. Ideal para una cena sin prisa.$tr$
from public.recommendations r
where r.name = $tr$Trattoria Delia$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Pasa por Sotto, el bar de vinos de al lado, para una copa antes o después.$tr$
from public.recommendations r
where r.name = $tr$Trattoria Delia$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un italien chaleureux, aux chandelles, avec une cuisine rustique du nord de l'Italie et une atmosphère d'un autre temps. Parfait pour un dîner sans se presser.$tr$
from public.recommendations r
where r.name = $tr$Trattoria Delia$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Passez par Sotto, le bar à vin d'à côté, pour un verre avant ou après.$tr$
from public.recommendations r
where r.name = $tr$Trattoria Delia$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un restaurante pequeño e íntimo de tapas, hecho para compartir platos y probar un poco de todo.$tr$
from public.recommendations r
where r.name = $tr$Restaurant Poco$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Es pequeño y solo entras sin reserva, así que ve temprano o prepárate para esperar con una copa.$tr$
from public.recommendations r
where r.name = $tr$Restaurant Poco$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un petit restaurant de tapas, intime, fait pour partager des assiettes et goûter un peu de tout.$tr$
from public.recommendations r
where r.name = $tr$Restaurant Poco$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$C'est petit et sans réservation, alors venez tôt ou soyez prêt à attendre avec un verre.$tr$
from public.recommendations r
where r.name = $tr$Restaurant Poco$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Comida y bebidas cubanas de verdad, en un ambiente relajado y cercano. Platos contundentes, sabores vivos y buenos cócteles.$tr$
from public.recommendations r
where r.name = $tr$Santiago's Cuban Cuisine$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Auténtico y delicioso. Ven con hambre.$tr$
from public.recommendations r
where r.name = $tr$Santiago's Cuban Cuisine$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une cuisine cubaine authentique, dans un cadre détendu et accueillant. Des assiettes généreuses, des saveurs vives et de bons cocktails.$tr$
from public.recommendations r
where r.name = $tr$Santiago's Cuban Cuisine$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Authentique et délicieux. Venez avec de l'appétit.$tr$
from public.recommendations r
where r.name = $tr$Santiago's Cuban Cuisine$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Uno de los restaurantes más celebrados de Burlington, con platos pequeños del Mediterráneo oriental para compartir. Un sitio que destaca de verdad.$tr$
from public.recommendations r
where r.name = $tr$Honey Road$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Reserva con mucha antelación. Se llena rápido.$tr$
from public.recommendations r
where r.name = $tr$Honey Road$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$L'un des restaurants les plus célébrés de Burlington, avec des petites assiettes de Méditerranée orientale à partager. Une vraie adresse.$tr$
from public.recommendations r
where r.name = $tr$Honey Road$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Réservez longtemps à l'avance. Ça se remplit vite.$tr$
from public.recommendations r
where r.name = $tr$Honey Road$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un favorito de Vermont para comer de la granja a la mesa, con menús de temporada hechos con granjas y productores locales.$tr$
from public.recommendations r
where r.name = $tr$Hen of the Wood (Burlington)$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Ideal para una noche especial.$tr$
from public.recommendations r
where r.name = $tr$Hen of the Wood (Burlington)$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse très aimée au Vermont pour une cuisine de la ferme à la table, avec des menus de saison autour des fermes et des producteurs locaux.$tr$
from public.recommendations r
where r.name = $tr$Hen of the Wood (Burlington)$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfait pour une soirée spéciale.$tr$
from public.recommendations r
where r.name = $tr$Hen of the Wood (Burlington)$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un sitio de marisco informal cerca del paseo de Burlington, con vistas al lago y marisco clásico de Nueva Inglaterra.$tr$
from public.recommendations r
where r.name = $tr$Shanty on the Shore$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Muy buen marisco, y una parada divertida después de un paseo por el lago.$tr$
from public.recommendations r
where r.name = $tr$Shanty on the Shore$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse de fruits de mer décontractée près du front de lac de Burlington, avec vue sur le lac et des classiques de Nouvelle-Angleterre.$tr$
from public.recommendations r
where r.name = $tr$Shanty on the Shore$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$D'excellents fruits de mer, et un arrêt agréable après une promenade au bord du lac.$tr$
from public.recommendations r
where r.name = $tr$Shanty on the Shore$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un local de Winooski con pollo frito crujiente, ostras frescas y buenos cócteles.$tr$
from public.recommendations r
where r.name = $tr$Onion City Chicken & Oysters$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$La carta es corta y está muy rica. Ven con ganas de pollo o de ostras.$tr$
from public.recommendations r
where r.name = $tr$Onion City Chicken & Oysters$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse de Winooski pour le poulet frit croustillant, les huîtres fraîches et de bons cocktails.$tr$
from public.recommendations r
where r.name = $tr$Onion City Chicken & Oysters$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$La carte est courte et délicieuse. Venez d'humeur pour du poulet ou des huîtres.$tr$
from public.recommendations r
where r.name = $tr$Onion City Chicken & Oysters$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un sitio local de confianza para tacos y comida mexicana informal.$tr$
from public.recommendations r
where r.name = $tr$Taco Gordo$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Fácil, rico y perfecto para un bocado rápido.$tr$
from public.recommendations r
where r.name = $tr$Taco Gordo$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse locale pour les tacos et une cuisine mexicaine simple.$tr$
from public.recommendations r
where r.name = $tr$Taco Gordo$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Simple, bon, et parfait pour une bouchée rapide.$tr$
from public.recommendations r
where r.name = $tr$Taco Gordo$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un favorito de Burlington para hamburguesas y comida de granja, con una buena lista de cervezas de Vermont.$tr$
from public.recommendations r
where r.name = $tr$Farmhouse Tap & Grill$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$En invierno, quédate en el sótano acogedor junto a la chimenea. En verano, el patio de atrás.$tr$
from public.recommendations r
where r.name = $tr$Farmhouse Tap & Grill$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse très aimée à Burlington pour les burgers et la cuisine de ferme, avec une belle carte de bières du Vermont.$tr$
from public.recommendations r
where r.name = $tr$Farmhouse Tap & Grill$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$En hiver, installez-vous dans le sous-sol chaleureux près de la cheminée. En été, la terrasse derrière.$tr$
from public.recommendations r
where r.name = $tr$Farmhouse Tap & Grill$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Comida italiana reconfortante, con pasta y pizza hechas en casa, justo en Church Street.$tr$
from public.recommendations r
where r.name = $tr$Pascolo Ristorante$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Perfecto para cenar antes de pasear Church Street de noche.$tr$
from public.recommendations r
where r.name = $tr$Pascolo Ristorante$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une cuisine italienne réconfortante, avec des pâtes et des pizzas maison, en plein sur Church Street.$tr$
from public.recommendations r
where r.name = $tr$Pascolo Ristorante$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfait pour dîner avant de flâner sur Church Street le soir.$tr$
from public.recommendations r
where r.name = $tr$Pascolo Ristorante$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un favorito de siempre en Burlington para cocina china y platos para compartir.$tr$
from public.recommendations r
where r.name = $tr$A Single Pebble$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Pide varios platos y compártelos en familia.$tr$
from public.recommendations r
where r.name = $tr$A Single Pebble$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse de longue date à Burlington pour la cuisine chinoise et les plats à partager.$tr$
from public.recommendations r
where r.name = $tr$A Single Pebble$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Commandez plusieurs plats et partagez-les.$tr$
from public.recommendations r
where r.name = $tr$A Single Pebble$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un bistró francés clásico en Church Street, con un ambiente acogedor de otro tiempo y muy buen sitio para ver pasar a la gente.$tr$
from public.recommendations r
where r.name = $tr$Leunig's Bistro$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Pide una mesa en la ventana o en la terraza si hace buen tiempo.$tr$
from public.recommendations r
where r.name = $tr$Leunig's Bistro$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un bistrot français classique sur Church Street, chaleureux, d'un autre temps, et parfait pour regarder passer le monde.$tr$
from public.recommendations r
where r.name = $tr$Leunig's Bistro$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Prenez une table à la fenêtre ou en terrasse par beau temps.$tr$
from public.recommendations r
where r.name = $tr$Leunig's Bistro$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un sitio popular de Burlington que le gusta mucho a la gente local.$tr$
from public.recommendations r
where r.name = $tr$May Day$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Un favorito local que vale la pena conocer.$tr$
from public.recommendations r
where r.name = $tr$May Day$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse populaire de Burlington, très aimée des gens du coin.$tr$
from public.recommendations r
where r.name = $tr$May Day$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Un favori local qui vaut le détour.$tr$
from public.recommendations r
where r.name = $tr$May Day$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un bar y restaurante en el agua, justo en Lake Champlain, con mesas fuera y cócteles junto al lago.$tr$
from public.recommendations r
where r.name = $tr$Spot on the Dock$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Ve al atardecer. Es precioso.$tr$
from public.recommendations r
where r.name = $tr$Spot on the Dock$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un bar et restaurant au bord de l'eau, en plein sur Lake Champlain, avec des tables dehors et des cocktails face au lac.$tr$
from public.recommendations r
where r.name = $tr$Spot on the Dock$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Allez au coucher du soleil. C'est magnifique.$tr$
from public.recommendations r
where r.name = $tr$Spot on the Dock$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una cervecería de Winooski conocida por cervezas creativas de lote pequeño y un taproom relajado con buena comida.$tr$
from public.recommendations r
where r.name = $tr$Four Quarters Brewing$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Muy tranquilo y aceptan perros.$tr$
from public.recommendations r
where r.name = $tr$Four Quarters Brewing$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une brasserie de Winooski connue pour des bières créatives en petit lot et un taproom détendu avec de la bonne cuisine.$tr$
from public.recommendations r
where r.name = $tr$Four Quarters Brewing$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Très tranquille, et les chiens sont les bienvenus.$tr$
from public.recommendations r
where r.name = $tr$Four Quarters Brewing$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una cervecería de Burlington cerca del lago, conocida por IPAs turbias, cervezas de lote pequeño y un ambiente estupendo.$tr$
from public.recommendations r
where r.name = $tr$Foam Brewers$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Mira si hay música en vivo, y en verano quédate en la terraza.$tr$
from public.recommendations r
where r.name = $tr$Foam Brewers$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une brasserie de Burlington près du lac, connue pour ses IPA troubles, ses bières en petit lot et une belle ambiance.$tr$
from public.recommendations r
where r.name = $tr$Foam Brewers$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Regardez s'il y a de la musique live, et en été prenez la terrasse.$tr$
from public.recommendations r
where r.name = $tr$Foam Brewers$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una sala de cerveza grande y animada, con muchas cervezas de la casa y un menú completo.$tr$
from public.recommendations r
where r.name = $tr$Burlington Beer Co.$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Va muy bien con un grupo grande. La comida también está buenísima.$tr$
from public.recommendations r
where r.name = $tr$Burlington Beer Co.$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une grande salle de bière animée, avec beaucoup de bières de la maison et un menu complet.$tr$
from public.recommendations r
where r.name = $tr$Burlington Beer Co.$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfait pour un grand groupe. La cuisine est excellente aussi.$tr$
from public.recommendations r
where r.name = $tr$Burlington Beer Co.$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un bar de cócteles íntimo, con bebidas cuidadas y de mucha calidad.$tr$
from public.recommendations r
where r.name = $tr$Devil Takes a Holiday$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Un sitio estupendo para una cita.$tr$
from public.recommendations r
where r.name = $tr$Devil Takes a Holiday$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un bar à cocktails intime, avec des boissons soignées et de grande qualité.$tr$
from public.recommendations r
where r.name = $tr$Devil Takes a Holiday$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Une très belle adresse pour un rendez-vous.$tr$
from public.recommendations r
where r.name = $tr$Devil Takes a Holiday$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una de las cervecerías conocidas de Vermont, con un taproom grande que sirve sus cervezas y buena comida.$tr$
from public.recommendations r
where r.name = $tr$Zero Gravity Brewery$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Un clásico de Burlington para una pinta y un bocado.$tr$
from public.recommendations r
where r.name = $tr$Zero Gravity Brewery$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$L'une des brasseries connues du Vermont, avec un grand taproom qui sert ses bières et une bonne cuisine.$tr$
from public.recommendations r
where r.name = $tr$Zero Gravity Brewery$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Un classique de Burlington pour une pinte et une bouchée.$tr$
from public.recommendations r
where r.name = $tr$Zero Gravity Brewery$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un bar de cócteles acogedor, con aire de speakeasy, luz baja y música en vivo.$tr$
from public.recommendations r
where r.name = $tr$The 126$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Ve por la música en vivo y quédate para una última copa.$tr$
from public.recommendations r
where r.name = $tr$The 126$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un bar à cocktails chaleureux, dans l'esprit d'un speakeasy, avec une lumière douce et de la musique live.$tr$
from public.recommendations r
where r.name = $tr$The 126$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Allez pour la musique live et restez pour un dernier verre.$tr$
from public.recommendations r
where r.name = $tr$The 126$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una montaña clásica de Vermont, con terreno exigente y un programa familiar estupendo, y un ambiente de verdad local.$tr$
from public.recommendations r
where r.name = $tr$Smugglers' Notch$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Nuestro sitio local para esquiar y hacer snowboard.$tr$
from public.recommendations r
where r.name = $tr$Smugglers' Notch$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une montagne classique du Vermont, avec un terrain exigeant et un très bon programme famille, et une vraie ambiance locale.$tr$
from public.recommendations r
where r.name = $tr$Smugglers' Notch$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Notre spot local pour le ski et le snowboard.$tr$
from public.recommendations r
where r.name = $tr$Smugglers' Notch$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una de las estaciones de esquí más famosas del Este, al pie de Mount Mansfield, el pico más alto de Vermont.$tr$
from public.recommendations r
where r.name = $tr$Stowe Mountain Resort$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Está en el Epic Pass. Mountain Road está llena de bares y restaurantes, y hay spa, pista de patinaje y mucho más.$tr$
from public.recommendations r
where r.name = $tr$Stowe Mountain Resort$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$L'une des stations de ski les plus connues de l'Est, au pied de Mount Mansfield, le plus haut sommet du Vermont.$tr$
from public.recommendations r
where r.name = $tr$Stowe Mountain Resort$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Elle est sur l'Epic Pass. Mountain Road est pleine de bars et de restaurants, et il y a un spa, une patinoire et bien plus.$tr$
from public.recommendations r
where r.name = $tr$Stowe Mountain Resort$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una montaña grande y variada en Mad River Valley, con mucho terreno para todos los niveles.$tr$
from public.recommendations r
where r.name = $tr$Sugarbush Resort$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Está en el Ikon Pass.$tr$
from public.recommendations r
where r.name = $tr$Sugarbush Resort$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une grande montagne variée dans la Mad River Valley, avec beaucoup de terrain pour tous les niveaux.$tr$
from public.recommendations r
where r.name = $tr$Sugarbush Resort$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Elle est sur l'Ikon Pass.$tr$
from public.recommendations r
where r.name = $tr$Sugarbush Resort$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una montaña cercana y a buen precio, con un ambiente relajado, y uno de los pocos sitios de Vermont con esquí nocturno.$tr$
from public.recommendations r
where r.name = $tr$Bolton Valley Resort$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Ideal para principiantes y niños. No te pierdas el esquí de noche.$tr$
from public.recommendations r
where r.name = $tr$Bolton Valley Resort$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une montagne accueillante et abordable, avec une ambiance détendue, et l'un des rares endroits du Vermont avec du ski de nuit.$tr$
from public.recommendations r
where r.name = $tr$Bolton Valley Resort$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfait pour les débutants et les enfants. Ne manquez pas le ski de nuit.$tr$
from public.recommendations r
where r.name = $tr$Bolton Valley Resort$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$El lodge histórico de Stowe fundado por la familia von Trapp, con kilómetros de pistas de esquí de fondo y vistas amplias a la montaña.$tr$
from public.recommendations r
where r.name = $tr$Trapp Family Lodge$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$De lo mejor en esquí de fondo por aquí, y hay una cervecería en el mismo sitio.$tr$
from public.recommendations r
where r.name = $tr$Trapp Family Lodge$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Le lodge historique de Stowe fondé par la famille von Trapp, avec des kilomètres de pistes de ski de fond et de larges vues sur la montagne.$tr$
from public.recommendations r
where r.name = $tr$Trapp Family Lodge$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parmi les meilleurs ski de fond du coin, et il y a une brasserie sur place.$tr$
from public.recommendations r
where r.name = $tr$Trapp Family Lodge$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una granja histórica que sigue en marcha, y una organización sin ánimo de lucro a la orilla de Lake Champlain, con senderos, jardines, elaboración de queso y vistas preciosas de los Adirondacks.$tr$
from public.recommendations r
where r.name = $tr$Shelburne Farms$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Los senderos están abiertos toda la temporada (lo sentimos, no se admiten perros). En verano, toma algo en el Inn y siéntate en las sillas Adirondack mirando al agua.$tr$
from public.recommendations r
where r.name = $tr$Shelburne Farms$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une ferme historique encore en activité, et une association, au bord de Lake Champlain, avec des sentiers, des jardins, une fromagerie et de superbes vues sur les Adirondacks.$tr$
from public.recommendations r
where r.name = $tr$Shelburne Farms$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Les sentiers sont ouverts toute la saison (désolé, pas de chiens). En été, prenez un verre à l'Inn et asseyez-vous dans les chaises Adirondack face à l'eau.$tr$
from public.recommendations r
where r.name = $tr$Shelburne Farms$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$El paseo peatonal de Burlington, lleno de restaurantes, tiendas, bares, cafeterías y artistas callejeros. El corazón del centro.$tr$
from public.recommendations r
where r.name = $tr$Church Street$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Ve cuando ya es de noche. Está toda iluminada.$tr$
from public.recommendations r
where r.name = $tr$Church Street$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$La rue piétonne de Burlington, bordée de restaurants, de boutiques, de bars, de cafés et d'artistes de rue. Le cœur du centre.$tr$
from public.recommendations r
where r.name = $tr$Church Street$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Allez une fois la nuit tombée. Tout est illuminé.$tr$
from public.recommendations r
where r.name = $tr$Church Street$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un barco de paseo por Lake Champlain, con cruceros panorámicos, de cena y de atardecer desde el paseo de Burlington.$tr$
from public.recommendations r
where r.name = $tr$Spirit of Ethan Allen$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Una noche de verano estupenda en el lago.$tr$
from public.recommendations r
where r.name = $tr$Spirit of Ethan Allen$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un bateau de croisière sur Lake Champlain, avec des sorties panoramiques, des dîners et des couchers de soleil depuis le front de lac de Burlington.$tr$
from public.recommendations r
where r.name = $tr$Spirit of Ethan Allen$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Une très belle soirée d'été sur le lac.$tr$
from public.recommendations r
where r.name = $tr$Spirit of Ethan Allen$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$La cascada y el paseo del río en el corazón de Winooski, rodeados de antiguos edificios de molinos. Un paseo fácil desde tu puerta.$tr$
from public.recommendations r
where r.name = $tr$Winooski Falls and river trails$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Perfecto para un paseo con el café de la mañana.$tr$
from public.recommendations r
where r.name = $tr$Winooski Falls and river trails$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$La cascade et la promenade au bord de la rivière, au cœur de Winooski, entourées d'anciens bâtiments de moulins. Une marche facile depuis votre porte.$tr$
from public.recommendations r
where r.name = $tr$Winooski Falls and river trails$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfait pour une promenade avec le café du matin.$tr$
from public.recommendations r
where r.name = $tr$Winooski Falls and river trails$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una carretera de campo tranquila en Stowe, con vistas clásicas de Vermont, sobre todo en el pico del follaje.$tr$
from public.recommendations r
where r.name = $tr$Upper Hollow Road$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Preciosa en otoño. Lleva la cámara.$tr$
from public.recommendations r
where r.name = $tr$Upper Hollow Road$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une route de campagne tranquille à Stowe, avec des vues classiques du Vermont, surtout au pic du feuillage.$tr$
from public.recommendations r
where r.name = $tr$Upper Hollow Road$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Magnifique en automne. Prenez votre appareil.$tr$
from public.recommendations r
where r.name = $tr$Upper Hollow Road$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$El parque estatal más antiguo de Vermont, con una subida corta (carretera pavimentada o sendero entre árboles) hasta una cima con vistas amplias de Lake Champlain.$tr$
from public.recommendations r
where r.name = $tr$Mount Philo$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Una caminata fácil con una recompensa grande. Los perros son bienvenidos con correa.$tr$
from public.recommendations r
where r.name = $tr$Mount Philo$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Le plus ancien parc d'État du Vermont, avec une courte montée (route goudronnée ou sentier en forêt) jusqu'à un sommet avec de larges vues sur Lake Champlain.$tr$
from public.recommendations r
where r.name = $tr$Mount Philo$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Une randonnée facile avec une belle récompense. Les chiens sont les bienvenus en laisse.$tr$
from public.recommendations r
where r.name = $tr$Mount Philo$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un parque tranquilo en Essex, con senderos fáciles alrededor del agua.$tr$
from public.recommendations r
where r.name = $tr$Indian Brook Reservoir$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Muy buenos senderos para caminar, y aceptan perros.$tr$
from public.recommendations r
where r.name = $tr$Indian Brook Reservoir$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un parc paisible à Essex, avec des sentiers faciles autour de l'eau.$tr$
from public.recommendations r
where r.name = $tr$Indian Brook Reservoir$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$De très beaux sentiers de promenade, et les chiens sont les bienvenus.$tr$
from public.recommendations r
where r.name = $tr$Indian Brook Reservoir$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una caminata popular hasta un estanque de montaña cerca de Smugglers' Notch, en el Long Trail de Vermont.$tr$
from public.recommendations r
where r.name = $tr$Sterling Pond Trail$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une randonnée très suivie jusqu'à un étang de montagne près de Smugglers' Notch, sur le Long Trail du Vermont.$tr$
from public.recommendations r
where r.name = $tr$Sterling Pond Trail$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una subida exigente hasta una cima rocosa y abierta, con grandes vistas de las Green Mountains.$tr$
from public.recommendations r
where r.name = $tr$Burnt Rock Mountain$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une montée rude jusqu'à un sommet rocheux et ouvert, avec de grandes vues sur les Green Mountains.$tr$
from public.recommendations r
where r.name = $tr$Burnt Rock Mountain$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Uno de los picos más emblemáticos de Vermont, con una silueta inconfundible y unas vistas increíbles desde la cima. Una caminata de las que hay que hacer en Vermont.$tr$
from public.recommendations r
where r.name = $tr$Camel's Hump$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$No la recomendamos si estás empezando. Sal temprano y lleva capas.$tr$
from public.recommendations r
where r.name = $tr$Camel's Hump$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$L'un des sommets les plus emblématiques du Vermont, avec une silhouette reconnaissable et des vues incroyables du haut. Une randonnée à faire au moins une fois.$tr$
from public.recommendations r
where r.name = $tr$Camel's Hump$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Nous ne la recommandons pas aux débutants. Partez tôt et prenez plusieurs couches.$tr$
from public.recommendations r
where r.name = $tr$Camel's Hump$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$El club de comedia de Burlington, con monólogos e improvisación casi todos los fines de semana.$tr$
from public.recommendations r
where r.name = $tr$Vermont Comedy Club$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Una noche divertida cuando hace frío.$tr$
from public.recommendations r
where r.name = $tr$Vermont Comedy Club$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Le club de comédie de Burlington, avec du stand-up et de l'impro presque tous les week-ends.$tr$
from public.recommendations r
where r.name = $tr$Vermont Comedy Club$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Une soirée amusante quand il fait froid.$tr$
from public.recommendations r
where r.name = $tr$Vermont Comedy Club$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un centro al aire libre para las cuatro estaciones, con senderos para bici, esquí de fondo y raquetas.$tr$
from public.recommendations r
where r.name = $tr$Catamount Outdoor Family Center$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Hay equipo de alquiler, así que no tienes que traer el material.$tr$
from public.recommendations r
where r.name = $tr$Catamount Outdoor Family Center$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un centre de plein air pour les quatre saisons, avec des sentiers pour le vélo, le ski de fond et les raquettes.$tr$
from public.recommendations r
where r.name = $tr$Catamount Outdoor Family Center$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Le matériel se loue, vous n'avez pas besoin d'apporter le vôtre.$tr$
from public.recommendations r
where r.name = $tr$Catamount Outdoor Family Center$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Gelato de lote pequeño en Burlington.$tr$
from public.recommendations r
where r.name = $tr$Shy Guy Gelato$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un gelato en petit lot à Burlington.$tr$
from public.recommendations r
where r.name = $tr$Shy Guy Gelato$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un puesto clásico de creemees en Vermont. Creemee es como llaman aquí al helado suave.$tr$
from public.recommendations r
where r.name = $tr$Mr. Creemee Stand$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Prueba un creemee de maple. Es algo que hay que hacer en Vermont.$tr$
from public.recommendations r
where r.name = $tr$Mr. Creemee Stand$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un stand classique de creemees au Vermont. Un creemee, c'est le nom d'ici pour la glace molle.$tr$
from public.recommendations r
where r.name = $tr$Mr. Creemee Stand$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Goûtez un creemee à l'érable. C'est un incontournable du Vermont.$tr$
from public.recommendations r
where r.name = $tr$Mr. Creemee Stand$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un pub acogedor de Waterbury con una carta de cerveza artesanal muy seria y un menú sólido.$tr$
from public.recommendations r
where r.name = $tr$Blackback Pub$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Muy buena comida y una selección de cerveza excelente.$tr$
from public.recommendations r
where r.name = $tr$Blackback Pub$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un pub chaleureux de Waterbury avec une très belle carte de bières artisanales et un menu solide.$tr$
from public.recommendations r
where r.name = $tr$Blackback Pub$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Une très bonne cuisine et un excellent choix de bières.$tr$
from public.recommendations r
where r.name = $tr$Blackback Pub$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Pasta fresca hecha a mano en Waterbury.$tr$
from public.recommendations r
where r.name = $tr$Gallus Handcrafted Pasta$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Comida italiana deliciosa.$tr$
from public.recommendations r
where r.name = $tr$Gallus Handcrafted Pasta$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Des pâtes fraîches faites à la main à Waterbury.$tr$
from public.recommendations r
where r.name = $tr$Gallus Handcrafted Pasta$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Une cuisine italienne délicieuse.$tr$
from public.recommendations r
where r.name = $tr$Gallus Handcrafted Pasta$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un restaurante y taproom animado de Waterbury, con una larga lista de cervezas de Vermont y un menú relajado.$tr$
from public.recommendations r
where r.name = $tr$The Reservoir$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Perfecto para picar algo y tomar una pinta.$tr$
from public.recommendations r
where r.name = $tr$The Reservoir$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un restaurant et taproom animé de Waterbury, avec une longue liste de bières du Vermont et un menu détendu.$tr$
from public.recommendations r
where r.name = $tr$The Reservoir$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfait pour grignoter et boire une pinte.$tr$
from public.recommendations r
where r.name = $tr$The Reservoir$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una institución de Waterbury, conocida por carnes ahumadas, comida reconfortante de inspiración sureña y su propia cerveza.$tr$
from public.recommendations r
where r.name = $tr$Prohibition Pig$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Hay una cervecería por la parte de atrás, así que toma una cerveza allí también.$tr$
from public.recommendations r
where r.name = $tr$Prohibition Pig$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une institution de Waterbury, connue pour les viandes fumées, une cuisine réconfortante d'inspiration du Sud et sa propre bière.$tr$
from public.recommendations r
where r.name = $tr$Prohibition Pig$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Il y a une brasserie derrière, alors prenez aussi une bière là-bas.$tr$
from public.recommendations r
where r.name = $tr$Prohibition Pig$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un sitio de desayuno y comida en Waterbury, cercano y sin complicaciones.$tr$
from public.recommendations r
where r.name = $tr$Park Row Cafe$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Tiene ambiente de diner.$tr$
from public.recommendations r
where r.name = $tr$Park Row Cafe$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse de petit-déjeuner et de déjeuner à Waterbury, simple et accueillante.$tr$
from public.recommendations r
where r.name = $tr$Park Row Cafe$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Ambiance de diner.$tr$
from public.recommendations r
where r.name = $tr$Park Row Cafe$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un sitio de Waterbury que le gusta mucho a la gente local.$tr$
from public.recommendations r
where r.name = $tr$Salt & Rind$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse de Waterbury très aimée des gens du coin.$tr$
from public.recommendations r
where r.name = $tr$Salt & Rind$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un favorito de Waterbury para una comida relajada.$tr$
from public.recommendations r
where r.name = $tr$Maxi's$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Ideal para el brunch.$tr$
from public.recommendations r
where r.name = $tr$Maxi's$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse très aimée à Waterbury pour un repas détendu.$tr$
from public.recommendations r
where r.name = $tr$Maxi's$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfait pour le brunch.$tr$
from public.recommendations r
where r.name = $tr$Maxi's$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una pizzería local en Waterbury.$tr$
from public.recommendations r
where r.name = $tr$Stone's Throw Pizza$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Perfecta para una noche fácil de pizza en casa.$tr$
from public.recommendations r
where r.name = $tr$Stone's Throw Pizza$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une pizzeria locale à Waterbury.$tr$
from public.recommendations r
where r.name = $tr$Stone's Throw Pizza$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfaite pour une soirée pizza facile à la maison.$tr$
from public.recommendations r
where r.name = $tr$Stone's Throw Pizza$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$La cervecería de Stowe detrás de Heady Topper, una de las cervezas más famosas de Estados Unidos.$tr$
from public.recommendations r
where r.name = $tr$The Alchemist Brewery$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Imprescindible si te gusta la cerveza. Llévate unas latas a casa.$tr$
from public.recommendations r
where r.name = $tr$The Alchemist Brewery$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$La brasserie de Stowe derrière Heady Topper, l'une des bières les plus connues des États-Unis.$tr$
from public.recommendations r
where r.name = $tr$The Alchemist Brewery$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$À ne pas manquer si vous aimez la bière. Prenez des canettes à ramener.$tr$
from public.recommendations r
where r.name = $tr$The Alchemist Brewery$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una sidrería de Stowe con sidras duras de muchos estilos, de las secas a las afrutadas.$tr$
from public.recommendations r
where r.name = $tr$Stowe Cider$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Muy bien si quieres un descanso de la cerveza.$tr$
from public.recommendations r
where r.name = $tr$Stowe Cider$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un cidrier de Stowe avec une large gamme de cidres, du sec au fruité.$tr$
from public.recommendations r
where r.name = $tr$Stowe Cider$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Très bien si vous voulez une pause loin de la bière.$tr$
from public.recommendations r
where r.name = $tr$Stowe Cider$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una cervecería muy querida de Vermont, con un taproom precioso en Waitsfield, famosa por Sip of Sunshine.$tr$
from public.recommendations r
where r.name = $tr$Lawson's Finest Liquids$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Vale la pena el paseo en coche por Mad River Valley.$tr$
from public.recommendations r
where r.name = $tr$Lawson's Finest Liquids$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une brasserie très aimée du Vermont, avec un beau taproom à Waitsfield, connue pour Sip of Sunshine.$tr$
from public.recommendations r
where r.name = $tr$Lawson's Finest Liquids$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Le trajet à travers la Mad River Valley vaut le coup.$tr$
from public.recommendations r
where r.name = $tr$Lawson's Finest Liquids$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una panadería y cafetería acogedora en Waterbury.$tr$
from public.recommendations r
where r.name = $tr$Hender's Bake Shop & Cafe$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une boulangerie et un café chaleureux à Waterbury.$tr$
from public.recommendations r
where r.name = $tr$Hender's Bake Shop & Cafe$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un sitio local de Waterbury para bagels y sándwiches de desayuno.$tr$
from public.recommendations r
where r.name = $tr$K.C.'s Bagel Café$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une adresse locale de Waterbury pour les bagels et les sandwiches du matin.$tr$
from public.recommendations r
where r.name = $tr$K.C.'s Bagel Café$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una cafetería y panadería de Waterbury con comida, pasteles, sándwiches y lattes.$tr$
from public.recommendations r
where r.name = $tr$Black Cap Coffee & Bakery$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un café et une boulangerie de Waterbury, avec le déjeuner, des pâtisseries, des sandwiches et des lattes.$tr$
from public.recommendations r
where r.name = $tr$Black Cap Coffee & Bakery$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una cafetería cercana de Waterbury, en Stowe Street.$tr$
from public.recommendations r
where r.name = $tr$Stowe Street Café$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un café accueillant de Waterbury, sur Stowe Street.$tr$
from public.recommendations r
where r.name = $tr$Stowe Street Café$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un tostador local en Waterbury Center, que tuesta el café allí mismo.$tr$
from public.recommendations r
where r.name = $tr$Vermont Artisan Coffee & Tea$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un torréfacteur local à Waterbury Center, qui torréfie le café sur place.$tr$
from public.recommendations r
where r.name = $tr$Vermont Artisan Coffee & Tea$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$La fábrica original de Ben & Jerry's, donde puedes hacer la visita, probar muestras gratis y ver el Flavor Graveyard de sabores retirados.$tr$
from public.recommendations r
where r.name = $tr$Ben & Jerry's Factory$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Una parada clásica de Vermont, a unos minutos.$tr$
from public.recommendations r
where r.name = $tr$Ben & Jerry's Factory$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$L'usine d'origine de Ben & Jerry's, où vous pouvez faire la visite, goûter des échantillons gratuits et voir le Flavor Graveyard des parfums retirés.$tr$
from public.recommendations r
where r.name = $tr$Ben & Jerry's Factory$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Un arrêt classique du Vermont, à quelques minutes.$tr$
from public.recommendations r
where r.name = $tr$Ben & Jerry's Factory$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un clásico de Vermont para sidra de manzana fresca y los famosos donuts de sidra, con una tienda de campo llena de productos locales.$tr$
from public.recommendations r
where r.name = $tr$Cold Hollow Cider Mill$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Pide los donuts de sidra. Confía en nosotros.$tr$
from public.recommendations r
where r.name = $tr$Cold Hollow Cider Mill$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un classique du Vermont pour le cidre de pomme frais et les fameux beignets au cidre, avec une grande boutique de campagne pleine de produits locaux.$tr$
from public.recommendations r
where r.name = $tr$Cold Hollow Cider Mill$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Prenez les beignets au cidre. Faites-nous confiance.$tr$
from public.recommendations r
where r.name = $tr$Cold Hollow Cider Mill$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una tienda del famoso queso Cabot de Vermont, con muestras gratis y muchos productos locales.$tr$
from public.recommendations r
where r.name = $tr$Cabot Farmers' Store$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Prueba antes de comprar.$tr$
from public.recommendations r
where r.name = $tr$Cabot Farmers' Store$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une boutique du célèbre fromage Cabot du Vermont, avec des dégustations gratuites et beaucoup de spécialités locales.$tr$
from public.recommendations r
where r.name = $tr$Cabot Farmers' Store$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Goûtez avant d'acheter.$tr$
from public.recommendations r
where r.name = $tr$Cabot Farmers' Store$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Un parque estatal grande en el embalse de Waterbury, con baño, piragüismo y senderos, incluidos antiguos asentamientos de granjas en el bosque.$tr$
from public.recommendations r
where r.name = $tr$Little River State Park$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Ideal para un baño de verano o una caminata fácil.$tr$
from public.recommendations r
where r.name = $tr$Little River State Park$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un grand parc d'État sur le réservoir de Waterbury, avec la baignade, le canoë et des sentiers, dont d'anciens sites de fermes dans les bois.$tr$
from public.recommendations r
where r.name = $tr$Little River State Park$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$Parfait pour une baignade d'été ou une randonnée facile.$tr$
from public.recommendations r
where r.name = $tr$Little River State Park$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una caminata corta pero empinada hasta una cima rocosa, con buenas vistas de Mount Mansfield y el valle de Stowe.$tr$
from public.recommendations r
where r.name = $tr$Stowe Pinnacle$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Une randonnée courte mais raide jusqu'à un sommet rocheux, avec de belles vues sur Mount Mansfield et la vallée de Stowe.$tr$
from public.recommendations r
where r.name = $tr$Stowe Pinnacle$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$El pico más alto de Vermont, con varios senderos de subida y unas vistas increíbles desde arriba.$tr$
from public.recommendations r
where r.name = $tr$Mount Mansfield$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Le plus haut sommet du Vermont, avec plusieurs sentiers pour monter et des vues incroyables du haut.$tr$
from public.recommendations r
where r.name = $tr$Mount Mansfield$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una red de senderos muy usada en Stowe, querida por quien va en bici de montaña, con trazados fluidos para varios niveles.$tr$
from public.recommendations r
where r.name = $tr$Cady Hill Forest$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'es', $tr$Muy buenos senderos de bici de montaña.$tr$
from public.recommendations r
where r.name = $tr$Cady Hill Forest$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un réseau de sentiers très fréquenté à Stowe, aimé des vététistes, avec des pistes fluides pour plusieurs niveaux.$tr$
from public.recommendations r
where r.name = $tr$Cady Hill Forest$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'host_note', 'fr', $tr$De très beaux sentiers de VTT.$tr$
from public.recommendations r
where r.name = $tr$Cady Hill Forest$tr$
  and r.host_note is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'es', $tr$Una red de senderos pensada para ser accesible al ciclismo de montaña adaptado.$tr$
from public.recommendations r
where r.name = $tr$The Driving Range Adaptive Mountain Bike Trails$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select 'recommendations', r.id, 'description', 'fr', $tr$Un réseau de sentiers conçu pour être accessible au VTT adapté.$tr$
from public.recommendations r
where r.name = $tr$The Driving Range Adaptive Mountain Bike Trails$tr$
  and r.description is not null
  and r.is_active
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

notify pgrst, 'reload schema';
