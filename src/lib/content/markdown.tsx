import Markdown, { type Components } from "react-markdown";
import rehypeSanitize, { defaultSchema } from "rehype-sanitize";

export function safeUrl(url: string): string {
  const trimmed = url.trim();
  if (/^mailto:[^\s@]+@[^\s@]+\.[^\s@]+$/i.test(trimmed)) return trimmed;
  try {
    const parsed = new URL(trimmed);
    if (parsed.protocol === "https:" || parsed.protocol === "http:") return parsed.toString();
  } catch {
    return "";
  }
  return "";
}

export const guidebookMarkdownSchema = {
  ...defaultSchema,
  tagNames: ["p", "h2", "h3", "ul", "ol", "li", "a", "strong", "em", "blockquote", "code", "pre", "br"],
  attributes: {
    a: ["href", "rel"],
  },
  protocols: {
    href: ["http", "https", "mailto"],
  },
};

const components: Components = {
  a: ({ href, children }) => {
    const safe = href ? safeUrl(href) : "";
    if (!safe) return <span>{children}</span>;
    const external = safe.startsWith("http");
    return (
      <a href={safe} rel={external ? "noopener noreferrer" : undefined}>
        {children}
      </a>
    );
  },
};

export function GuidebookMarkdown({ markdown }: { markdown: string }) {
  return (
    <Markdown
      skipHtml
      rehypePlugins={[[rehypeSanitize, guidebookMarkdownSchema]]}
      urlTransform={(url) => safeUrl(url)}
      components={components}
    >
      {markdown}
    </Markdown>
  );
}
