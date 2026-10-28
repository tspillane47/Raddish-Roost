import { fireEvent, render, screen } from "@testing-library/react";
import type { ReactNode } from "react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { SectionView } from "@/components/guidebook/section-view";
import { BookNow } from "@/components/property/book-now";
import { PropertyHome } from "@/components/property/property-home";
import { previewGuideSection, previewProperty } from "@/lib/data/map-content";
import { trackBookingClick } from "@/lib/analytics/booking-click";

vi.mock("@/lib/analytics/booking-click", () => ({
  trackBookingClick: vi.fn(),
}));

vi.mock("next/link", () => ({
  default: ({ href, children, ...props }: { href: string; children: ReactNode } & Record<string, unknown>) => (
    <a href={href} {...props}>
      {children}
    </a>
  ),
}));

const airbnb = {
  channel: "airbnb" as const,
  name: "Airbnb",
  detail: "Book this stay on Airbnb.",
  url: "https://www.airbnb.com/rooms/1477625352327415954",
};

describe("Book Now", () => {
  beforeEach(() => {
    vi.mocked(trackBookingClick).mockClear();
  });

  it("opens only the saved platforms and records the click", () => {
    const property = previewProperty("raddish-roost");
    render(<PropertyHome property={{ ...property!, bookings: [airbnb] }} />);

    const button = screen.getByRole("button", { name: "Book Now" });
    expect(button).toHaveStyle({ backgroundColor: "#1E4A42" });
    fireEvent.click(button);

    const dialog = screen.getByRole("dialog", { name: "Book Your Stay" });
    expect(dialog).toBeInTheDocument();
    expect(screen.queryByRole("link", { name: /Book Direct/ })).not.toBeInTheDocument();
    expect(screen.queryByRole("link", { name: /VRBO/ })).not.toBeInTheDocument();
    expect(screen.queryByText("Best rate")).not.toBeInTheDocument();

    const link = screen.getByRole("link", { name: /Airbnb/ });
    expect(link).toHaveAttribute("href", airbnb.url);
    expect(link).toHaveAttribute("target", "_blank");
    expect(link).toHaveAttribute("rel", "noopener noreferrer");
    fireEvent.click(link);
    expect(trackBookingClick).toHaveBeenCalledWith("raddish-roost", "airbnb");
  });

  it("stays hidden when a stay has no booking links", () => {
    const property = previewProperty("shallot-chalet");
    render(<BookNow propertySlug="shallot-chalet" bookings={property!.bookings} accent="#6E2E3A" />);
    expect(screen.queryByRole("button", { name: "Book Now" })).not.toBeInTheDocument();
  });

  it("shows the same options in Stay With Us Again", () => {
    const section = previewGuideSection("onion-ranch", "stay-again");
    render(
      <SectionView
        section={{
          ...section!,
          bookings: [
            {
              channel: "direct",
              name: "Book Direct",
              detail: "Book with us directly.",
              url: "https://example.com/book",
            },
            airbnb,
          ],
        }}
      />,
    );

    const links = screen.getAllByRole("link").filter((link) => link.getAttribute("target") === "_blank");
    expect(links.map((link) => link.textContent)).toEqual([
      "Book DirectBook with us directly.",
      "AirbnbBook this stay on Airbnb.",
    ]);
    fireEvent.click(links[0]!);
    expect(trackBookingClick).toHaveBeenCalledWith("onion-ranch", "direct");
  });
});
