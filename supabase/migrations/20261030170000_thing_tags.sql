-- Guest filter tags for Things to Do.
-- Walkable is a manual tag. This file does not assign it from the town.
-- Dog friendly is only where a host tip welcomes dogs.
-- Safe to paste again. Tags you add by hand are kept.

alter table public.property_recommendations
  add column if not exists guest_tags text[] not null default '{}';

alter table public.property_recommendations drop constraint if exists property_recommendations_guest_tags;
alter table public.property_recommendations
  add constraint property_recommendations_guest_tags check (
    guest_tags <@ array['walkable', 'rainy_day', 'kid_friendly', 'dog_friendly']::text[]
  );

grant select (guest_tags) on public.property_recommendations to anon;

update public.recommendations
set town = 'Winooski'
where name = 'Scout Coffee'
  and town is null;

update public.recommendations
set subcategory = 'coffee'
where name = 'Scout Coffee'
  and subcategory is null;

do $tags$
declare
  missing text;
begin
  select string_agg(wanted.name, ', ' order by wanted.name)
  into missing
  from (
    values
      ($n$Ben & Jerry's Factory$n$),
      ($n$Bolton Valley Resort$n$),
      ($n$Cabot Farmers' Store$n$),
      ($n$Catamount Outdoor Family Center$n$),
      ($n$Cold Hollow Cider Mill$n$),
      ($n$Four Quarters Brewing$n$),
      ($n$Indian Brook Reservoir$n$),
      ($n$K.C.'s Bagel Café$n$),
      ($n$Little River State Park$n$),
      ($n$Maxi's$n$),
      ($n$Mount Philo$n$),
      ($n$Mr. Creemee Stand$n$),
      ($n$Park Row Cafe$n$),
      ($n$Shelburne Farms$n$),
      ($n$Shy Guy Gelato$n$),
      ($n$Smugglers' Notch$n$),
      ($n$Vermont Comedy Club$n$),
      ($n$Winooski Falls and river trails$n$)
  ) as wanted(name)
  where not exists (
    select 1 from public.recommendations r where r.name = wanted.name
  );

  if missing is not null then
    raise exception 'A tagged place is missing: %', missing;
  end if;

  update public.property_recommendations pr
  set guest_tags = (
    select coalesce(array_agg(distinct tag order by tag), '{}')
    from (
      select unnest(pr.guest_tags) as tag
      union
      select unnest(computed.tags) as tag
    ) combined
    where tag is not null
  )
  from (
    select
      link.property_id,
      link.recommendation_id,
      array(
        select tag
        from unnest(array[
          case
            when place.name <> 'Spot on the Dock'
              and (
                place.subcategory in ('eat', 'drink', 'coffee')
                or place.name in (
                  'Vermont Comedy Club',
                  'Ben & Jerry''s Factory',
                  'Cabot Farmers'' Store',
                  'Cold Hollow Cider Mill'
                )
              )
              then 'rainy_day'
          end,
          case
            when place.name in (
              'Ben & Jerry''s Factory',
              'Cold Hollow Cider Mill',
              'Cabot Farmers'' Store',
              'Shelburne Farms',
              'Little River State Park',
              'Mount Philo',
              'Bolton Valley Resort',
              'Smugglers'' Notch',
              'Catamount Outdoor Family Center',
              'Winooski Falls and river trails',
              'Mr. Creemee Stand',
              'Shy Guy Gelato',
              'Park Row Cafe',
              'Maxi''s',
              'K.C.''s Bagel Café'
            )
              then 'kid_friendly'
          end,
          case
            when place.name in ('Four Quarters Brewing', 'Mount Philo', 'Indian Brook Reservoir')
              then 'dog_friendly'
          end
        ]) as tag
        where tag is not null
      ) as tags
    from public.property_recommendations link
    join public.properties stay on stay.id = link.property_id
    join public.recommendations place on place.id = link.recommendation_id
    where stay.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
  ) computed
  where pr.property_id = computed.property_id
    and pr.recommendation_id = computed.recommendation_id
    and cardinality(computed.tags) > 0;

  if exists (
    select 1
    from public.property_recommendations pr
    join public.properties p on p.id = pr.property_id
    join public.recommendations r on r.id = pr.recommendation_id
    where p.slug = 'raddish-roost'
      and r.name = 'Cold Hollow Cider Mill'
      and 'walkable' = any (pr.guest_tags)
  ) then
    raise exception 'Cold Hollow Cider Mill is in Waterbury Center, so it is not walkable.';
  end if;

  if exists (
    select 1
    from public.property_recommendations pr
    join public.recommendations r on r.id = pr.recommendation_id
    where r.name = 'Church Street'
      and 'rainy_day' = any (pr.guest_tags)
  ) then
    raise exception 'Church Street is partly outdoors, so it is not a rainy day pick.';
  end if;

  if exists (
    select 1
    from public.property_recommendations pr
    join public.recommendations r on r.id = pr.recommendation_id
    where r.name = 'Shelburne Farms'
      and 'dog_friendly' = any (pr.guest_tags)
  ) then
    raise exception 'Shelburne Farms does not welcome dogs.';
  end if;
end;
$tags$;

notify pgrst, 'reload schema';
