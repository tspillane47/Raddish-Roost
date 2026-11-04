import type { SVGProps } from "react";

type IconProps = SVGProps<SVGSVGElement>;

/** Simple line icons for the Getaway Club heist theme. */
export function KeyholeIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" aria-hidden="true" {...props}>
      <circle cx="12" cy="9" r="3.25" />
      <path d="M12 12.25v6.5" strokeLinecap="round" />
      <path d="M10 18.75h4" strokeLinecap="round" />
    </svg>
  );
}

export function VintageKeyIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" aria-hidden="true" {...props}>
      <circle cx="8" cy="10" r="3.25" />
      <path d="M11 10h9.5" strokeLinecap="round" />
      <path d="M17.5 10v3.5M20.5 10v2.5" strokeLinecap="round" />
    </svg>
  );
}

export function LuggageTagIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" aria-hidden="true" {...props}>
      <rect x="4.5" y="7.5" width="15" height="11" rx="1.5" />
      <path d="M9 7.5V6a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v1.5" strokeLinecap="round" />
      <path d="M8.5 12.5h7" strokeLinecap="round" />
    </svg>
  );
}

export function DuffelBagIcon(props: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" aria-hidden="true" {...props}>
      <path d="M5.5 10.5c0-1.5 2.9-2.75 6.5-2.75s6.5 1.25 6.5 2.75v6c0 1.5-2.9 2.75-6.5 2.75s-6.5-1.25-6.5-2.75v-6Z" />
      <path d="M5.5 13.5c0 1.5 2.9 2.75 6.5 2.75s6.5-1.25 6.5-2.75" />
      <path d="M9 7.75V6.5a1.5 1.5 0 0 1 1.5-1.5h3A1.5 1.5 0 0 1 15 6.5v1.25" strokeLinecap="round" />
    </svg>
  );
}
