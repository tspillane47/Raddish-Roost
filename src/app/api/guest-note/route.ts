import { NextResponse } from "next/server";
import { submitGuestNote } from "@/lib/server/submit-guest-note";

export async function POST(request: Request) {
  const formData = await request.formData();
  const result = await submitGuestNote(formData);
  return NextResponse.json(result, { status: result.status === "sent" ? 200 : 400 });
}
