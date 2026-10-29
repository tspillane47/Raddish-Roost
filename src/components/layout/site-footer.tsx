import Link from "next/link";

export function SiteFooter({
  brandName,
  properties,
  year,
}: {
  brandName: string;
  properties: { slug: string; name: string }[];
  year: number;
}) {
  return (
    <footer className="mt-auto border-t border-beige bg-beige/40">
      <div className="mx-auto grid w-full max-w-6xl gap-8 px-5 py-12 sm:grid-cols-2">
        <div>
          <p className="font-heading text-2xl text-forest">{brandName}</p>
          <p className="mt-3 max-w-sm text-base leading-7 text-muted-foreground">
            A small collection of Vermont stays, each with its own guidebook.
          </p>
        </div>
        <nav aria-label="Footer" className="grid gap-2 sm:justify-items-end">
          {properties.map((property) => (
            <Link
              key={property.slug}
              href={`/${property.slug}`}
              className="inline-flex min-h-11 items-center text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
            >
              {property.name}
            </Link>
          ))}
          <Link
            href="/contact"
            className="inline-flex min-h-11 items-center underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          >
            Contact
          </Link>
          <Link
            href="/privacy"
            className="inline-flex min-h-11 items-center underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          >
            Privacy policy
          </Link>
          <Link
            href="/terms"
            className="inline-flex min-h-11 items-center underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
          >
            Terms
          </Link>
        </nav>
        <p className="text-sm text-muted-foreground sm:col-span-2">
          © {year} {brandName}
        </p>
      </div>
    </footer>
  );
}
