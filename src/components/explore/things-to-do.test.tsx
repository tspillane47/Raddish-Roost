import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { ThingsToDo } from "@/components/explore/things-to-do";
import type { ThingToDo } from "@/lib/content/things-to-do";

const places: ThingToDo[] = [
  {
    id: "waterworks",
    name: "Waterworks Food + Drink",
    town: "Winooski",
    tip: "The steak frites are to die for!",
    section: "eat",
    season: null,
    directionsUrl:
      "https://www.google.com/maps/search/?api=1&query=Waterworks%20Food%20%2B%20Drink%20Winooski%20Vermont",
    photo: null,
  },
  {
    id: "hen",
    name: "Hen of the Wood (Burlington)",
    town: "Burlington",
    tip: null,
    section: "eat",
    season: null,
    directionsUrl: "https://www.google.com/maps/search/?api=1&query=Hen%20of%20the%20Wood%20(Burlington)%20Burlington%20Vermont",
    photo: null,
  },
  {
    id: "dock",
    name: "Spot on the Dock",
    town: "Burlington",
    tip: "Fun place right on the water for cocktails! Beautiful at sunset.",
    section: "drink",
    season: "summer",
    directionsUrl: "https://www.google.com/maps/search/?api=1&query=Spot%20on%20the%20Dock%20Burlington%20Vermont",
    photo: null,
  },
];

describe("Things to Do", () => {
  it("filters places and leaves a card with no tip blank", () => {
    render(<ThingsToDo places={places} />);

    const tabs = screen.getByRole("tablist", { name: "Things to do" });
    expect(tabs.className).toContain("overflow-x-auto");
    expect(tabs.parentElement?.className).toContain("sticky");
    expect(screen.getByRole("tab", { name: "Eat" })).toHaveAttribute("aria-selected", "true");
    expect(screen.getByRole("heading", { name: "Waterworks Food + Drink" })).toBeInTheDocument();
    expect(screen.getByText("The steak frites are to die for!")).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Hen of the Wood (Burlington)" })).toBeInTheDocument();
    expect(screen.getByText("Burlington")).toBeInTheDocument();
    expect(screen.queryByText(/details coming soon/i)).not.toBeInTheDocument();
    expect(screen.queryByRole("link", { name: /^Photo:/ })).not.toBeInTheDocument();
    expect(screen.queryByText("A host favorite.")).not.toBeInTheDocument();

    const directions = screen.getAllByRole("link", { name: "Get Directions" })[0];
    expect(directions).toHaveAttribute("target", "_blank");
    expect(directions).toHaveAttribute("rel", "noopener noreferrer");
    expect(directions).toHaveAttribute("href", places[0]?.directionsUrl);

    fireEvent.click(screen.getByRole("tab", { name: "Drink" }));
    expect(screen.getByRole("heading", { name: "Spot on the Dock" })).toBeInTheDocument();
    expect(screen.getByText("Summer")).toBeInTheDocument();
    expect(screen.queryByRole("heading", { name: "Waterworks Food + Drink" })).not.toBeInTheDocument();
  });

  it("links the photo credit when the license asks for it", () => {
    render(
      <ThingsToDo
        places={[
          {
            id: "hump",
            name: "Camel's Hump",
            town: "Huntington / Duxbury",
            tip: "Famous Vermont hike! Not recommended for beginners.",
            section: "hike",
            season: null,
            directionsUrl: "https://www.google.com/maps/search/?api=1&query=Camel%27s%20Hump%20Vermont",
            photo: {
              src: "/images/recommendations/camels-hump.webp",
              alt: "The western face of Camel's Hump.",
              credit: {
                author: "Niranjan Arminius",
                license: "CC BY-SA 4.0",
                url: "https://commons.wikimedia.org/wiki/File:CamelsHumpMt_fromCharlotteVT_20140824.jpg",
              },
            },
          },
        ]}
      />,
    );
    expect(screen.getByRole("img", { name: "The western face of Camel's Hump." })).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Photo: Niranjan Arminius, CC BY-SA 4.0" })).toHaveAttribute(
      "href",
      "https://commons.wikimedia.org/wiki/File:CamelsHumpMt_fromCharlotteVT_20140824.jpg",
    );
  });

  it("says when a stay has no places yet", () => {
    render(<ThingsToDo places={[]} />);
    expect(screen.getByRole("status")).toHaveTextContent("Things to do have not been added yet.");
  });
});
