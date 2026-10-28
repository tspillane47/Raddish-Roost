import { cn } from "@/lib/utils";
import type { PlaceholderTone } from "@/lib/content/sections";

const tones: Record<PlaceholderTone, string> = {
  forest: "bg-forest text-cream",
  charcoal: "bg-charcoal text-cream",
  beige: "bg-beige text-forest",
};

export function PhotoPlaceholder({
  name,
  tone,
  className,
}: {
  name: string;
  tone: PlaceholderTone;
  className?: string;
}) {
  return (
    <div className={cn("flex aspect-[4/3] flex-col justify-between p-6", tones[tone], className)}>
      <p className="font-heading text-3xl leading-tight">{name}</p>
      <p className="text-sm">Photograph coming soon</p>
    </div>
  );
}
