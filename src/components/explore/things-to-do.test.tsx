import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { ThingsToDo } from "@/components/explore/things-to-do";
import type { PerfectDay, ThingToDo } from "@/lib/content/things-to-do";

const places: ThingToDo[] = [
  {
    id: "waterworks",
    name: "Waterworks Food + Drink",
    town: "Winooski",
    description: "A lively restaurant in a restored mill building right on the Winooski River.",
    tip: "The steak frites are to die for. Ask for a table by the windows.",
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
    description: "A Vermont favorite for farm-to-table dining.",
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
    description: "A waterfront bar and restaurant right on Lake Champlain.",
    tip: "Go at sunset. It's beautiful.",
    section: "drink",
    season: "summer",
    directionsUrl: "https://www.google.com/maps/search/?api=1&query=Spot%20on%20the%20Dock%20Burlington%20Vermont",
    photo: null,
  },
];

describe("Things to Do", () => {
  it("filters places and leaves a card with no tip blank", () => {
    render(<ThingsToDo places={places} accent="#6E2E3A" />);

    const tabs = screen.getByRole("tablist", { name: "Things to do" });
    expect(tabs.className).toContain("overflow-x-auto");
    expect(tabs.parentElement?.className).toContain("sticky");
    expect(screen.getByRole("tab", { name: "Eat" })).toHaveAttribute("aria-selected", "true");
    expect(screen.queryByRole("tab", { name: "Coffee" })).not.toBeInTheDocument();
    expect(screen.queryByRole("tab", { name: "Bike" })).not.toBeInTheDocument();
    expect(screen.queryByRole("tab", { name: "Winter Fun" })).not.toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Waterworks Food + Drink" })).toBeInTheDocument();
    expect(screen.getByText(/restored mill building/)).toBeInTheDocument();
    const tip = screen.getByText(/Ask for a table by the windows/);
    expect(tip.closest("p")).toHaveAttribute("style", expect.stringContaining("#6E2E3A"));
    expect(screen.getByText("Host tip:")).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Hen of the Wood (Burlington)" })).toBeInTheDocument();
    expect(screen.getByText(/farm-to-table dining/)).toBeInTheDocument();
    expect(screen.getAllByText("Host tip:")).toHaveLength(1);
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

  it("shows Coffee and Bike only when that stay has places there", () => {
    render(
      <ThingsToDo
        places={[
          {
            id: "coffee",
            name: "Black Cap Coffee & Bakery",
            town: "Waterbury",
            description: "A Waterbury coffee shop and bakery with lunch, pastries, sandwiches, and lattes.",
            tip: null,
            section: "coffee",
            season: null,
            directionsUrl: "https://www.google.com/maps/search/?api=1&query=Black%20Cap%20Coffee%20%26%20Bakery%20Waterbury%20Vermont",
            photo: null,
          },
          {
            id: "bike",
            name: "Cady Hill Forest",
            town: "Stowe",
            description: "A popular Stowe trail network loved by mountain bikers.",
            tip: "Great mountain bike trails.",
            section: "bike",
            season: null,
            directionsUrl: "https://www.google.com/maps/search/?api=1&query=Cady%20Hill%20Forest%20Stowe%20Vermont",
            photo: null,
          },
        ]}
      />,
    );
    expect(screen.getByRole("tab", { name: "Coffee" })).toBeInTheDocument();
    expect(screen.getByText(/lunch, pastries, sandwiches, and lattes/i)).toBeInTheDocument();
    expect(screen.queryByText("Host tip:")).not.toBeInTheDocument();
    expect(screen.getByRole("tab", { name: "Bike" })).toBeInTheDocument();
    expect(screen.queryByRole("tab", { name: "Eat" })).not.toBeInTheDocument();
    expect(screen.queryByRole("tab", { name: "Winter Fun" })).not.toBeInTheDocument();
    fireEvent.click(screen.getByRole("tab", { name: "Bike" }));
    expect(screen.getByRole("heading", { name: "Cady Hill Forest" })).toBeInTheDocument();
    expect(screen.queryByRole("heading", { name: "Black Cap Coffee & Bakery" })).not.toBeInTheDocument();
  });

  it("links the photo credit when the license asks for it", () => {
    render(
      <ThingsToDo
        places={[
          {
            id: "hump",
            name: "Camel's Hump",
            town: "Huntington / Duxbury",
            description: "One of Vermont's most iconic peaks.",
            tip: "Not recommended for beginners. Start early and bring layers.",
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

  it("opens Perfect Day first and switches season", () => {
    const coffee: ThingToDo = {
      id: "black-cap",
      name: "Black Cap Coffee & Bakery",
      town: "Waterbury",
      description: "A Waterbury coffee shop and bakery.",
      tip: null,
      section: "coffee",
      season: null,
      directionsUrl:
        "https://www.google.com/maps/search/?api=1&query=Black%20Cap%20Coffee%20%26%20Bakery%20Waterbury%20Vermont",
      photo: null,
    };
    const bagels: ThingToDo = {
      ...coffee,
      id: "kc",
      name: "K.C.'s Bagel Café",
      description: "Fresh bagels in Waterbury.",
      directionsUrl: "https://www.google.com/maps/search/?api=1&query=K.C.%27s%20Bagel%20Cafe%20Vermont",
    };
    const days: PerfectDay[] = [
      {
        season: "fall",
        title: "Our perfect day",
        stops: [
          {
            id: "fall-morning",
            timeLabel: "Morning",
            name: coffee.name,
            detail: "Coffee and a pastry, a short walk from the house.",
            place: coffee,
          },
        ],
      },
      {
        season: "winter",
        title: "Our perfect day",
        stops: [
          {
            id: "winter-morning",
            timeLabel: "Morning",
            name: bagels.name,
            detail: "Bagels to start the day.",
            place: bagels,
          },
        ],
      },
    ];

    render(<ThingsToDo places={[coffee]} itineraries={days} today={new Date(2026, 9, 30)} />);

    const tabs = screen.getAllByRole("tab");
    expect(tabs[0]).toHaveAccessibleName("Perfect Day");
    expect(tabs[0]).toHaveAttribute("aria-selected", "true");
    expect(screen.getByRole("button", { name: "Fall" })).toHaveAttribute("aria-pressed", "true");
    expect(screen.getByText("Coffee and a pastry, a short walk from the house.")).toBeInTheDocument();
    expect(screen.queryByText(/discount|perk|reward|coupon/i)).not.toBeInTheDocument();

    fireEvent.click(screen.getByText("See this place"));
    expect(screen.getByText("A Waterbury coffee shop and bakery.")).toBeInTheDocument();
    expect(screen.getAllByRole("link", { name: "Get Directions" })[0]).toHaveAttribute("href", coffee.directionsUrl);

    fireEvent.click(screen.getByRole("button", { name: "Winter" }));
    expect(screen.getByRole("button", { name: "Winter" })).toHaveAttribute("aria-pressed", "true");
    expect(screen.getByText("Bagels to start the day.")).toBeInTheDocument();
    expect(screen.queryByText("Coffee and a pastry, a short walk from the house.")).not.toBeInTheDocument();
  });

  it("says when a stay has no places yet", () => {
    render(<ThingsToDo places={[]} />);
    expect(screen.getByRole("status")).toHaveTextContent("Things to do have not been added yet.");
  });
});
