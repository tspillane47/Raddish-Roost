import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { LanguageToggle } from "@/components/layout/language-toggle";
import { LocaleProvider } from "@/lib/i18n/locale-context";
import type { Locale } from "@/lib/i18n/locale";

const setLocale = vi.fn(async (_locale: Locale) => undefined);

vi.mock("@/lib/i18n/set-locale", () => ({
  setLocale: (locale: Locale) => setLocale(locale),
}));

describe("LanguageToggle", () => {
  beforeEach(() => {
    setLocale.mockClear();
  });

  it("switches between EN, ES, and FR and persists via setLocale", async () => {
    render(
      <LocaleProvider locale="en">
        <LanguageToggle />
      </LocaleProvider>,
    );

    const en = screen.getByRole("button", { name: "en" });
    const es = screen.getByRole("button", { name: "es" });
    const fr = screen.getByRole("button", { name: "fr" });

    expect(en).toHaveAttribute("aria-pressed", "true");
    expect(es).toHaveAttribute("aria-pressed", "false");
    expect(fr).toHaveAttribute("aria-pressed", "false");

    fireEvent.click(es);
    expect(es).toHaveAttribute("aria-pressed", "true");
    await waitFor(() => expect(setLocale).toHaveBeenCalledWith("es"));

    fireEvent.click(fr);
    expect(fr).toHaveAttribute("aria-pressed", "true");
    await waitFor(() => expect(setLocale).toHaveBeenCalledWith("fr"));

    fireEvent.click(en);
    expect(en).toHaveAttribute("aria-pressed", "true");
    await waitFor(() => expect(setLocale).toHaveBeenCalledWith("en"));

    expect(setLocale.mock.calls.map((call) => call[0])).toEqual(["es", "fr", "en"]);
  });

  it("does not call setLocale again for the already active language", async () => {
    render(
      <LocaleProvider locale="fr">
        <LanguageToggle />
      </LocaleProvider>,
    );

    fireEvent.click(screen.getByRole("button", { name: "fr" }));
    expect(setLocale).not.toHaveBeenCalled();
  });
});
