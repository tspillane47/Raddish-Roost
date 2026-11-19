import type { MetadataRoute } from "next";
import { getSiteConfig } from "@/sites";
import { siteUrl } from "@/sites/site-url";

export default function sitemap(): MetadataRoute.Sitemap {
  const site = getSiteConfig();
  const paths = ["/", ...site.artworkOrder.map((slug) => `/${slug}`), "/contact", "/privacy", "/terms"];
  return paths.flatMap((path) => {
    const url = siteUrl(site, path);
    return url ? [{ url }] : [];
  });
}
