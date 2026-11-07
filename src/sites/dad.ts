import { dadLabelsEn, dadLabelsEs, dadLabelsFr } from "@/sites/dad-labels";
import type { SiteConfig } from "@/sites/types";

/**
 * The Getaway Club (dad site).
 * Playful retro heist theme: stylish escape, never actually criminal.
 * Hero prefers public/sites/dad/hero-getaway.webp when that file exists
 * (resolved at render via resolveDadHero).
 */
export const dadSite: SiteConfig = {
  key: "dad",
  name: "The Getaway Club",
  shortName: "Getaway Club",
  tagline: "Make a clean getaway.",
  domain: null,
  seoDescription:
    "The Getaway Club. Make a clean getaway. Vacation hideouts in Vermont and on Sanibel Island.",
  footerBlurb: "Eight hideouts across Vermont and Sanibel Island. Make a clean getaway.",
  collectionHeading: "The Hideouts",
  collectionBody: "Eight hideouts. Six in Vermont, two on Sanibel Island. No questions asked.",
  comingSoonTitle: "Hideouts on the way",
  comingSoonBody: "Check back soon for guidebooks and local tips.",
  comingSoon: [
    {
      id: "reservoir-retreat",
      name: "The Reservoir Retreat",
      locality: "Waterbury, VT",
      placeholder: "mountain",
    },
    {
      id: "bear-den",
      name: "The Bear Den",
      locality: "Waterbury, VT",
      placeholder: "cabin",
    },
  ],
  welcome: {
    placeName: "Getaway Club",
    background: "#1B4332",
    ink: "#E8DCC8",
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
    forest: "#1B4332",
    sage: "#6B9B8E",
    cream: "#E8DCC8",
    charcoal: "#1A1A1A",
    beige: "#D4C4A8",
    terracotta: "#C1121F",
    muted: "#5C5A55",
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
    { label: "The Hideouts", href: "/#our-stays", plain: "Our stays" },
    { label: "Vermont", href: "/#vermont" },
    { label: "Sanibel", href: "/#sanibel" },
  ],
  bookCta: { label: "Plan Your Escape", href: "/#our-stays", plain: "Book now" },
  labels: {
    en: dadLabelsEn,
    es: dadLabelsEs,
    fr: dadLabelsFr,
  },
};
