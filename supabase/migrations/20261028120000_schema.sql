-- Vermont Roost Collection
-- File 1 of 3 — schema, row level security, and grants.
-- Supabase Dashboard → SQL → New query → paste this entire file → Run.
-- Run once on an empty project, before the storage file and the seed file.
-- Do not run this file twice.

create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function public.guidebook_body_is_valid(body jsonb)
returns boolean
language plpgsql
immutable
set search_path = ''
as $$
declare
  block_type text;
begin
  if jsonb_typeof(body) is distinct from 'object' then
    return false;
  end if;
  block_type := body->>'type';
  return block_type in ('rich_text', 'steps', 'callout', 'checklist', 'link_list', 'media');
end;
$$;

create table public.locations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.properties (
  id uuid primary key default gen_random_uuid(),
  location_id uuid not null references public.locations (id),
  slug text not null,
  name text not null,
  tagline text,
  description text,
  welcome_title text,
  welcome_message text,
  address_line text,
  locality text,
  region text not null default 'VT',
  postal_code text,
  google_maps_url text,
  apple_maps_url text,
  check_in_time text,
  check_out_time text,
  parking_summary text,
  hero_image_path text,
  status text not null default 'draft',
  published_at timestamptz,
  sort_order integer not null default 0,
  draft jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint properties_slug_unique unique (slug),
  constraint properties_slug_format check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  constraint properties_status check (status in ('draft', 'published')),
  constraint properties_published_timestamp check (status <> 'published' or published_at is not null),
  constraint properties_sort_order check (sort_order >= 0),
  constraint properties_draft_object check (draft is null or jsonb_typeof(draft) = 'object'),
  constraint properties_google_maps_url check (google_maps_url is null or google_maps_url ~ '^https://'),
  constraint properties_apple_maps_url check (apple_maps_url is null or apple_maps_url ~ '^https://'),
  constraint properties_hero_path check (
    hero_image_path is null
    or (hero_image_path !~ '\.\.' and hero_image_path !~ '://')
  )
);

create table public.admin_profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  role text not null default 'owner',
  display_name text,
  created_at timestamptz not null default now(),
  constraint admin_profiles_role check (role in ('owner', 'admin'))
);

create table public.site_settings (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now(),
  constraint site_settings_value_type check (
    jsonb_typeof(value) in ('object', 'string', 'boolean', 'array', 'number')
  )
);

create table public.guidebook_sections (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  section_type text not null,
  slug text not null,
  title text,
  summary text,
  sort_order integer not null default 0,
  is_visible boolean not null default true,
  published_at timestamptz,
  draft jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint guidebook_sections_property_type unique (property_id, section_type),
  constraint guidebook_sections_property_slug unique (property_id, slug),
  constraint guidebook_sections_type check (
    section_type in (
      'getting_here',
      'check_in',
      'wifi',
      'house_guide',
      'amenities',
      'recommendations',
      'things_to_do',
      'house_rules',
      'checkout',
      'faq',
      'contact',
      'stay_again'
    )
  ),
  constraint guidebook_sections_slug_format check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  constraint guidebook_sections_sort_order check (sort_order >= 0),
  constraint guidebook_sections_draft_object check (draft is null or jsonb_typeof(draft) = 'object')
);

create table public.guidebook_blocks (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.guidebook_sections (id) on delete cascade,
  block_type text not null,
  sort_order integer not null default 0,
  title text,
  body jsonb not null,
  published_at timestamptz,
  draft jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  search_vector tsvector generated always as (
    to_tsvector('english', coalesce(title, '') || ' ' || coalesce(body::text, ''))
  ) stored,
  constraint guidebook_blocks_type check (
    block_type in ('rich_text', 'steps', 'callout', 'checklist', 'link_list', 'media')
  ),
  constraint guidebook_blocks_body_valid check (public.guidebook_body_is_valid(body)),
  constraint guidebook_blocks_sort_order check (sort_order >= 0),
  constraint guidebook_blocks_draft_object check (draft is null or jsonb_typeof(draft) = 'object')
);

create table public.amenities (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  sort_order integer not null default 0,
  is_visible boolean not null default true,
  name text,
  description text,
  category text,
  instructions text,
  image_path text,
  published_at timestamptz,
  draft jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint amenities_sort_order check (sort_order >= 0),
  constraint amenities_draft_object check (draft is null or jsonb_typeof(draft) = 'object'),
  constraint amenities_image_path check (
    image_path is null or (image_path !~ '\.\.' and image_path !~ '://')
  )
);

create table public.faqs (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  sort_order integer not null default 0,
  is_visible boolean not null default true,
  question text,
  answer text,
  published_at timestamptz,
  draft jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint faqs_sort_order check (sort_order >= 0),
  constraint faqs_draft_object check (draft is null or jsonb_typeof(draft) = 'object')
);

create table public.checkout_items (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  sort_order integer not null default 0,
  is_visible boolean not null default true,
  label text,
  details text,
  published_at timestamptz,
  draft jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint checkout_items_sort_order check (sort_order >= 0),
  constraint checkout_items_draft_object check (draft is null or jsonb_typeof(draft) = 'object')
);

create table public.booking_links (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  channel text not null,
  label text not null,
  url text not null,
  is_primary boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint booking_links_channel check (channel in ('airbnb', 'vrbo', 'direct', 'other')),
  constraint booking_links_url check (url ~ '^https://'),
  constraint booking_links_sort_order check (sort_order >= 0)
);

create table public.recommendations (
  id uuid primary key default gen_random_uuid(),
  category text not null,
  season text not null default 'year_round',
  is_family_friendly boolean,
  is_indoor boolean,
  drive_minutes integer,
  is_active boolean not null default false,
  name text,
  description text,
  host_note text,
  address text,
  website_url text,
  maps_url text,
  image_path text,
  published_at timestamptz,
  draft jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint recommendations_category check (
    category in ('food_drink', 'outdoors', 'shopping', 'family', 'vermont_experiences')
  ),
  constraint recommendations_season check (
    season in ('spring', 'summer', 'fall', 'winter', 'year_round')
  ),
  constraint recommendations_drive_minutes check (
    drive_minutes is null or (drive_minutes >= 0 and drive_minutes <= 600)
  ),
  constraint recommendations_published_name check (
    published_at is null or (name is not null and char_length(name) > 0)
  ),
  constraint recommendations_website_url check (website_url is null or website_url ~ '^https://'),
  constraint recommendations_maps_url check (maps_url is null or maps_url ~ '^https://'),
  constraint recommendations_image_path check (
    image_path is null or (image_path !~ '\.\.' and image_path !~ '://')
  ),
  constraint recommendations_draft_object check (draft is null or jsonb_typeof(draft) = 'object')
);

create table public.property_recommendations (
  property_id uuid not null references public.properties (id) on delete cascade,
  recommendation_id uuid not null references public.recommendations (id) on delete cascade,
  custom_description text,
  is_featured boolean not null default false,
  sort_order integer not null default 0,
  published_at timestamptz,
  primary key (property_id, recommendation_id),
  constraint property_recommendations_sort_order check (sort_order >= 0)
);

create table public.media_assets (
  id uuid primary key default gen_random_uuid(),
  property_id uuid references public.properties (id) on delete cascade,
  storage_path text not null,
  alt_text text not null,
  media_type text not null default 'image',
  created_at timestamptz not null default now(),
  constraint media_assets_type check (media_type in ('image', 'video')),
  constraint media_assets_alt check (char_length(alt_text) > 0),
  constraint media_assets_path check (storage_path !~ '\.\.' and storage_path !~ '://')
);

create table public.property_wifi (
  property_id uuid primary key references public.properties (id) on delete cascade,
  network_name text,
  password text,
  router_note text,
  is_public boolean not null default false,
  updated_at timestamptz not null default now()
);

comment on table public.property_wifi is
  'Guests can read a row only when is_public is true. Door codes are not stored.';

create table public.contact_channels (
  id uuid primary key default gen_random_uuid(),
  property_id uuid references public.properties (id) on delete cascade,
  channel text not null,
  label text not null,
  value text not null,
  is_public boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint contact_channels_channel check (channel in ('airbnb', 'email', 'phone', 'sms')),
  constraint contact_channels_sort_order check (sort_order >= 0),
  constraint contact_channels_email check (
    channel <> 'email' or value ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'
  ),
  constraint contact_channels_phone check (
    channel not in ('phone', 'sms') or value ~ '^[0-9+(). -]{7,20}$'
  ),
  constraint contact_channels_link check (
    channel <> 'airbnb' or value ~ '^https://'
  )
);

create table public.analytics_events (
  id uuid primary key default gen_random_uuid(),
  event_name text not null,
  property_slug text,
  path text,
  source text,
  created_at timestamptz not null default now(),
  constraint analytics_events_name check (
    event_name in (
      'homepage_view',
      'property_select',
      'section_view',
      'recommendation_click',
      'contact_click',
      'rebooking_click',
      'qr_entry'
    )
  ),
  constraint analytics_events_source check (source is null or source in ('qr', 'direct')),
  constraint analytics_events_slug check (
    property_slug is null or property_slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'
  ),
  constraint analytics_events_path check (path is null or char_length(path) <= 300)
);

create table public.contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null,
  property_slug text,
  subject text not null,
  message text not null,
  created_at timestamptz not null default now(),
  constraint contact_messages_email check (email ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'),
  constraint contact_messages_lengths check (
    char_length(name) between 1 and 120
    and char_length(subject) between 1 and 200
    and char_length(message) between 1 and 5000
  )
);

create index guidebook_sections_property_sort_idx
  on public.guidebook_sections (property_id, sort_order);

create index guidebook_blocks_section_sort_idx
  on public.guidebook_blocks (section_id, sort_order);

create index guidebook_blocks_search_idx
  on public.guidebook_blocks using gin (search_vector);

create index amenities_property_sort_idx
  on public.amenities (property_id, sort_order);

create index faqs_property_sort_idx
  on public.faqs (property_id, sort_order);

create index checkout_items_property_sort_idx
  on public.checkout_items (property_id, sort_order);

create index booking_links_property_sort_idx
  on public.booking_links (property_id, sort_order);

create index recommendations_browse_idx
  on public.recommendations (category, season)
  where published_at is not null and is_active;

create index property_recommendations_property_sort_idx
  on public.property_recommendations (property_id, sort_order);

create index media_assets_property_idx
  on public.media_assets (property_id);

create index contact_channels_property_sort_idx
  on public.contact_channels (property_id, sort_order);

create index analytics_events_created_idx
  on public.analytics_events (created_at desc);

create or replace function public.is_staff()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.admin_profiles
    where user_id = auth.uid()
  );
$$;

revoke all on function public.set_updated_at() from public, anon, authenticated;
revoke all on function public.guidebook_body_is_valid(jsonb) from public, anon, authenticated;
revoke all on function public.is_staff() from public, anon, authenticated;
grant execute on function public.is_staff() to authenticated, service_role;

create trigger locations_set_updated_at
  before update on public.locations
  for each row execute function public.set_updated_at();

create trigger properties_set_updated_at
  before update on public.properties
  for each row execute function public.set_updated_at();

create trigger site_settings_set_updated_at
  before update on public.site_settings
  for each row execute function public.set_updated_at();

create trigger guidebook_sections_set_updated_at
  before update on public.guidebook_sections
  for each row execute function public.set_updated_at();

create trigger guidebook_blocks_set_updated_at
  before update on public.guidebook_blocks
  for each row execute function public.set_updated_at();

create trigger amenities_set_updated_at
  before update on public.amenities
  for each row execute function public.set_updated_at();

create trigger faqs_set_updated_at
  before update on public.faqs
  for each row execute function public.set_updated_at();

create trigger checkout_items_set_updated_at
  before update on public.checkout_items
  for each row execute function public.set_updated_at();

create trigger booking_links_set_updated_at
  before update on public.booking_links
  for each row execute function public.set_updated_at();

create trigger recommendations_set_updated_at
  before update on public.recommendations
  for each row execute function public.set_updated_at();

create trigger property_wifi_set_updated_at
  before update on public.property_wifi
  for each row execute function public.set_updated_at();

create trigger contact_channels_set_updated_at
  before update on public.contact_channels
  for each row execute function public.set_updated_at();

alter table public.locations enable row level security;
alter table public.properties enable row level security;
alter table public.admin_profiles enable row level security;
alter table public.site_settings enable row level security;
alter table public.guidebook_sections enable row level security;
alter table public.guidebook_blocks enable row level security;
alter table public.amenities enable row level security;
alter table public.faqs enable row level security;
alter table public.checkout_items enable row level security;
alter table public.booking_links enable row level security;
alter table public.recommendations enable row level security;
alter table public.property_recommendations enable row level security;
alter table public.media_assets enable row level security;
alter table public.property_wifi enable row level security;
alter table public.contact_channels enable row level security;
alter table public.analytics_events enable row level security;
alter table public.contact_messages enable row level security;

revoke all on table public.locations from anon, authenticated;
revoke all on table public.properties from anon, authenticated;
revoke all on table public.admin_profiles from anon, authenticated;
revoke all on table public.site_settings from anon, authenticated;
revoke all on table public.guidebook_sections from anon, authenticated;
revoke all on table public.guidebook_blocks from anon, authenticated;
revoke all on table public.amenities from anon, authenticated;
revoke all on table public.faqs from anon, authenticated;
revoke all on table public.checkout_items from anon, authenticated;
revoke all on table public.booking_links from anon, authenticated;
revoke all on table public.recommendations from anon, authenticated;
revoke all on table public.property_recommendations from anon, authenticated;
revoke all on table public.media_assets from anon, authenticated;
revoke all on table public.property_wifi from anon, authenticated;
revoke all on table public.contact_channels from anon, authenticated;
revoke all on table public.analytics_events from anon, authenticated;
revoke all on table public.contact_messages from anon, authenticated;

grant select (id, name) on public.locations to anon;
grant select, insert, update, delete on public.locations to authenticated;

grant select (
  id, location_id, slug, name, tagline, description, welcome_title, welcome_message,
  address_line, locality, region, postal_code, google_maps_url, apple_maps_url,
  check_in_time, check_out_time, parking_summary, hero_image_path, status, published_at, sort_order
) on public.properties to anon;
grant select, insert, update, delete on public.properties to authenticated;

grant select, insert, update, delete on public.admin_profiles to authenticated;

grant select (key, value) on public.site_settings to anon;
grant select, insert, update, delete on public.site_settings to authenticated;

grant select (
  id, property_id, section_type, slug, title, summary, sort_order, is_visible, published_at
) on public.guidebook_sections to anon;
grant select, insert, update, delete on public.guidebook_sections to authenticated;

grant select (
  id, section_id, block_type, sort_order, title, body, published_at, search_vector
) on public.guidebook_blocks to anon;
grant select, insert, update, delete on public.guidebook_blocks to authenticated;

grant select (
  id, property_id, sort_order, is_visible, name, description, category, instructions, image_path, published_at
) on public.amenities to anon;
grant select, insert, update, delete on public.amenities to authenticated;

grant select (
  id, property_id, sort_order, is_visible, question, answer, published_at
) on public.faqs to anon;
grant select, insert, update, delete on public.faqs to authenticated;

grant select (
  id, property_id, sort_order, is_visible, label, details, published_at
) on public.checkout_items to anon;
grant select, insert, update, delete on public.checkout_items to authenticated;

grant select (
  id, property_id, channel, label, url, is_primary, sort_order
) on public.booking_links to anon;
grant select, insert, update, delete on public.booking_links to authenticated;

grant select (
  id, category, season, is_family_friendly, is_indoor, drive_minutes, is_active,
  name, description, host_note, address, website_url, maps_url, image_path, published_at
) on public.recommendations to anon;
grant select, insert, update, delete on public.recommendations to authenticated;

grant select (
  property_id, recommendation_id, custom_description, is_featured, sort_order, published_at
) on public.property_recommendations to anon;
grant select, insert, update, delete on public.property_recommendations to authenticated;

grant select (id, property_id, storage_path, alt_text, media_type, created_at)
  on public.media_assets to anon;
grant select, insert, update, delete on public.media_assets to authenticated;

grant select (property_id, network_name, password, router_note, is_public)
  on public.property_wifi to anon;
grant select, insert, update, delete on public.property_wifi to authenticated;

grant select (id, property_id, channel, label, value, is_public, sort_order)
  on public.contact_channels to anon;
grant select, insert, update, delete on public.contact_channels to authenticated;

grant select, delete on public.analytics_events to authenticated;
grant select, delete on public.contact_messages to authenticated;

create policy locations_public_read on public.locations
  for select to anon
  using (
    exists (
      select 1 from public.properties p
      where p.location_id = locations.id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy locations_staff on public.locations
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy properties_public_read on public.properties
  for select to anon
  using (status = 'published' and published_at is not null);

create policy properties_staff on public.properties
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy admin_profiles_staff on public.admin_profiles
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy site_settings_public_read on public.site_settings
  for select to anon
  using (true);

create policy site_settings_staff on public.site_settings
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy guidebook_sections_public_read on public.guidebook_sections
  for select to anon
  using (
    is_visible
    and published_at is not null
    and exists (
      select 1 from public.properties p
      where p.id = guidebook_sections.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy guidebook_sections_staff on public.guidebook_sections
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy guidebook_blocks_public_read on public.guidebook_blocks
  for select to anon
  using (
    published_at is not null
    and exists (
      select 1
      from public.guidebook_sections s
      join public.properties p on p.id = s.property_id
      where s.id = guidebook_blocks.section_id
        and s.is_visible
        and s.published_at is not null
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy guidebook_blocks_staff on public.guidebook_blocks
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy amenities_public_read on public.amenities
  for select to anon
  using (
    is_visible
    and published_at is not null
    and exists (
      select 1 from public.properties p
      where p.id = amenities.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy amenities_staff on public.amenities
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy faqs_public_read on public.faqs
  for select to anon
  using (
    is_visible
    and published_at is not null
    and exists (
      select 1 from public.properties p
      where p.id = faqs.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy faqs_staff on public.faqs
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy checkout_items_public_read on public.checkout_items
  for select to anon
  using (
    is_visible
    and published_at is not null
    and exists (
      select 1 from public.properties p
      where p.id = checkout_items.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy checkout_items_staff on public.checkout_items
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy booking_links_public_read on public.booking_links
  for select to anon
  using (
    exists (
      select 1 from public.properties p
      where p.id = booking_links.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy booking_links_staff on public.booking_links
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy recommendations_public_read on public.recommendations
  for select to anon
  using (is_active and published_at is not null);

create policy recommendations_staff on public.recommendations
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy property_recommendations_public_read on public.property_recommendations
  for select to anon
  using (
    published_at is not null
    and exists (
      select 1 from public.properties p
      where p.id = property_recommendations.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
    and exists (
      select 1 from public.recommendations r
      where r.id = property_recommendations.recommendation_id
        and r.is_active
        and r.published_at is not null
    )
  );

create policy property_recommendations_staff on public.property_recommendations
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy media_assets_public_read on public.media_assets
  for select to anon
  using (
    property_id is not null
    and exists (
      select 1 from public.properties p
      where p.id = media_assets.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy media_assets_staff on public.media_assets
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy property_wifi_public_read on public.property_wifi
  for select to anon
  using (
    is_public
    and exists (
      select 1 from public.properties p
      where p.id = property_wifi.property_id
        and p.status = 'published'
        and p.published_at is not null
    )
  );

create policy property_wifi_staff on public.property_wifi
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy contact_channels_public_read on public.contact_channels
  for select to anon
  using (
    is_public
    and (
      property_id is null
      or exists (
        select 1 from public.properties p
        where p.id = contact_channels.property_id
          and p.status = 'published'
          and p.published_at is not null
      )
    )
  );

create policy contact_channels_staff on public.contact_channels
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

create policy analytics_events_staff_read on public.analytics_events
  for select to authenticated
  using (public.is_staff());

create policy analytics_events_staff_delete on public.analytics_events
  for delete to authenticated
  using (public.is_staff());

create policy contact_messages_staff_read on public.contact_messages
  for select to authenticated
  using (public.is_staff());

create policy contact_messages_staff_delete on public.contact_messages
  for delete to authenticated
  using (public.is_staff());

notify pgrst, 'reload schema';
