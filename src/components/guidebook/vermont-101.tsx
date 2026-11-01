"use client";

import Link from "next/link";
import { Beer, Car, CloudRain, Footprints, IceCreamCone, Leaf, Mountain } from "lucide-react";
import type { MessageKey } from "@/lib/i18n/messages";
import { useTranslate } from "@/lib/i18n/locale-context";

const SECTIONS: {
  id: string;
  title: MessageKey;
  body?: MessageKey;
  before?: MessageKey;
  after?: MessageKey;
  href?: string;
  linkLabel?: string;
  icon: typeof IceCreamCone;
}[] = [
  { id: "creemees", title: "vtCreemeesTitle", body: "vtCreemeesBody", icon: IceCreamCone },
  { id: "maple", title: "vtMapleTitle", body: "vtMapleBody", icon: Leaf },
  { id: "mud", title: "vtMudTitle", body: "vtMudBody", icon: CloudRain },
  { id: "foliage", title: "vtFoliageTitle", body: "vtFoliageBody", icon: Mountain },
  {
    id: "winter",
    title: "vtWinterTitle",
    before: "vtWinterBefore",
    after: "vtWinterAfter",
    href: "https://newengland511.org",
    linkLabel: "newengland511.org",
    icon: Car,
  },
  { id: "beer", title: "vtBeerTitle", body: "vtBeerBody", icon: Beer },
  { id: "trace", title: "vtTraceTitle", body: "vtTraceBody", icon: Footprints },
];

export function Vermont101({ propertySlug, propertyName }: { propertySlug: string; propertyName: string }) {
  const { t, tf } = useTranslate();
  return (
    <article className="mx-auto w-full min-w-0 max-w-3xl px-5 pt-10 pb-16">
      <p>
        <Link
          href={`/${propertySlug}`}
          className="inline-flex min-h-11 items-center text-base text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          {tf("backToName", { name: propertyName })}
        </Link>
      </p>
      <header className="mt-4">
        <h1 className="font-heading text-4xl leading-tight text-charcoal">{t("vermont101")}</h1>
        <p className="mt-3 text-lg leading-8">{t("vermont101Intro")}</p>
      </header>
      <ul className="mt-8 grid list-none gap-5 p-0">
        {SECTIONS.map((section) => {
          const Icon = section.icon;
          return (
            <li key={section.id} className="flex gap-3">
              <Icon className="mt-1 size-6 shrink-0 text-forest" aria-hidden="true" strokeWidth={1.75} />
              <div className="min-w-0">
                <h2 className="font-heading text-2xl text-charcoal">{t(section.title)}</h2>
                <p className="mt-1 text-base leading-7">
                  {section.href && section.before && section.after ? (
                    <>
                      {t(section.before)}
                      <a
                        href={section.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
                      >
                        {section.linkLabel}
                      </a>
                      {t(section.after)}
                    </>
                  ) : section.body ? (
                    t(section.body)
                  ) : null}
                </p>
              </div>
            </li>
          );
        })}
      </ul>
    </article>
  );
}
