export type GuideSection = {
  slug: string;
  title: string;
  summary: string | null;
  sectionType: string;
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
  parkingSummary: string | null;
  wifi: PublicWifi | null;
  contacts: PublicContact[];
  sections: GuideSection[];
};

export type ContentSource = "preview" | "database";

export type ContentResult<T> =
  | { ok: true; source: ContentSource; data: T }
  | { ok: false; error: "unavailable" };

export type PropertyResult =
  | { ok: true; source: ContentSource; property: PropertyGuide }
  | { ok: false; error: "unavailable" | "not_found" };
