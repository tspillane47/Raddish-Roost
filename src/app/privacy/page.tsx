import type { Metadata } from "next";
import { Tx } from "@/lib/i18n/locale-context";
import { getLocale } from "@/lib/i18n/get-locale";
import { t } from "@/lib/i18n/translate";

export async function generateMetadata(): Promise<Metadata> {
  const locale = await getLocale();
  return { title: t(locale, "privacy") };
}

export default function PrivacyPage() {
  return (
    <div className="mx-auto w-full max-w-xl px-5 py-16">
      <p className="text-xs font-medium tracking-[0.14em] text-forest uppercase">
        <Tx k="privacyDraft" />
      </p>
      <h1 className="mt-3 font-heading text-4xl text-charcoal">
        <Tx k="privacy" />
      </h1>
      <div className="mt-6 grid gap-4 text-base leading-7">
        <p>
          <Tx k="privacy1" />
        </p>
        <p>
          <Tx k="privacy2" />
        </p>
        <p>
          <Tx k="privacy3" />
        </p>
        <p>
          <Tx k="privacy4" />
        </p>
      </div>
    </div>
  );
}
