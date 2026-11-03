import { getSiteKey, type SiteKey } from "@/lib/site";
import { dadSite } from "@/sites/dad";
import { roostSite } from "@/sites/roost";
import type { SiteConfig, SitePalette } from "@/sites/types";

const SITES: Record<SiteKey, SiteConfig> = {
  roost: roostSite,
  dad: dadSite,
};

export function getSiteConfig(siteKey: SiteKey = getSiteKey()): SiteConfig {
  return SITES[siteKey];
}

export function sitePaletteStyle(colors: SitePalette): Record<string, string> {
  return {
    "--background": colors.cream,
    "--foreground": colors.charcoal,
    "--card": colors.cream,
    "--card-foreground": colors.charcoal,
    "--popover": colors.cream,
    "--popover-foreground": colors.charcoal,
    "--primary": colors.forest,
    "--primary-foreground": colors.cream,
    "--secondary": colors.beige,
    "--secondary-foreground": colors.charcoal,
    "--muted": colors.beige,
    "--muted-foreground": colors.muted,
    "--accent": colors.beige,
    "--accent-foreground": colors.charcoal,
    "--border": colors.beige,
    "--input": colors.beige,
    "--ring": colors.forest,
    "--forest": colors.forest,
    "--sage": colors.sage,
    "--cream": colors.cream,
    "--charcoal": colors.charcoal,
    "--beige": colors.beige,
    "--terracotta": colors.terracotta,
    "--sidebar": colors.cream,
    "--sidebar-foreground": colors.charcoal,
    "--sidebar-primary": colors.forest,
    "--sidebar-primary-foreground": colors.cream,
    "--sidebar-accent": colors.beige,
    "--sidebar-accent-foreground": colors.charcoal,
    "--sidebar-border": colors.beige,
    "--sidebar-ring": colors.forest,
  };
}

export { dadSite, roostSite };
export type { SiteConfig, SiteHero, SiteLogo, SitePalette } from "@/sites/types";
