-- Merge the shared guidebook from 12 visible sections to 8.
-- Paste this file once in the Supabase SQL editor. Do not re-run the original seed.
-- Old rows stay in the database. FAQ, checkout, amenities, and local recommendations
-- are hidden so they can be turned back on later. Block text, photos, and publish times stay.
-- The search index is generated from each block's title and body, so it follows the block.

create or replace function public.seed_guidebook_sections(target_property_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $fn$
begin
  if target_property_id is null then
    raise exception 'A property is required.';
  end if;

  if not exists (select 1 from public.properties where id = target_property_id) then
    raise exception 'That property does not exist.';
  end if;

  insert into public.guidebook_sections (
    property_id, section_type, slug, title, summary, sort_order, is_visible, published_at
  )
  select
    target_property_id,
    seed.section_type,
    seed.slug,
    seed.title,
    seed.summary,
    seed.sort_order,
    seed.is_visible,
    now()
  from (
    values
      ('check_in'::text, 'check-in-checkout'::text, 'Check-In & Checkout'::text, 'Check-in is at 4:00 PM. Checkout is at 10:00 AM.'::text, 10::integer, true::boolean),
      ('getting_here', 'getting-here', 'Getting Here & Parking', null::text, 20, true),
      ('wifi', 'wifi', 'Wi-Fi & TV', null::text, 30, true),
      ('house_guide', 'the-house', 'The House', null::text, 40, true),
      ('house_rules', 'house-rules', 'House Rules', null::text, 50, true),
      ('things_to_do', 'things-to-do', 'Things to Do', 'Places to eat, drink, ski, hike, and more nearby.', 60, true),
      ('contact', 'contact', 'Contact & Emergency', null::text, 70, true),
      ('stay_again', 'stay-again', 'Stay With Us Again', null::text, 80, true),
      ('faq', 'faq', 'Frequently Asked Questions', null::text, 200, false)
  ) as seed(section_type, slug, title, summary, sort_order, is_visible)
  on conflict (property_id, section_type) do nothing;
end
$fn$;

revoke all on function public.seed_guidebook_sections(uuid) from public, anon;
grant execute on function public.seed_guidebook_sections(uuid) to authenticated, service_role;

do $migrate$
declare
  block_count integer;
  block_count_after integer;
  faq_block_count integer;
  faq_block_count_after integer;
begin
  if (
    select count(*)
    from public.properties
    where slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
  ) <> 3 then
    raise exception 'The three stays must exist before this file.';
  end if;

  select count(*) into block_count from public.guidebook_blocks;

  select count(*) into faq_block_count
  from public.guidebook_blocks b
  join public.guidebook_sections s on s.id = b.section_id
  where s.section_type = 'faq';

  update public.guidebook_blocks as block
  set
    section_id = destination.id,
    sort_order = case
      when block.sort_order >= 1000 then block.sort_order
      else 1000 + block.sort_order
    end
  from public.guidebook_sections as source
  join public.guidebook_sections as destination
    on destination.property_id = source.property_id
   and destination.section_type = 'check_in'
  where block.section_id = source.id
    and source.section_type = 'checkout';

  update public.guidebook_blocks as block
  set
    section_id = destination.id,
    sort_order = case
      when block.sort_order >= 1000 then block.sort_order
      else 1000 + block.sort_order
    end
  from public.guidebook_sections as source
  join public.guidebook_sections as destination
    on destination.property_id = source.property_id
   and destination.section_type = 'house_guide'
  where block.section_id = source.id
    and source.section_type = 'amenities';

  update public.guidebook_blocks as block
  set
    section_id = destination.id,
    sort_order = case
      when block.sort_order >= 1000 then block.sort_order
      else 1000 + block.sort_order
    end
  from public.guidebook_sections as source
  join public.guidebook_sections as destination
    on destination.property_id = source.property_id
   and destination.section_type = 'things_to_do'
  where block.section_id = source.id
    and source.section_type = 'recommendations';

  update public.guidebook_sections as arrival
  set
    slug = 'check-in-checkout',
    title = 'Check-In & Checkout',
    sort_order = 10,
    summary = coalesce((
      select case
        when leaving.summary is null
          or btrim(leaving.summary) = ''
          or leaving.summary in (
            'Checkout is at 10:00 AM.',
            'Checkout is at 10:00 AM',
            'Details coming soon.',
            'Details coming soon'
          )
          then arrival.summary
        when arrival.summary is null or btrim(arrival.summary) = '' then leaving.summary
        when position(lower(btrim(leaving.summary)) in lower(arrival.summary)) > 0 then arrival.summary
        else btrim(arrival.summary) || ' ' || btrim(leaving.summary)
      end
      from public.guidebook_sections as leaving
      where leaving.property_id = arrival.property_id
        and leaving.section_type = 'checkout'
    ), arrival.summary)
  where arrival.section_type = 'check_in';

  update public.guidebook_sections
  set title = 'Getting Here & Parking', sort_order = 20
  where section_type = 'getting_here';

  update public.guidebook_sections
  set title = 'Wi-Fi & TV', sort_order = 30
  where section_type = 'wifi';

  update public.guidebook_sections as house
  set
    slug = 'the-house',
    title = 'The House',
    sort_order = 40,
    summary = coalesce((
      select case
        when amenity.summary is null or btrim(amenity.summary) = '' then house.summary
        when house.summary is null or btrim(house.summary) = '' then amenity.summary
        when position(lower(btrim(amenity.summary)) in lower(house.summary)) > 0 then house.summary
        else btrim(house.summary) || ' ' || btrim(amenity.summary)
      end
      from public.guidebook_sections as amenity
      where amenity.property_id = house.property_id
        and amenity.section_type = 'amenities'
    ), house.summary)
  where house.section_type = 'house_guide';

  update public.guidebook_sections
  set title = 'House Rules', sort_order = 50
  where section_type = 'house_rules';

  update public.guidebook_sections as things
  set
    title = 'Things to Do',
    sort_order = 60,
    summary = coalesce((
      select case
        when things.summary ilike '%coming soon%'
          and ideas.summary is not null
          and btrim(ideas.summary) <> ''
          and ideas.summary not ilike '%coming soon%'
          then ideas.summary
        when ideas.summary is null or btrim(ideas.summary) = '' then things.summary
        when things.summary is null or btrim(things.summary) = '' then ideas.summary
        when position(lower(btrim(ideas.summary)) in lower(things.summary)) > 0 then things.summary
        else btrim(things.summary) || ' ' || btrim(ideas.summary)
      end
      from public.guidebook_sections as ideas
      where ideas.property_id = things.property_id
        and ideas.section_type = 'recommendations'
    ), things.summary)
  where things.section_type = 'things_to_do';

  update public.guidebook_sections
  set title = 'Contact & Emergency', sort_order = 70
  where section_type = 'contact';

  update public.guidebook_sections
  set title = 'Stay With Us Again', sort_order = 80
  where section_type = 'stay_again';

  update public.guidebook_sections
  set
    is_visible = false,
    sort_order = case section_type
      when 'faq' then 200
      when 'checkout' then 210
      when 'amenities' then 220
      when 'recommendations' then 230
      else sort_order
    end
  where section_type in ('faq', 'checkout', 'amenities', 'recommendations');

  update public.guidebook_blocks
  set body = jsonb_set(
    body,
    '{markdown}',
    to_jsonb($copy$Places to eat, drink, ski, hike, and more are listed below. Each place has a tip and directions.$copy$::text)
  )
  where body->>'markdown' = 'Open Explore for places to eat, drink, ski, hike, and more. Each place has a tip and directions.';

  update public.guidebook_blocks
  set body = jsonb_set(
    body,
    '{markdown}',
    to_jsonb(replace(
      body->>'markdown',
      'Our favorite places are in Local Recommendations.',
      'Our favorite places are listed below.'
    ))
  )
  where body->>'type' = 'rich_text'
    and body->>'markdown' like '%Our favorite places are in Local Recommendations.%';

  select count(*) into block_count_after from public.guidebook_blocks;
  if block_count_after <> block_count then
    raise exception 'Guidebook block count changed from % to %.', block_count, block_count_after;
  end if;

  select count(*) into faq_block_count_after
  from public.guidebook_blocks b
  join public.guidebook_sections s on s.id = b.section_id
  where s.section_type = 'faq';

  if faq_block_count_after <> faq_block_count then
    raise exception 'FAQ blocks changed. They should stay hidden, not be removed.';
  end if;

  if exists (
    select 1
    from public.properties p
    where p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and (
        select count(*)
        from public.guidebook_sections s
        where s.property_id = p.id
          and s.is_visible
      ) <> 8
  ) then
    raise exception 'Each stay should show eight guidebook sections.';
  end if;

  if exists (
    select 1
    from public.properties p
    where p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and (
        select count(*)
        from public.guidebook_sections s
        where s.property_id = p.id
          and s.is_visible
          and s.slug in (
            'check-in-checkout',
            'getting-here',
            'wifi',
            'the-house',
            'house-rules',
            'things-to-do',
            'contact',
            'stay-again'
          )
      ) <> 8
  ) then
    raise exception 'A stay is missing one of the eight guidebook sections.';
  end if;

  if exists (
    select 1
    from public.properties p
    join public.guidebook_sections s on s.property_id = p.id
    where p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and s.section_type in ('faq', 'checkout', 'amenities', 'recommendations')
      and s.is_visible
  ) then
    raise exception 'FAQ and the merged sections should be hidden, not deleted.';
  end if;

  if (
    select count(*)
    from public.properties p
    join public.guidebook_sections s on s.property_id = p.id
    where p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and s.section_type = 'faq'
  ) <> 3 then
    raise exception 'FAQ rows should stay for all three stays.';
  end if;

  if exists (
    select 1
    from public.guidebook_blocks b
    join public.guidebook_sections s on s.id = b.section_id
    join public.properties p on p.id = s.property_id
    where p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and s.section_type in ('checkout', 'amenities', 'recommendations')
  ) then
    raise exception 'Merged content should move onto the new section.';
  end if;

  if exists (
    select 1
    from public.guidebook_sections s
    join public.properties p on p.id = s.property_id
    where p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and (
        (s.section_type = 'check_in' and (s.slug <> 'check-in-checkout' or s.title <> 'Check-In & Checkout' or s.sort_order <> 10))
        or (s.section_type = 'getting_here' and (s.slug <> 'getting-here' or s.title <> 'Getting Here & Parking' or s.sort_order <> 20))
        or (s.section_type = 'wifi' and (s.slug <> 'wifi' or s.title <> 'Wi-Fi & TV' or s.sort_order <> 30))
        or (s.section_type = 'house_guide' and (s.slug <> 'the-house' or s.title <> 'The House' or s.sort_order <> 40))
        or (s.section_type = 'house_rules' and (s.slug <> 'house-rules' or s.title <> 'House Rules' or s.sort_order <> 50))
        or (s.section_type = 'things_to_do' and (s.slug <> 'things-to-do' or s.title <> 'Things to Do' or s.sort_order <> 60))
        or (s.section_type = 'contact' and (s.slug <> 'contact' or s.title <> 'Contact & Emergency' or s.sort_order <> 70))
        or (s.section_type = 'stay_again' and (s.slug <> 'stay-again' or s.title <> 'Stay With Us Again' or s.sort_order <> 80))
      )
  ) then
    raise exception 'Guidebook section titles did not update.';
  end if;
end
$migrate$;

notify pgrst, 'reload schema';
