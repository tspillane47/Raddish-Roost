import Link from "next/link";
import { Beer, Car, CloudRain, Footprints, IceCreamCone, Leaf, Mountain } from "lucide-react";
import { VERMONT_101 } from "@/lib/content/vermont-101";

const ICONS = {
  creemees: IceCreamCone,
  maple: Leaf,
  mud: CloudRain,
  foliage: Mountain,
  winter: Car,
  beer: Beer,
  trace: Footprints,
} as const;

export function Vermont101({ propertySlug, propertyName }: { propertySlug: string; propertyName: string }) {
  return (
    <article className="mx-auto w-full min-w-0 max-w-3xl px-5 pt-10 pb-16">
      <p>
        <Link
          href={`/${propertySlug}`}
          className="inline-flex min-h-11 items-center text-base text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          Back to {propertyName}
        </Link>
      </p>
      <header className="mt-4">
        <h1 className="font-heading text-4xl leading-tight text-charcoal">Vermont 101</h1>
        <p className="mt-3 text-lg leading-8">A few local words and habits, from your hosts.</p>
      </header>
      <ul className="mt-8 grid list-none gap-5 p-0">
        {VERMONT_101.map((section) => {
          const Icon = ICONS[section.id];
          return (
            <li key={section.id} className="flex gap-3">
              <Icon className="mt-1 size-6 shrink-0 text-forest" aria-hidden="true" strokeWidth={1.75} />
              <div className="min-w-0">
                <h2 className="font-heading text-2xl text-charcoal">{section.title}</h2>
                <p className="mt-1 text-base leading-7">
                  {"href" in section ? (
                    <>
                      {section.before}
                      <a
                        href={section.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
                      >
                        {section.linkLabel}
                      </a>
                      {section.after}
                    </>
                  ) : (
                    section.body
                  )}
                </p>
              </div>
            </li>
          );
        })}
      </ul>
    </article>
  );
}
