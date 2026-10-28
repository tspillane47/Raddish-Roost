# Vermont Roost Collection

Guest guidebooks for The Raddish Roost, The Shallot Chalet, and The Onion Ranch.

Indexing is off. Search engines are asked not to crawl the site (`src/app/robots.ts` and the root layout). The database setting `allow_indexing` is stored for later and does not turn indexing on.

## Scripts

```bash
npm run dev
npm test
npm run build
```

## Environment

Copy the example file and fill in the cloud project values. There is no local database.

```bash
cp .env.example .env.local
```

`NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` come from Supabase → Project Settings → API. Use the anon public key. Do not put the service role key in this app.

Until those values are set, the site shows a labeled preview of the three properties. After they are set, pages read published rows from Supabase. Restart the dev server after changing `.env.local`.

Set the same two variables in Vercel before you deploy, then redeploy if you change them. `NEXT_PUBLIC_SITE_URL` is reserved for printable QR codes in a later phase.

## Database

Run these once, in order, in the Supabase SQL Editor (Dashboard → SQL → New query). Paste the whole file, then Run. Wait for success before the next file. Do not run a file twice on the same project.

1. `supabase/migrations/20261028120000_schema.sql`
2. `supabase/migrations/20261028120100_storage.sql`
3. `supabase/migrations/20261028120200_seed.sql`

The seed is sample structure. Copy is marked `[Sample]`. It does not include addresses, Wi-Fi passwords, phone numbers, or businesses.

Door codes are not stored. Wi-Fi is hidden unless a property’s `property_wifi.is_public` value is true.

Owner login is added in a later phase. After you create a user under Authentication → Users, this insert (with that user’s UUID) grants dashboard access:

```sql
insert into public.admin_profiles (user_id, role, display_name)
values ('PASTE-USER-UUID', 'owner', 'Owner');
```

## Deploy

Indexing stays off. Do not change `src/app/robots.ts` or the `robots` setting in `src/app/layout.tsx` for this deploy. `allow_indexing` in the database still does nothing.

The GitHub remote is `https://github.com/tspillane47/Raddish-Roost.git`. Commit and push the Phase 2 work yourself, then connect Vercel:

1. Open [vercel.com/new](https://vercel.com/new) and import **Raddish-Roost**.
2. Framework preset: **Next.js**. Root directory: the repository root. Leave the build command as `next build`.
3. Add these environment variables before the first deploy. Copy the values from `.env.local`. Do not paste the service role key.

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
NEXT_PUBLIC_SITE_URL
```

Set `NEXT_PUBLIC_SITE_URL` to the `https://….vercel.app` address Vercel assigns. If you do not know it yet, deploy once, copy the address, set the variable, and redeploy.

4. Deploy, then open the site on your phone. Check `/`, `/raddish-roost`, a guidebook section, and `/not-a-real-stay` (that last one should be a 404).
