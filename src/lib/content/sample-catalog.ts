import { GUIDE_SECTIONS, SAMPLE_SECTION_SUMMARY } from "@/lib/content/sections";

export type SampleProperty = {
  slug: string;
  name: string;
  tagline: string;
  description: string;
  welcomeTitle: string;
  welcomeMessage: string;
};

export const SAMPLE_PROPERTIES: SampleProperty[] = [
  {
    // Spelling is intentional: "The Raddish Roost" and /raddish-roost.
    slug: "raddish-roost",
    name: "The Raddish Roost",
    tagline: "[Sample] A short description will go here.",
    description: "[Sample] Replace this with a short description of The Raddish Roost.",
    welcomeTitle: "Welcome to The Raddish Roost",
    welcomeMessage:
      "[Sample] We're so glad you're here. Replace this with your own welcome for The Raddish Roost.",
  },
  {
    slug: "shallot-chalet",
    name: "The Shallot Chalet",
    tagline: "[Sample] A short description will go here.",
    description: "[Sample] Replace this with a short description of The Shallot Chalet.",
    welcomeTitle: "Welcome to The Shallot Chalet",
    welcomeMessage:
      "[Sample] We're so glad you're here. Replace this with your own welcome for The Shallot Chalet.",
  },
  {
    slug: "onion-ranch",
    name: "The Onion Ranch",
    tagline: "[Sample] A short description will go here.",
    description: "[Sample] Replace this with a short description of The Onion Ranch.",
    welcomeTitle: "Welcome to The Onion Ranch",
    welcomeMessage:
      "[Sample] We're so glad you're here. Replace this with your own welcome for The Onion Ranch.",
  },
];

export function sampleSections() {
  return GUIDE_SECTIONS.map((section) => ({
    slug: section.slug,
    title: section.title,
    summary: SAMPLE_SECTION_SUMMARY,
    sectionType: section.sectionType,
  }));
}
