"use client";

import { BookOpen, Compass, House, MessageCircle } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";

export function PropertyDock({ slug }: { slug: string }) {
  const pathname = usePathname();
  const home = `/${slug}`;
  const items = [
    { href: home, label: "Home", icon: House, current: pathname === home },
    {
      href: `${home}#guidebook`,
      label: "Guide",
      icon: BookOpen,
      current: pathname.startsWith(`${home}/guide`) && pathname !== `${home}/guide/contact`,
    },
    {
      href: `${home}/explore`,
      label: "Explore",
      icon: Compass,
      current: pathname.startsWith(`${home}/explore`),
    },
    {
      href: `${home}/guide/contact`,
      label: "Contact",
      icon: MessageCircle,
      current: pathname === `${home}/guide/contact`,
    },
  ];

  return (
    <nav
      aria-label="Stay"
      data-property-dock=""
      className="fixed inset-x-0 bottom-0 z-40 border-t border-beige bg-cream/95 pb-[env(safe-area-inset-bottom)] backdrop-blur-sm md:hidden"
    >
      <ul className="mx-auto grid max-w-lg grid-cols-4 list-none p-0">
        {items.map((item) => {
          const Icon = item.icon;
          return (
            <li key={item.label}>
              <Link
                href={item.href}
                aria-current={item.current ? "page" : undefined}
                className="flex min-h-16 flex-col items-center justify-center gap-1 text-xs text-muted-foreground focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-forest aria-[current=page]:font-medium aria-[current=page]:text-forest"
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
