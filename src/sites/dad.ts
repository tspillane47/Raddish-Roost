import type { SiteConfig } from "@/sites/types";

/**
 * The Far & Familiar Collection.
 * Palette and art follow public/sites/dad/far-and-familiar-concept.png.
 */
export const dadSite: SiteConfig = {
  key: "dad",
  name: "The Far & Familiar Collection",
  shortName: "Far & Familiar",
  tagline: "Good places to get away.",
  domain: null,
  seoDescription: "Good places to get away. Vacation homes in Vermont and on Sanibel Island.",
  footerBlurb: "Vacation homes in Vermont and on Sanibel Island, each with a clear guidebook.",
  collectionHeading: "Explore Our Stays",
  collectionBody: "Six homes in Vermont and two on Sanibel Island.",
  comingSoonTitle: "Homes are on the way",
  comingSoonBody: "Check back soon for guidebooks and local tips.",
  welcome: {
    placeName: "Far & Familiar",
    background: "#1F3A2E",
    ink: "#F3EFE4",
    showSeasonIcons: false,
    useLodgeFonts: false,
  },
  hero: {
    src: "/sites/dad/hero.webp",
    width: 2172,
    height: 724,
    alt: "Illustrated Vermont autumn mountains, church, and airport meeting a Sanibel beach with dolphins and a sunset bridge",
  },
  logos: [],
  artworkOrder: [
    "cider-loft",
    "switchback-suite",
    "hinesburg-hideaway-3",
    "hinesburg-hideaway-4",
    "backyard-bungalow",
    "landing-pad",
    "tennisplace-a35",
    "sanibel-sunsets",
  ],
  colors: {
    forest: "#1F3A2E",
    sage: "#5B8A8A",
    cream: "#F3EFE4",
    charcoal: "#2A2622",
    beige: "#E5DFD2",
    terracotta: "#C45C2A",
    muted: "#5C6B5F",
    mustard: "#C9A227",
  },
  icons: {
    favicon: "/sites/dad/favicon.png",
    icon192: "/sites/dad/icon-192.png",
    icon512: "/sites/dad/icon-512.png",
    iconMaskable512: "/sites/dad/icon-maskable-512.png",
    appleTouch: "/sites/dad/apple-touch-icon.png",
  },
  nav: [
    { label: "Our Stays", href: "/#our-stays" },
    { label: "Vermont", href: "/#vermont" },
    { label: "Sanibel", href: "/#sanibel" },
  ],
  bookCta: { label: "Book a Stay", href: "/#our-stays" },
};
