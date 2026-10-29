-- Check-in and checkout times, plus a guest portal link for The Raddish Roost.
-- Paste once in the Supabase SQL Editor after the listing files.
-- Times are the same for all three stays. The portal link is only for The Raddish Roost.
-- Other guidebook copy is left as it is. Only the times placeholder is replaced.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'raddish-roost')
    or not exists (select 1 from public.properties where slug = 'shallot-chalet')
    or not exists (select 1 from public.properties where slug = 'onion-ranch') then
    raise exception 'One of the three stays was not found. Paste the listing files before this one.';
  end if;
end;
$$;

alter table public.properties
  add column if not exists guest_portal_url text;

alter table public.properties drop constraint if exists properties_guest_portal_url;
alter table public.properties add constraint properties_guest_portal_url check (
  guest_portal_url is null
  or (
    guest_portal_url ~ '^https://'
    and char_length(guest_portal_url) between 12 and 500
  )
);

grant select (guest_portal_url) on public.properties to anon;

alter table public.analytics_events drop constraint if exists analytics_events_name;
alter table public.analytics_events add constraint analytics_events_name check (
  event_name in (
    'homepage_view',
    'property_select',
    'section_view',
    'recommendation_click',
    'contact_click',
    'rebooking_click',
    'qr_entry',
    'booking_click',
    'guest_portal_click'
  )
);

drop policy if exists analytics_events_public_insert on public.analytics_events;
create policy analytics_events_public_insert on public.analytics_events
  for insert to anon
  with check (
    property_slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'
    and (
      (
        event_name = 'booking_click'
        and platform in ('direct', 'airbnb', 'vrbo')
      )
      or (
        event_name = 'guest_portal_click'
        and platform is null
      )
    )
  );

update public.properties
set
  check_in_time = '4:00 PM',
  check_out_time = '10:00 AM',
  guest_portal_url = case slug
    when 'raddish-roost' then 'https://stay.hospitable.com/7f2dc4a2-c49d-4fba-af96-4d92d9870635/login?returnUrl=%2F7f2dc4a2-c49d-4fba-af96-4d92d9870635%2Fupgrade%3F_t%3Dsc_su'
    else null
  end
where slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch');

update public.guidebook_blocks b
set body = jsonb_set(
  b.body,
  '{steps}',
  (
    select jsonb_agg(
      case
        when step->>'title' = 'Check-in and checkout times.' then
          jsonb_set(
            step,
            '{detail}',
            to_jsonb('Check-in is at 4:00 PM. Checkout is at 10:00 AM.'::text)
          )
        else step
      end
      order by ord
    )
    from jsonb_array_elements(b.body->'steps') with ordinality as t(step, ord)
  )
)
from public.guidebook_sections s
join public.properties p on p.id = s.property_id
where b.section_id = s.id
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
  and s.section_type = 'check_in'
  and b.sort_order = 10
  and b.body->>'type' = 'steps';

update public.guidebook_sections s
set summary = 'Access instructions are in your Airbnb messages. Check-in is at 4:00 PM.'
from public.properties p
where s.property_id = p.id
  and p.slug = 'shallot-chalet'
  and s.section_type = 'check_in'
  and s.summary = 'Access instructions are in your Airbnb messages. Check-in details are coming soon.';

update public.guidebook_sections s
set summary = 'Checkout is at 10:00 AM.'
from public.properties p
where s.property_id = p.id
  and p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
  and s.section_type = 'checkout'
  and s.summary in ('Details coming soon.', 'Details coming soon');

do $$
begin
  if (
    select count(*)
    from public.properties
    where slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and check_in_time = '4:00 PM'
      and check_out_time = '10:00 AM'
  ) <> 3 then
    raise exception 'Check-in and checkout times were not saved on every stay.';
  end if;

  if (
    select guest_portal_url
    from public.properties
    where slug = 'raddish-roost'
  ) is null then
    raise exception 'The Raddish Roost guest portal link was not saved.';
  end if;

  if exists (
    select 1
    from public.properties
    where slug in ('shallot-chalet', 'onion-ranch')
      and guest_portal_url is not null
  ) then
    raise exception 'The guest portal link should stay empty for The Shallot Chalet and The Onion Ranch.';
  end if;

  if (
    select count(*)
    from public.guidebook_blocks b
    join public.guidebook_sections s on s.id = b.section_id
    join public.properties p on p.id = s.property_id
    where p.slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and s.section_type = 'check_in'
      and b.body::text like '%Check-in is at 4:00 PM. Checkout is at 10:00 AM.%'
  ) <> 3 then
    raise exception 'The times placeholder is still in a Check-In section.';
  end if;
end;
$$;

notify pgrst, 'reload schema';
