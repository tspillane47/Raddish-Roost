import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { PropertyCard } from "@/components/homepage/property-card";
import { previewProperties } from "@/lib/data/map-content";

vi.mock("next/link", () => ({
  default: ({
    href,
    children,
    ...props
  }: {
    href: string;
    children: React.ReactNode;
  } & React.AnchorHTMLAttributes<HTMLAnchorElement>) => (
    <a href={href} {...props}>
      {children}
    </a>
  ),
}));

describe("PropertyCard", () => {
  it("links to the property and marks sample copy", () => {
    const property = previewProperties()[0];
    render(<PropertyCard property={property} />);

    expect(screen.getByRole("heading", { name: "The Raddish Roost" })).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Explore Your Stay" })).toHaveAttribute(
      "href",
      "/raddish-roost",
    );
    expect(screen.getByText("Sample")).toBeInTheDocument();
    expect(screen.getByText("Photograph coming soon")).toBeInTheDocument();
  });
});
