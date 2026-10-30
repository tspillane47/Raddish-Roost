-- Correct Things to Do tags and fill in three places that had no town or section.
-- Walkable is an explicit list here. Later places stay untagged until you add Walkable yourself.
-- Safe to paste again. Run 20261030170000_thing_tags.sql first.

do $fixes$
declare
  missing text;
begin
  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'property_recommendations'
      and column_name = 'guest_tags'
  ) then
    raise exception 'Run 20261030170000_thing_tags.sql before this file.';
  end if;

  select string_agg(wanted.name, ', ' order by wanted.name)
  into missing
  from (
    values
      ($n$Ben & Jerry's Factory$n$),
      ($n$Black Cap Coffee & Bakery$n$),
      ($n$Hen of the Wood$n$),
      ($n$Little River State Park$n$),
      ($n$Mule Bar$n$),
      ($n$Our House$n$),
      ($n$Spot on the Dock$n$)
  ) as wanted(name)
  where not exists (
    select 1 from public.recommendations r where r.name = wanted.name
  );

  if missing is not null then
    raise exception 'A place for this tag fix is missing: %', missing;
  end if;

  update public.recommendations
  set town = 'Winooski', subcategory = 'eat'
  where name = 'Our House';

  update public.recommendations
  set town = 'Winooski', subcategory = 'drink'
  where name = 'Mule Bar';

  update public.recommendations
  set town = 'Waterbury', subcategory = 'eat'
  where name = 'Hen of the Wood';

  insert into public.property_recommendations (
    property_id, recommendation_id, is_featured, sort_order, published_at
  )
  select stay.id, place.id, true, item.sort_order, now()
  from (
    values
      ('shallot-chalet', $n$Our House$n$, 20),
      ('onion-ranch', $n$Our House$n$, 20),
      ('shallot-chalet', $n$Mule Bar$n$, 30),
      ('onion-ranch', $n$Mule Bar$n$, 30),
      ('raddish-roost', $n$Hen of the Wood$n$, 40)
  ) as item(slug, name, sort_order)
  join public.properties stay on stay.slug = item.slug
  join public.recommendations place on place.name = item.name
  on conflict (property_id, recommendation_id) do update
  set published_at = coalesce(public.property_recommendations.published_at, excluded.published_at);

  update public.property_recommendations pr
  set guest_tags = (
    select coalesce(array_agg(distinct tag order by tag), '{}')
    from (
      select unnest(pr.guest_tags) as tag
      union
      select 'walkable'::text
    ) combined
    where tag is not null
  )
  from public.properties stay,
    public.recommendations place,
    (
    values
      ('raddish-roost', $n$Black Cap Coffee & Bakery$n$),
      ('raddish-roost', $n$Blackback Pub$n$),
      ('raddish-roost', $n$Gallus Handcrafted Pasta$n$),
      ('raddish-roost', $n$Hender's Bake Shop & Cafe$n$),
      ('raddish-roost', $n$Hen of the Wood$n$),
      ('raddish-roost', $n$K.C.'s Bagel Café$n$),
      ('raddish-roost', $n$Maxi's$n$),
      ('raddish-roost', $n$Park Row Cafe$n$),
      ('raddish-roost', $n$Prohibition Pig$n$),
      ('raddish-roost', $n$Salt & Rind$n$),
      ('raddish-roost', $n$Stone's Throw Pizza$n$),
      ('raddish-roost', $n$Stowe Street Café$n$),
      ('raddish-roost', $n$The Reservoir$n$),
      ('shallot-chalet', $n$Four Quarters Brewing$n$),
      ('shallot-chalet', $n$Mule Bar$n$),
      ('shallot-chalet', $n$Onion City Chicken & Oysters$n$),
      ('shallot-chalet', $n$Our House$n$),
      ('shallot-chalet', $n$Scout Coffee$n$),
      ('shallot-chalet', $n$Waterworks Food + Drink$n$),
      ('shallot-chalet', $n$Winooski Falls and river trails$n$),
      ('onion-ranch', $n$Four Quarters Brewing$n$),
      ('onion-ranch', $n$Mule Bar$n$),
      ('onion-ranch', $n$Onion City Chicken & Oysters$n$),
      ('onion-ranch', $n$Our House$n$),
      ('onion-ranch', $n$Scout Coffee$n$),
      ('onion-ranch', $n$Waterworks Food + Drink$n$),
      ('onion-ranch', $n$Winooski Falls and river trails$n$)
  ) as wanted(slug, name)
  where pr.property_id = stay.id
    and pr.recommendation_id = place.id
    and wanted.slug = stay.slug
    and wanted.name = place.name;

  update public.property_recommendations pr
  set guest_tags = (
    select coalesce(array_agg(distinct tag order by tag), '{}')
    from (
      select unnest(pr.guest_tags) as tag
      union
      select unnest(array['walkable', 'rainy_day']::text[]) as tag
    ) combined
    where tag is not null
  )
  from public.properties stay,
    public.recommendations place
  where pr.property_id = stay.id
    and pr.recommendation_id = place.id
    and (
      (stay.slug in ('shallot-chalet', 'onion-ranch') and place.name in ('Our House', 'Mule Bar'))
      or (stay.slug = 'raddish-roost' and place.name = 'Hen of the Wood')
    );

  update public.property_recommendations pr
  set guest_tags = array_remove(pr.guest_tags, 'walkable')
  from public.properties stay,
    public.recommendations place
  where pr.property_id = stay.id
    and pr.recommendation_id = place.id
    and stay.slug = 'raddish-roost'
    and place.name in ($n$Little River State Park$n$, $n$Ben & Jerry's Factory$n$);

  update public.property_recommendations pr
  set guest_tags = array_remove(pr.guest_tags, 'rainy_day')
  from public.recommendations place
  where pr.recommendation_id = place.id
    and place.name = 'Spot on the Dock';

  if exists (
    select 1
    from public.property_recommendations pr
    join public.properties stay on stay.id = pr.property_id
    join public.recommendations place on place.id = pr.recommendation_id
    where stay.slug = 'raddish-roost'
      and place.name in ('Little River State Park', 'Ben & Jerry''s Factory')
      and 'walkable' = any (pr.guest_tags)
  ) then
    raise exception 'Little River State Park and Ben & Jerry''s Factory are too far to walk from The Raddish Roost.';
  end if;

  if exists (
    select 1
    from public.property_recommendations pr
    join public.recommendations place on place.id = pr.recommendation_id
    where place.name = 'Spot on the Dock'
      and 'rainy_day' = any (pr.guest_tags)
  ) then
    raise exception 'Spot on the Dock is outdoors, so it is not a rainy day pick.';
  end if;

  if exists (
    select 1
    from (
      values
        ('shallot-chalet', $n$Our House$n$, 'Winooski', 'eat'),
        ('onion-ranch', $n$Our House$n$, 'Winooski', 'eat'),
        ('shallot-chalet', $n$Mule Bar$n$, 'Winooski', 'drink'),
        ('onion-ranch', $n$Mule Bar$n$, 'Winooski', 'drink'),
        ('raddish-roost', $n$Hen of the Wood$n$, 'Waterbury', 'eat')
    ) as wanted(slug, name, town, subcategory)
    left join public.properties stay on stay.slug = wanted.slug
    left join public.recommendations place
      on place.name = wanted.name
     and place.town = wanted.town
     and place.subcategory = wanted.subcategory
    left join public.property_recommendations pr
      on pr.property_id = stay.id
     and pr.recommendation_id = place.id
     and pr.published_at is not null
     and 'walkable' = any (pr.guest_tags)
     and 'rainy_day' = any (pr.guest_tags)
    where pr.property_id is null
  ) then
    raise exception 'Our House, Mule Bar, or Hen of the Wood is missing its town, section, link, or tags.';
  end if;

  if not exists (
    select 1
    from public.property_recommendations pr
    join public.properties stay on stay.id = pr.property_id
    join public.recommendations place on place.id = pr.recommendation_id
    where stay.slug = 'raddish-roost'
      and place.name = 'Black Cap Coffee & Bakery'
      and 'walkable' = any (pr.guest_tags)
  ) then
    raise exception 'Black Cap Coffee & Bakery should stay walkable from The Raddish Roost.';
  end if;

  if exists (
    select 1
    from public.recommendations
    where name = 'Hen of the Wood (Burlington)'
      and town = 'Waterbury'
  ) then
    raise exception 'The Burlington Hen of the Wood row was changed by mistake.';
  end if;
end;
$fixes$;

notify pgrst, 'reload schema';
