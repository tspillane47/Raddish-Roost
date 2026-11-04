"use client";

import Link from "next/link";
import { AlertTriangle, Bike, ExternalLink, Footprints, LifeBuoy, Shell, Trees, Waves } from "lucide-react";
import type { MessageKey } from "@/lib/i18n/messages";
import { useTranslate } from "@/lib/i18n/locale-context";

const SECTIONS: {
  id: string;
  title: MessageKey;
  body?: MessageKey;
  before?: MessageKey;
  after?: MessageKey;
  href?: string;
  linkLabelKey?: MessageKey;
  icon: typeof Shell;
}[] = [
  { id: "shelling", title: "sbShellingTitle", body: "sbShellingBody", icon: Shell },
  { id: "turtles", title: "sbTurtlesTitle", body: "sbTurtlesBody", icon: Waves },
  { id: "wildlife", title: "sbWildlifeTitle", body: "sbWildlifeBody", icon: Trees },
  { id: "biking", title: "sbBikingTitle", body: "sbBikingBody", icon: Bike },
  {
    id: "parking",
    title: "sbParkingTitle",
    before: "sbParkingBefore",
    after: "sbParkingAfter",
    href: "https://www.mysanibel.com",
    linkLabelKey: "sbParkingLink",
    icon: Footprints,
  },
  {
    id: "hurricane",
    title: "sbHurricaneTitle",
    before: "sbHurricaneBefore",
    after: "sbHurricaneAfter",
    href: "https://www.leegov.com/publicsafety/emergencymanagement",
    linkLabelKey: "sbHurricaneLink",
    icon: AlertTriangle,
  },
  { id: "links", title: "sbLinksTitle", body: "sbLinksBody", icon: ExternalLink },
  { id: "emergency", title: "sbEmergencyTitle", body: "sbEmergencyBody", icon: LifeBuoy },
];

const HELPFUL_LINKS = [
  { href: "https://www.mysanibel.com", label: "City of Sanibel" },
  {
    href: "https://www.leegov.com/publicsafety/emergencymanagement",
    label: "Lee County Emergency Management",
  },
  { href: "https://sanibel-captiva.org", label: "Sanibel & Captiva Chamber" },
] as const;

export function Sanibel101({ propertySlug, propertyName }: { propertySlug: string; propertyName: string }) {
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
        <h1 className="font-heading text-4xl leading-tight text-charcoal">{t("sanibel101")}</h1>
        <p className="mt-3 text-lg leading-8">{t("sanibel101Intro")}</p>
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
                  {section.href && section.before && section.after && section.linkLabelKey ? (
                    <>
                      {t(section.before)}
                      <a
                        href={section.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
                      >
                        {t(section.linkLabelKey)}
                      </a>
                      {t(section.after)}
                    </>
                  ) : section.body ? (
                    t(section.body)
                  ) : null}
                </p>
                {section.id === "links" ? (
                  <ul className="mt-3 grid list-none gap-2 p-0">
                    {HELPFUL_LINKS.map((link) => (
                      <li key={link.href}>
                        <a
                          href={link.href}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex min-h-11 items-center text-base text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
                        >
                          {link.label}
                        </a>
                      </li>
                    ))}
                  </ul>
                ) : null}
              </div>
            </li>
          );
        })}
      </ul>
    </article>
  );
}
