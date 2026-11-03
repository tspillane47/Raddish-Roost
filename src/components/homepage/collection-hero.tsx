import Image from "next/image";
import type { SiteHero } from "@/sites";

export function CollectionHero({ hero }: { hero: SiteHero }) {
  return (
    <div className="bg-charcoal">
      <Image
        src={hero.src}
        alt={hero.alt}
        width={hero.width}
        height={hero.height}
        preload
        fetchPriority="high"
        decoding="sync"
        quality={60}
        sizes="100vw"
        className="aspect-[3/2] w-full object-cover object-center md:aspect-[1536/497]"
      />
    </div>
  );
}
