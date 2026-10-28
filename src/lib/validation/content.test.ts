import { describe, expect, it } from "vitest";
import { BRAND_COLORS } from "@/lib/brand";
import { parseGuidebookBlock } from "@/lib/validation/blocks";
import { toContactHref } from "@/lib/validation/contact";
import { propertySlugSchema } from "@/lib/validation/slug";
import { safeUrl } from "@/lib/content/markdown";
import { previewProperty, toPublicWifi } from "@/lib/data/map-content";
import { guidebookImageUrl } from "@/lib/media";

function contrast(foreground: string, background: string) {
  const luminance = (hex: string) => {
    const channels = [0, 2, 4].map((offset) => {
      const value = Number.parseInt(hex.slice(1 + offset, 3 + offset), 16) / 255;
      return value <= 0.03928 ? value / 12.92 : ((value + 0.055) / 1.055) ** 2.4;
    });
    return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
  };
  const lighter = Math.max(luminance(foreground), luminance(background));
  const darker = Math.min(luminance(foreground), luminance(background));
  return (lighter + 0.05) / (darker + 0.05);
}

describe("property slugs", () => {
  it("accepts guidebook slugs and rejects paths", () => {
    expect(propertySlugSchema.safeParse("raddish-roost").success).toBe(true);
    expect(propertySlugSchema.safeParse("shallot-chalet").success).toBe(true);
    expect(propertySlugSchema.safeParse("onion-ranch").success).toBe(true);
    expect(propertySlugSchema.safeParse("Raddish").success).toBe(false);
    expect(propertySlugSchema.safeParse("../admin").success).toBe(false);
    expect(propertySlugSchema.safeParse("raddish_roost").success).toBe(false);
  });
});

describe("guidebook blocks", () => {
  it("accepts steps and rejects unsafe links", () => {
    expect(
      parseGuidebookBlock({
        type: "steps",
        steps: [{ title: "Arrive at the property." }],
      }).success,
    ).toBe(true);

    expect(
      parseGuidebookBlock({
        type: "link_list",
        links: [{ label: "Map", href: "javascript:alert(1)" }],
      }).success,
    ).toBe(false);

    expect(
      parseGuidebookBlock({
        type: "media",
        path: "../secret.jpg",
        alt: "Parking",
      }).success,
    ).toBe(false);
  });
});

describe("contact links", () => {
  it("builds safe hrefs", () => {
    expect(toContactHref("email", "host@example.com")).toBe("mailto:host@example.com");
    expect(toContactHref("phone", "(802) 555-0100")).toBe("tel:8025550100");
    expect(toContactHref("airbnb", "https://www.airbnb.com/rooms/1")).toBe(
      "https://www.airbnb.com/rooms/1",
    );
    expect(toContactHref("airbnb", "javascript:alert(1)")).toBeNull();
    expect(toContactHref("email", "not-an-email")).toBeNull();
  });
});

describe("markdown urls", () => {
  it("keeps http and mailto links", () => {
    expect(safeUrl("https://example.com/cafe")).toBe("https://example.com/cafe");
    expect(safeUrl("mailto:host@example.com")).toBe("mailto:host@example.com");
    expect(safeUrl("javascript:alert(1)")).toBe("");
    expect(safeUrl("data:text/html,hi")).toBe("");
  });
});

describe("preview content", () => {
  it("hides wifi and marks the three sample homes", () => {
    const property = previewProperty("raddish-roost");
    expect(property?.wifi).toBeNull();
    expect(property?.sections).toHaveLength(12);
    expect(property?.welcomeMessage.startsWith("[Sample]")).toBe(true);
    expect(previewProperty("unknown")).toBeNull();
    expect(toPublicWifi({ network_name: "   ", password: null, router_note: null })).toBeNull();
  });
});

describe("guidebook images", () => {
  it("builds a public storage url and rejects remote paths", () => {
    expect(guidebookImageUrl("https://example.supabase.co", "raddish/hero.jpg")).toBe(
      "https://example.supabase.co/storage/v1/object/public/guidebook-media/raddish/hero.jpg",
    );
    expect(guidebookImageUrl("https://example.supabase.co", "https://evil.test/a.jpg")).toBeNull();
    expect(guidebookImageUrl("https://example.supabase.co", "../secret.jpg")).toBeNull();
  });
});

describe("brand contrast", () => {
  it("keeps text colors at WCAG AA", () => {
    expect(contrast(BRAND_COLORS.charcoal, BRAND_COLORS.cream)).toBeGreaterThanOrEqual(4.5);
    expect(contrast(BRAND_COLORS.cream, BRAND_COLORS.forest)).toBeGreaterThanOrEqual(4.5);
    expect(contrast(BRAND_COLORS.cream, BRAND_COLORS.charcoal)).toBeGreaterThanOrEqual(4.5);
    expect(contrast(BRAND_COLORS.forest, BRAND_COLORS.beige)).toBeGreaterThanOrEqual(4.5);
    expect(contrast(BRAND_COLORS.muted, BRAND_COLORS.cream)).toBeGreaterThanOrEqual(4.5);
  });
});
