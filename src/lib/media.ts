export function guidebookImageUrl(supabaseUrl: string, path: string | null | undefined): string | null {
  if (!path) return null;
  if (path.includes("..") || path.startsWith("/") || path.includes("://")) return null;
  const encoded = path
    .split("/")
    .filter(Boolean)
    .map((segment) => encodeURIComponent(segment))
    .join("/");
  if (!encoded) return null;
  return `${supabaseUrl.replace(/\/$/, "")}/storage/v1/object/public/guidebook-media/${encoded}`;
}
