import { describe, expect, it } from "vitest";
import { propertySlugRedirectPath } from "@/lib/routing/property-slug-redirect";

describe("property slug redirects", () => {
  it("rewrites old Sanibel slugs and keeps subpaths", () => {
    expect(propertySlugRedirectPath("/tennisplace-a35")).toBe("/shell-game");
    expect(propertySlugRedirectPath("/tennisplace-a35/guide/getting-here")).toBe(
      "/shell-game/guide/getting-here",
    );
    expect(propertySlugRedirectPath("/sanibel-sunsets/explore")).toBe("/safe-harbor/explore");
    expect(propertySlugRedirectPath("/sanibel-sunsets/guide/sanibel-101")).toBe(
      "/safe-harbor/guide/sanibel-101",
    );
  });

  it("leaves current and unrelated paths alone", () => {
    expect(propertySlugRedirectPath("/shell-game")).toBeNull();
    expect(propertySlugRedirectPath("/safe-harbor/guide/the-house")).toBeNull();
    expect(propertySlugRedirectPath("/cider-loft")).toBeNull();
    expect(propertySlugRedirectPath("/")).toBeNull();
  });
});
