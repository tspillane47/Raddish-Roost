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

  it("states the checkout time and offers late checkout on the Checkout section", () => {
    const section = previewGuideSection("onion-ranch", "checkout");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);
    expect(screen.getByText("Checkout is at 10:00 AM")).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Request Late Checkout" })).toHaveAttribute(
      "href",
      GUEST_PORTAL_URLS["onion-ranch"],
    );
  });

  it("keeps check-in free of the portal button", () => {
    const section = previewGuideSection("raddish-roost", "check-in");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);
    expect(screen.getByText("Check-in is at 4:00 PM")).toBeInTheDocument();
    expect(screen.queryByText("Want to stay a little longer?")).not.toBeInTheDocument();
    expect(screen.queryByRole("link", { name: "Request Late Checkout" })).not.toBeInTheDocument();
  });
});
