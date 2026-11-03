import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Tx } from "@/lib/i18n/locale-context";
import { getLocale } from "@/lib/i18n/get-locale";
import { t } from "@/lib/i18n/translate";
import { getSiteConfig } from "@/sites";

export async function generateMetadata(): Promise<Metadata> {
  const site = getSiteConfig();
  if (site.key === "dad") return { title: "Not Found" };
  const locale = await getLocale();
  return { title: t(locale, "contact") };
}

export default function ContactPage() {
  const site = getSiteConfig();
  if (site.key === "dad") notFound();

  return (
    <div className="mx-auto w-full max-w-xl px-5 py-16">
      <p className="text-xs font-medium tracking-[0.14em] text-forest uppercase">
        <Tx k="draft" />
      </p>
      <h1 className="mt-3 font-heading text-4xl text-charcoal">
        <Tx k="contactHosts" />
      </h1>
      <p className="mt-4 text-lg leading-8">
        <Tx k="contactHostsBody" />
      </p>
      <p className="mt-8">
        <Link
          href="/"
          className="inline-flex min-h-12 items-center text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          <Tx k="backToStays" />
        </Link>
      </p>
    </div>
  );
}
