/** Blocks moved in from a second section start at this sort order. */
export const MERGED_BLOCK_SORT = 1000;

export const GUIDE_SECTIONS = [
  {
    sectionType: "check_in",
    slug: "check-in-checkout",
    title: "Check-In & Checkout",
    sortOrder: 10,
  },
  {
    sectionType: "getting_here",
    slug: "getting-here",
    title: "Getting Here & Parking",
    sortOrder: 20,
  },
  { sectionType: "wifi", slug: "wifi", title: "Wi-Fi & TV", sortOrder: 30 },
  { sectionType: "house_guide", slug: "the-house", title: "The House", sortOrder: 40 },
  { sectionType: "house_rules", slug: "house-rules", title: "House Rules", sortOrder: 50 },
  { sectionType: "things_to_do", slug: "things-to-do", title: "Things to Do", sortOrder: 60 },
  { sectionType: "contact", slug: "contact", title: "Contact & Emergency", sortOrder: 70 },
  { sectionType: "stay_again", slug: "stay-again", title: "Stay With Us Again", sortOrder: 80 },
] as const;

/** Old guidebook addresses. They forward once the new section is published. */
export const LEGACY_SECTION_REDIRECTS: Record<string, string> = {
  "check-in": "check-in-checkout",
  checkout: "check-in-checkout",
  "house-guide": "the-house",
  amenities: "the-house",
  "local-recommendations": "things-to-do",
  recommendations: "things-to-do",
};

export const SAMPLE_SECTION_SUMMARY = "[Sample] This section is ready for your notes.";

export const ARRIVAL_STEPS = [
  "Arrive at the property.",
  "Park in the designated parking area.",
  "Locate the main entrance.",
  "Follow the private access instructions provided with your reservation.",
  "Make yourself at home.",
] as const;

export type PlaceholderTone = "forest" | "charcoal" | "beige";

const TONES: Record<string, PlaceholderTone> = {
  "raddish-roost": "forest",
  "shallot-chalet": "charcoal",
  "onion-ranch": "beige",
};

export function placeholderTone(slug: string): PlaceholderTone {
  return TONES[slug] ?? "forest";
}
