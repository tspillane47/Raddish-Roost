import type { SiteConfig } from "@/sites/types";

/**
 * Queen City Stays (errin site).
 * Editorial, Dwell-inspired look. Swap hero, logos, and copy here as details land.
 */
export const errinSite: SiteConfig = {
  key: "errin",
  name: "Queen City Stays",
  shortName: "Queen City Stays",
  tagline: "Modern stays in Burlington and Winooski.",
  domain: null,
  seoDescription:
    "Queen City Stays. Modern stays in Burlington and Winooski. Hosted by Errin.",
  footerBlurb: "Modern stays in Burlington and Winooski. Hosted by Errin.",
  collectionHeading: "Where are you staying?",
  collectionBody: "Three calm apartments for your next trip to Burlington and Winooski.",
  comingSoonTitle: "Where are you staying?",
  comingSoonBody: "Three calm apartments for your next trip to Burlington and Winooski.",
  welcome: {
    placeName: "Queen City Stays",
    background: "#FAF9F6",
    ink: "#141414",
    showSeasonIcons: false,
    useLodgeFonts: false,
  },
  hero: {
    src: "/sites/errin/hero.webp",
    width: 2172,
    height: 724,
    alt: "Autumn evening on a Burlington street with lake and mountains beyond",
  },
  logos: [],
  artworkOrder: ["winooski-flat", "mill-house", "maple-street-flat"],
  colors: {
    forest: "#3D5A6C", // Lake Champlain slate blue (primary accent)
    sage: "#3D5A6C",
    cream: "#FAF9F6", // warm white
    charcoal: "#141414", // ink
    beige: "#E7E3DC", // stone
    terracotta: "#A5543E", // muted brick, used sparingly
    muted: "#6B6560",
    mustard: "#A5543E",
  },
  icons: {
    favicon: "/sites/errin/favicon.png",
    icon192: "/sites/errin/icon-192.png",
    icon512: "/sites/errin/icon-512.png",
    iconMaskable512: "/sites/errin/icon-maskable-512.png",
    appleTouch: "/sites/errin/apple-touch-icon.png",
  },
  nav: [
    { label: "Stays", href: "/#where-staying", plain: "Where are you staying?" },
  ],
  bookCta: { label: "Book a stay", href: "/#where-staying", plain: "Book now" },
};
