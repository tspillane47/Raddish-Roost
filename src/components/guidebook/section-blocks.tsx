import Image from "next/image";
import { GuidebookMarkdown } from "@/lib/content/markdown";
import type { GuideBlockView } from "@/types/content";

export function SectionBlocks({ blocks }: { blocks: GuideBlockView[] }) {
  if (blocks.length === 0) {
    return (
      <p role="status" className="text-lg leading-8">
        This section has not been written yet.
      </p>
    );
  }

  return (
    <div className="grid gap-8">
      {blocks.map((block) => (
        <section key={block.id} className="grid gap-3">
          {block.title ? <h2 className="font-heading text-2xl text-charcoal">{block.title}</h2> : null}
          <BlockBody block={block} />
        </section>
      ))}
    </div>
  );
}

function BlockBody({ block }: { block: GuideBlockView }) {
  if (block.kind === "rich_text" || block.kind === "callout") {
    const copy = <GuidebookMarkdown markdown={block.markdown} />;
    if (block.kind === "rich_text") return copy;
    return (
      <div
        className={
          block.tone === "important"
            ? "rounded-xl border border-forest bg-beige/80 px-5 py-4"
            : "rounded-xl bg-beige/70 px-5 py-4"
        }
      >
        {copy}
      </div>
    );
  }

  if (block.kind === "steps") {
    return (
      <ol className="grid list-none gap-4 p-0">
        {block.steps.map((step, index) => (
          <li key={`${block.id}-${index}`} className="flex gap-4">
            <span className="flex size-10 shrink-0 items-center justify-center rounded-full bg-forest font-medium text-cream">
              {index + 1}
            </span>
            <span className="pt-1 text-lg leading-8">
              {step.title}
              {step.detail ? <span className="mt-1 block text-base leading-7">{step.detail}</span> : null}
            </span>
          </li>
        ))}
      </ol>
    );
  }

  if (block.kind === "checklist") {
    return (
      <ul className="grid list-none gap-3 p-0">
        {block.items.map((item) => (
          <li key={item.id} className="rounded-xl border border-beige px-4 py-3 text-lg leading-8">
            {item.label}
            {item.detail ? <span className="mt-1 block text-base leading-7">{item.detail}</span> : null}
          </li>
        ))}
      </ul>
    );
  }

  if (block.kind === "link_list") {
    return (
      <ul className="grid list-none gap-2 p-0">
        {block.links.map((link) => (
          <li key={link.href}>
            <a
              href={link.href}
              rel="noopener noreferrer"
              className="inline-flex min-h-12 items-center text-lg text-forest underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
            >
              {link.label}
            </a>
          </li>
        ))}
      </ul>
    );
  }

  return (
    <figure className="grid gap-3">
      <Image
        src={block.url}
        alt={block.alt}
        width={1600}
        height={1000}
        className="h-auto w-full rounded-xl"
        sizes="(max-width: 768px) calc(100vw - 2.5rem), 48rem"
      />
      {block.caption ? <figcaption className="text-base leading-7">{block.caption}</figcaption> : null}
    </figure>
  );
}
