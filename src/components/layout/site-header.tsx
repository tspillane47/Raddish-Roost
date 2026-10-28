import Link from "next/link";

export function SiteHeader({ brandName }: { brandName: string }) {
  return (
    <header className="sticky top-0 z-40 border-b border-beige/80 bg-cream/95 backdrop-blur-sm">
      <div className="mx-auto flex h-16 w-full max-w-6xl items-center px-5">
        <Link
          href="/"
          className="font-heading text-xl text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          {brandName}
        </Link>
      </div>
    </header>
  );
}
