/** Prefer property-link voice; fall back to the shared recommendation row. */
export function linkHostTip(input: {
  linkId?: string | null;
  linkHostNote?: string | null;
  recommendationId: string;
  recommendationHostNote?: string | null;
}): { table: "property_recommendations" | "recommendations"; id: string; english: string | null } {
  const linkTip = input.linkHostNote?.trim() || null;
  if (input.linkId && linkTip) {
    return { table: "property_recommendations", id: input.linkId, english: linkTip };
  }
  return {
    table: "recommendations",
    id: input.recommendationId,
    english: input.recommendationHostNote?.trim() || null,
  };
}

export function linkDescription(input: {
  customDescription?: string | null;
  recommendationDescription?: string | null;
}): string | null {
  const custom = input.customDescription?.trim() || null;
  if (custom) return custom;
  return input.recommendationDescription?.trim() || null;
}
