-- Vermont Roost Collection
-- File 3 of 3 — sample guidebook structure.
-- Run after the schema file succeeds.
-- Dashboard → SQL → New query → paste this entire file → Run.
-- Do not run this file twice.
-- The property name "The Raddish Roost" and slug raddish-roost are intentional.
-- Every guest-facing sentence is marked [Sample].
-- No addresses, Wi-Fi passwords, phone numbers, emails, or businesses.

insert into public.locations (id, name, notes)
values
  (
    'a1000000-0000-4000-8000-000000000001',
    'Main Street, Waterbury, Vermont',
    '[Sample] The Raddish Roost is on its own on Main Street in Waterbury, Vermont. No street number yet.'
  ),
  (
    'a1000000-0000-4000-8000-000000000002',
    'Winooski, Vermont',
    '[Sample] The Shallot Chalet and The Onion Ranch share this building in Winooski, Vermont. No street address yet.'
  );

insert into public.properties (
  id, location_id, slug, name, tagline, description, welcome_title, welcome_message,
  status, published_at, sort_order
)
values
  (
    'b2000000-0000-4000-8000-000000000001',
    'a1000000-0000-4000-8000-000000000001',
    'raddish-roost',
    'The Raddish Roost',
    '[Sample] A short description will go here.',
    '[Sample] Replace this with a short description of The Raddish Roost.',
    'Welcome to The Raddish Roost',
    $roost$[Sample] We're so glad you're here. Replace this with your own welcome for The Raddish Roost.$roost$,
    'published',
    now(),
    1
  ),
  (
    'b2000000-0000-4000-8000-000000000002',
    'a1000000-0000-4000-8000-000000000002',
    'shallot-chalet',
    'The Shallot Chalet',
    '[Sample] A short description will go here.',
    '[Sample] Replace this with a short description of The Shallot Chalet.',
    'Welcome to The Shallot Chalet',
    $shallot$[Sample] We're so glad you're here. Replace this with your own welcome for The Shallot Chalet.$shallot$,
    'published',
    now(),
    2
  ),
  (
    'b2000000-0000-4000-8000-000000000003',
    'a1000000-0000-4000-8000-000000000002',
    'onion-ranch',
    'The Onion Ranch',
    '[Sample] A short description will go here.',
    '[Sample] Replace this with a short description of The Onion Ranch.',
    'Welcome to The Onion Ranch',
    $onion$[Sample] We're so glad you're here. Replace this with your own welcome for The Onion Ranch.$onion$,
    'published',
    now(),
    3
  );

insert into public.site_settings (key, value)
values
  ('brand_name', '"The Vermont Roost Collection"'::jsonb),
  ('allow_indexing', 'false'::jsonb),
  (
    'active_seasons',
    '{"spring":false,"summer":false,"fall":false,"winter":false}'::jsonb
  ),
  ('public_site_url', '""'::jsonb);

insert into public.guidebook_sections (
  property_id, section_type, slug, title, summary, sort_order, is_visible, published_at
)
select
  p.id,
  s.section_type,
  s.slug,
  s.title,
  '[Sample] This section is ready for your notes.',
  s.sort_order,
  true,
  now()
from public.properties p
cross join (
  values
    ('getting_here'::text, 'getting-here'::text, 'Getting Here'::text, 10),
    ('check_in'::text, 'check-in'::text, 'Check-In & Access'::text, 20),
    ('wifi'::text, 'wifi'::text, 'Wi-Fi & Technology'::text, 30),
    ('house_guide'::text, 'house-guide'::text, 'House Guide'::text, 40),
    ('amenities'::text, 'amenities'::text, 'Amenities'::text, 50),
    ('recommendations'::text, 'local-recommendations'::text, 'Local Recommendations'::text, 60),
    ('things_to_do'::text, 'things-to-do'::text, 'Things to Do'::text, 70),
    ('house_rules'::text, 'house-rules'::text, 'House Rules'::text, 80),
    ('checkout'::text, 'checkout'::text, 'Checkout Instructions'::text, 90),
    ('faq'::text, 'faq'::text, 'Frequently Asked Questions'::text, 100),
    ('contact'::text, 'contact'::text, 'Contact Your Hosts'::text, 110),
    ('stay_again'::text, 'stay-again'::text, 'Stay With Us Again'::text, 120)
) as s(section_type, slug, title, sort_order);

insert into public.guidebook_blocks (section_id, block_type, sort_order, title, body, published_at)
select
  s.id,
  'rich_text',
  10,
  '[Sample] Notes',
  jsonb_build_object(
    'type', 'rich_text',
    'markdown', '[Sample] Your notes for this section will appear here.'
  ),
  now()
from public.guidebook_sections s
where s.section_type <> 'check_in';

insert into public.guidebook_blocks (section_id, block_type, sort_order, title, body, published_at)
select
  s.id,
  'steps',
  10,
  '[Sample] Arrival steps',
  jsonb_build_object(
    'type', 'steps',
    'steps', jsonb_build_array(
      jsonb_build_object('title', 'Arrive at the property.'),
      jsonb_build_object('title', 'Park in the designated parking area.'),
      jsonb_build_object('title', 'Locate the main entrance.'),
      jsonb_build_object('title', 'Follow the private access instructions provided with your reservation.'),
      jsonb_build_object('title', 'Make yourself at home.')
    )
  ),
  now()
from public.guidebook_sections s
where s.section_type = 'check_in';

insert into public.amenities (
  property_id, sort_order, is_visible, name, description, published_at
)
select
  p.id,
  10,
  true,
  '[Sample] Amenity name',
  '[Sample] Replace this with a real amenity.',
  now()
from public.properties p;

insert into public.faqs (
  property_id, sort_order, is_visible, question, answer, published_at
)
select
  p.id,
  10,
  true,
  '[Sample] Where will common questions appear?',
  '[Sample] Replace this with a real question and answer.',
  now()
from public.properties p;

insert into public.checkout_items (
  property_id, sort_order, is_visible, label, details, published_at
)
select
  p.id,
  10,
  true,
  '[Sample] Checklist items will appear here after your host adds them.',
  '[Sample] Edit this item to match the property.',
  now()
from public.properties p;

notify pgrst, 'reload schema';
