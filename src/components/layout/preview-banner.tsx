import { Tx } from "@/lib/i18n/locale-context";

export function PreviewBanner() {
  return (
    <p
      role="status"
      className="border-b border-beige bg-beige/70 px-5 py-3 text-center text-sm leading-6 text-charcoal"
    >
      <Tx k="previewMode" />
    </p>
  );
}
