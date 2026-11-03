import type { MetadataRoute } from "next";
import { getSiteConfig } from "@/sites";

export default function manifest(): MetadataRoute.Manifest {
  const site = getSiteConfig();
  return {
    name: site.name,
    short_name: site.shortName,
    description: site.seoDescription,
    start_url: "/",
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
