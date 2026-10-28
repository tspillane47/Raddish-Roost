import Image from "next/image";
import { COLLECTION_HERO } from "@/lib/content/brand-art";

export function CollectionHero() {
  return (
    <div className="bg-charcoal">
      <Image
        src={COLLECTION_HERO.src}
        alt={COLLECTION_HERO.alt}
        width={COLLECTION_HERO.width}
        height={COLLECTION_HERO.height}
        preload
        sizes="100vw"
        className="aspect-[3/2] w-full object-cover object-center md:aspect-[1536/497]"
      />
    </div>
  );
}
