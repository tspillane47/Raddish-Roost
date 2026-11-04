"use client";

import Link from "next/link";
import { useState } from "react";
import { LuggageTagIcon } from "@/components/dad/heist-icons";
import { LanguageToggle } from "@/components/layout/language-toggle";
import type { SiteNavItem } from "@/sites/types";

export function DadHeader({
  brandName,
  shortName,
  nav,
  bookCta,
}: {
  brandName: string;
  shortName: string;
  nav: SiteNavItem[];
  bookCta: { label: string; href: string; plain?: string };
}) {
  const [open, setOpen] = useState(false);

  return (
    <header className="sticky top-0 z-40 border-b border-beige/80 bg-cream/95 pt-[env(safe-area-inset-top,0px)] backdrop-blur-sm">
      <div className="mx-auto flex h-16 w-full max-w-6xl items-center justify-between gap-3 px-5">
        <Link
          href="/"
          className="min-w-0 shrink font-[family-name:var(--font-dad-display)] text-[clamp(1rem,2.2vw,1.35rem)] leading-none text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          <span className="sr-only">{brandName}</span>
          <span aria-hidden="true" className="block truncate">
            {shortName}
          </span>
        </Link>

        <nav className="hidden items-center gap-0.5 lg:flex" aria-label="Primary">
          {nav.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              title={item.plain}
              className="inline-flex min-h-11 shrink-0 flex-col items-center justify-center px-2.5 text-[0.7rem] font-semibold uppercase tracking-[0.16em] text-forest/85 hover:text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest xl:px-3 xl:tracking-[0.18em]"
            >
              <span>{item.label}</span>
              {item.plain ? (
                <span className="mt-0.5 font-[family-name:var(--font-dad-typewriter)] text-[0.55rem] font-normal normal-case tracking-wide text-muted-foreground">
                  {item.plain}
                </span>
              ) : null}
            </Link>
          ))}
          <Link
            href={bookCta.href}
            className="ml-1 inline-flex min-h-11 shrink-0 flex-col items-center justify-center rounded-sm bg-terracotta px-3.5 text-[0.7rem] font-semibold uppercase tracking-[0.14em] text-cream focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest xl:ml-2 xl:px-4"
          >
            <span className="inline-flex items-center gap-1.5">
              <LuggageTagIcon className="size-3.5 shrink-0" />
              {bookCta.label}
            </span>
            {bookCta.plain ? (
              <span className="mt-0.5 font-[family-name:var(--font-dad-typewriter)] text-[0.55rem] font-normal normal-case tracking-wide text-cream/85">
                {bookCta.plain}
              </span>
            ) : null}
          </Link>
          <div className="ml-1 xl:ml-2">
            <LanguageToggle />
          </div>
        </nav>

        <div className="flex shrink-0 items-center gap-2 lg:hidden">
          <LanguageToggle />
          <button
            type="button"
            className="inline-flex min-h-11 min-w-11 items-center justify-center rounded-sm border border-beige text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
            aria-expanded={open}
            aria-controls="dad-mobile-nav"
            onClick={() => setOpen((value) => !value)}
          >
            <span className="sr-only">{open ? "Close menu" : "Open menu"}</span>
            <span aria-hidden="true" className="flex flex-col gap-1.5">
              <span className={`block h-0.5 w-5 bg-forest transition ${open ? "translate-y-2 rotate-45" : ""}`} />
              <span className={`block h-0.5 w-5 bg-forest transition ${open ? "opacity-0" : ""}`} />
              <span className={`block h-0.5 w-5 bg-forest transition ${open ? "-translate-y-2 -rotate-45" : ""}`} />
            </span>
          </button>
        </div>
      </div>

      {open ? (
        <div id="dad-mobile-nav" className="border-t border-beige bg-cream px-5 py-4 lg:hidden">
          <nav className="flex flex-col gap-1" aria-label="Mobile">
            {nav.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="inline-flex min-h-11 flex-col justify-center text-sm font-semibold uppercase tracking-[0.16em] text-forest"
                onClick={() => setOpen(false)}
              >
                <span>{item.label}</span>
                {item.plain ? (
                  <span className="font-[family-name:var(--font-dad-typewriter)] text-xs font-normal normal-case tracking-wide text-muted-foreground">
                    {item.plain}
                  </span>
                ) : null}
              </Link>
            ))}
            <Link
              href={bookCta.href}
              className="mt-2 inline-flex min-h-11 flex-col items-center justify-center rounded-sm bg-terracotta px-4 text-sm font-semibold uppercase tracking-[0.16em] text-cream"
              onClick={() => setOpen(false)}
            >
              <span className="inline-flex items-center gap-2">
                <LuggageTagIcon className="size-4 shrink-0" />
                {bookCta.label}
              </span>
              {bookCta.plain ? (
                <span className="mt-0.5 font-[family-name:var(--font-dad-typewriter)] text-xs font-normal normal-case tracking-wide text-cream/85">
                  {bookCta.plain}
                </span>
              ) : null}
            </Link>
          </nav>
        </div>
      ) : null}
    </header>
  );
}
