"use client";

import { useState } from "react";
import {
  EMERGENCY_COPY,
  GUEST_NOTE_SENT,
  GUEST_NOTE_TEXT,
  GUEST_NOTE_TITLE,
  type GuestNoteResult,
} from "@/lib/content/guest-note";

export function GuestNote({
  propertySlug,
  propertyName,
  airbnbHref,
  compact = false,
}: {
  propertySlug: string;
  propertyName: string;
  airbnbHref: string | null;
  compact?: boolean;
}) {
  const [pending, setPending] = useState(false);
  const [result, setResult] = useState<GuestNoteResult | null>(null);

  return (
    <section className={compact ? "rounded-xl bg-beige/50 p-4" : "rounded-2xl bg-beige/70 p-5"}>
      <h2 className={compact ? "font-heading text-2xl text-charcoal" : "font-heading text-3xl text-charcoal"}>
        {GUEST_NOTE_TITLE}
      </h2>
      <p className="mt-2 text-base leading-7">{GUEST_NOTE_TEXT}</p>
      {result?.status === "sent" ? (
        <p role="status" className="mt-4 text-base leading-7 text-charcoal">
          {GUEST_NOTE_SENT}
        </p>
      ) : (
        <form
          className="mt-4 grid gap-3"
          onSubmit={(event) => {
            event.preventDefault();
            const body = new FormData(event.currentTarget);
            setPending(true);
            void fetch("/api/guest-note", { method: "POST", body })
              .then(async (response) => (await response.json()) as GuestNoteResult)
              .then((next) => setResult(next))
              .catch(() => setResult({ status: "error", message: "We couldn't send that just now. Please try again." }))
              .finally(() => setPending(false));
          }}
        >
          <label className="grid gap-1 text-base">
            Name
            <span className="text-sm text-muted-foreground">Optional</span>
            <input
              name="name"
              autoComplete="name"
              maxLength={120}
              className="min-h-11 rounded-lg border border-beige bg-cream px-3 text-base text-charcoal"
            />
          </label>
          <label className="grid gap-1 text-base">
            What's going on
            <textarea
              name="message"
              required
              rows={compact ? 3 : 4}
              maxLength={5000}
              className="rounded-lg border border-beige bg-cream px-3 py-2 text-base leading-7 text-charcoal"
            />
          </label>
          <label className="grid gap-1 text-base">
            Property
            <input
              value={propertyName}
              readOnly
              aria-readonly="true"
              className="min-h-11 rounded-lg border border-beige bg-cream px-3 text-base text-charcoal"
            />
          </label>
          <input type="hidden" name="property" value={propertySlug} />
          <div className="h-0 w-0 overflow-hidden" aria-hidden="true">
            <label>
              Company
              <input name="company" tabIndex={-1} autoComplete="off" />
            </label>
          </div>
          {result?.status === "error" ? (
            <p role="alert" className="text-base leading-7 text-charcoal">
              {result.message}
            </p>
          ) : null}
          <button
            type="submit"
            disabled={pending}
            className="inline-flex min-h-11 items-center justify-center rounded-full bg-forest px-4 text-base text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest disabled:opacity-60"
          >
            {pending ? "Sending" : "Send"}
          </button>
        </form>
      )}
      {airbnbHref ? (
        <p className="mt-4">
          <a
            href={airbnbHref}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex min-h-11 items-center rounded-full border border-forest px-4 text-base text-forest focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
          >
            Message us on Airbnb
          </a>
        </p>
      ) : null}
      {compact ? null : <p className="mt-4 text-base leading-7">{EMERGENCY_COPY}</p>}
    </section>
  );
}
