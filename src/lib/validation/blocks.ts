import { z } from "zod";

const httpUrl = z.string().trim().refine((value) => {
  try {
    const url = new URL(value);
    return url.protocol === "https:" || url.protocol === "http:";
  } catch {
    return false;
  }
}, "Enter a full http or https link.");

const storagePath = z
  .string()
  .trim()
  .min(1)
  .max(500)
  .regex(/^[a-zA-Z0-9][a-zA-Z0-9/_.-]*$/)
  .refine((value) => !value.includes(".."), "Use a storage path without ..");

export const richTextBlockSchema = z.object({
  type: z.literal("rich_text"),
  markdown: z.string().max(20000),
});

export const stepsBlockSchema = z.object({
  type: z.literal("steps"),
  steps: z
    .array(
      z.object({
        title: z.string().trim().min(1).max(200),
        detail: z.string().max(2000).optional(),
      }),
    )
    .min(1)
    .max(30),
});

export const calloutBlockSchema = z.object({
  type: z.literal("callout"),
  tone: z.enum(["note", "important"]),
  markdown: z.string().max(4000),
});

export const checklistBlockSchema = z.object({
  type: z.literal("checklist"),
  items: z
    .array(
      z.object({
        id: z.string().regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/).max(80),
        label: z.string().trim().min(1).max(300),
        detail: z.string().max(1000).optional(),
      }),
    )
    .min(1)
    .max(50),
});

export const linkListBlockSchema = z.object({
  type: z.literal("link_list"),
  links: z
    .array(
      z.object({
        label: z.string().trim().min(1).max(200),
        href: httpUrl,
      }),
    )
    .min(1)
    .max(20),
});

export const mediaBlockSchema = z.object({
  type: z.literal("media"),
  path: storagePath,
  alt: z.string().trim().min(1).max(300),
  caption: z.string().max(300).optional(),
});

export const guidebookBlockSchema = z.discriminatedUnion("type", [
  richTextBlockSchema,
  stepsBlockSchema,
  calloutBlockSchema,
  checklistBlockSchema,
  linkListBlockSchema,
  mediaBlockSchema,
]);

export type GuidebookBlock = z.infer<typeof guidebookBlockSchema>;

export function parseGuidebookBlock(input: unknown) {
  return guidebookBlockSchema.safeParse(input);
}
