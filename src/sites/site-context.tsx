"use client";

import { createContext, useContext } from "react";
import type { SiteKey } from "@/lib/site";
import { getSiteConfig } from "@/sites";
import type { SiteConfig } from "@/sites/types";

const SiteKeyContext = createContext<SiteKey>("roost");

/** Pass the server SITE_KEY into client components (env is not available in the browser). */
export function SiteProvider({ siteKey, children }: { siteKey: SiteKey; children: React.ReactNode }) {
  return <SiteKeyContext.Provider value={siteKey}>{children}</SiteKeyContext.Provider>;
}

export function useSiteKey(): SiteKey {
  return useContext(SiteKeyContext);
}

export function useSiteConfig(): SiteConfig {
  return getSiteConfig(useSiteKey());
}
