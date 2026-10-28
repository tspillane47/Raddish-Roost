export type PhotoFocus = "center" | "top" | "bottom";

export function photoObjectPosition(focus: PhotoFocus): string {
  if (focus === "top") return "center top";
  if (focus === "bottom") return "center bottom";
  return "center";
}
