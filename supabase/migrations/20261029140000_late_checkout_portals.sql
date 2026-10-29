-- Late checkout portal links for all three stays.
-- Paste once, after 20261029130000_check_in_times.sql.
-- Updates the existing portal field. It does not add a second link column.
-- Check-in stays 4:00 PM and checkout stays 10:00 AM.

do $$
begin
  if not exists (select 1 from public.properties where slug = 'raddish-roost')
    or not exists (select 1 from public.properties where slug = 'shallot-chalet')
    or not exists (select 1 from public.properties where slug = 'onion-ranch') then
    raise exception 'One of the three stays was not found. Paste the listing files before this one.';
  end if;

  if (
    select count(*)
    from public.properties
    where slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch')
      and check_in_time = '4:00 PM'
      and check_out_time = '10:00 AM'
  ) <> 3 then
    raise exception 'Paste 20261029130000_check_in_times.sql before this file.';
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

update public.analytics_events
set event_name = 'late_checkout_click'
where event_name = 'guest_portal_click';

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
    'late_checkout_click'
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
        event_name = 'late_checkout_click'
        and platform is null
      )
    )
  );

update public.properties p
set guest_portal_url = v.url
from (
  values
    (
      'raddish-roost',
      'https://stay.hospitable.com/7f2dc4a2-c49d-4fba-af96-4d92d9870635/login?returnUrl=%2F7f2dc4a2-c49d-4fba-af96-4d92d9870635%2Fupgrade%3F_t%3Dsc_su'
    ),
    (
      'shallot-chalet',
      'https://stay.hospitable.com/53bf07d7-1177-43f0-bd73-36427f1b1289/upgrade?_t=sc_su'
    ),
    (
      'onion-ranch',
      'https://stay.hospitable.com/72b4adbe-4aa2-4d62-a077-55829eeba0d1/login?returnUrl=%2F72b4adbe-4aa2-4d62-a077-55829eeba0d1%2Fupgrade%3F_t%3Dsc_su'
    )
) as v(slug, url)
where p.slug = v.slug;

do $$
begin
  if (
    select count(*)
    from public.properties p
    join (
      values
        (
          'raddish-roost',
          'https://stay.hospitable.com/7f2dc4a2-c49d-4fba-af96-4d92d9870635/login?returnUrl=%2F7f2dc4a2-c49d-4fba-af96-4d92d9870635%2Fupgrade%3F_t%3Dsc_su'
        ),
        (
          'shallot-chalet',
          'https://stay.hospitable.com/53bf07d7-1177-43f0-bd73-36427f1b1289/upgrade?_t=sc_su'
        ),
        (
          'onion-ranch',
          'https://stay.hospitable.com/72b4adbe-4aa2-4d62-a077-55829eeba0d1/login?returnUrl=%2F72b4adbe-4aa2-4d62-a077-55829eeba0d1%2Fupgrade%3F_t%3Dsc_su'
        )
    ) as v(slug, url) on p.slug = v.slug
    where p.guest_portal_url = v.url
      and p.check_in_time = '4:00 PM'
      and p.check_out_time = '10:00 AM'
  ) <> 3 then
    raise exception 'A late checkout portal link was not saved. Paste the check-in times file first if the times are still missing.';
  end if;
end;
$$;

notify pgrst, 'reload schema';
