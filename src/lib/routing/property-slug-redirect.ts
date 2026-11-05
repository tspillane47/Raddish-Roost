/** Old dad property slugs that permanently redirect to new ones. */
export const PROPERTY_SLUG_REDIRECTS: Record<string, string> = {
  "tennisplace-a35": "shell-game",
  "sanibel-sunsets": "safe-harbor",
};

/** Rewrite /old-slug/... to /new-slug/... for permanent redirects. */
export function propertySlugRedirectPath(pathname: string): string | null {
  const parts = pathname.split("/").filter(Boolean);
  if (parts.length === 0) return null;

  let oldSlug: string;
  try {
    oldSlug = decodeURIComponent(parts[0] ?? "").toLowerCase();
  } catch {
    return null;
  }

  const nextSlug = PROPERTY_SLUG_REDIRECTS[oldSlug];
  if (!nextSlug) return null;

  const rest = parts.slice(1);
  return `/${[nextSlug, ...rest].join("/")}`;
}
