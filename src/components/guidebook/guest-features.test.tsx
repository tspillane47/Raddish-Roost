import type { ReactNode } from "react";
import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { CheckoutList } from "@/components/guidebook/checkout-list";
import { GuestNote } from "@/components/guidebook/guest-note";
import { SectionView } from "@/components/guidebook/section-view";
import { EMERGENCY_COPY, GUEST_NOTE_TEXT, REVIEW_NOTE } from "@/lib/content/guest-note";
import { previewGuideSection } from "@/lib/data/map-content";

vi.mock("next/link", () => ({
  default: ({ href, children, ...props }: { href: string; children: ReactNode }) => (
    <a href={href} {...props}>
      {children}
    </a>
  ),
}));

describe("Something not right", () => {
  it("puts the full note on Contact and keeps 911 visible", () => {
    const section = previewGuideSection("raddish-roost", "contact");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);

    expect(screen.getByRole("heading", { name: "Something not right?" })).toBeInTheDocument();
    expect(screen.getByText(GUEST_NOTE_TEXT)).toBeInTheDocument();
    expect(screen.getByLabelText(/What's going on/)).toBeRequired();
    expect(screen.getByLabelText(/^Name/)).not.toBeRequired();
    expect(screen.getByDisplayValue("The Raddish Roost")).toHaveAttribute("readonly");
    expect(screen.getByText(EMERGENCY_COPY)).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Message us on Airbnb" })).toHaveAttribute(
      "href",
      "https://www.airbnb.com/contact_host/1477625352327415954/send_message",
    );
    const honeypot = document.querySelector<HTMLInputElement>('input[name="company"]');
    expect(honeypot).not.toBeNull();
    expect(honeypot?.closest("[aria-hidden='true']")).not.toBeNull();
  });

  it("uses the smaller note at the end of Check-In & Checkout", () => {
    const section = previewGuideSection("shallot-chalet", "check-in-checkout");
    expect(section).not.toBeNull();
    render(<SectionView section={section!} />);

    expect(screen.getByRole("heading", { name: "Something not right?" })).toBeInTheDocument();
    expect(screen.queryByText(EMERGENCY_COPY)).not.toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Message us on Airbnb" })).toHaveAttribute(
      "href",
      "https://www.airbnb.com/contact_host/1064639214342902592/send_message",
    );
    expect(screen.getByText(REVIEW_NOTE)).toBeInTheDocument();
  });
});

describe("review nudge", () => {
  it("stays under the list and is announced after the last box is checked", () => {
    render(
      <CheckoutList
        items={[
          { id: "dishes", label: "Wash the dishes" },
          { id: "trash", label: "Take out the trash" },
        ]}
      />,
    );

    const note = screen.getByText(REVIEW_NOTE);
    expect(note).not.toHaveAttribute("role", "status");
    expect(note.textContent).not.toMatch(/discount|perk|reward|coupon/i);

    fireEvent.click(screen.getByRole("checkbox", { name: "Wash the dishes" }));
    expect(screen.getByText(REVIEW_NOTE)).not.toHaveAttribute("role", "status");

    fireEvent.click(screen.getByRole("checkbox", { name: "Take out the trash" }));
    expect(screen.getByText(REVIEW_NOTE)).toHaveAttribute("role", "status");
  });
});

describe("guest note form", () => {
  it("shows a thank you after a note is sent", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      json: async () => ({ status: "sent" }),
    });
    vi.stubGlobal("fetch", fetchMock);

    render(
      <GuestNote
        propertySlug="onion-ranch"
        propertyName="The Onion Ranch"
        airbnbHref="https://www.airbnb.com/contact_host/862913226430309914/send_message"
        compact
      />,
    );

    fireEvent.change(screen.getByLabelText(/What's going on/), { target: { value: "The sink is dripping." } });
    fireEvent.click(screen.getByRole("button", { name: "Send" }));

    expect(await screen.findByRole("status")).toHaveTextContent("Thanks. We got your note and we'll get back to you.");
    expect(fetchMock).toHaveBeenCalledWith("/api/guest-note", expect.objectContaining({ method: "POST" }));
    vi.unstubAllGlobals();
  });
});
