"use client";

export default function ErrorPage({ reset }: { error: Error & { digest?: string }; reset: () => void }) {
  return (
    <div className="mx-auto w-full max-w-xl px-5 py-24" role="alert">
      <h1 className="font-heading text-4xl text-forest">Something went wrong</h1>
      <p className="mt-4 text-lg leading-8">The page couldn&apos;t be loaded. Please try again.</p>
      <button
        type="button"
        onClick={reset}
        className="mt-8 inline-flex min-h-12 items-center rounded-lg bg-forest px-5 text-base text-cream focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-forest"
      >
        Try again
      </button>
    </div>
  );
}
