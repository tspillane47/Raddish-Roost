"use client";

import { useState } from "react";

export function CopyPassword({ password }: { password: string }) {
  const [copied, setCopied] = useState(false);

  async function copy() {
    try {
      await navigator.clipboard.writeText(password);
      setCopied(true);
      window.setTimeout(() => setCopied(false), 2000);
    } catch {
      setCopied(false);
    }
  }

  return (
    <span className="flex flex-wrap items-center gap-x-3 gap-y-2">
      <span className="font-mono text-base break-all">Password: {password}</span>
      <button
        type="button"
        aria-live="polite"
        className="inline-flex min-h-11 items-center rounded-full bg-forest px-4 text-base text-cream focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-forest"
        onClick={() => void copy()}
      >
        {copied ? "Copied" : "Copy"}
      </button>
    </span>
  );
}
