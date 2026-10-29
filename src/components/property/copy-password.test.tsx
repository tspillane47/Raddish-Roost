import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { CopyPassword } from "@/components/property/copy-password";

describe("CopyPassword", () => {
  it("copies the password in one tap", async () => {
    const writeText = vi.fn().mockResolvedValue(undefined);
    Object.assign(navigator, { clipboard: { writeText } });
    render(<CopyPassword password="guest-wifi" />);

    fireEvent.click(screen.getByRole("button", { name: "Copy" }));

    expect(writeText).toHaveBeenCalledWith("guest-wifi");
    expect(await screen.findByRole("button", { name: "Copied" })).toBeInTheDocument();
  });
});
