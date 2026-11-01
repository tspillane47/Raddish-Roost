import { messages, type MessageKey } from "@/lib/i18n/messages";
import type { Locale } from "@/lib/i18n/locale";

export function t(locale: Locale, key: MessageKey): string {
  return messages[locale][key] || messages.en[key];
}

export function fill(template: string, values?: Record<string, string | number>): string {
  if (!values) return template;
  return template.replace(/\{([a-zA-Z0-9]+)\}/g, (match, key: string) =>
    Object.prototype.hasOwnProperty.call(values, key) ? String(values[key]) : match,
  );
}

export function tf(locale: Locale, key: MessageKey, values?: Record<string, string | number>): string {
  return fill(t(locale, key), values);
}
