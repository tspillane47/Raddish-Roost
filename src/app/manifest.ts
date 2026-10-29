import type { MetadataRoute } from "next";
import { BRAND_COLORS, DEFAULT_BRAND_NAME } from "@/lib/brand";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: DEFAULT_BRAND_NAME,
    short_name: "Vermont Roost",
    description: "Everything you need for a wonderful stay, all in one place.",
    start_url: "/",
    display: "standalone",
    background_color: BRAND_COLORS.cream,
    theme_color: BRAND_COLORS.forest,
    icons: [
      { src: "/icons/icon-192.png", sizes: "192x192", type: "image/png", purpose: "any" },
      { src: "/icons/icon-512.png", sizes: "512x512", type: "image/png", purpose: "any" },
      { src: "/icons/icon-maskable-512.png", sizes: "512x512", type: "image/png", purpose: "maskable" },
    ],
  };
}
