import type { SiteConfig } from "@/sites/types";

/**
 * Errin's Digs (errin site).
 * Temporary 1980s apres-ski placeholder until real brand details land.
 * Swap name, colors, fonts, hero, and logos here when ready.
 */
export const errinSite: SiteConfig = {
  key: "errin",
  name: "Errin's Digs",
  shortName: "Errin's Digs",
  tagline: "Ski hard. Apres harder.",
  domain: null,
  seoDescription:
    "Errin's Digs. Ski hard. Apres harder. Cozy ski-trip hideaways coming soon.",
  footerBlurb: "Three cozy hideaways for your next ski trip. Details coming soon.",
  collectionHeading: "Coming soon. Grab your shades.",
  collectionBody: "Three cozy hideaways for your next ski trip. Details coming soon.",
  comingSoonTitle: "Coming soon. Grab your shades.",
  comingSoonBody: "Three cozy hideaways for your next ski trip. Details coming soon.",
  welcome: {
    placeName: "Errin's Digs",
    background: "#0A1628",
    ink: "#FFFAFE",
    showSeasonIcons: false,
    useLodgeFonts: false,
  },
  hero: {
    src: "/sites/errin/hero.webp",
    width: 1600,
    height: 900,
    alt: "Neon mountain under a striped sunset with crossed skis and retro sunglasses",
  },
  logos: [],
  artworkOrder: [],
  colors: {
    // Mapped onto the shared palette slots so layout CSS vars keep working.
    forest: "#6B2D8B", // grape purple
    sage: "#00E5C0", // electric teal
    cream: "#FFFAFE", // snowy white
    charcoal: "#0A1628", // deep navy
    beige: "#FFE0F0", // soft pink snow
    terracotta: "#FF2D95", // hot pink
    muted: "#5C4A6E",
    mustard: "#FFE566", // sunshine yellow
  },
  icons: {
    favicon: "/sites/errin/favicon.png",
    icon192: "/sites/errin/icon-192.png",
    icon512: "/sites/errin/icon-512.png",
    iconMaskable512: "/sites/errin/icon-maskable-512.png",
    appleTouch: "/sites/errin/apple-touch-icon.png",
  },
  nav: [
    { label: "The Digs", href: "/#coming-soon", plain: "Our stays" },
  ],
  bookCta: { label: "Coming Soon", href: "/#coming-soon", plain: "Coming soon" },
};
