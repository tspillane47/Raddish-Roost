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
const shallotListing = readFileSync(
  path.join(root, "supabase/migrations/20261028170000_shallot_chalet_listing.sql"),
  "utf8",
);
const onionListing = readFileSync(
  path.join(root, "supabase/migrations/20261028190000_onion_ranch_listing.sql"),
  "utf8",
);
const bookingLinks = readFileSync(
  path.join(root, "supabase/migrations/20261028201000_booking_links.sql"),
  "utf8",
);
const vrboLinks = readFileSync(
  path.join(root, "supabase/migrations/20261028220000_vrbo_booking_links.sql"),
  "utf8",
);
const thingsToDo = readFileSync(
  path.join(root, "supabase/migrations/20261028233000_winooski_things_to_do.sql"),
  "utf8",
);
const winooskiFalls = readFileSync(
  path.join(root, "supabase/migrations/20261028234500_winooski_falls_place.sql"),
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
    expect(listing).toContain("It is on its own.");
    expect(listing).not.toContain("onion-ranch");
    expect(listing).not.toContain("The Onion Ranch");
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

describe("Shallot Chalet listing sql", () => {
  it("publishes the listing facts for this stay only", () => {
    expect(shallotListing).toContain("slug = 'shallot-chalet'");
    expect(shallotListing).toContain("The Shallot Chalet");
    expect(shallotListing).toContain("A cozy two-level stay steps from the Winooski Circle");
    expect(shallotListing).toContain("Winooski, Vermont");
    expect(shallotListing).toContain("https://www.airbnb.com/rooms/1064639214342902592");
    expect(shallotListing).toContain(
      "https://www.airbnb.com/contact_host/1064639214342902592/send_message",
    );
    for (const name of [
      "Waterworks",
      "Our House",
      "Mule Bar",
      "Onion City Chicken & Oysters",
      "Four Quarters Brewery",
      "Scout Coffee",
      "Winooski Falls and river trails",
    ]) {
      expect(shallotListing).toContain(name);
    }
    expect(shallotListing).toContain("shares the building with The Onion Ranch");
    expect(shallotListing).toContain("where p.slug = 'shallot-chalet'");
    expect(shallotListing).toContain("food_drink");
    expect(shallotListing).toContain("outdoors");
    expect(shallotListing).toContain("Details coming soon");
    expect(shallotListing).toContain("usually reply within an hour");
    expect(shallotListing).not.toContain("[Sample]");
    expect(shallotListing).not.toContain("—");
    expect(shallotListing).not.toContain("raddish-roost");
    expect(shallotListing).not.toContain("onion-ranch");
    expect(shallotListing).not.toMatch(/insert into public\.property_wifi/i);
    expect(shallotListing).not.toMatch(/keypad|lockbox|door code/i);
    expect(shallotListing).not.toMatch(/\b\d{1,5}\s+\w+\s+(street|st|road|rd|avenue|ave|lane|ln)\b/i);
  });
});

describe("onion ranch listing migration", () => {
  it("publishes the real listing, separates Waterbury, and shares Winooski", () => {
    expect(onionListing).toContain("onion-ranch");
    expect(onionListing).toContain("The Onion Ranch");
    expect(onionListing).toContain("A cozy two-bedroom in the heart of downtown Winooski");
    expect(onionListing).toContain("Winooski, Vermont");
    expect(onionListing).toContain("Main Street, Waterbury, Vermont");
    expect(onionListing).toContain("It is on its own.");
    expect(onionListing).toContain("https://www.airbnb.com/rooms/862913226430309914");
    expect(onionListing).toContain(
      "https://www.airbnb.com/contact_host/862913226430309914/send_message",
    );
    expect(onionListing).toContain("usually reply within an hour");
    expect(onionListing).toContain("Free parking on site.");
    expect(onionListing).toContain("Netflix");
    expect(onionListing).toContain("HBO");
    expect(onionListing).toContain("$1,000");
    expect(onionListing).toContain("Pets are welcome.");
    for (const name of [
      "Waterworks",
      "Our House",
      "Mule Bar",
      "Onion City Chicken & Oysters",
      "Four Quarters Brewery",
      "Scout Coffee",
      "Winooski Falls and river trails",
    ]) {
      expect(onionListing).toContain(name);
    }
    expect(onionListing).toContain("where p.slug in ('shallot-chalet', 'onion-ranch')");
    expect(onionListing).toContain("c3000000-0000-4000-8000-000000000001");
    expect(onionListing).toContain("c3000000-0000-4000-8000-000000000004");
    expect(onionListing).toContain("and p.slug = 'onion-ranch'");
    expect(onionListing).toContain("food_drink");
    expect(onionListing).toContain("outdoors");
    expect(onionListing).toContain("Details coming soon");
    expect(onionListing).not.toContain("[Sample]");
    expect(onionListing).not.toContain("—");
    expect(onionListing).not.toMatch(/insert into public\.property_wifi/i);
    expect(onionListing).not.toMatch(/keypad|lockbox|door code/i);
    expect(onionListing).not.toMatch(/\b\d{1,5}\s+\w+\s+(street|st|road|rd|avenue|ave|lane|ln)\b/i);
  });
});

describe("booking links migration", () => {
  it("saves one https Airbnb link per stay and records booking clicks", () => {
    expect(bookingLinks).toContain("https://www.airbnb.com/rooms/1477625352327415954");
    expect(bookingLinks).toContain("https://www.airbnb.com/rooms/1064639214342902592");
    expect(bookingLinks).toContain("https://www.airbnb.com/rooms/862913226430309914");
    expect(bookingLinks).toContain("bl.channel = 'airbnb'");
    expect(bookingLinks).toContain("not exists");
    expect(bookingLinks).toContain("'booking_click'");
    expect(bookingLinks).toContain("platform");
    expect(bookingLinks).not.toContain("channel = 'direct'");
    expect(bookingLinks).not.toContain("channel = 'vrbo'");
    expect(bookingLinks).not.toMatch(/http:\/\//);
    expect(bookingLinks).not.toContain("—");
  });
});

describe("Winooski things to do migration", () => {
  it("saves the guidebook places for both Winooski stays", () => {
    const readable = thingsToDo.replaceAll("''", "'");
    for (const name of [
      "Waterworks Food + Drink",
      "Pho Hong",
      "Trattoria Delia",
      "Restaurant Poco",
      "Santiago's Cuban Cuisine",
      "Honey Road",
      "Hen of the Wood (Burlington)",
      "Shanty on the Shore",
      "Onion City Chicken & Oysters",
      "Taco Gordo",
      "Farmhouse Tap & Grill",
      "Pascolo Ristorante",
      "A Single Pebble",
      "Leunig's Bistro",
      "May Day",
      "Spot on the Dock",
      "Four Quarters Brewing",
      "Foam Brewers",
      "Burlington Beer Co.",
      "Devil Takes a Holiday",
      "Zero Gravity Brewery",
      "The 126",
      "Smugglers' Notch",
      "Stowe Mountain Resort",
      "Sugarbush Resort",
      "Bolton Valley Resort",
      "Trapp Family Lodge",
      "Shelburne Farms",
      "Church Street",
      "Spirit of Ethan Allen",
      "Upper Hollow Road",
      "Mount Philo",
      "Indian Brook Reservoir",
      "Sterling Pond Trail",
      "Burnt Rock Mountain",
      "Camel's Hump",
      "Vermont Comedy Club",
      "Catamount Outdoor Family Center",
      "Shy Guy Gelato",
      "Mr. Creemee Stand",
    ]) {
      expect(readable).toContain(name);
    }
    expect(readable.replaceAll("Hen of the Wood (Burlington)", "")).not.toContain("Hen of the Wood");
    expect(thingsToDo).toContain("where p.slug in ('shallot-chalet', 'onion-ranch')");
    expect(thingsToDo).not.toContain("raddish-roost");
    expect(thingsToDo).toContain("subcategory");
    expect(thingsToDo).toContain("'ski_ride'");
    expect(thingsToDo).toContain("'sweet_treats'");
    expect(thingsToDo).toContain("is_featured");
    expect(thingsToDo).toContain("Waterworks|Waterworks Food + Drink");
    expect(thingsToDo).toContain("Four Quarters Brewery|Four Quarters Brewing");
    expect(thingsToDo).toContain("https://www.google.com/maps/search/");
    expect(thingsToDo).not.toContain("—");
    expect(thingsToDo).not.toMatch(/http:\/\//);
    expect(thingsToDo).not.toMatch(/\b\d{1,5}\s+\w+\s+(street|st|road|rd|avenue|ave|lane|ln)\b/i);
  });
});

describe("Winooski Falls place migration", () => {
  it("puts the existing falls on Things to Do for the Winooski stays", () => {
    expect(winooskiFalls).toContain("Winooski Falls and river trails");
    expect(winooskiFalls).toContain("subcategory = 'see'");
    expect(winooskiFalls).toContain("p.slug in ('shallot-chalet', 'onion-ranch')");
    expect(winooskiFalls).not.toContain("raddish-roost");
    expect(winooskiFalls).not.toContain("—");
  });
});

describe("vrbo booking links migration", () => {
  it("saves one https VRBO link per stay without a direct link", () => {
    expect(vrboLinks).toContain("https://www.vrbo.com/p4832729vb");
    expect(vrboLinks).toContain("https://www.vrbo.com/p4832731vb");
    expect(vrboLinks).toContain("https://www.vrbo.com/p4832726vb");
    expect(vrboLinks).toContain("bl.channel = 'vrbo'");
    expect(vrboLinks).toContain("not exists");
    expect(vrboLinks).not.toContain("channel = 'direct'");
    expect(vrboLinks).not.toContain("channel = 'airbnb'");
    expect(vrboLinks).not.toMatch(/http:\/\//);
    expect(vrboLinks).not.toContain("—");
  });
});
