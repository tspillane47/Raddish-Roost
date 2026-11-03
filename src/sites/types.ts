import type { SiteKey } from "@/lib/site";

export type SitePalette = {
  forest: string;
  sage: string;
  cream: string;
  charcoal: string;
  beige: string;
  terracotta: string;
  muted: string;
  /** Optional accent; dad uses mustard yellow from the concept art. */
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
  welcome: SiteWelcome;
  hero: SiteHero;
  logos: SiteLogo[];
  artworkOrder: string[];
  colors: SitePalette;
  icons: SiteIcons;
  nav?: SiteNavItem[];
  bookCta?: { label: string; href: string };
};
