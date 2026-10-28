import { readFileSync } from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { SAMPLE_PROPERTIES } from "@/lib/content/sample-catalog";
import { ARRIVAL_STEPS, GUIDE_SECTIONS, SAMPLE_SECTION_SUMMARY } from "@/lib/content/sections";

const root = path.resolve(__dirname, "../../..");
const schema = readFileSync(
  path.join(root, "supabase/migrations/20261028120000_schema.sql"),
  "utf8",
);
const seed = readFileSync(
  path.join(root, "supabase/migrations/20261028120200_seed.sql"),
  "utf8",
);
const listing = readFileSync(
  path.join(root, "supabase/migrations/20261028143000_raddish_roost_listing.sql"),
  "utf8",
);

const tables = [
  "locations",
  "properties",
  "admin_profiles",
  "site_settings",
  "guidebook_sections",
  "guidebook_blocks",
  "amenities",
  "faqs",
  "checkout_items",
  "booking_links",
  "recommendations",
  "property_recommendations",
  "media_assets",
  "property_wifi",
  "contact_channels",
  "analytics_events",
  "contact_messages",
];

describe("schema sql", () => {
  it("enables row level security on every public table", () => {
    for (const table of tables) {
      expect(schema).toContain(`create table public.${table}`);
      expect(schema).toContain(`alter table public.${table} enable row level security`);
    }
  });

  it("does not grant guests the draft column", () => {
    const grants = schema.match(/grant select \([\s\S]*?\) on public\.\w+ to anon;/g) ?? [];
    expect(grants.length).toBeGreaterThan(0);
    for (const grant of grants) {
      expect(grant).not.toMatch(/\bdraft\b/);
    }
  });

  it("keeps wifi passwords behind the public flag", () => {
    expect(schema).toContain("create policy property_wifi_public_read");
    expect(schema).toMatch(/property_wifi_public_read[\s\S]*is_public/);
  });
});

describe("seed sql", () => {
  it("matches the sample catalog and stays free of invented facts", () => {
    for (const property of SAMPLE_PROPERTIES) {
      expect(seed).toContain(property.slug);
      expect(seed).toContain(property.name);
      expect(seed).toContain(property.welcomeMessage);
    }
    for (const section of GUIDE_SECTIONS) {
      expect(seed).toContain(section.slug);
      expect(seed).toContain(section.title);
    }
    for (const step of ARRIVAL_STEPS) {
      expect(seed).toContain(step);
    }
    expect(seed).toContain(SAMPLE_SECTION_SUMMARY);
    expect(seed).toContain("[Sample]");
    expect(seed).toContain("raddish-roost");
    expect(seed).toContain("The Raddish Roost");
    expect(seed).not.toContain("radish-roost");
    expect(seed).not.toContain("The Radish Roost");
    expect(seed).not.toMatch(/insert into public\.property_wifi/i);
    expect(seed).not.toMatch(/insert into public\.contact_channels/i);
    expect(seed).not.toMatch(/insert into public\.recommendations/i);
    expect(seed).not.toMatch(/\b\d{1,5}\s+\w+\s+(street|st|road|rd|avenue|ave|lane|ln)\b/i);
    expect(seed).not.toMatch(/\b\d{3}-\d{3}-\d{4}\b/);
  });
});

describe("Raddish Roost listing sql", () => {
  it("publishes the listing facts without sample copy or a door code", () => {
    expect(listing).toContain("slug = 'raddish-roost'");
    expect(listing).toContain("The Raddish Roost");
    expect(listing).toContain("A restored 1899 farmhouse right on Main Street in Waterbury");
    expect(listing).toContain("Main Street, Waterbury, Vermont");
    expect(listing).toContain("https://www.airbnb.com/rooms/1477625352327415954");
    expect(listing).toContain(
      "https://www.airbnb.com/contact_host/1477625352327415954/send_message",
    );
    for (const name of ["The Reservoir", "Prohibition Pig", "Blackback Pub", "Hen of the Wood"]) {
      expect(listing).toContain(name);
    }
    expect(listing).toContain("onion-ranch");
    expect(listing).toContain("Details coming soon");
    expect(listing).toContain("food_drink");
    expect(listing).not.toContain("[Sample]");
    expect(listing).not.toContain("—");
    expect(listing).not.toContain("The Radish Roost");
    expect(listing).not.toContain("radish-roost");
    expect(listing).not.toContain("shallot-chalet");
    expect(listing).not.toMatch(/insert into public\.property_wifi/i);
    expect(listing).not.toMatch(/\b\d{1,5}\s+Main Street\b/);
  });
});
