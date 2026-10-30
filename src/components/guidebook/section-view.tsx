import Link from "next/link";
import { SectionBlocks } from "@/components/guidebook/section-blocks";
import { CheckoutList } from "@/components/guidebook/checkout-list";
import { GuestNote } from "@/components/guidebook/guest-note";
import { NearbyEssentials } from "@/components/guidebook/nearby-essentials";
import { ThingsToDo } from "@/components/explore/things-to-do";
import { BookingChoices } from "@/components/property/book-now";
import { LateCheckout } from "@/components/property/late-checkout";
import { PropertyGallery } from "@/components/property/property-gallery";
import { MERGED_BLOCK_SORT } from "@/lib/content/sections";
import { photosForSection } from "@/lib/content/property-photos";
import type { PerfectDay, ThingToDo } from "@/lib/content/things-to-do";
import { isMarkedSample } from "@/lib/data/map-content";
import type { GuideSectionDetail, HouseAmenity } from "@/types/content";

export function SectionView({
  section,
  places = [],
  itineraries = [],
  accent = "#263F35",
}: {
  section: GuideSectionDetail;
  places?: ThingToDo[];
  itineraries?: PerfectDay[];
  accent?: string;
}) {
  const sample =
    isMarkedSample(section.summary) ||
    section.blocks.some((block) => isMarkedSample(block.title) || blockHasSample(block)) ||
    section.checkoutItems.some((item) => isMarkedSample(item.label) || isMarkedSample(item.detail)) ||
    section.amenities.some((item) => isMarkedSample(item.name) || isMarkedSample(item.description));
  const photos = photosForSection(section.propertySlug, section.slug);
  const checkInLine = section.checkInTime ? `Check-in is at ${section.checkInTime}` : null;
  const checkoutLine = section.checkOutTime ? `Checkout is at ${section.checkOutTime}` : null;
  const arrival = section.slug === "check-in-checkout";
  const showCheckIn = Boolean(checkInLine) && (arrival || section.slug === "check-in");
  const showCheckOut = Boolean(checkoutLine) && (arrival || section.slug === "checkout");
  const summary = section.summary?.trim() || null;
  const showSummary = Boolean(summary) && !summaryRepeatsTimes(summary, checkInLine, checkoutLine);

  return (
    <article className="mx-auto w-full min-w-0 max-w-3xl px-5 pt-10 pb-16">
      <p>
        <Link
          href={`/${section.propertySlug}`}
          className="inline-flex min-h-11 items-center text-base text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          Back to {section.propertyName}
        </Link>
      </p>
      <header id={section.slug === "contact" ? "emergency" : undefined} className="mt-4 scroll-mt-[var(--site-header)]">
        <div className="flex items-start justify-between gap-3">
          <h1 className="font-heading text-4xl leading-tight text-charcoal md:text-5xl">{section.title}</h1>
          {sample ? (
            <span className="mt-2 shrink-0 rounded-full border border-forest px-2 py-0.5 text-xs font-medium tracking-wide text-forest">
              Sample
            </span>
          ) : null}
        </div>
        {showCheckIn ? <p className="mt-4 font-heading text-3xl text-charcoal">{checkInLine}</p> : null}
        {showCheckOut ? <p className="mt-2 font-heading text-3xl text-charcoal">{checkoutLine}</p> : null}
        {showSummary ? <p className="mt-4 text-lg leading-8">{summary}</p> : null}
        {section.slug === "checkout" ? (
          <LateCheckout propertySlug={section.propertySlug} portalUrl={section.guestPortalUrl} />
        ) : null}
      </header>
      {section.slug === "stay-again" && section.bookings.length > 0 ? (
        <div className="mt-8">
          <h2 className="font-heading text-3xl text-charcoal">Book Your Stay</h2>
          <div className="mt-4">
            <BookingChoices propertySlug={section.propertySlug} bookings={section.bookings} />
          </div>
        </div>
      ) : null}
      {photos.length > 0 ? (
        <div className="mt-8">
          <PropertyGallery photos={photos} />
        </div>
      ) : null}
      <div className="mt-10 grid gap-10">
        {section.slug === "contact" ? (
          <>
            <GuestNoteCard section={section} />
            <NearbyLink section={section} />
          </>
        ) : null}
        {arrival ? (
          <ArrivalBody section={section} />
        ) : section.slug === "the-house" ? (
          <HouseBody section={section} />
        ) : section.slug === "things-to-do" ? (
          <ThingsBody section={section} places={places} itineraries={itineraries} accent={accent} />
        ) : (
          <>
            <SectionBlocks blocks={section.blocks} empty={section.slug === "contact" ? "hide" : "message"} />
            {section.slug === "getting-here" ? (
              <>
                <ParkingNote summary={section.parkingSummary} />
                <NearbyEssentials items={section.nearbyEssentials} />
              </>
            ) : null}
            {section.slug === "checkout" ? (
              <>
                <CheckoutList items={section.checkoutItems} />
                <GuestNoteCard section={section} compact />
              </>
            ) : null}
          </>
        )}
      </div>
    </article>
  );
}

function ArrivalBody({ section }: { section: GuideSectionDetail }) {
  const access = section.blocks.filter((block) => block.sortOrder < MERGED_BLOCK_SORT);
  const leaving = section.blocks.filter((block) => block.sortOrder >= MERGED_BLOCK_SORT);
  const empty = access.length === 0 && leaving.length === 0 && section.checkoutItems.length === 0;

  return (
    <>
      {empty ? (
        <p role="status" className="text-lg leading-8">
          This section has not been written yet.
        </p>
      ) : (
        <SectionBlocks blocks={access} empty="hide" />
      )}
      <LateCheckout propertySlug={section.propertySlug} portalUrl={section.guestPortalUrl} />
      <SectionBlocks blocks={leaving} empty="hide" />
      <CheckoutList items={section.checkoutItems} />
      <GuestNoteCard section={section} compact />
    </>
  );
}

function GuestNoteCard({ section, compact = false }: { section: GuideSectionDetail; compact?: boolean }) {
  return (
    <GuestNote
      propertySlug={section.propertySlug}
      propertyName={section.propertyName}
      airbnbHref={section.airbnbHref}
      compact={compact}
    />
  );
}

function HouseBody({ section }: { section: GuideSectionDetail }) {
  const here = section.blocks.filter((block) => block.sortOrder >= MERGED_BLOCK_SORT);
  const how = section.blocks.filter((block) => block.sortOrder < MERGED_BLOCK_SORT);
  const showHere = here.length > 0 || section.amenities.length > 0;
  const showHow = how.length > 0;

  if (!showHere && !showHow) {
    return (
      <p role="status" className="text-lg leading-8">
        This section has not been written yet.
      </p>
    );
  }

  return (
    <>
      {showHere ? (
        <section aria-labelledby="whats-here-heading">
          <h2 id="whats-here-heading" className="font-heading text-3xl text-charcoal">
            What&apos;s here
          </h2>
          <div className="mt-4">
            {here.length > 0 ? <SectionBlocks blocks={here} /> : <AmenityList amenities={section.amenities} />}
          </div>
        </section>
      ) : null}
      {showHow ? (
        <section aria-labelledby="how-things-work-heading">
          <h2 id="how-things-work-heading" className="font-heading text-3xl text-charcoal">
            How things work
          </h2>
          <div className="mt-4">
            <SectionBlocks blocks={how} accordion />
          </div>
        </section>
      ) : null}
    </>
  );
}

function AmenityList({ amenities }: { amenities: HouseAmenity[] }) {
  return (
    <ul className="grid list-none gap-3 p-0">
      {amenities.map((item) => (
        <li key={item.id} className="rounded-xl bg-beige/50 px-4 py-3">
          <p className="text-lg leading-8 text-charcoal">{item.name}</p>
          {item.description ? <p className="mt-1 text-base leading-7">{item.description}</p> : null}
        </li>
      ))}
    </ul>
  );
}

function NearbyLink({ section }: { section: GuideSectionDetail }) {
  if (section.nearbyEssentials.length === 0) return null;
  return (
    <p>
      <Link
        href={`/${section.propertySlug}/guide/getting-here#nearby-essentials`}
        className="inline-flex min-h-11 items-center text-base text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
      >
        Nearby essentials
      </Link>
    </p>
  );
}

function ThingsBody({
  section,
  places,
  itineraries,
  accent,
}: {
  section: GuideSectionDetail;
  places: ThingToDo[];
  itineraries: PerfectDay[];
  accent: string;
}) {
  return (
    <>
      <SectionBlocks blocks={section.blocks} empty="hide" />
      <p>
        <Link
          href={`/${section.propertySlug}/guide/vermont-101`}
          className="inline-flex min-h-11 items-center text-base text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          New to Vermont? Read Vermont 101.
        </Link>
      </p>
      <ThingsToDo places={places} itineraries={itineraries} accent={accent} />
    </>
  );
}

function ParkingNote({ summary }: { summary: string | null }) {
  const parking = summary?.trim();
  if (!parking) return null;
  return (
    <section id="parking" aria-labelledby="parking-heading" className="scroll-mt-[var(--site-header)]">
      <h2 id="parking-heading" className="font-heading text-2xl text-charcoal">
        Parking
      </h2>
      <p className="mt-3 text-lg leading-8">{parking}</p>
    </section>
  );
}

function summaryRepeatsTimes(summary: string | null, checkInLine: string | null, checkoutLine: string | null) {
  if (!summary) return false;
  const trimmed = summary.trim().replace(/\.$/, "");
  const both = checkInLine && checkoutLine ? `${checkInLine}. ${checkoutLine}` : null;
  return trimmed === checkInLine || trimmed === checkoutLine || trimmed === both;
}

function blockHasSample(block: GuideSectionDetail["blocks"][number]) {
  if (block.kind === "rich_text" || block.kind === "callout") return isMarkedSample(block.markdown);
  if (block.kind === "steps") return block.steps.some((step) => isMarkedSample(step.title) || isMarkedSample(step.detail));
  if (block.kind === "checklist") {
    return block.items.some((item) => isMarkedSample(item.label) || isMarkedSample(item.detail));
  }
  if (block.kind === "link_list") return block.links.some((link) => isMarkedSample(link.label));
  return isMarkedSample(block.caption);
}

export function SectionFallback() {
  return (
    <div aria-busy="true" aria-live="polite" className="mx-auto w-full max-w-3xl px-5 py-10">
      <p className="sr-only">Loading this section</p>
      <div className="h-8 w-40 rounded bg-beige" />
      <div className="mt-6 h-12 w-2/3 rounded bg-beige" />
      <div className="mt-8 h-40 rounded-xl bg-beige/80" />
    </div>
  );
}
