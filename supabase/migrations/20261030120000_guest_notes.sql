-- Guest notes for all three stays.
-- Paste once. Anonymous visitors send a note through submit_guest_note.
-- They cannot read notes, and they cannot insert into the table directly.

alter table public.contact_messages
  alter column name drop not null,
  alter column email drop not null;

alter table public.contact_messages drop constraint if exists contact_messages_lengths;
alter table public.contact_messages add constraint contact_messages_lengths check (
  (name is null or char_length(name) between 1 and 120)
  and char_length(subject) between 1 and 200
  and char_length(message) between 1 and 5000
);

alter table public.contact_messages
  add column if not exists visitor_hash text;

alter table public.contact_messages drop constraint if exists contact_messages_visitor_hash;
alter table public.contact_messages add constraint contact_messages_visitor_hash check (
  visitor_hash is null or visitor_hash ~ '^[a-f0-9]{64}$'
);

create index if not exists contact_messages_visitor_created_idx
  on public.contact_messages (visitor_hash, created_at desc);

create or replace function public.submit_guest_note(
  p_name text,
  p_message text,
  p_property_slug text,
  p_visitor_hash text
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_name text;
  v_message text;
  v_slug text;
  v_hash text;
  v_count integer;
  v_id uuid;
begin
  v_name := nullif(btrim(coalesce(p_name, '')), '');
  v_message := btrim(coalesce(p_message, ''));
  v_slug := lower(btrim(coalesce(p_property_slug, '')));
  v_hash := lower(btrim(coalesce(p_visitor_hash, '')));

  if v_slug !~ '^[a-z0-9]+(-[a-z0-9]+)*$' then
    raise exception 'Choose a stay.';
  end if;

  if not exists (
    select 1
    from public.properties
    where slug = v_slug
      and status = 'published'
      and published_at is not null
  ) then
    raise exception 'Choose a stay.';
  end if;

  if v_name is not null and char_length(v_name) > 120 then
    raise exception 'Name is too long.';
  end if;

  if char_length(v_message) = 0 then
    raise exception 'Tell us what''s going on.';
  end if;

  if char_length(v_message) > 5000 then
    raise exception 'That note is too long.';
  end if;

  if v_hash !~ '^[a-f0-9]{64}$' then
    raise exception 'Please try again.';
  end if;

  select count(*)
  into v_count
  from public.contact_messages
  where visitor_hash = v_hash
    and created_at > now() - interval '1 hour';

  if v_count >= 5 then
    raise exception 'Please wait a bit and try again.';
  end if;

  insert into public.contact_messages (
    name, email, property_slug, subject, message, visitor_hash
  )
  values (
    v_name, null, v_slug, 'Something not right', v_message, v_hash
  )
  returning id into v_id;

  return v_id;
end;
$$;

revoke all on function public.submit_guest_note(text, text, text, text) from public, anon, authenticated;
grant execute on function public.submit_guest_note(text, text, text, text) to anon;

revoke all on table public.contact_messages from anon;

notify pgrst, 'reload schema';
