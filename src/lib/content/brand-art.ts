import { dadSite } from "@/sites/dad";
import { getSiteConfig, roostSite, type SiteHero, type SiteLogo } from "@/sites";

export type BrandLogo = SiteLogo;

/** Roost hero kept for tests. Prefer getSiteConfig().hero at runtime. */
export const COLLECTION_HERO: SiteHero = roostSite.hero;

/**
 * Left-to-right order on the original roost brand sheet.
 * The Raddish Roost spelling is intentional.
 */
export const ARTWORK_ORDER = roostSite.artworkOrder;

/** Slug lookup across sites. Safe in client components; slugs stay globally unique. */
const LOGO_BY_SLUG: Record<string, SiteLogo> = Object.fromEntries(
  [...roostSite.logos, ...dadSite.logos].map((logo) => [logo.slug, logo]),
);

export function brandLogo(slug: string): BrandLogo | null {
  return LOGO_BY_SLUG[slug] ?? null;
}

export function orderLikeArtwork<T extends { slug: string }>(
  items: T[],
  artworkOrder: readonly string[] = getSiteConfig().artworkOrder,
): T[] {
  return items
    .map((item, index) => ({ item, index }))
    .sort(
      (a, b) =>
        artworkRank(a.item.slug, a.index, artworkOrder) - artworkRank(b.item.slug, b.index, artworkOrder),
    )
    .map(({ item }) => item);
}

function artworkRank(slug: string, originalIndex: number, artworkOrder: readonly string[]) {
  const painted = artworkOrder.indexOf(slug);
  if (painted === -1) return artworkOrder.length + originalIndex;
  return painted;
}
