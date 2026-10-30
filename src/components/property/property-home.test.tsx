import { fireEvent, render, screen, within } from "@testing-library/react";
import type { ReactNode } from "react";
import { describe, expect, it, vi } from "vitest";
import { PropertyDock } from "@/components/property/property-dock";
import { PropertyHome } from "@/components/property/property-home";
import { WeatherCard } from "@/components/property/weather-card";
import { photoFrame } from "@/components/property/property-look";
import { PropertyTools } from "@/components/property/property-tools";
import { previewProperty } from "@/lib/data/map-content";

vi.mock("next/link", () => ({
  default: ({ href, children, ...props }: { href: string; children: ReactNode } & Record<string, unknown>) => (
    <a href={href} {...props}>
      {children}
    </a>
  ),
}));

vi.mock("next/navigation", () => ({
  usePathname: () => "/raddish-roost/guide/things-to-do",
}));

describe("PropertyHome", () => {
  it("shows the name once in the hero and previews grouped photos", () => {
    const property = previewProperty("raddish-roost");
    expect(property).not.toBeNull();
    render(<PropertyHome property={property!} />);

    expect(screen.getAllByRole("heading", { name: "The Raddish Roost" })).toHaveLength(1);
    expect(screen.queryByRole("heading", { name: "Welcome to The Raddish Roost" })).not.toBeInTheDocument();
    expect(screen.getByRole("img", { name: "Logo for The Raddish Roost" })).toBeInTheDocument();
    expect(screen.getByRole("img", { name: /dark-shingled farmhouse/ })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Show photo 2 of 3" })).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /dark-shingled farmhouse/ }));
    expect(within(screen.getByRole("dialog")).getByText("1 of 27")).toBeInTheDocument();
    fireEvent.click(within(screen.getByRole("dialog")).getByRole("button", { name: "Close" }));
    expect(screen.getByRole("heading", { name: "A Look Around" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Living Spaces" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Kitchen and Dining" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Bedrooms" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Bath and Laundry" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Outside and Around Town" })).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Book Now" })).not.toBeInTheDocument();
    expect(screen.getByRole("link", { name: /The House/ })).toHaveAttribute("href", "/raddish-roost/guide/the-house");
    expect(screen.getByRole("link", { name: /Things to Do/ })).toHaveAttribute(
      "href",
      "/raddish-roost/guide/things-to-do",
    );
    expect(screen.getByRole("link", { name: /Stay With Us Again/ })).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /Vermont 101/ })).toHaveAttribute(
      "href",
      "/raddish-roost/guide/vermont-101",
    );
    expect(screen.queryByRole("region", { name: "Weather" })).not.toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "See all 27 photos" }));
    const dialog = screen.getByRole("dialog");
    expect(within(dialog).getByRole("button", { name: "Close" })).toBeInTheDocument();
    expect(within(dialog).getByText("1 of 27")).toBeInTheDocument();
  });

  it("uses the Shallot Chalet living room as the hero and keeps the logo", () => {
    const property = previewProperty("shallot-chalet");
    expect(property).not.toBeNull();
    render(<PropertyHome property={property!} />);

    expect(screen.getAllByRole("heading", { name: "The Shallot Chalet" })).toHaveLength(1);
    expect(screen.getByRole("img", { name: "Logo for The Shallot Chalet" })).toBeInTheDocument();
    expect(screen.getAllByRole("img", { name: /Upstairs living room/ }).length).toBeGreaterThan(0);
    expect(screen.getByRole("button", { name: "See all 18 photos" })).toBeInTheDocument();
    expect(screen.queryByRole("heading", { name: "Outside and Around Town" })).not.toBeInTheDocument();
  });

  it("uses the Onion Ranch entrance as the hero and keeps the logo", () => {
    const property = previewProperty("onion-ranch");
    expect(property).not.toBeNull();
    render(<PropertyHome property={property!} />);

    expect(screen.getAllByRole("heading", { name: "The Onion Ranch" })).toHaveLength(1);
    expect(screen.getByRole("img", { name: "Logo for The Onion Ranch" })).toBeInTheDocument();
    expect(screen.getAllByRole("img", { name: /Light blue house/ }).length).toBeGreaterThan(0);
    expect(screen.getByRole("heading", { name: "Outside and Around Town" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "See all 16 photos" })).toBeInTheDocument();
  });

  it("uses the name alone when a stay has no photos yet", () => {
    const base = previewProperty("onion-ranch");
    expect(base).not.toBeNull();
    render(<PropertyHome property={{ ...base!, slug: "extra-cabin", name: "Extra Cabin" }} />);

    expect(screen.getAllByRole("heading", { name: "Extra Cabin" })).toHaveLength(1);
    expect(screen.queryByRole("heading", { name: "A Look Around" })).not.toBeInTheDocument();
    expect(screen.queryByRole("button", { name: /See all/ })).not.toBeInTheDocument();
  });
});

describe("weather card", () => {
  it("shows the temperature, today's range, and a seasonal line", () => {
    render(
      <WeatherCard
        weather={{
          temp: 48,
          code: 61,
          high: 55,
          low: 39,
          line: "Rainy day? Check the Rainy Day picks in Things to Do.",
          days: [
            { label: "Today", code: 61, high: 55, low: 39 },
            { label: "Sat", code: 2, high: 52, low: 34 },
            { label: "Sun", code: 0, high: 50, low: 32 },
          ],
        }}
      />,
    );

    const card = screen.getByRole("region", { name: "Weather" });
    expect(card).toHaveTextContent("48°");
    expect(card).toHaveTextContent("High 55°");
    expect(card).toHaveTextContent("Low 39°");
    expect(card).toHaveTextContent("Rainy day? Check the Rainy Day picks in Things to Do.");
    expect(card).toHaveTextContent("Sat");
  });
});

describe("guidebook links", () => {
  it("points Essentials and the bottom bar at the eight sections", () => {
    render(
      <>
        <PropertyTools slug="raddish-roost" />
        <PropertyDock slug="raddish-roost" />
      </>,
    );

    expect(screen.getByRole("link", { name: "Wi-Fi", hidden: true })).toHaveAttribute(
      "href",
      "/raddish-roost/guide/wifi",
    );
    expect(screen.getByRole("link", { name: "Check-in", hidden: true })).toHaveAttribute(
      "href",
      "/raddish-roost/guide/check-in-checkout",
    );
    expect(screen.getByRole("link", { name: "Checkout", hidden: true })).toHaveAttribute(
      "href",
      "/raddish-roost/guide/check-in-checkout#checkout-list",
    );
    expect(screen.getByRole("link", { name: "Parking", hidden: true })).toHaveAttribute(
      "href",
      "/raddish-roost/guide/getting-here#parking",
    );
    expect(screen.getAllByRole("link", { name: "Contact", hidden: true }).map((link) => link.getAttribute("href"))).toEqual([
      "/raddish-roost/guide/contact",
      "/raddish-roost/guide/contact",
    ]);
    expect(screen.getByRole("link", { name: "Emergency", hidden: true })).toHaveAttribute(
      "href",
      "/raddish-roost/guide/contact#emergency",
    );
    expect(screen.getByRole("link", { name: "Explore" })).toHaveAttribute(
      "href",
      "/raddish-roost/guide/things-to-do",
    );
    expect(screen.getByRole("link", { name: "Explore" })).toHaveAttribute("aria-current", "page");
  });
});

describe("photo frames", () => {
  it("alternates a wide photo with a pair", () => {
    expect([0, 1, 2].map((index) => photoFrame(3, index))).toEqual(["wide", "pair", "pair"]);
    expect([0, 1].map((index) => photoFrame(2, index))).toEqual(["pair", "pair"]);
    expect(photoFrame(1, 0)).toBe("wide");
  });
});
