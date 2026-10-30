import { readFileSync } from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { SAMPLE_PROPERTIES } from "@/lib/content/sample-catalog";
import { ARRIVAL_STEPS, GUIDE_SECTIONS, isExtraGuidePage, SAMPLE_SECTION_SUMMARY } from "@/lib/content/sections";

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
const raddishThings = readFileSync(
  path.join(root, "supabase/migrations/20261028235900_raddish_roost_things_to_do.sql"),
  "utf8",
);
const thingsCopy = readFileSync(
  path.join(root, "supabase/migrations/20261029010000_things_to_do_copy.sql"),
  "utf8",
);
const checkInTimes = readFileSync(
  path.join(root, "supabase/migrations/20261029130000_check_in_times.sql"),
  "utf8",
);
const lateCheckout = readFileSync(
  path.join(root, "supabase/migrations/20261029140000_late_checkout_portals.sql"),
  "utf8",
);
const guidebookSections = readFileSync(
  path.join(root, "supabase/migrations/20261029150000_guidebook_sections.sql"),
  "utf8",
);
const guestNotes = readFileSync(
  path.join(root, "supabase/migrations/20261030120000_guest_notes.sql"),
  "utf8",
);
const perfectDays = readFileSync(
  path.join(root, "supabase/migrations/20261030130000_perfect_days.sql"),
  "utf8",
);
const weatherNearby = readFileSync(
  path.join(root, "supabase/migrations/20261030160000_weather_and_nearby.sql"),
  "utf8",
);
const thingTags = readFileSync(
  path.join(root, "supabase/migrations/20261030170000_thing_tags.sql"),
  "utf8",
);
const thingTagFixes = readFileSync(
  path.join(root, "supabase/migrations/20261030180000_thing_tag_fixes.sql"),
  "utf8",
);

const SEEDED_SECTIONS = [
  ["getting-here", "Getting Here"],
  ["check-in", "Check-In & Access"],
  ["wifi", "Wi-Fi & Technology"],
  ["house-guide", "House Guide"],
  ["amenities", "Amenities"],
  ["local-recommendations", "Local Recommendations"],
  ["things-to-do", "Things to Do"],
  ["house-rules", "House Rules"],
  ["checkout", "Checkout Instructions"],
  ["faq", "Frequently Asked Questions"],
  ["contact", "Contact Your Hosts"],
  ["stay-again", "Stay With Us Again"],
] as const;

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
    for (const [slug, title] of SEEDED_SECTIONS) {
      expect(seed).toContain(slug);
      expect(seed).toContain(title);
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

describe("Raddish Roost things to do migration", () => {
  it("adds Waterbury places for The Raddish Roost and keeps shared places linked", () => {
    const readable = raddishThings.replaceAll("''", "'");
    for (const name of [
      "Blackback Pub",
      "Gallus Handcrafted Pasta",
      "The Reservoir",
      "Park Row Cafe",
      "Salt & Rind",
      "Maxi's",
      "Michael's on the Hill",
      "Stone's Throw Pizza",
      "Prohibition Pig",
      "The Alchemist Brewery",
      "Stowe Cider",
      "Lawson's Finest Liquids",
      "Hender's Bake Shop & Cafe",
      "K.C.'s Bagel Café",
      "Black Cap Coffee & Bakery",
      "Stowe Street Café",
      "Vermont Artisan Coffee & Tea",
      "Bolton Valley Resort",
      "Sugarbush Resort",
      "Stowe Mountain Resort",
      "Ben & Jerry's Factory",
      "Cold Hollow Cider Mill",
      "Cabot Farmers' Store",
      "Little River State Park",
      "Stowe Pinnacle",
      "Burnt Rock Mountain",
      "Camel's Hump",
      "Mount Mansfield",
      "Cady Hill Forest",
      "The Driving Range Adaptive Mountain Bike Trails",
    ]) {
      expect(readable).toContain(name);
    }
    expect(readable).toContain("Great food and an excellent beer selection.");
    expect(readable).toContain("Brewery around the back!");
    expect(readable).toContain("'coffee'");
    expect(readable).toContain("'bike'");
    expect(readable).toContain("rec.link_only");
    expect(raddishThings).toContain("where p.slug = 'raddish-roost'");
    expect(raddishThings).not.toContain("shallot-chalet");
    expect(raddishThings).not.toContain("onion-ranch");
    expect(readable).not.toContain("Hen of the Wood");
    expect(raddishThings).toContain("is_featured");
    expect(raddishThings).toContain("https://www.google.com/maps/search/");
    expect(raddishThings).not.toContain("—");
    expect(raddishThings).not.toMatch(/http:\/\//);
    expect(raddishThings).not.toMatch(/\b\d{1,5}\s+\w+\s+(street|st|road|rd|avenue|ave|lane|ln)\b/i);
  });
});

describe("Things to Do copy migration", () => {
  it("updates descriptions and host tips by name without changing stay links", () => {
    expect(thingsCopy).toContain("where name = rec.name");
    expect(thingsCopy).toContain("The steak frites are to die for. Ask for a table by the windows.");
    expect(thingsCopy).toContain("A lively restaurant in a restored mill building right on the Winooski River");
    expect(thingsCopy).toContain("Hen of the Wood (Burlington)");
    expect(thingsCopy.replaceAll("Hen of the Wood (Burlington)", "")).not.toContain("Hen of the Wood");
    expect(thingsCopy).toContain("Winooski Falls and river trails");
    expect(thingsCopy).toContain("The Driving Range Adaptive Mountain Bike Trails");
    expect(thingsCopy).toContain("subcategory = coalesce(rec.subcategory, subcategory)");
    expect(thingsCopy).toContain("$n$Prohibition Pig$n$, $d$A Waterbury institution");
    expect(thingsCopy).toMatch(/\$n\$Prohibition Pig\$n\$, \$d\$[\s\S]*?, 'eat'\)/);
    expect(thingsCopy).toContain("null::text, null::text");
    expect(thingsCopy).not.toMatch(/property_recommendations/i);
    expect(thingsCopy).not.toContain("shallot-chalet");
    expect(thingsCopy).not.toContain("onion-ranch");
    expect(thingsCopy).not.toContain("raddish-roost");
    expect(thingsCopy).not.toContain("—");
    expect(thingsCopy).not.toMatch(/http:\/\//);
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

describe("check-in times migration", () => {
  it("sets the same times for every stay and a portal link only for The Raddish Roost", () => {
    expect(checkInTimes).toContain("check_in_time = '4:00 PM'");
    expect(checkInTimes).toContain("check_out_time = '10:00 AM'");
    expect(checkInTimes).toContain("guest_portal_url");
    expect(checkInTimes).toContain(
      "https://stay.hospitable.com/7f2dc4a2-c49d-4fba-af96-4d92d9870635/login?returnUrl=%2F7f2dc4a2-c49d-4fba-af96-4d92d9870635%2Fupgrade%3F_t%3Dsc_su",
    );
    expect(checkInTimes).toContain("when 'raddish-roost' then");
    expect(checkInTimes).toContain("else null");
    expect(checkInTimes).toContain("'guest_portal_click'");
    expect(checkInTimes).toContain("Check-in is at 4:00 PM. Checkout is at 10:00 AM.");
    expect(checkInTimes).toContain("Checkout is at 10:00 AM.");
    expect(checkInTimes).toContain("grant select (guest_portal_url)");
    expect(checkInTimes).not.toContain("—");
    expect(checkInTimes).not.toMatch(/http:\/\//);
    expect(checkInTimes).not.toContain("shallot-chalet' then 'https");
  });
});

describe("guidebook sections migration", () => {
  it("merges to eight sections and keeps the hidden rows", () => {
    expect(GUIDE_SECTIONS).toHaveLength(8);
    expect(isExtraGuidePage("vermont-101")).toBe(true);
    expect(isExtraGuidePage("things-to-do")).toBe(false);
    for (const section of GUIDE_SECTIONS) {
      expect(guidebookSections).toContain(section.slug);
      expect(guidebookSections).toContain(section.title);
    }
    expect(guidebookSections).toContain("seed_guidebook_sections");
    expect(guidebookSections).toContain("is_visible = false");
    expect(guidebookSections).toContain("'faq'");
    expect(guidebookSections).toContain("1000 + block.sort_order");
    expect(guidebookSections).toContain("check-in-checkout");
    expect(guidebookSections).toContain("the-house");
    expect(guidebookSections).toContain("Getting Here & Parking");
    expect(guidebookSections).toContain("Wi-Fi & TV");
    expect(guidebookSections).toContain("Contact & Emergency");
    expect(guidebookSections).not.toMatch(/delete from public\.guidebook_sections/i);
    expect(guidebookSections).not.toMatch(/delete from public\.guidebook_blocks/i);
    expect(guidebookSections).not.toContain("—");
    expect(guidebookSections).not.toContain("Radish");
  });
});

describe("late checkout portal migration", () => {
  it("saves one https portal link per stay and records late checkout clicks", () => {
    expect(lateCheckout).toContain("20261029130000_check_in_times.sql");
    expect(lateCheckout).toContain("'late_checkout_click'");
    expect(lateCheckout).toContain("where event_name = 'guest_portal_click'");
    const allowedEvents = lateCheckout.slice(lateCheckout.indexOf("event_name in ("));
    expect(allowedEvents.slice(0, allowedEvents.indexOf(")"))).not.toContain("guest_portal_click");
    expect(lateCheckout).toContain("set guest_portal_url = v.url");
    for (const url of [
      "https://stay.hospitable.com/7f2dc4a2-c49d-4fba-af96-4d92d9870635/login?returnUrl=%2F7f2dc4a2-c49d-4fba-af96-4d92d9870635%2Fupgrade%3F_t%3Dsc_su",
      "https://stay.hospitable.com/53bf07d7-1177-43f0-bd73-36427f1b1289/upgrade?_t=sc_su",
      "https://stay.hospitable.com/72b4adbe-4aa2-4d62-a077-55829eeba0d1/login?returnUrl=%2F72b4adbe-4aa2-4d62-a077-55829eeba0d1%2Fupgrade%3F_t%3Dsc_su",
    ]) {
      expect(lateCheckout).toContain(url);
    }
    expect(lateCheckout).toContain("'raddish-roost'");
    expect(lateCheckout).toContain("'shallot-chalet'");
    expect(lateCheckout).toContain("'onion-ranch'");
    expect(lateCheckout).not.toContain("—");
    expect(lateCheckout).not.toMatch(/http:\/\//);
    expect(lateCheckout).not.toMatch(/insert into public\.properties/i);
  });
});

describe("guest notes migration", () => {
  it("lets anonymous guests send a note without reading the table", () => {
    expect(guestNotes).toContain("alter column name drop not null");
    expect(guestNotes).toContain("alter column email drop not null");
    expect(guestNotes).toContain("visitor_hash");
    expect(guestNotes).toContain("submit_guest_note");
    expect(guestNotes).toContain("grant execute on function public.submit_guest_note(text, text, text, text) to anon");
    expect(guestNotes).toContain("revoke all on table public.contact_messages from anon");
    expect(guestNotes).toContain("Please wait a bit and try again.");
    expect(guestNotes).toContain("'Something not right'");
    expect(guestNotes).toContain("v_count >= 5");
    expect(guestNotes).not.toMatch(/grant select[\s\S]*contact_messages to anon/);
    expect(guestNotes).not.toMatch(/grant insert[\s\S]*contact_messages to anon/);
    expect(guestNotes).not.toContain("—");
    expect(guestNotes).not.toContain("Radish");
  });
});

describe("perfect days migration", () => {
  it("stores a fall and winter day for every stay and links each stop", () => {
    expect(perfectDays).toContain("create table if not exists public.itineraries");
    expect(perfectDays).toContain("create table if not exists public.itinerary_stops");
    expect(perfectDays).toContain("itineraries_public_read");
    expect(perfectDays).toContain("grant select");
    expect(perfectDays).toContain("on conflict (property_id, recommendation_id) do nothing");
    expect(perfectDays).toContain("on conflict (property_id, season) do nothing");
    expect(perfectDays).toContain("existing.sort_order = s.sort_order");
    expect(perfectDays).toContain("'Our perfect day'");
    expect(perfectDays).toContain("Upper Hollow Road");
    expect(perfectDays).toContain("Coffee and a pastry, a short walk from the house.");
    expect(perfectDays).toContain("Dinner, then a beer at the brewery around the back.");
    expect(perfectDays).toContain("Night skiing is a fun alternative to an early night.");
    expect(perfectDays).toContain("A walk along the falls and the river trails.");
    expect(perfectDays).toContain("Dinner. Book well in advance.");
    expect(perfectDays).toContain("'shallot-chalet'");
    expect(perfectDays).toContain("'onion-ranch'");
    expect(perfectDays).toContain("'raddish-roost'");
    expect(perfectDays).toContain("The Raddish Roost fall day should have 8 stops.");
    expect(perfectDays).toContain("Each Winooski winter day should have 7 stops.");
    expect(perfectDays).not.toMatch(/delete from public\.guidebook/i);
    expect(perfectDays).not.toMatch(/discount|perk|reward|coupon/i);
    expect(perfectDays).not.toContain("—");
    expect(perfectDays).not.toContain("Radish");
  });
});

describe("weather and nearby essentials migration", () => {
  it("stores town coordinates and a search row for each stay", () => {
    expect(weatherNearby).toContain("weather_latitude = 44.3378");
    expect(weatherNearby).toContain("weather_longitude = -72.7562");
    expect(weatherNearby).toContain("weather_latitude = 44.4914");
    expect(weatherNearby).toContain("weather_longitude = -73.1854");
    expect(weatherNearby).toContain("slug = 'raddish-roost'");
    expect(weatherNearby).toContain("slug in ('shallot-chalet', 'onion-ranch')");
    expect(weatherNearby).toContain("('raddish-roost', 'Waterbury, VT')");
    expect(weatherNearby).toContain("('shallot-chalet', 'Winooski, VT')");
    expect(weatherNearby).toContain("('onion-ranch', 'Winooski, VT')");
    expect(weatherNearby).toContain("'grocery store near'");
    expect(weatherNearby).toContain("'hospital near'");
    expect(weatherNearby).toContain("For emergencies, call 911.");
    expect(weatherNearby).toContain("grant select (weather_latitude, weather_longitude)");
    expect(weatherNearby).toContain("nearby_essentials_public_read");
    expect(weatherNearby).toContain("where not exists");
    expect(weatherNearby).not.toContain("—");
    expect(weatherNearby).not.toContain("Radish");
  });
});

describe("thing tags migration", () => {
  it("keeps rainy, kid, and dog lists and leaves Walkable for a later manual list", () => {
    expect(thingTags).toContain("guest_tags");
    expect(thingTags).toContain("Walkable is a manual tag");
    expect(thingTags).not.toContain("when 'raddish-roost' then 'Waterbury'");
    expect(thingTags).toContain("place.name <> 'Spot on the Dock'");
    expect(thingTags).toContain("name = 'Scout Coffee'");
    expect(thingTags).toContain("town = 'Winooski'");
    expect(thingTags).toContain("subcategory = 'coffee'");
    expect(thingTags).toContain("Cold Hollow Cider Mill is in Waterbury Center");
    expect(thingTags).toContain("Church Street is partly outdoors");
    expect(thingTags).toContain("Shelburne Farms does not welcome dogs");
    expect(thingTags).toContain("'Four Quarters Brewing'");
    expect(thingTags).toContain("'Mount Philo'");
    expect(thingTags).toContain("'Indian Brook Reservoir'");
    expect(thingTags).toContain("where tag is not null");
    expect(thingTags).not.toContain("—");
    expect(thingTags).not.toContain("Radish");
    expect(thingTags).not.toMatch(/delete from public\.guidebook/i);
  });
});

describe("thing tag fixes migration", () => {
  it("corrects the far Waterbury spots, the dock, and the three blank rows", () => {
    expect(thingTagFixes).toContain("Run 20261030170000_thing_tags.sql before this file.");
    expect(thingTagFixes).toContain("Little River State Park and Ben & Jerry''s Factory are too far to walk");
    expect(thingTagFixes).toContain("array_remove(pr.guest_tags, 'walkable')");
    expect(thingTagFixes).toContain("array_remove(pr.guest_tags, 'rainy_day')");
    expect(thingTagFixes).toContain("place.name = 'Spot on the Dock'");
    expect(thingTagFixes).toContain("town = 'Winooski', subcategory = 'eat'");
    expect(thingTagFixes).toContain("town = 'Winooski', subcategory = 'drink'");
    expect(thingTagFixes).toContain("town = 'Waterbury', subcategory = 'eat'");
    expect(thingTagFixes).toContain("where name = 'Our House'");
    expect(thingTagFixes).toContain("where name = 'Mule Bar'");
    expect(thingTagFixes).toContain("where name = 'Hen of the Wood'");
    expect(thingTagFixes).toContain("'shallot-chalet', $n$Our House$n$");
    expect(thingTagFixes).toContain("'onion-ranch', $n$Mule Bar$n$");
    expect(thingTagFixes).toContain("'raddish-roost', $n$Hen of the Wood$n$");
    expect(thingTagFixes).toContain("'raddish-roost', $n$Black Cap Coffee & Bakery$n$");
    expect(thingTagFixes).not.toContain("'raddish-roost', $n$Little River State Park$n$");
    expect(thingTagFixes).not.toContain("'raddish-roost', $n$Ben & Jerry's Factory$n$");
    expect(thingTagFixes).toContain("Hen of the Wood (Burlington)");
    expect(thingTagFixes).not.toContain(
      "from public.properties stay\n  join public.recommendations place on place.id = pr.recommendation_id",
    );
    expect(thingTagFixes).toContain("and pr.recommendation_id = place.id");
    expect(thingTagFixes).not.toContain("—");
    expect(thingTagFixes).not.toContain("Radish");
    expect(thingTagFixes).not.toMatch(/delete from public\.guidebook/i);
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
