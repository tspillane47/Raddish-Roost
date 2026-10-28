"use client";

export default function GlobalError({
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <html lang="en">
      <body
        style={{
          margin: 0,
          minHeight: "100vh",
          background: "#F7F4ED",
          color: "#262626",
          fontFamily: "Georgia, serif",
        }}
      >
        <main style={{ maxWidth: "36rem", margin: "0 auto", padding: "6rem 1.25rem" }}>
          <h1 style={{ fontSize: "2.5rem", fontWeight: 400, color: "#263F35" }}>
            Something went wrong
          </h1>
          <p style={{ fontFamily: "Inter, sans-serif", fontSize: "1.125rem", lineHeight: 1.6 }}>
            The page couldn&apos;t be loaded. Please try again.
          </p>
          <button
            type="button"
            onClick={reset}
            style={{
              marginTop: "2rem",
              minHeight: "3rem",
              background: "#263F35",
              color: "#F7F4ED",
              border: 0,
              borderRadius: "0.5rem",
              padding: "0 1.25rem",
              fontFamily: "Inter, sans-serif",
              fontSize: "1rem",
            }}
          >
            Try again
          </button>
        </main>
      </body>
    </html>
  );
}
