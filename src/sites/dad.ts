import type { SiteConfig } from "@/sites/types";

/**
 * The Getaway Club (dad site).
 * Retro club palette; hero art stays at public/sites/dad/hero.webp.
 */
export const dadSite: SiteConfig = {
  key: "dad",
  name: "The Getaway Club",
  shortName: "Getaway Club",
  tagline: "Good places to get away.",
  domain: null,
  seoDescription: "Good places to get away. Vacation homes in Vermont and on Sanibel Island.",
  footerBlurb: "Vacation homes in Vermont and on Sanibel Island, each with a clear guidebook.",
  collectionHeading: "Explore Our Stays",
  collectionBody: "Six homes in Vermont and two on Sanibel Island.",
  comingSoonTitle: "Homes are on the way",
  comingSoonBody: "Check back soon for guidebooks and local tips.",
  welcome: {
    placeName: "Getaway Club",
    background: "#163A4A",
    ink: "#F1EDE4",
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
    forest: "#163A4A",
    sage: "#4A7C7A",
    cream: "#F1EDE4",
    charcoal: "#1A2330",
    beige: "#D9D2C5",
    terracotta: "#E85D04",
    muted: "#5B6B75",
    mustard: "#F0C808",
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
