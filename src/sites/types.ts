import type { Locale } from "@/lib/i18n/locale";
import type { SiteKey } from "@/lib/site";

export type SitePalette = {
  forest: string;
  sage: string;
  cream: string;
  charcoal: string;
  beige: string;
  terracotta: string;
  muted: string;
  /** Optional accent; dad uses brass gold. */
  mustard?: string;
};

export type SiteHero = {
  src: string;
  width: number;
  height: number;
  alt: string;
};

export type SiteLogo = {
  slug: string;
  src: string;
  width: number;
  height: number;
  alt: string;
  /** Decorative edge color taken from the lockup. Not used for text. */
  accent: string;
};

export type SiteIcons = {
  favicon: string;
  icon192: string;
  icon512: string;
  iconMaskable512: string;
  appleTouch: string;
};

export type SiteWelcome = {
  /** Big place word under the welcome band, e.g. "Vermont." */
  placeName: string;
  background: string;
  ink: string;
  showSeasonIcons: boolean;
  useLodgeFonts: boolean;
};

export type SiteNavItem = {
  label: string;
  href: string;
  /** Optional plain label shown under a themed nav label. */
  plain?: string;
};

/** Themed headline + plain guest-facing label. */
export type SiteLabelPair = {
  themed: string;
  plain: string;
};

/**
 * Optional dad-style chrome labels. Roost leaves this unset and keeps normal names.
 * Keys map to guidebook sections and shared UI spots.
 */
export type SiteLabelKey =
  | "ourStays"
  | "bookNow"
  | "checkInCheckout"
  | "gettingHere"
  | "wifi"
  | "theHouse"
  | "houseRules"
  | "thingsToDo"
  | "perfectDay"
  | "contact"
  | "guestNote"
  | "stayAgain"
  | "checkoutIntro";

export type SiteLabelSet = Partial<Record<SiteLabelKey, SiteLabelPair>> & {
  /** Rubber-stamp text when checkout is complete. */
  checkoutStamp?: string;
};

/** Homepage-only teaser. Not a published property and not in the database. */
export type ComingSoonStay = {
  id: string;
  name: string;
  locality: string;
  /** Optional photo later; leave unset for the branded placeholder. */
  photoSrc?: string;
  /** mountain or cabin silhouette while waiting on real photos. */
  placeholder: "mountain" | "cabin";
};

export type SiteConfig = {
  key: SiteKey;
  name: string;
  shortName: string;
  tagline?: string;
  domain: string | null;
  seoDescription: string;
  footerBlurb: string;
  collectionHeading: string;
  collectionBody: string;
  comingSoonTitle: string;
  comingSoonBody: string;
  /** Dad homepage teasers only. Not routed, not booked, not in Supabase. */
  comingSoon?: ComingSoonStay[];
  welcome: SiteWelcome;
  hero: SiteHero;
  logos: SiteLogo[];
  artworkOrder: string[];
  colors: SitePalette;
  icons: SiteIcons;
  nav?: SiteNavItem[];
  bookCta?: { label: string; href: string; plain?: string };
  /** Localized themed labels. When missing, UI uses normal roost names. */
  labels?: Partial<Record<Locale, SiteLabelSet>>;
};
