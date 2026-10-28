import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Terms",
};

export default function TermsPage() {
  return (
    <div className="mx-auto w-full max-w-xl px-5 py-16">
      <p className="text-xs font-medium tracking-[0.14em] text-forest uppercase">
        Draft — review before launch
      </p>
      <h1 className="mt-3 font-heading text-4xl text-charcoal">Terms</h1>
      <div className="mt-6 grid gap-4 text-base leading-7">
        <p>Guidebook notes are written by the hosts to help during a stay.</p>
        <p>
          This website does not take reservations or payments. Booking happens through a listing
          link the hosts publish, or through the platform where the guest already booked.
        </p>
        <p>Replace this draft with terms you have reviewed before the site is public.</p>
      </div>
    </div>
  );
}
