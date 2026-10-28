import { Car, KeyRound, LogOut, MessageCircle, Phone, Wifi } from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import type { GalleryPhoto } from "@/components/property/property-gallery";
import type { PropertyGuide } from "@/types/content";

const EMERGENCY_COPY =
  "For immediate danger, call 911. Property emergency contacts have not been added.";

export function Essentials({
  property,
  parkingPhoto = null,
}: {
  property: PropertyGuide;
  parkingPhoto?: GalleryPhoto | null;
}) {
  const contact = property.contacts[0];

  return (
    <section aria-labelledby="essentials-heading">
      <h2 id="essentials-heading" className="font-heading text-3xl text-forest">
        Essentials
      </h2>
      <dl className="mt-6 grid gap-3 sm:grid-cols-2">
        <Item icon={Wifi} label="Wi-Fi">
          {property.wifi ? (
            <span className="grid gap-1">
              {property.wifi.networkName ? <span>Network: {property.wifi.networkName}</span> : null}
              {property.wifi.password ? (
                <span className="font-mono text-sm">Password: {property.wifi.password}</span>
              ) : (
                <span>Password has not been added.</span>
              )}
              {property.wifi.routerNote ? <span>{property.wifi.routerNote}</span> : null}
            </span>
          ) : (
            "Wi-Fi details are in your reservation message."
          )}
        </Item>
        <Item icon={KeyRound} label="Check-in">
          {property.checkInTime ?? "Not added yet"}
        </Item>
        <Item icon={LogOut} label="Checkout">
          {property.checkOutTime ?? "Not added yet"}
        </Item>
        <Item id="parking" icon={Car} label="Parking">
          <span className="grid gap-3">
            <span>{property.parkingSummary ?? "Not added yet"}</span>
            {parkingPhoto ? (
              <Image
                src={parkingPhoto.src}
                alt={parkingPhoto.alt}
                width={parkingPhoto.width}
                height={parkingPhoto.height}
                className="aspect-[4/3] w-full rounded-lg object-cover"
                sizes="(max-width: 640px) 100vw, 20rem"
              />
            ) : null}
          </span>
        </Item>
        <Item icon={MessageCircle} label="Contact">
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
              href="/contact"
              className="underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
            >
              Host contact details have not been added yet.
            </Link>
          )}
        </Item>
        <Item id="emergency" icon={Phone} label="Emergency">
          {EMERGENCY_COPY}
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
    <div id={id} className="scroll-mt-28 rounded-xl bg-beige/70 p-4">
      <dt className="flex items-center gap-2 text-sm font-medium text-forest">
        <Icon aria-hidden="true" className="size-5" />
        {label}
      </dt>
      <dd className="mt-2 text-base leading-7">{children}</dd>
    </div>
  );
}
