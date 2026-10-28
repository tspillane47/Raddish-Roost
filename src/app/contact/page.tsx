import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Contact",
};

export default function ContactPage() {
  return (
    <div className="mx-auto w-full max-w-xl px-5 py-16">
      <p className="text-xs font-medium tracking-[0.14em] text-forest uppercase">Draft</p>
      <h1 className="mt-3 font-heading text-4xl text-charcoal">Contact your hosts</h1>
      <p className="mt-4 text-lg leading-8">
        Host contact details have not been added yet. For an urgent safety emergency, call 911.
      </p>
      <p className="mt-8">
        <Link
          href="/"
          className="inline-flex min-h-12 items-center text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          Back to all stays
        </Link>
      </p>
    </div>
  );
}
