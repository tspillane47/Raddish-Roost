-- Move host voice onto the property link.
-- Recommendations stay a shared place pool across sites.
-- Host tips and custom descriptions live on property_recommendations
-- so each site can keep its own voice without overwriting the other.
-- Existing roost tip text and translations are copied, not rewritten.
-- Paste after 20261103120000_sites.sql. Safe to paste again.

alter table public.property_recommendations
  add column if not exists id uuid;

update public.property_recommendations
set id = gen_random_uuid()
where id is null;

alter table public.property_recommendations
  alter column id set default gen_random_uuid();

alter table public.property_recommendations
  alter column id set not null;

do $id$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.property_recommendations'::regclass
      and conname = 'property_recommendations_id_unique'
  ) then
    alter table public.property_recommendations
      add constraint property_recommendations_id_unique unique (id);
  end if;
end
$id$;

alter table public.property_recommendations
  add column if not exists host_note text;

update public.property_recommendations as link
set host_note = rec.host_note
from public.recommendations as rec
where link.recommendation_id = rec.id
  and link.host_note is null
  and rec.host_note is not null
  and char_length(trim(rec.host_note)) > 0;

grant select (id, host_note) on public.property_recommendations to anon;

insert into public.content_translations (source_table, source_id, field, language, text)
select
  'property_recommendations',
  link.id,
  'host_note',
  tip.language,
  tip.text
from public.content_translations as tip
join public.recommendations as rec
  on rec.id = tip.source_id
join public.property_recommendations as link
  on link.recommendation_id = rec.id
where tip.source_table = 'recommendations'
  and tip.field = 'host_note'
  and char_length(trim(tip.text)) > 0
on conflict (source_table, source_id, field, language) do nothing;

do $check$
declare
  missing_ids integer;
  missing_tip_copies integer;
begin
  select count(*) into missing_ids
  from public.property_recommendations
  where id is null;

  if missing_ids > 0 then
    raise exception 'property_recommendations.id must be set on every link';
  end if;

  select count(*) into missing_tip_copies
  from public.property_recommendations as link
  join public.recommendations as rec
    on rec.id = link.recommendation_id
  where rec.host_note is not null
    and char_length(trim(rec.host_note)) > 0
    and (
      link.host_note is null
      or char_length(trim(link.host_note)) = 0
    );

  if missing_tip_copies > 0 then
    raise exception 'Host tips were not copied onto every property link';
  end if;
end
$check$;

notify pgrst, 'reload schema';
