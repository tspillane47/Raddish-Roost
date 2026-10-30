import type { ReactNode } from "react";
import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { SectionView } from "@/components/guidebook/section-view";
import { Essentials } from "@/components/property/essentials";
import { LateCheckout } from "@/components/property/late-checkout";
import { trackLateCheckoutClick } from "@/lib/analytics/late-checkout-click";
import { GUEST_PORTAL_URLS, LATE_CHECKOUT_TEXT } from "@/lib/content/guest-portal";
import { previewGuideSection, previewProperty } from "@/lib/data/map-content";

vi.mock("@/lib/analytics/late-checkout-click", () => ({
  trackLateCheckoutClick: vi.fn(),
}));

vi.mock("next/link", () => ({
  default: ({ href, children, ...props }: { href: string; children: ReactNode }) => (
    <a href={href} {...props}>
      {children}
    </a>
  ),
}));

describe("LateCheckout", () => {
  it("links the stay portal and records the click", () => {
    vi.mocked(trackLateCheckoutClick).mockClear();
    render(<LateCheckout propertySlug="shallot-chalet" portalUrl={GUEST_PORTAL_URLS["shallot-chalet"]} />);

    expect(screen.getByText("Want to stay a little longer?")).toBeInTheDocument();
    expect(screen.getByText(LATE_CHECKOUT_TEXT)).toBeInTheDocument();
    const link = screen.getByRole("link", { name: "Request Late Checkout" });
    expect(link).toHaveAttribute("href", GUEST_PORTAL_URLS["shallot-chalet"]);
    expect(link).toHaveAttribute("target", "_blank");
    expect(link).toHaveAttribute("rel", "noopener noreferrer");
    fireEvent.click(link);
    expect(trackLateCheckoutClick).toHaveBeenCalledWith("shallot-chalet");
  });

  it("shows the note without a button when the stay has no portal", () => {
    render(<LateCheckout propertySlug="onion-ranch" portalUrl={null} />);
    expect(screen.getByText("Want to stay a little longer?")).toBeInTheDocument();
    expect(screen.queryByRole("link", { name: "Request Late Checkout" })).not.toBeInTheDocument();
  });
});

describe("check-in and checkout times", () => {
  it("keeps the times and puts the late checkout note on Essentials checkout", () => {
    const raddish = previewProperty("raddish-roost");
    const shallot = previewProperty("shallot-chalet");
    const onion = previewProperty("onion-ranch");
    expect(raddish?.guestPortalUrl).toBe(GUEST_PORTAL_URLS["raddish-roost"]);
    expect(shallot?.guestPortalUrl).toBe(GUEST_PORTAL_URLS["shallot-chalet"]);
    expect(onion?.guestPortalUrl).toBe(GUEST_PORTAL_URLS["onion-ranch"]);

    render(<Essentials property={raddish!} />);
    expect(screen.getByText("4:00 PM")).toBeInTheDocument();
    expect(screen.getByText("10:00 AM")).toBeInTheDocument();
    expect(screen.getByText("Want to stay a little longer?")).toBeInTheDocument();
    expect(screen.queryByText("Want to arrive early?")).not.toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Request Late Checkout" })).toHaveAttribute(
      "href",
      GUEST_PORTAL_URLS["raddish-roost"],
    );
  });

  it("states both times, then late checkout, on Check-In & Checkout", () => {
    const section = previewGuideSection("onion-ranch", "check-in-checkout");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);
    expect(screen.getByText("Check-in is at 4:00 PM")).toBeInTheDocument();
    expect(screen.getByText("Checkout is at 10:00 AM")).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Request Late Checkout" })).toHaveAttribute(
      "href",
      GUEST_PORTAL_URLS["onion-ranch"],
    );
    expect(screen.getByRole("checkbox", { name: /Run through the checkout list/ })).toBeInTheDocument();
    expect(screen.getByText("Arrive at the property.")).toBeInTheDocument();
  });

  it("groups the house into what is here and how things work", () => {
    const section = previewGuideSection("raddish-roost", "the-house");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);
    expect(screen.getByRole("heading", { name: "What's here" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "How things work" })).toBeInTheDocument();
    expect(screen.getByText("[Sample] Amenities will appear here.")).toBeInTheDocument();
    fireEvent.click(screen.getByText("[Sample] Heat"));
    expect(screen.getByText("[Sample] How the heat works will appear here.")).toBeInTheDocument();
  });

  it("adds parking to Getting Here", () => {
    const section = previewGuideSection("shallot-chalet", "getting-here");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);
    expect(screen.getByRole("heading", { name: "Parking" })).toBeInTheDocument();
    expect(screen.getByText("[Sample] Park in the driveway.")).toBeInTheDocument();
  });

  it("keeps other sections free of the late checkout note", () => {
    const section = previewGuideSection("raddish-roost", "wifi");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);
    expect(screen.queryByText("Check-in is at 4:00 PM")).not.toBeInTheDocument();
    expect(screen.queryByText("Want to stay a little longer?")).not.toBeInTheDocument();
    expect(screen.queryByRole("link", { name: "Request Late Checkout" })).not.toBeInTheDocument();
  });
});
