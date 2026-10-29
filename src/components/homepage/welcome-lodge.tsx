import type { ReactNode } from "react";
import { Fraunces, Lilita_One } from "next/font/google";

const lodgeDisplay = Lilita_One({
  subsets: ["latin"],
  weight: "400",
  display: "swap",
  adjustFontFallback: true,
  preload: false,
});

const lodgeItalic = Fraunces({
  subsets: ["latin"],
  weight: "600",
  style: "italic",
  display: "swap",
  adjustFontFallback: true,
  preload: false,
});

const ink = "#F8F6F0";

export function WelcomeLodge() {
  return (
    <section
      className="px-4 py-10 text-center md:px-6 md:py-16"
      style={{ backgroundColor: "#243D33", color: ink }}
    >
      <div className="mx-auto flex max-w-5xl flex-col items-center">
        <ul className="mb-5 flex items-end justify-center gap-3 md:mb-6 md:gap-5" aria-hidden="true">
          <li>
            <SeasonIcon label="Spring">
              <Flower />
            </SeasonIcon>
          </li>
          <li>
            <SeasonIcon label="Summer">
              <Sun />
            </SeasonIcon>
          </li>
          <li>
            <SeasonIcon label="Autumn">
              <MapleLeaf />
            </SeasonIcon>
          </li>
          <li>
            <SeasonIcon label="Winter">
              <Snowflake />
            </SeasonIcon>
          </li>
        </ul>
        <h1 className="w-full max-w-full [container-type:inline-size]">
          <span className="block font-sans text-xs font-semibold uppercase tracking-[0.28em] min-[380px]:text-[0.72rem] min-[380px]:tracking-[0.34em] md:text-sm md:tracking-[0.52em]">
            Welcome to
          </span>
          <span
            className={`${lodgeDisplay.className} mt-1 block whitespace-nowrap text-center uppercase leading-[0.8] [font-size:clamp(1.9rem,10.6cqi,8.75rem)]`}
          >
            Vermont.
          </span>
        </h1>
        <p className={`${lodgeItalic.className} mt-4 text-[1.65rem] leading-none md:mt-5 md:text-5xl`}>
          Make yourself at home.
        </p>
        <p className="mt-3 max-w-xl font-sans text-base leading-7 md:mt-4 md:text-lg md:leading-8">
          Everything you need for a wonderful stay, all in one place.
        </p>
      </div>
    </section>
  );
}

function SeasonIcon({ label, children }: { label: string; children: ReactNode }) {
  return (
    <span className="block size-9 md:size-11" title={label}>
      {children}
    </span>
  );
}

function Flower() {
  return (
    <svg viewBox="0 0 48 48" className="size-full" aria-hidden="true">
      <ellipse cx="14" cy="34" rx="9" ry="5" fill="#2E7A3A" transform="rotate(-36 14 34)" />
      <ellipse cx="35" cy="33" rx="9" ry="5" fill="#3C9450" transform="rotate(32 35 33)" />
      <circle cx="24" cy="20" r="7" fill="#FFF8F1" />
      <circle cx="15" cy="16" r="7" fill="#FFF8F1" />
      <circle cx="33" cy="16" r="7" fill="#FFF8F1" />
      <circle cx="16" cy="27" r="7" fill="#FFF8F1" />
      <circle cx="32" cy="27" r="7" fill="#FFF8F1" />
      <circle cx="24" cy="21" r="4.5" fill="#F0B429" />
      <circle cx="24" cy="21" r="2" fill="#D9781C" />
    </svg>
  );
}

function Sun() {
  return (
    <svg viewBox="0 0 48 48" className="size-full" aria-hidden="true">
      <g stroke="#F0A202" strokeWidth="3.2" strokeLinecap="round">
        <path d="M24 5v6M24 37v6M5 24h6M37 24h6M10.5 10.5l4.2 4.2M33.3 33.3l4.2 4.2M37.5 10.5l-4.2 4.2M14.7 33.3l-4.2 4.2" />
      </g>
      <circle cx="24" cy="24" r="9" fill="#FFC531" />
      <circle cx="24" cy="24" r="5.5" fill="#FFE08A" />
    </svg>
  );
}

function MapleLeaf() {
  return (
    <svg viewBox="0 0 48 48" className="size-full" aria-hidden="true">
      <path
        fill="#E24B2A"
        d="M24 3l3.2 8.2 9.2-2.6-4.2 8.2 8.6-1-5.6 7.2 8.2 2.4-9.6 3.2 3 8.4-8.2-5.4-.8 10.2h-3.6L23.2 31l-8.2 5.4 3-8.4L8.4 25l8.2-2.4-5.6-7.2 8.6 1-4.2-8.2 9.2 2.6L24 3z"
      />
      <path fill="#8C3E22" d="M22.4 33h3.2l.6 11h-4.4l.6-11z" />
    </svg>
  );
}

function Snowflake() {
  return (
    <svg viewBox="0 0 48 48" className="size-full" aria-hidden="true">
      <g fill="none" stroke="#D8F3FF" strokeWidth="2.6" strokeLinecap="round">
        <path d="M24 7v34M9.2 15.5l29.6 17M9.2 32.5l29.6-17" />
        <path d="M24 12.5l-3.2-2M24 12.5l3.2-2M24 35.5l-3.2 2M24 35.5l3.2 2M14.2 18.4l-1.2-3.6M14.2 18.4l-3.4.6M33.8 29.6l1.2 3.6M33.8 29.6l3.4-.6M14.2 29.6l-3.4-.6M14.2 29.6l-1.2 3.6M33.8 18.4l3.4.6M33.8 18.4l1.2-3.6" />
      </g>
      <circle cx="24" cy="24" r="2.3" fill="#F4FBFF" />
    </svg>
  );
}
