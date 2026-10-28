export const COLLECTION_HERO = {
  src: "/images/brand/hero.webp",
  width: 1536,
  height: 497,
  alt: "An onion cowboy, a shallot skier, and a raddish snowboarder in a Vermont mountain scene",
} as const;

export const WELCOME_BANNER = {
  src: "/images/brand/banner.webp",
  width: 2164,
  height: 703,
  alt: "Welcome to Vermont. Make Yourself at Home. Everything you need for a wonderful stay, all in one place.",
} as const;

export type BrandLogo = {
  src: string;
  width: number;
  height: number;
  alt: string;
  /** Decorative edge color taken from the lockup. Not used for text. */
  accent: string;
};

/**
 * Left-to-right order on the original brand sheet.
 * The Raddish Roost spelling is intentional.
 */
export const ARTWORK_ORDER = ["onion-ranch", "shallot-chalet", "raddish-roost"] as const;

const LOGOS: Record<(typeof ARTWORK_ORDER)[number], BrandLogo> = {
  "onion-ranch": {
    src: "/images/brand/logo-onion-ranch.webp",
    width: 504,
    height: 483,
    alt: "Logo for The Onion Ranch",
    accent: "#6B4423",
  },
  "shallot-chalet": {
    src: "/images/brand/logo-shallot-chalet.webp",
    width: 477,
    height: 495,
    alt: "Logo for The Shallot Chalet",
    accent: "#6E2E3A",
  },
  "raddish-roost": {
    src: "/images/brand/logo-raddish-roost.webp",
    width: 515,
    height: 527,
    alt: "Logo for The Raddish Roost",
    accent: "#1E4A42",
  },
};

export function brandLogo(slug: string): BrandLogo | null {
  if (slug in LOGOS) return LOGOS[slug as keyof typeof LOGOS];
  return null;
}

export function orderLikeArtwork<T extends { slug: string }>(items: T[]): T[] {
  return items
    .map((item, index) => ({ item, index }))
    .sort((a, b) => artworkRank(a.item.slug, a.index) - artworkRank(b.item.slug, b.index))
    .map(({ item }) => item);
}

function artworkRank(slug: string, originalIndex: number) {
  const painted = ARTWORK_ORDER.indexOf(slug as (typeof ARTWORK_ORDER)[number]);
  if (painted === -1) return ARTWORK_ORDER.length + originalIndex;
  return painted;
}
