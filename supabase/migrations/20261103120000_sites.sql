-- Multi-site foundation.
-- One Supabase project can serve more than one branded website.
-- Site A key is "roost". Site B key is "dad".
-- Property slugs stay unique across every site.
-- Recommendations stay a shared pool. Do not delete or rewrite old rows.
-- Paste once in the Supabase SQL Editor after the translations migration.
-- Safe to paste again.

create table if not exists public.sites (
  id uuid primary key default gen_random_uuid(),
  key text not null,
  name text not null,
  domain text,
  settings jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint sites_key_unique unique (key),
  constraint sites_key_format check (key ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  constraint sites_name_length check (char_length(name) between 1 and 120),
  constraint sites_domain_length check (domain is null or char_length(domain) between 1 and 253),
  constraint sites_settings_object check (jsonb_typeof(settings) = 'object')
);

drop trigger if exists sites_set_updated_at on public.sites;
create trigger sites_set_updated_at
  before update on public.sites
  for each row execute function public.set_updated_at();

alter table public.sites enable row level security;

revoke all on table public.sites from anon, authenticated;
grant select (id, key, name, domain) on public.sites to anon;
grant select, insert, update, delete on public.sites to authenticated;

drop policy if exists sites_public_read on public.sites;
create policy sites_public_read on public.sites
  for select to anon
  using (true);

drop policy if exists sites_staff on public.sites;
create policy sites_staff on public.sites
  for all to authenticated
  using (public.is_staff())
  with check (public.is_staff());

insert into public.sites (id, key, name, domain, settings)
values
  (
    'c1000000-0000-4000-8000-000000000001',
    'roost',
    'The Vermont Roost Collection',
    'raddishroost1.vercel.app',
    '{}'::jsonb
  ),
  (
    'c1000000-0000-4000-8000-000000000002',
    'dad',
    '[Dad''s Site Name]',
    null,
    '{}'::jsonb
  )
on conflict (key) do update
set
  name = excluded.name,
  domain = coalesce(public.sites.domain, excluded.domain),
  updated_at = now();

alter table public.properties
  add column if not exists site_id uuid references public.sites (id);

update public.properties
set site_id = 'c1000000-0000-4000-8000-000000000001'
where site_id is null;

alter table public.properties
  alter column site_id set not null;

create index if not exists properties_site_sort_idx
  on public.properties (site_id, sort_order);

grant select (site_id) on public.properties to anon;

alter table public.site_settings
  add column if not exists site_id uuid references public.sites (id);

update public.site_settings
set site_id = 'c1000000-0000-4000-8000-000000000001'
where site_id is null;

alter table public.site_settings
  alter column site_id set not null;

do $pk$
begin
  if exists (
    select 1
    from pg_constraint
    where conrelid = 'public.site_settings'::regclass
      and contype = 'p'
      and conname = 'site_settings_pkey'
      and pg_get_constraintdef(oid) = 'PRIMARY KEY (key)'
  ) then
    alter table public.site_settings drop constraint site_settings_pkey;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.site_settings'::regclass
      and contype = 'p'
  ) then
    alter table public.site_settings
      add constraint site_settings_pkey primary key (site_id, key);
  end if;
end
$pk$;

insert into public.site_settings (site_id, key, value)
values
  (
    'c1000000-0000-4000-8000-000000000002',
    'brand_name',
    '"[Dad''s Site Name]"'::jsonb
  ),
  (
    'c1000000-0000-4000-8000-000000000002',
    'allow_indexing',
    'false'::jsonb
  ),
  (
    'c1000000-0000-4000-8000-000000000002',
    'active_seasons',
    '{"spring":false,"summer":false,"fall":false,"winter":false}'::jsonb
  ),
  (
    'c1000000-0000-4000-8000-000000000002',
    'public_site_url',
    '""'::jsonb
  )
on conflict (site_id, key) do nothing;

grant select (site_id) on public.site_settings to anon;

do $check$
declare
  missing_site integer;
  unscoped_settings integer;
begin
  select count(*) into missing_site
  from public.properties
  where site_id is distinct from 'c1000000-0000-4000-8000-000000000001'
    and slug in ('raddish-roost', 'shallot-chalet', 'onion-ranch');

  if missing_site > 0 then
    raise exception 'Roost properties must belong to the roost site';
  end if;

  select count(*) into unscoped_settings
  from public.site_settings
  where site_id is null;

  if unscoped_settings > 0 then
    raise exception 'site_settings rows must belong to a site';
  end if;
end
$check$;

notify pgrst, 'reload schema';
