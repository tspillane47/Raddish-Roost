import { Car, KeyRound, LogOut, MessageCircle, Phone, Wifi } from "lucide-react";
import Link from "next/link";

const LINKS = [
  { key: "wifi", label: "Wi-Fi", path: "/guide/wifi", icon: Wifi },
  { key: "check-in", label: "Check-in", path: "/guide/check-in", icon: KeyRound },
  { key: "checkout", label: "Checkout", path: "/guide/checkout", icon: LogOut },
  { key: "parking", label: "Parking", path: "#parking", icon: Car },
  { key: "contact", label: "Contact", path: "/guide/contact", icon: MessageCircle },
  { key: "emergency", label: "Emergency", path: "#emergency", icon: Phone },
] as const;

export function PropertyTools({ slug }: { slug: string }) {
  return (
    <div className="border-b border-beige bg-cream">
      <details className="mx-auto w-full max-w-6xl px-5">
        <summary className="flex min-h-12 cursor-pointer list-none items-center text-base font-medium text-forest focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest [&::-webkit-details-marker]:hidden">
          Essentials
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
                  {item.label}
                </Link>
              </li>
            );
          })}
        </ul>
      </details>
    </div>
  );
}
