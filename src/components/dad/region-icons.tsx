export function PineIcon({ className = "size-4" }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden="true" fill="currentColor">
      <path d="M12 2.5 6.5 11h2.2L5 17h3.2L4.5 22h15l-3.7-5H19l-3.7-6h2.2L12 2.5Z" />
      <rect x="10.6" y="20" width="2.8" height="2.5" />
    </svg>
  );
}

export function ShellIcon({ className = "size-4" }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden="true" fill="currentColor">
      <path d="M12 3c-2.4 2.8-6.5 7.2-6.5 11.2 0 3.5 2.8 6.3 6.5 6.3s6.5-2.8 6.5-6.3C18.5 10.2 14.4 5.8 12 3Z" />
      <path
        d="M12 5.2v13.6M8.4 8.4c1.1 2.2 1.8 4.2 1.8 6.2M15.6 8.4c-1.1 2.2-1.8 4.2-1.8 6.2M7.2 12.2c1.6 1.4 2.9 2.6 3.4 4.6M16.8 12.2c-1.6 1.4-2.9 2.6-3.4 4.6"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.2"
        opacity="0.35"
      />
    </svg>
  );
}
