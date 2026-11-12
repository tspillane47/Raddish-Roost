-- Errin Perfect Day itineraries for The Winooski Flat and The Mill House.
-- Clones Shallot Chalet fall/winter days with simple insert ... select.
-- Scoped to sites.key = 'errin' only. Safe to paste again. Wrapped in begin/commit. No em dashes.
-- Paste after 20261112120100_errin_things_to_do.sql.

begin;

-- Clean up any leftover permanent tip table from an earlier failed paste.
drop table if exists public.errin_host_tips;

-- Clone Shallot Chalet fall/winter Perfect Days onto Errin Winooski stays.
-- Simple insert ... select only. Safe to paste again.

do $guard$
begin
  if (
    select count(*)
    from public.properties p
    join public.sites s on s.id = p.site_id
    where s.key = 'errin'
      and p.slug in ('winooski-flat', 'mill-house')
  ) <> 2 then
    raise exception 'Errin Winooski properties are missing. Run 20261112120000_errin_properties.sql first.';
  end if;
  if not exists (
    select 1
    from public.itineraries i
    join public.properties p on p.id = i.property_id
    where p.slug = 'shallot-chalet'
  ) then
    raise exception 'shallot-chalet Perfect Days are missing. Run the roost Perfect Day migration first.';
  end if;
end
$guard$;

insert into public.itineraries (
  property_id, season, title, sort_order, is_visible, published_at
)
select
  errin.id,
  src.season,
  src.title,
  src.sort_order,
  true,
  now()
from public.itineraries src
join public.properties shallot
  on shallot.id = src.property_id
 and shallot.slug = 'shallot-chalet'
join public.properties errin on true
join public.sites errin_site on errin_site.id = errin.site_id
where errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
on conflict (property_id, season) do update
set
  title = excluded.title,
  sort_order = excluded.sort_order,
  is_visible = true,
  published_at = coalesce(public.itineraries.published_at, now()),
  updated_at = now();

insert into public.itinerary_stops (
  itinerary_id, recommendation_id, time_label, name, detail, sort_order
)
select
  dest.id,
  src_stop.recommendation_id,
  src_stop.time_label,
  src_stop.name,
  src_stop.detail,
  src_stop.sort_order
from public.itinerary_stops src_stop
join public.itineraries src on src.id = src_stop.itinerary_id
join public.properties shallot
  on shallot.id = src.property_id
 and shallot.slug = 'shallot-chalet'
join public.properties errin on true
join public.sites errin_site on errin_site.id = errin.site_id
join public.itineraries dest
  on dest.property_id = errin.id
 and dest.season = src.season
where errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
on conflict (itinerary_id, sort_order) do update
set
  recommendation_id = excluded.recommendation_id,
  time_label = excluded.time_label,
  name = excluded.name,
  detail = excluded.detail,
  updated_at = now();

insert into public.content_translations (source_table, source_id, field, language, text)
select
  'itinerary_stops',
  dest_stop.id,
  ct.field,
  ct.language,
  ct.text
from public.content_translations ct
join public.itinerary_stops src_stop on src_stop.id = ct.source_id
join public.itineraries src on src.id = src_stop.itinerary_id
join public.properties shallot
  on shallot.id = src.property_id
 and shallot.slug = 'shallot-chalet'
join public.properties errin on true
join public.sites errin_site on errin_site.id = errin.site_id
join public.itineraries dest
  on dest.property_id = errin.id
 and dest.season = src.season
join public.itinerary_stops dest_stop
  on dest_stop.itinerary_id = dest.id
 and dest_stop.sort_order = src_stop.sort_order
where ct.source_table = 'itinerary_stops'
  and errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;

insert into public.content_translations (source_table, source_id, field, language, text)
select
  'itineraries',
  dest.id,
  ct.field,
  ct.language,
  ct.text
from public.content_translations ct
join public.itineraries src on src.id = ct.source_id
join public.properties shallot
  on shallot.id = src.property_id
 and shallot.slug = 'shallot-chalet'
join public.properties errin on true
join public.sites errin_site on errin_site.id = errin.site_id
join public.itineraries dest
  on dest.property_id = errin.id
 and dest.season = src.season
where ct.source_table = 'itineraries'
  and errin_site.key = 'errin'
  and errin.slug in ('winooski-flat', 'mill-house')
on conflict (source_table, source_id, field, language) do update
set text = excluded.text;


do $check$
declare
  fall_flat integer;
  fall_mill integer;
  winter_flat integer;
  winter_mill integer;
begin
  select count(*) into fall_flat
  from public.itinerary_stops st
  join public.itineraries i on i.id = st.itinerary_id
  join public.properties p on p.id = i.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'winooski-flat'
    and i.season = 'fall';

  select count(*) into fall_mill
  from public.itinerary_stops st
  join public.itineraries i on i.id = st.itinerary_id
  join public.properties p on p.id = i.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'mill-house'
    and i.season = 'fall';

  if fall_flat < 9 or fall_mill < 9 then
    raise exception 'Each errin Winooski fall Perfect Day should have at least 9 stops (flat %, mill %).', fall_flat, fall_mill;
  end if;

  select count(*) into winter_flat
  from public.itinerary_stops st
  join public.itineraries i on i.id = st.itinerary_id
  join public.properties p on p.id = i.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'winooski-flat'
    and i.season = 'winter';

  select count(*) into winter_mill
  from public.itinerary_stops st
  join public.itineraries i on i.id = st.itinerary_id
  join public.properties p on p.id = i.property_id
  join public.sites s on s.id = p.site_id
  where s.key = 'errin'
    and p.slug = 'mill-house'
    and i.season = 'winter';

  if winter_flat < 7 or winter_mill < 7 then
    raise exception 'Each errin Winooski winter Perfect Day should have at least 7 stops (flat %, mill %).', winter_flat, winter_mill;
  end if;
end
$check$;

notify pgrst, 'reload schema';

commit;
