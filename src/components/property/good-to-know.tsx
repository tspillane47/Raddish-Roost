"use client";

import { stayGlanceFor } from "@/lib/content/stay-glance";
import { useTranslate } from "@/lib/i18n/locale-context";

export function GoodToKnow({ propertySlug }: { propertySlug: string }) {
  const { t } = useTranslate();
  const glance = stayGlanceFor(propertySlug);
  if (!glance?.goodToKnowKey) return null;

  return (
    <aside
      aria-labelledby="good-to-know-heading"
      className="mt-8 rounded-sm border-2 border-terracotta/50 bg-beige/70 px-4 py-4 md:px-5"
    >
      <h2
        id="good-to-know-heading"
        className="font-[family-name:var(--font-dad-typewriter,var(--font-inter))] text-sm font-semibold uppercase tracking-[0.18em] text-terracotta"
      >
        {t("goodToKnowTitle")}
      </h2>
      <p className="mt-2 text-base leading-7 text-charcoal">{t(glance.goodToKnowKey)}</p>
    </aside>
  );
}

export function MinStayNote({ propertySlug }: { propertySlug: string }) {
  const { t } = useTranslate();
  const glance = stayGlanceFor(propertySlug);
  if (!glance?.minStayKey) return null;

  return (
    <p className="mt-3 max-w-xl text-sm leading-6 text-forest md:mx-0">
      <span className="font-medium">{t("minStayLabel")}</span> {t(glance.minStayKey)}
    </p>
  );
}
