import type { SiteConfig } from "@/sites/types";

/** Live Vermont Roost Collection brand. Keep values in sync with the current site look. */
export const roostSite: SiteConfig = {
  key: "roost",
  name: "The Vermont Roost Collection",
  shortName: "Vermont Roost",
  domain: "raddishroost1.vercel.app",
  seoDescription: "Everything you need for a wonderful stay, all in one place.",
  footerBlurb: "A small collection of Vermont stays, each with its own guidebook.",
  collectionHeading: "Three unique Vermont stays. One thoughtfully curated experience.",
  collectionBody:
    "The Raddish Roost, The Shallot Chalet, and The Onion Ranch each have a guidebook for the stay itself: arrival, the house, and the places worth your time nearby.",
  comingSoonTitle: "Homes are on the way",
  comingSoonBody: "Check back soon for guidebooks and local tips.",
  welcome: {
    placeName: "Vermont.",
    background: "#243D33",
    ink: "#F8F6F0",
    showSeasonIcons: true,
    useLodgeFonts: true,
  },
  hero: {
    src: "/images/brand/hero.webp",
    width: 1536,
    height: 497,
    alt: "An onion cowboy, a shallot skier, and a raddish snowboarder in a Vermont mountain scene",
  },
  logos: [
    {
      slug: "onion-ranch",
      src: "/images/brand/logo-onion-ranch.webp",
      width: 504,
      height: 483,
      alt: "Logo for The Onion Ranch",
      accent: "#6B4423",
    },
    {
      slug: "shallot-chalet",
      src: "/images/brand/logo-shallot-chalet.webp",
      width: 477,
      height: 495,
      alt: "Logo for The Shallot Chalet",
      accent: "#6E2E3A",
    },
    {
      slug: "raddish-roost",
      src: "/images/brand/logo-raddish-roost.webp",
      width: 515,
      height: 527,
      alt: "Logo for The Raddish Roost",
      accent: "#1E4A42",
    },
  ],
  artworkOrder: ["onion-ranch", "shallot-chalet", "raddish-roost"],
  colors: {
    forest: "#263F35",
    sage: "#A8B7A0",
    cream: "#F7F4ED",
    charcoal: "#262626",
    beige: "#DDD3C4",
    terracotta: "#B97759",
    muted: "#3E4A43",
  },
  icons: {
    favicon: "/favicon.ico",
    icon192: "/icons/icon-192.png",
    icon512: "/icons/icon-512.png",
    iconMaskable512: "/icons/icon-maskable-512.png",
    appleTouch: "/apple-icon.png",
  },
};
