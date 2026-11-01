"use client";

import { BookOpen, Compass, House, MessageCircle } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useTranslate } from "@/lib/i18n/locale-context";

export function PropertyDock({ slug }: { slug: string }) {
  const pathname = usePathname();
  const { t } = useTranslate();
  const home = `/${slug}`;
  const items = [
    { href: home, label: t("home"), icon: House, current: pathname === home },
    {
      href: `${home}#guidebook`,
      label: t("guide"),
      icon: BookOpen,
      current:
        pathname.startsWith(`${home}/guide`) &&
        pathname !== `${home}/guide/contact` &&
        pathname !== `${home}/guide/things-to-do`,
    },
    {
      href: `${home}/guide/things-to-do`,
      label: t("explore"),
      icon: Compass,
      current: pathname === `${home}/guide/things-to-do` || pathname.startsWith(`${home}/explore`),
    },
    {
      href: `${home}/guide/contact`,
      label: t("contact"),
      icon: MessageCircle,
      current: pathname === `${home}/guide/contact`,
    },
  ];

  return (
    <nav
      aria-label={t("stayNav")}
      data-property-dock=""
      className="fixed inset-x-0 bottom-0 z-40 border-t border-beige bg-cream/95 pr-[env(safe-area-inset-right)] pb-[env(safe-area-inset-bottom)] pl-[env(safe-area-inset-left)] backdrop-blur-sm md:hidden"
    >
      <ul className="mx-auto grid max-w-lg grid-cols-4 list-none p-0">
        {items.map((item) => {
          const Icon = item.icon;
          return (
            <li key={item.label}>
              <Link
                href={item.href}
                aria-current={item.current ? "page" : undefined}
                className="flex min-h-16 flex-col items-center justify-center gap-1 px-1 text-sm text-muted-foreground focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-forest aria-[current=page]:font-medium aria-[current=page]:text-forest"
              >
                <Icon aria-hidden="true" className="size-5" />
                {item.label}
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
