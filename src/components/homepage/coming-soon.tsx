export function ComingSoon({
  title,
  body,
}: {
  title: string;
  body: string;
}) {
  return (
    <section
      aria-labelledby="coming-soon-heading"
      className="mx-auto w-full max-w-3xl px-5 py-16 text-center md:py-24"
    >
      <p className="font-sans text-xs font-semibold uppercase tracking-[0.28em] text-muted-foreground">
        Coming soon
      </p>
      <h2 id="coming-soon-heading" className="mt-4 font-heading text-4xl text-forest md:text-5xl">
        {title}
      </h2>
      <p className="mx-auto mt-5 max-w-xl text-lg leading-8 text-charcoal">{body}</p>
      <div
        className="mx-auto mt-10 h-px w-24 bg-beige"
        aria-hidden="true"
      />
    </section>
  );
}
