export const GUIDE_SECTIONS = [
  { sectionType: "getting_here", slug: "getting-here", title: "Getting Here", sortOrder: 10 },
  { sectionType: "check_in", slug: "check-in", title: "Check-In & Access", sortOrder: 20 },
  { sectionType: "wifi", slug: "wifi", title: "Wi-Fi & Technology", sortOrder: 30 },
  { sectionType: "house_guide", slug: "house-guide", title: "House Guide", sortOrder: 40 },
  { sectionType: "amenities", slug: "amenities", title: "Amenities", sortOrder: 50 },
  {
    sectionType: "recommendations",
    slug: "local-recommendations",
    title: "Local Recommendations",
    sortOrder: 60,
  },
  { sectionType: "things_to_do", slug: "things-to-do", title: "Things to Do", sortOrder: 70 },
  { sectionType: "house_rules", slug: "house-rules", title: "House Rules", sortOrder: 80 },
  { sectionType: "checkout", slug: "checkout", title: "Checkout Instructions", sortOrder: 90 },
  { sectionType: "faq", slug: "faq", title: "Frequently Asked Questions", sortOrder: 100 },
  { sectionType: "contact", slug: "contact", title: "Contact Your Hosts", sortOrder: 110 },
  { sectionType: "stay_again", slug: "stay-again", title: "Stay With Us Again", sortOrder: 120 },
] as const;

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
