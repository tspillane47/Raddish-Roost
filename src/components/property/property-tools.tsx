import { Car, KeyRound, LogOut, MessageCircle, Phone, Wifi } from "lucide-react";
import Link from "next/link";
import { Tx } from "@/lib/i18n/locale-context";
import type { MessageKey } from "@/lib/i18n/messages";

const LINKS: { key: string; label: MessageKey; path: string; icon: typeof Wifi }[] = [
  { key: "wifi", label: "wifi", path: "/guide/wifi", icon: Wifi },
  { key: "check-in", label: "checkIn", path: "/guide/check-in-checkout", icon: KeyRound },
  { key: "checkout", label: "checkout", path: "/guide/check-in-checkout#checkout-list", icon: LogOut },
  { key: "parking", label: "parking", path: "/guide/getting-here#parking", icon: Car },
  { key: "contact", label: "contact", path: "/guide/contact", icon: MessageCircle },
  { key: "emergency", label: "emergency", path: "/guide/contact#emergency", icon: Phone },
];

export function PropertyTools({ slug }: { slug: string }) {
  return (
    <div className="border-b border-beige bg-cream">
      <details className="mx-auto w-full max-w-6xl px-5">
        <summary className="flex min-h-12 cursor-pointer list-none items-center text-base font-medium text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest [&::-webkit-details-marker]:hidden">
          <Tx k="essentials" />
        </summary>
        <ul className="grid list-none gap-2 p-0 pb-4 sm:grid-cols-3">
          {LINKS.map((item) => {
            const Icon = item.icon;
            const href = item.path.startsWith("#") ? `/${slug}${item.path}` : `/${slug}${item.path}`;
            return (
              <li key={item.key}>
                <Link
                  href={href}
                  className="flex min-h-12 items-center gap-2 rounded-lg bg-beige/70 px-3 text-base text-charcoal focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
                >
                  <Icon aria-hidden="true" className="size-5 text-forest" />
                  <Tx k={item.label} />
                </Link>
              </li>
            );
          })}
        </ul>
      </details>
    </div>
  );
}
