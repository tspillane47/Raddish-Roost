import type { BookingLink } from "@/lib/content/booking-links";

export type { BookingLink };

export type GuideSection = {
  slug: string;
  title: string;
  summary: string | null;
  sectionType: string;
};

type GuideBlockFields =
  | { id: string; title: string | null; kind: "rich_text"; markdown: string }
  | {
      id: string;
      title: string | null;
      kind: "steps";
      steps: { title: string; detail?: string }[];
    }
  | {
      id: string;
      title: string | null;
      kind: "callout";
      tone: "note" | "important";
      markdown: string;
    }
  | {
      id: string;
      title: string | null;
      kind: "checklist";
      items: { id: string; label: string; detail?: string }[];
    }
  | {
      id: string;
      title: string | null;
      kind: "link_list";
      links: { label: string; href: string }[];
    }
  | {
      id: string;
      title: string | null;
      kind: "media";
      url: string;
      alt: string;
      caption?: string;
    };

export type GuideBlockView = GuideBlockFields & { sortOrder: number };

export type CheckoutTask = {
  id: string;
  label: string;
  detail?: string;
};

export type HouseAmenity = {
  id: string;
  name: string;
  description: string | null;
};

export type GuideSectionDetail = {
  propertySlug: string;
  propertyName: string;
  slug: string;
  title: string;
  summary: string | null;
  blocks: GuideBlockView[];
  bookings: BookingLink[];
  checkInTime: string | null;
  checkOutTime: string | null;
  guestPortalUrl: string | null;
  parkingSummary: string | null;
  checkoutItems: CheckoutTask[];
  amenities: HouseAmenity[];
};

export type PublicWifi = {
  networkName: string | null;
  password: string | null;
  routerNote: string | null;
};

export type PublicContact = {
  channel: "airbnb" | "email" | "phone" | "sms";
  label: string;
  value: string;
  href: string | null;
};

export type PropertySummary = {
  slug: string;
  name: string;
  tagline: string | null;
  description: string | null;
  heroImageUrl: string | null;
  heroImageAlt: string;
};

export type PropertyGuide = PropertySummary & {
  welcomeTitle: string;
  welcomeMessage: string;
  checkInTime: string | null;
  checkOutTime: string | null;
  guestPortalUrl: string | null;
  parkingSummary: string | null;
  wifi: PublicWifi | null;
  contacts: PublicContact[];
  bookings: BookingLink[];
  sections: GuideSection[];
};

export type ContentSource = "preview" | "database";

export type ContentResult<T> =
  | { ok: true; source: ContentSource; data: T }
  | { ok: false; error: "unavailable" };

export type PropertyResult =
  | { ok: true; source: ContentSource; property: PropertyGuide }
  | { ok: false; error: "unavailable" | "not_found" };

export type SectionResult =
  | { ok: true; source: ContentSource; section: GuideSectionDetail }
  | { ok: false; error: "unavailable" | "not_found" };
