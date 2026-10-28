import { fireEvent, render, screen, within } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { PropertyGallery } from "@/components/property/property-gallery";

const photos = [
  { src: "/images/properties/raddish-roost/front-of-house.webp", alt: "Sunny front of the farmhouse", width: 1600, height: 1199 },
  { src: "/images/properties/raddish-roost/kitchen.webp", alt: "Sage green kitchen", width: 1600, height: 1067 },
];

describe("PropertyGallery", () => {
  it("opens a viewer from the grid, moves between photos, and closes", () => {
    render(<PropertyGallery photos={photos} />);

    expect(screen.getByRole("heading", { name: "Photos" })).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Sunny front of the farmhouse" }));

    const dialog = screen.getByRole("dialog");
    expect(within(dialog).getByRole("img", { name: "Sunny front of the farmhouse" })).toBeInTheDocument();
    expect(within(dialog).getByText("1 of 2")).toBeInTheDocument();

    fireEvent.click(within(dialog).getByRole("button", { name: "Next" }));
    expect(within(dialog).getByRole("img", { name: "Sage green kitchen" })).toBeInTheDocument();

    const stage = within(dialog).getByRole("img", { name: "Sage green kitchen" }).parentElement;
    expect(stage).not.toBeNull();
    fireEvent.pointerDown(stage!, { clientX: 280, clientY: 80, pointerId: 1, pointerType: "touch" });
    fireEvent.pointerUp(stage!, { clientX: 40, clientY: 84, pointerId: 1, pointerType: "touch" });
    expect(within(dialog).getByRole("img", { name: "Sunny front of the farmhouse" })).toBeInTheDocument();

    fireEvent.click(within(dialog).getByRole("button", { name: "Close" }));
    expect(screen.queryByRole("dialog")).not.toBeInTheDocument();
  });

  it("renders nothing when a stay has no photos", () => {
    const { container } = render(<PropertyGallery photos={[]} />);
    expect(container).toBeEmptyDOMElement();
  });
});
