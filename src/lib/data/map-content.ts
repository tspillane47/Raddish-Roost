import { SAMPLE_PROPERTIES, sampleSections } from "@/lib/content/sample-catalog";
import { guidebookImageUrl } from "@/lib/media";
import { toContactHref, type ContactChannel } from "@/lib/validation/contact";
import type {
  GuideSection,
  PropertyGuide,
  PropertySummary,
  PublicContact,
  PublicWifi,
} from "@/types/content";

export type PropertyRow = {
  id: string;
  slug: string;
  name: string;
  tagline: string | null;
  description: string | null;
  welcome_title: string | null;
  welcome_message: string | null;
  check_in_time: string | null;
  check_out_time: string | null;
  parking_summary: string | null;
  hero_image_path: string | null;
};

export type SectionRow = {
  slug: string;
  title: string | null;
  summary: string | null;
  section_type: string;
  sort_order: number;
};

export type WifiRow = {
  network_name: string | null;
  password: string | null;
  router_note: string | null;
};

export type ContactRow = {
  channel: string;
  label: string;
  value: string;
};

const CONTACT_CHANNELS = new Set<ContactChannel>(["airbnb", "email", "phone", "sms"]);

export function isMarkedSample(value: string | null | undefined): boolean {
  return typeof value === "string" && value.includes("[Sample]");
}

export function toPropertySummary(row: PropertyRow, supabaseUrl: string | null): PropertySummary {
  return {
    slug: row.slug,
    name: row.name,
    tagline: row.tagline,
    description: row.description,
    heroImageUrl: supabaseUrl ? guidebookImageUrl(supabaseUrl, row.hero_image_path) : null,
    heroImageAlt: `Photograph of ${row.name}`,
  };
}

export function toGuideSection(row: SectionRow): GuideSection {
  return {
    slug: row.slug,
    title: row.title?.trim() || "Guide section",
    summary: row.summary,
    sectionType: row.section_type,
  };
}

export function toPublicWifi(row: WifiRow | null): PublicWifi | null {
  if (!row) return null;
  const networkName = row.network_name?.trim() || null;
  const password = row.password?.trim() || null;
  const routerNote = row.router_note?.trim() || null;
  if (!networkName && !password && !routerNote) return null;
  return { networkName, password, routerNote };
}

export function toPublicContact(row: ContactRow): PublicContact | null {
  if (!CONTACT_CHANNELS.has(row.channel as ContactChannel)) return null;
  const channel = row.channel as ContactChannel;
  const label = row.label.trim();
  const value = row.value.trim();
  if (!label || !value) return null;
  return {
    channel,
    label,
    value,
    href: toContactHref(channel, value),
  };
}

export function toPropertyGuide(
  row: PropertyRow,
  sections: SectionRow[],
  wifi: WifiRow | null,
  contacts: ContactRow[],
  supabaseUrl: string | null,
): PropertyGuide {
  return {
    ...toPropertySummary(row, supabaseUrl),
    welcomeTitle: row.welcome_title?.trim() || `Welcome to ${row.name}`,
    welcomeMessage: row.welcome_message?.trim() || "Your host has not added a welcome message yet.",
    checkInTime: row.check_in_time?.trim() || null,
    checkOutTime: row.check_out_time?.trim() || null,
    parkingSummary: row.parking_summary?.trim() || null,
    wifi: toPublicWifi(wifi),
    contacts: contacts.flatMap((contact) => {
      const mapped = toPublicContact(contact);
      return mapped ? [mapped] : [];
    }),
    sections: sections
      .slice()
      .sort((a, b) => a.sort_order - b.sort_order)
      .map(toGuideSection),
  };
}

export function previewProperties(): PropertySummary[] {
  return SAMPLE_PROPERTIES.map((property) => ({
    slug: property.slug,
    name: property.name,
    tagline: property.tagline,
    description: property.description,
    heroImageUrl: null,
    heroImageAlt: `Photograph of ${property.name}`,
  }));
}

export function previewProperty(slug: string): PropertyGuide | null {
  const property = SAMPLE_PROPERTIES.find((item) => item.slug === slug);
  if (!property) return null;
  return {
    slug: property.slug,
    name: property.name,
    tagline: property.tagline,
    description: property.description,
    heroImageUrl: null,
    heroImageAlt: `Photograph of ${property.name}`,
    welcomeTitle: property.welcomeTitle,
    welcomeMessage: property.welcomeMessage,
    checkInTime: null,
    checkOutTime: null,
    parkingSummary: null,
    wifi: null,
    contacts: [],
    sections: sampleSections(),
  };
}
