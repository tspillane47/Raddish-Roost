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
    <div className="grid gap-4 text-lg leading-8 [&_a]:text-forest [&_a]:underline [&_a]:underline-offset-4 [&_h2]:font-heading [&_h2]:text-2xl [&_h3]:font-heading [&_h3]:text-xl [&_ol]:list-decimal [&_ol]:pl-6 [&_ul]:list-disc [&_ul]:pl-6">
      <Markdown
        skipHtml
        rehypePlugins={[[rehypeSanitize, guidebookMarkdownSchema]]}
        urlTransform={(url) => safeUrl(url)}
        components={components}
      >
        {markdown}
      </Markdown>
    </div>
  );
}
