import Image from "next/image";
import { errinHeroFileExists } from "@/sites/resolve-errin-hero";
import type { SiteConfig } from "@/sites/types";

/**
 * Temporary Errin's Digs homepage: neon apres-ski coming soon.
 * Swap illustration for hero.webp by dropping the file at public/sites/errin/hero.webp.
 */
export function ErrinHome({ site }: { site: SiteConfig }) {
  const hasHero = errinHeroFileExists(site.hero);

  return (
    <div className="relative overflow-hidden bg-[var(--cream)] text-[var(--charcoal)]">
      <SunsetStripes />
      <div className="relative z-10 mx-auto flex w-full max-w-5xl flex-col items-center px-5 pb-20 pt-10 text-center md:pb-28 md:pt-16">
        <p className="font-[family-name:var(--font-errin-display,var(--font-inter))] text-sm uppercase tracking-[0.35em] text-[var(--terracotta)] md:text-base">
          {site.shortName}
        </p>
        <h1 className="mt-4 max-w-3xl font-[family-name:var(--font-errin-display,var(--font-inter))] text-[clamp(2.4rem,9vw,5.5rem)] leading-[0.95] tracking-wide text-[var(--forest)]">
          {site.name}
        </h1>
        <p className="mt-4 font-[family-name:var(--font-errin-display,var(--font-inter))] text-lg uppercase tracking-[0.18em] text-[var(--sage)] md:text-xl">
          {site.tagline}
        </p>

        <div className="relative mt-10 w-full max-w-3xl">
          {hasHero ? (
            <Image
              src={site.hero.src}
              alt={site.hero.alt}
              width={site.hero.width}
              height={site.hero.height}
              preload
              fetchPriority="high"
              sizes="(max-width: 768px) 100vw, 48rem"
              className="mx-auto h-auto w-full rounded-sm border-4 border-[var(--charcoal)] shadow-[6px_6px_0_var(--mustard)]"
            />
          ) : (
            <ErrinHeroIllustration />
          )}
          <GeometricBurst />
        </div>

        <section
          id="coming-soon"
          aria-labelledby="errin-coming-soon-heading"
          className="mt-12 max-w-2xl scroll-mt-24 md:mt-16"
        >
          <h2
            id="errin-coming-soon-heading"
            className="font-[family-name:var(--font-errin-display,var(--font-inter))] text-3xl leading-tight text-[var(--terracotta)] md:text-4xl"
          >
            {site.comingSoonTitle}
          </h2>
          <p className="mt-4 text-lg leading-8 text-[var(--charcoal)] md:text-xl">
            {site.comingSoonBody}
          </p>
          <div
            className="mx-auto mt-8 flex h-3 w-40 overflow-hidden rounded-sm border-2 border-[var(--charcoal)]"
            aria-hidden="true"
          >
            <span className="flex-1 bg-[var(--terracotta)]" />
            <span className="flex-1 bg-[var(--mustard)]" />
            <span className="flex-1 bg-[var(--sage)]" />
            <span className="flex-1 bg-[var(--forest)]" />
          </div>
        </section>
      </div>
    </div>
  );
}

function SunsetStripes() {
  return (
    <div className="pointer-events-none absolute inset-x-0 top-0 h-40 md:h-52" aria-hidden="true">
      <div className="flex h-full w-full flex-col">
        <span className="flex-1 bg-[var(--terracotta)]/90" />
        <span className="flex-1 bg-[var(--mustard)]/90" />
        <span className="flex-1 bg-[var(--sage)]/85" />
        <span className="flex-1 bg-[var(--forest)]/80" />
        <span className="flex-1 bg-[var(--charcoal)]/90" />
      </div>
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-[var(--cream)]" />
    </div>
  );
}

function GeometricBurst() {
  return (
    <div className="pointer-events-none absolute -right-2 -top-3 size-14 rotate-12 md:size-16" aria-hidden="true">
      <svg viewBox="0 0 64 64" className="size-full">
        <polygon points="32,4 38,26 60,26 42,40 48,62 32,48 16,62 22,40 4,26 26,26" fill="var(--mustard)" stroke="var(--charcoal)" strokeWidth="2" />
      </svg>
    </div>
  );
}

/** Neon mountain, striped sunset, crossed skis, and big retro sunglasses. */
function ErrinHeroIllustration() {
  return (
    <svg
      viewBox="0 0 800 450"
      role="img"
      aria-label="Neon mountain under a striped sunset with crossed skis and retro sunglasses"
      className="mx-auto h-auto w-full rounded-sm border-4 border-[var(--charcoal)] bg-[var(--charcoal)] shadow-[6px_6px_0_var(--mustard)]"
    >
      <defs>
        <linearGradient id="errin-sky" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#FF2D95" />
          <stop offset="28%" stopColor="#FFE566" />
          <stop offset="55%" stopColor="#00E5C0" />
          <stop offset="78%" stopColor="#6B2D8B" />
          <stop offset="100%" stopColor="#0A1628" />
        </linearGradient>
      </defs>
      <rect width="800" height="450" fill="url(#errin-sky)" />
      {[70, 110, 150, 190, 230].map((y, index) => (
        <rect
          key={y}
          x="0"
          y={y}
          width="800"
          height="18"
          fill={index % 2 === 0 ? "rgba(10,22,40,0.18)" : "rgba(255,250,254,0.12)"}
        />
      ))}
      <circle cx="640" cy="88" r="46" fill="#FFE566" stroke="#0A1628" strokeWidth="4" />
      <path d="M0 450 L0 310 L170 180 L280 260 L390 140 L520 250 L650 160 L800 300 L800 450 Z" fill="#0A1628" />
      <path
        d="M0 450 L0 330 L170 200 L280 270 L390 160 L520 260 L650 180 L800 310 L800 450 Z"
        fill="none"
        stroke="#00E5C0"
        strokeWidth="5"
      />
      <path d="M250 360 L310 210 L370 360 Z" fill="#FFFAFE" opacity="0.9" />
      <path d="M430 370 L500 230 L570 370 Z" fill="#FFE0F0" opacity="0.85" />

      {/* Crossed skis */}
      <g transform="translate(160 300) rotate(-28)">
        <rect x="0" y="0" width="14" height="150" rx="7" fill="#FFFAFE" stroke="#0A1628" strokeWidth="3" />
        <rect x="-8" y="36" width="30" height="10" rx="3" fill="#FF2D95" />
      </g>
      <g transform="translate(210 300) rotate(28)">
        <rect x="0" y="0" width="14" height="150" rx="7" fill="#FFFAFE" stroke="#0A1628" strokeWidth="3" />
        <rect x="-8" y="36" width="30" height="10" rx="3" fill="#FFE566" />
      </g>

      {/* Retro sunglasses */}
      <g transform="translate(520 300)">
        <rect x="18" y="28" width="150" height="12" rx="4" fill="#0A1628" />
        <ellipse cx="50" cy="48" rx="42" ry="30" fill="#6B2D8B" stroke="#FF2D95" strokeWidth="6" />
        <ellipse cx="140" cy="48" rx="42" ry="30" fill="#6B2D8B" stroke="#FF2D95" strokeWidth="6" />
        <path d="M88 42 Q95 52 108 42" fill="none" stroke="#0A1628" strokeWidth="5" />
        <path d="M12 40 L0 28" stroke="#0A1628" strokeWidth="5" strokeLinecap="round" />
        <path d="M178 40 L194 28" stroke="#0A1628" strokeWidth="5" strokeLinecap="round" />
        <ellipse cx="38" cy="40" rx="10" ry="6" fill="#00E5C0" opacity="0.7" />
        <ellipse cx="128" cy="40" rx="10" ry="6" fill="#00E5C0" opacity="0.7" />
      </g>
    </svg>
  );
}
