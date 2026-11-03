export const SITE_KEYS = ["roost", "dad"] as const;

export type SiteKey = (typeof SITE_KEYS)[number];

export const DEFAULT_SITE_KEY: SiteKey = "roost";

export const ROOST_SITE_ID = "c1000000-0000-4000-8000-000000000001";
export const DAD_SITE_ID = "c1000000-0000-4000-8000-000000000002";

export const SITE_IDS: Record<SiteKey, string> = {
  roost: ROOST_SITE_ID,
  dad: DAD_SITE_ID,
};

export function parseSiteKey(value: string | null | undefined): SiteKey | null {
  const raw = value?.trim().toLowerCase();
  if (raw === "roost" || raw === "dad") return raw;
  return null;
}

/** Active site for this deployment. Missing SITE_KEY means roost. */
export function getSiteKey(env: Record<string, string | undefined> = process.env as Record<string, string | undefined>): SiteKey {
  return parseSiteKey(env.SITE_KEY) ?? DEFAULT_SITE_KEY;
}

export function siteIdForKey(siteKey: SiteKey): string {
  return SITE_IDS[siteKey];
}

/** True only when the property belongs to the active site. */
export function propertyBelongsToSite(
  property: { site_id?: string | null; siteKey?: string | null } | null | undefined,
  siteKey: SiteKey,
): boolean {
  if (!property) return false;
  if (property.site_id) return property.site_id === siteIdForKey(siteKey);
  if (property.siteKey) return property.siteKey === siteKey;
  return false;
}

/** REST filter that lists published property slugs for one site only. */
export function publishedSlugsRequest(baseUrl: string, siteKey: SiteKey): string {
  const url = new URL(`${baseUrl.replace(/\/$/, "")}/rest/v1/properties`);
  url.searchParams.set("select", "slug");
  url.searchParams.set("status", "eq.published");
  url.searchParams.set("site_id", `eq.${siteIdForKey(siteKey)}`);
  return url.toString();
}

/** REST filter that checks a guidebook section on one site only. */
export function guideSectionRequest(
  baseUrl: string,
  siteKey: SiteKey,
  propertySlug: string,
  sectionSlug: string,
): string {
  const url = new URL(`${baseUrl.replace(/\/$/, "")}/rest/v1/guidebook_sections`);
  url.searchParams.set("select", "slug,properties!inner(slug,site_id)");
  url.searchParams.set("slug", `eq.${sectionSlug}`);
  url.searchParams.set("is_visible", "eq.true");
  url.searchParams.set("published_at", "not.is.null");
  url.searchParams.set("properties.slug", `eq.${propertySlug}`);
  url.searchParams.set("properties.status", "eq.published");
  url.searchParams.set("properties.site_id", `eq.${siteIdForKey(siteKey)}`);
  return url.toString();
}
