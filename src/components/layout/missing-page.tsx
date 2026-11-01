import Link from "next/link";
import { Tx } from "@/lib/i18n/locale-context";

export function MissingPage() {
  return (
    <div className="mx-auto w-full max-w-xl px-5 py-24">
      <h1 className="font-heading text-4xl text-forest">
        <Tx k="pageMissingTitle" />
      </h1>
      <p className="mt-4 text-lg leading-8">
        <Tx k="pageMissingBody" />
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
