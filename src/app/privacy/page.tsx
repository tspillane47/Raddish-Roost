import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Privacy policy",
};

export default function PrivacyPage() {
  return (
    <div className="mx-auto w-full max-w-xl px-5 py-16">
      <p className="text-xs font-medium tracking-[0.14em] text-forest uppercase">
        Draft — review before launch
      </p>
      <h1 className="mt-3 font-heading text-4xl text-charcoal">Privacy policy</h1>
      <div className="mt-6 grid gap-4 text-base leading-7">
        <p>Guests do not create an account to read a guidebook.</p>
        <p>Search engines are asked not to index this site.</p>
        <p>
          A later version may record anonymous events such as which guidebook section was opened.
          Those events are not tied to a guest&apos;s name, and they never include access codes or
          Wi-Fi passwords.
        </p>
        <p>Replace this draft with a policy you have reviewed before the site is public.</p>
      </div>
    </div>
  );
}
