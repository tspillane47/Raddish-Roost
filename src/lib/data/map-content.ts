import { toBookingLinks, type BookingRow } from "@/lib/content/booking-links";
import { GUEST_PORTAL_URLS, guestPortalUrl } from "@/lib/content/guest-portal";
import { AIRBNB_MESSAGE_URLS } from "@/lib/content/airbnb-messages";
import { ARRIVAL_STEPS, GUIDE_SECTIONS, MERGED_BLOCK_SORT, SAMPLE_SECTION_SUMMARY } from "@/lib/content/sections";
import { SAMPLE_PROPERTIES, sampleSections } from "@/lib/content/sample-catalog";
import { guidebookImageUrl } from "@/lib/media";
import { parseGuidebookBlock } from "@/lib/validation/blocks";
import { toContactHref, type ContactChannel } from "@/lib/validation/contact";
import type {
  CheckoutTask,
  GuideBlockView,
  GuideSection,
  GuideSectionDetail,
  HouseAmenity,
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
  guest_portal_url?: string | null;
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

export type BlockRow = {
  id: string;
  title: string | null;
  body: unknown;
  sort_order: number;
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
  bookings: BookingRow[],
  supabaseUrl: string | null,
): PropertyGuide {
  return {
    ...toPropertySummary(row, supabaseUrl),
    welcomeTitle: row.welcome_title?.trim() || `Welcome to ${row.name}`,
    welcomeMessage: row.welcome_message?.trim() || "Your host has not added a welcome message yet.",
    checkInTime: row.check_in_time?.trim() || null,
    checkOutTime: row.check_out_time?.trim() || null,
    guestPortalUrl: guestPortalUrl(row.guest_portal_url),
    parkingSummary: row.parking_summary?.trim() || null,
    wifi: toPublicWifi(wifi),
    contacts: contacts.flatMap((contact) => {
      const mapped = toPublicContact(contact);
      return mapped ? [mapped] : [];
    }),
    bookings: toBookingLinks(bookings),
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

function blockFromRow(row: BlockRow, supabaseUrl: string | null): GuideBlockView | null {
  const parsed = parseGuidebookBlock(row.body);
  if (!parsed.success) return null;
  const block = parsed.data;
  const title = row.title?.trim() || null;
  const sortOrder = row.sort_order;
  if (block.type === "rich_text") return { id: row.id, sortOrder, title, kind: "rich_text", markdown: block.markdown };
  if (block.type === "steps") return { id: row.id, sortOrder, title, kind: "steps", steps: block.steps };
  if (block.type === "callout") {
    return { id: row.id, sortOrder, title, kind: "callout", tone: block.tone, markdown: block.markdown };
  }
  if (block.type === "checklist") return { id: row.id, sortOrder, title, kind: "checklist", items: block.items };
  if (block.type === "link_list") return { id: row.id, sortOrder, title, kind: "link_list", links: block.links };
  const url = supabaseUrl ? guidebookImageUrl(supabaseUrl, block.path) : null;
  if (!url) return null;
  return { id: row.id, sortOrder, title, kind: "media", url, alt: block.alt, caption: block.caption };
}

export function toCheckoutTasks(
  rows: { id: string; label: string | null; details: string | null }[],
): CheckoutTask[] {
  return rows.flatMap((row) => {
    const label = row.label?.trim() ?? "";
    if (!label) return [];
    const detail = row.details?.trim();
    return [detail ? { id: row.id, label, detail } : { id: row.id, label }];
  });
}

export function toHouseAmenities(
  rows: { id: string; name: string | null; description: string | null }[],
): HouseAmenity[] {
  return rows.flatMap((row) => {
    const name = row.name?.trim() ?? "";
    if (!name) return [];
    return [{ id: row.id, name, description: row.description?.trim() || null }];
  });
}

export function toGuideBlocks(rows: BlockRow[], supabaseUrl: string | null): GuideBlockView[] {
  return rows
    .slice()
    .sort((a, b) => a.sort_order - b.sort_order)
    .flatMap((row) => {
      const block = blockFromRow(row, supabaseUrl);
      return block ? [block] : [];
    });
}

export function previewGuideSection(propertySlug: string, sectionSlug: string): GuideSectionDetail | null {
  const property = SAMPLE_PROPERTIES.find((item) => item.slug === propertySlug);
  const section = GUIDE_SECTIONS.find((item) => item.slug === sectionSlug);
  if (!property || !section) return null;

  const blocks: GuideBlockView[] =
    section.sectionType === "check_in"
      ? [
          {
            id: "sample-steps",
            sortOrder: 10,
            title: "[Sample] Arrival steps",
            kind: "steps",
            steps: ARRIVAL_STEPS.map((title) => ({ title })),
          },
          {
            id: "sample-leave",
            sortOrder: MERGED_BLOCK_SORT,
            title: "[Sample] Before you leave",
            kind: "rich_text",
            markdown: "[Sample] Checkout notes will appear here.",
          },
        ]
      : section.sectionType === "house_guide"
        ? [
            {
              id: "sample-how",
              sortOrder: 10,
              title: "[Sample] Heat",
              kind: "rich_text",
              markdown: "[Sample] How the heat works will appear here.",
            },
            {
              id: "sample-what",
              sortOrder: MERGED_BLOCK_SORT,
              title: "[Sample] In the house",
              kind: "rich_text",
              markdown: "[Sample] Amenities will appear here.",
            },
          ]
        : [
            {
              id: "sample-notes",
              sortOrder: 10,
              title: "[Sample] Notes",
              kind: "rich_text",
              markdown: "[Sample] Your notes for this section will appear here.",
            },
          ];

  return {
    propertySlug: property.slug,
    propertyName: property.name,
    slug: section.slug,
    title: section.title,
    summary: section.sectionType === "check_in" ? "Check-in is at 4:00 PM. Checkout is at 10:00 AM." : SAMPLE_SECTION_SUMMARY,
    blocks,
    bookings: [],
    checkInTime: "4:00 PM",
    checkOutTime: "10:00 AM",
    guestPortalUrl: GUEST_PORTAL_URLS[property.slug] ?? null,
    parkingSummary: section.sectionType === "getting_here" ? "[Sample] Park in the driveway." : null,
    checkoutItems:
      section.sectionType === "check_in"
        ? [{ id: "sample-checkout", label: "[Sample] Run through the checkout list.", detail: "Details coming soon." }]
        : [],
    amenities: [],
    airbnbHref: AIRBNB_MESSAGE_URLS[property.slug] ?? null,
  };
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
    checkInTime: "4:00 PM",
    checkOutTime: "10:00 AM",
    guestPortalUrl: GUEST_PORTAL_URLS[property.slug] ?? null,
    parkingSummary: null,
    wifi: null,
    contacts: [],
    bookings: [],
    sections: sampleSections(),
  };
}
