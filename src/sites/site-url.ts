import type { Metadata } from "next";
import type { SiteConfig } from "@/sites/types";

/** Official origin for Queen City Stays. Other sites keep their current hosts. */
export function siteOrigin(site: SiteConfig): string | null {
  if (site.key !== "errin" || !site.domain) return null;
  try {
    const url = new URL(site.domain.includes("://") ? site.domain : `https://${site.domain}`);
    return url.origin;
  } catch {
    return null;
  }
}

export function siteUrl(site: SiteConfig, path = "/"): string | null {
  const origin = siteOrigin(site);
  if (!origin) return null;
  return new URL(path, `${origin}/`).toString();
}

function shareTitle(metadata: Metadata, fallback: string): string {
  if (typeof metadata.title === "string") return metadata.title;
  if (metadata.title && typeof metadata.title === "object" && "default" in metadata.title) {
    const title = metadata.title.default;
    if (typeof title === "string") return title;
  }
  return fallback;
}

/** Canonical URL and share preview for the errin site. Other sites are returned unchanged. */
export function withSiteUrl(site: SiteConfig, path: string, metadata: Metadata): Metadata {
  const origin = siteOrigin(site);
  if (!origin) return metadata;
  const url = siteUrl(site, path);
  if (!url) return metadata;
  const title = shareTitle(metadata, site.name);
  const description = typeof metadata.description === "string" ? metadata.description : site.seoDescription;
  return {
    ...metadata,
    metadataBase: new URL(origin),
    alternates: { canonical: url },
    openGraph: {
      type: "website",
      url,
      siteName: site.name,
      title,
      description,
      images: [
        {
          url: site.hero.src,
          width: site.hero.width,
          height: site.hero.height,
          alt: site.hero.alt,
        },
      ],
    },
    twitter: {
      card: "summary_large_image",
      title,
      description,
      images: [site.hero.src],
    },
  };
}
