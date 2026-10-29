-- Show the existing Winooski Falls row on Things to Do for the two Winooski stays.
-- Run 20261028233000_winooski_things_to_do.sql first.

do $$
begin
  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'recommendations'
      and column_name = 'subcategory'
  ) then
    raise exception 'Run 20261028233000_winooski_things_to_do.sql before this file.';
  end if;
end $$;

update public.recommendations
set
  category = 'vermont_experiences',
  subcategory = 'see',
  season = 'year_round',
  is_active = true,
  town = 'Winooski',
  host_note = null,
  address = null,
  website_url = null,
  maps_url = 'https://www.google.com/maps/search/?api=1&query=Winooski%20Falls%20and%20river%20trails%20Winooski%20Vermont',
  published_at = coalesce(published_at, now())
where name = 'Winooski Falls and river trails';

update public.property_recommendations pr
set
  is_featured = true,
  sort_order = 305,
  published_at = coalesce(pr.published_at, now())
from public.recommendations r
join public.properties p on p.slug in ('shallot-chalet', 'onion-ranch')
where pr.recommendation_id = r.id
  and pr.property_id = p.id
  and r.name = 'Winooski Falls and river trails';

notify pgrst, 'reload schema';
