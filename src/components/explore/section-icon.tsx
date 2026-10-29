import { Bike, Coffee, IceCreamCone, Mountain, Snowflake, Utensils, Wine } from "lucide-react";
import type { ThingSectionId } from "@/lib/content/things-to-do";

export function SectionIcon({ id, className = "size-7" }: { id: ThingSectionId; className?: string }) {
  const props = { className, "aria-hidden": true as const, strokeWidth: 1.75 };
  if (id === "eat") return <Utensils {...props} />;
  if (id === "drink") return <Wine {...props} />;
  if (id === "coffee") return <Coffee {...props} />;
  if (id === "ski_ride") return <Skier className={className} />;
  if (id === "see") return <Mountain {...props} />;
  if (id === "hike") return <HikingBoot className={className} />;
  if (id === "bike") return <Bike {...props} />;
  if (id === "winter_fun") return <Snowflake {...props} />;
  return <IceCreamCone {...props} />;
}

function Skier({ className }: { className: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden="true" fill="none">
      <circle cx="9" cy="4.5" r="1.7" className="fill-current" />
      <path
        d="M8.2 8.2c.8.3 1.6.9 2.2 1.8l1.8 2.8M10.2 10.4 7.4 13.2M12.2 12.6l3.2-1.8"
        stroke="currentColor"
        strokeWidth="1.75"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M3.5 17.2c5.2-1.6 9.4-.6 15.2 1.6M5.2 20.2c5-1.4 9-.4 13.6 1.2"
        stroke="currentColor"
        strokeWidth="1.75"
        strokeLinecap="round"
      />
    </svg>
  );
}

function HikingBoot({ className }: { className: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden="true" fill="none">
      <path
        d="M8 3.8h4.4V10l3.6 1.7c1.3.6 2.1 1.9 2.1 3.3v1.4H7.2c-1 0-1.8-.8-1.8-1.8v-2.4L8 10.2V3.8Z"
        stroke="currentColor"
        strokeWidth="1.75"
        strokeLinejoin="round"
      />
      <path d="M8 8.2h4.4" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" />
    </svg>
  );
}
