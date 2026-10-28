import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it } from "vitest";
import { GuidebookMarkdown } from "@/lib/content/markdown";

describe("GuidebookMarkdown", () => {
  it("strips scripts and javascript links", () => {
    const html = renderToStaticMarkup(
      <GuidebookMarkdown
        markdown={
          "Hello\n\n<script>alert(1)</script>\n\n[bad](javascript:alert(1))\n\n[ok](https://example.com)\n\n**bold**"
        }
      />,
    );

    expect(html).not.toContain("<script");
    expect(html).not.toContain("javascript:");
    expect(html).toContain("https://example.com");
    expect(html).toContain("<strong>bold</strong>");
  });
});
