import Link from "next/link";
import { LanguageToggle } from "@/components/layout/language-toggle";

export function SiteHeader({ brandName }: { brandName: string }) {
  return (
    <header className="sticky top-0 z-40 border-b border-beige/80 bg-cream/95 pt-[env(safe-area-inset-top,0px)] backdrop-blur-sm">
      <div className="mx-auto flex h-16 w-full max-w-6xl items-center justify-between gap-2 px-5">
        <Link
          href="/"
          className="inline-flex min-h-11 min-w-0 items-center font-heading text-[clamp(0.82rem,3.1vw,1.25rem)] leading-tight whitespace-nowrap text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          {brandName}
        </Link>
        <LanguageToggle />
      </div>
    </header>
  );
}
