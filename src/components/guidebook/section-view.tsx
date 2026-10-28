import Link from "next/link";
import { SectionBlocks } from "@/components/guidebook/section-blocks";
import { isMarkedSample } from "@/lib/data/map-content";
import type { GuideSectionDetail } from "@/types/content";

export function SectionView({ section }: { section: GuideSectionDetail }) {
  const sample =
    isMarkedSample(section.summary) ||
    section.blocks.some((block) => isMarkedSample(block.title) || blockHasSample(block));

  return (
    <article className="mx-auto w-full max-w-3xl px-5 py-10">
      <p>
        <Link
          href={`/${section.propertySlug}`}
          className="inline-flex min-h-11 items-center text-sm text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
        >
          Back to {section.propertyName}
        </Link>
      </p>
      <header className="mt-4">
        <div className="flex items-start justify-between gap-3">
          <h1 className="font-heading text-4xl leading-tight text-charcoal md:text-5xl">{section.title}</h1>
          {sample ? (
            <span className="mt-2 shrink-0 rounded-full border border-forest px-2 py-0.5 text-xs font-medium tracking-wide text-forest">
              Sample
            </span>
          ) : null}
        </div>
        {section.summary ? <p className="mt-4 text-lg leading-8">{section.summary}</p> : null}
      </header>
      <div className="mt-10">
        <SectionBlocks blocks={section.blocks} />
      </div>
    </article>
  );
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
