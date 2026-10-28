import type { Metadata } from "next";
import { MissingPage } from "@/components/layout/missing-page";

export const metadata: Metadata = {
  title: "Page not found",
};

export default function NotFound() {
  return <MissingPage />;
}
