import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getSiteConfig } from "@/sites";

export async function generateMetadata(): Promise<Metadata> {
  const site = getSiteConfig();
  if (site.key !== "dad") return { title: "About" };
  return {
    title: "About",
    description: site.seoDescription,
    robots: { index: false, follow: false },
  };
}

export default function AboutPage() {
  const site = getSiteConfig();
  if (site.key !== "dad") notFound();

  return (
    <div className="mx-auto w-full max-w-3xl px-5 py-16 md:py-24">
      <p className="text-xs font-semibold uppercase tracking-[0.22em] text-muted-foreground">About</p>
      <h1 className="mt-3 font-[family-name:var(--font-dad-display)] text-4xl text-forest md:text-5xl">
        {site.name}
      </h1>
      <p className="mt-6 text-lg leading-8 text-charcoal">
        {site.tagline} We host vacation homes in Vermont and on Sanibel Island, Florida. Each stay has
        its own guidebook for arrival, the house, and nearby favorites.
      </p>
      <p className="mt-4 text-lg leading-8 text-charcoal">
        More of our story is coming soon. For booking questions, use the Contact page or message us on
        Airbnb from a stay page.
      </p>
    </div>
  );
}
