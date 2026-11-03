import type { SiteConfig } from "@/sites/types";

/**
 * Placeholder brand for Dad's site.
 * Replace name, domain, hero, colors, and icons when the real brand is ready.
 */
export const dadSite: SiteConfig = {
  key: "dad",
  name: "[Dad's Site Name]",
  shortName: "[Dad's Site]",
  domain: null,
  seoDescription: "Guidebooks for Vermont stays. Homes coming soon.",
  footerBlurb: "Vermont stays with a clear guidebook for each home. More soon.",
  collectionHeading: "Homes coming soon",
  collectionBody: "This site will hold Dad's Vermont rentals and their guest guidebooks.",
  comingSoonTitle: "Homes are on the way",
  comingSoonBody: "Check back soon for guidebooks and local tips.",
  welcome: {
    placeName: "[Dad's Site Name]",
    background: "#2F3A3C",
    ink: "#F4F5F5",
    showSeasonIcons: false,
    useLodgeFonts: false,
  },
  hero: {
    src: "/sites/dad/hero.webp",
    width: 1536,
    height: 497,
    alt: "Placeholder hills for Dad's Vermont stays",
  },
  logos: [],
  artworkOrder: [],
  colors: {
    forest: "#2F3A3C",
    sage: "#A7B0B0",
    cream: "#F4F5F5",
    charcoal: "#1F2424",
    beige: "#D5D8D8",
    terracotta: "#6B7C7E",
    muted: "#4A5355",
  },
  icons: {
    favicon: "/sites/dad/favicon.png",
    icon192: "/sites/dad/icon-192.png",
    icon512: "/sites/dad/icon-512.png",
    iconMaskable512: "/sites/dad/icon-maskable-512.png",
    appleTouch: "/sites/dad/apple-touch-icon.png",
  },
};
