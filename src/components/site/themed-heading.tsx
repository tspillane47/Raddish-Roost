"use client";

import type { ReactNode } from "react";
import { useLocale } from "@/lib/i18n/locale-context";
import { sectionLabel, siteLabel } from "@/sites/labels";
import { useSiteConfig } from "@/sites/site-context";
import type { SiteLabelKey, SiteLabelPair } from "@/sites/types";

/** Themed title with the plain guest label underneath for fast scanning. */
export function ThemedHeading({
  label,
  fallback,
  as: Tag = "h1",
  className,
  plainClassName,
  icon,
}: {
  label: SiteLabelPair | null | undefined;
  fallback: ReactNode;
  as?: "h1" | "h2" | "h3" | "p" | "span";
  className?: string;
  plainClassName?: string;
  icon?: ReactNode;
}) {
  if (!label) {
    return (
      <Tag className={className}>
        {icon}
        {fallback}
      </Tag>
    );
  }

  return (
    <span className="block">
      <Tag className={className}>
        {icon ? <span className="mr-2 inline-flex align-middle">{icon}</span> : null}
        {label.themed}
      </Tag>
      <span
        className={
          plainClassName ??
          "mt-1 block font-[family-name:var(--font-dad-typewriter,var(--font-inter))] text-sm font-normal tracking-wide text-muted-foreground normal-case"
        }
      >
        {label.plain}
      </span>
    </span>
  );
}

/** Resolves a site chrome label for the active locale. */
export function SiteThemedHeading({
  labelKey,
  fallback,
  as = "h1",
  className,
  icon,
}: {
  labelKey: SiteLabelKey;
  fallback: ReactNode;
  as?: "h1" | "h2" | "h3" | "p" | "span";
  className?: string;
  icon?: ReactNode;
}) {
  const locale = useLocale();
  return (
    <ThemedHeading
      as={as}
      label={siteLabel(useSiteConfig(), labelKey, locale)}
      fallback={fallback}
      className={className}
      icon={icon}
    />
  );
}

/** Resolves guidebook section themed labels for the active locale. */
export function SectionThemedHeading({
  sectionSlug,
  fallback,
  as = "h1",
  className,
  icon,
}: {
  sectionSlug: string;
  fallback: ReactNode;
  as?: "h1" | "h2" | "h3" | "p" | "span";
  className?: string;
  icon?: ReactNode;
}) {
  const locale = useLocale();
  return (
    <ThemedHeading
      as={as}
      label={sectionLabel(useSiteConfig(), sectionSlug, locale)}
      fallback={fallback}
      className={className}
      icon={icon}
    />
  );
}
