import type { MetadataRoute } from "next";
import { getSiteConfig } from "@/sites";
import { siteOrigin } from "@/sites/site-url";

export default function manifest(): MetadataRoute.Manifest {
  const site = getSiteConfig();
  const origin = siteOrigin(site);
  return {
    name: site.name,
    short_name: site.shortName,
    description: site.seoDescription,
    start_url: origin ? `${origin}/` : "/",
    ...(origin ? { id: `${origin}/`, scope: `${origin}/` } : {}),
    display: "standalone",
    background_color: site.colors.cream,
    theme_color: site.colors.forest,
    icons: [
      { src: site.icons.icon192, sizes: "192x192", type: "image/png", purpose: "any" },
      { src: site.icons.icon512, sizes: "512x512", type: "image/png", purpose: "any" },
      { src: site.icons.iconMaskable512, sizes: "512x512", type: "image/png", purpose: "maskable" },
    ],
  };
}
