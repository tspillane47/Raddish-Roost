"use client";

import { Car, KeyRound, LogOut, MessageCircle, Phone, Wifi } from "lucide-react";
import Link from "next/link";
import { CopyPassword } from "@/components/property/copy-password";
import { LateCheckout } from "@/components/property/late-checkout";
import { useTranslate } from "@/lib/i18n/locale-context";
import type { PropertyGuide } from "@/types/content";

export function Essentials({ property }: { property: PropertyGuide }) {
  const { t, tf } = useTranslate();
  const contact = property.contacts[0];

  return (
    <section aria-labelledby="essentials-heading">
      <h2 id="essentials-heading" className="font-heading text-3xl text-forest">
        {t("essentials")}
      </h2>
      <dl className="mt-6 grid gap-3 sm:grid-cols-2">
        <Item icon={Wifi} label={t("wifi")}>
          {property.wifi ? (
            <span className="grid gap-1">
              {property.wifi.networkName ? <span>{tf("network", { name: property.wifi.networkName })}</span> : null}
              {property.wifi.password ? <CopyPassword password={property.wifi.password} /> : (
                <span>{t("passwordMissing")}</span>
              )}
              {property.wifi.routerNote ? <span>{property.wifi.routerNote}</span> : null}
            </span>
          ) : (
            t("wifiInReservation")
          )}
        </Item>
        <Item icon={KeyRound} label={t("checkIn")}>
          {property.checkInTime ? (
            <span className="font-heading text-3xl leading-tight text-charcoal">{property.checkInTime}</span>
          ) : (
            t("notAddedYet")
          )}
        </Item>
        <Item icon={LogOut} label={t("checkout")}>
          <div className="grid gap-1">
            {property.checkOutTime ? (
              <span className="font-heading text-3xl leading-tight text-charcoal">{property.checkOutTime}</span>
            ) : (
              t("notAddedYet")
            )}
            <LateCheckout propertySlug={property.slug} portalUrl={property.guestPortalUrl} />
          </div>
        </Item>
        <Item id="parking" icon={Car} label={t("parking")}>
          {property.parkingSummary ?? t("notAddedYet")}
        </Item>
        <Item icon={MessageCircle} label={t("contact")}>
          {contact ? (
            contact.href ? (
              <a
                href={contact.href}
                className="underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
              >
                {contact.label}
              </a>
            ) : (
              contact.label
            )
          ) : (
            <Link
              href={`/${property.slug}/guide/contact`}
              className="underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
            >
              {t("hostContactMissing")}
            </Link>
          )}
        </Item>
        <Item id="emergency" icon={Phone} label={t("emergency")}>
          {t("emergencyCopy")}
        </Item>
      </dl>
    </section>
  );
}

function Item({
  id,
  icon: Icon,
  label,
  children,
}: {
  id?: string;
  icon: typeof Wifi;
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div id={id} className="scroll-mt-[calc(var(--site-header)+1rem)] rounded-xl bg-beige/70 p-4">
      <dt className="flex items-center gap-2 text-base font-medium text-forest">
        <Icon aria-hidden="true" className="size-5" />
        {label}
      </dt>
      <dd className="mt-2 text-base leading-7">{children}</dd>
    </div>
  );
}
