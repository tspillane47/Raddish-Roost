import { describe, expect, it } from "vitest";
import { linkDescription, linkHostTip } from "@/lib/content/link-voice";

describe("link voice", () => {
  it("reads host tips from the property link when present", () => {
    expect(
      linkHostTip({
        linkId: "link-1",
        linkHostNote: "Ask for the window table.",
        recommendationId: "rec-1",
        recommendationHostNote: "Shared tip that must not win.",
      }),
    ).toEqual({
      table: "property_recommendations",
      id: "link-1",
      english: "Ask for the window table.",
    });
  });

  it("falls back to the shared recommendation tip before the voice migration", () => {
    expect(
      linkHostTip({
        linkId: null,
        linkHostNote: null,
        recommendationId: "rec-1",
        recommendationHostNote: "Shared tip stays.",
      }),
    ).toEqual({
      table: "recommendations",
      id: "rec-1",
      english: "Shared tip stays.",
    });
  });

  it("prefers a custom description on the property link", () => {
    expect(
      linkDescription({
        customDescription: "Our take for this stay.",
        recommendationDescription: "Shared place copy.",
      }),
    ).toBe("Our take for this stay.");
    expect(
      linkDescription({
        customDescription: null,
        recommendationDescription: "Shared place copy.",
      }),
    ).toBe("Shared place copy.");
  });
});
