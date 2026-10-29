import type { ReactNode } from "react";
import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { SectionView } from "@/components/guidebook/section-view";
import { EarlyArrival } from "@/components/property/early-arrival";
import { Essentials } from "@/components/property/essentials";
import { trackGuestPortalClick } from "@/lib/analytics/guest-portal-click";
import { EARLY_CHECK_IN_TEXT, RADDISH_GUEST_PORTAL_URL } from "@/lib/content/guest-portal";
import { previewGuideSection, previewProperty } from "@/lib/data/map-content";

vi.mock("@/lib/analytics/guest-portal-click", () => ({
  trackGuestPortalClick: vi.fn(),
}));

vi.mock("next/link", () => ({
  default: ({ href, children, ...props }: { href: string; children: ReactNode }) => (
    <a href={href} {...props}>
      {children}
    </a>
  ),
}));

describe("EarlyArrival", () => {
  it("links the Raddish portal and records the click", () => {
    vi.mocked(trackGuestPortalClick).mockClear();
    render(<EarlyArrival propertySlug="raddish-roost" portalUrl={RADDISH_GUEST_PORTAL_URL} />);

    expect(screen.getByText("Want to arrive early?")).toBeInTheDocument();
    expect(screen.getByText(EARLY_CHECK_IN_TEXT)).toBeInTheDocument();
    const link = screen.getByRole("link", { name: "Open Guest Portal" });
    expect(link).toHaveAttribute("href", RADDISH_GUEST_PORTAL_URL);
    expect(link).toHaveAttribute("target", "_blank");
    expect(link).toHaveAttribute("rel", "noopener noreferrer");
    fireEvent.click(link);
    expect(trackGuestPortalClick).toHaveBeenCalledWith("raddish-roost");
  });

  it("shows the note without a button when the stay has no portal", () => {
    render(<EarlyArrival propertySlug="shallot-chalet" portalUrl={null} />);
    expect(screen.getByText("Want to arrive early?")).toBeInTheDocument();
    expect(screen.queryByRole("link", { name: "Open Guest Portal" })).not.toBeInTheDocument();
  });
});

describe("check-in and checkout times", () => {
  it("shows the times and the early note on Essentials", () => {
    const raddish = previewProperty("raddish-roost");
    const shallot = previewProperty("shallot-chalet");
    expect(raddish?.guestPortalUrl).toBe(RADDISH_GUEST_PORTAL_URL);
    expect(shallot?.guestPortalUrl).toBeNull();

    render(<Essentials property={raddish!} />);
    expect(screen.getByText("4:00 PM")).toBeInTheDocument();
    expect(screen.getByText("10:00 AM")).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Open Guest Portal" })).toBeInTheDocument();
  });

  it("states the checkout time on the Checkout section", () => {
    const section = previewGuideSection("onion-ranch", "checkout");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);
    expect(screen.getByText("Checkout is at 10:00 AM")).toBeInTheDocument();
    expect(screen.queryByRole("link", { name: "Open Guest Portal" })).not.toBeInTheDocument();
  });

  it("states the check-in time and offers the portal on Check-In", () => {
    const section = previewGuideSection("raddish-roost", "check-in");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);
    expect(screen.getByText("Check-in is at 4:00 PM")).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Open Guest Portal" })).toBeInTheDocument();
  });
});
