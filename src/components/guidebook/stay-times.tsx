"use client";

import { useTranslate } from "@/lib/i18n/locale-context";

export function StayTimes({
  checkInTime,
  checkOutTime,
  summary,
  showCheckIn,
  showCheckOut,
}: {
  checkInTime: string | null;
  checkOutTime: string | null;
  summary: string | null;
  showCheckIn: boolean;
  showCheckOut: boolean;
}) {
  const { tf } = useTranslate();
  const checkInLine = checkInTime ? tf("checkInAt", { time: checkInTime }) : null;
  const checkoutLine = checkOutTime ? tf("checkoutAt", { time: checkOutTime }) : null;
  const text = summary?.trim() || null;
  const showSummary = Boolean(text) && !summaryRepeatsTimes(text, checkInLine, checkoutLine);

  return (
    <>
      {showCheckIn && checkInLine ? <p className="mt-4 font-heading text-3xl text-charcoal">{checkInLine}</p> : null}
      {showCheckOut && checkoutLine ? <p className="mt-2 font-heading text-3xl text-charcoal">{checkoutLine}</p> : null}
      {showSummary ? <p className="mt-4 text-lg leading-8">{text}</p> : null}
    </>
  );
}

function summaryRepeatsTimes(summary: string | null, checkInLine: string | null, checkoutLine: string | null) {
  if (!summary) return false;
  const trimmed = summary.trim().replace(/\.$/, "");
  const both = checkInLine && checkoutLine ? `${checkInLine}. ${checkoutLine}` : null;
  return trimmed === checkInLine || trimmed === checkoutLine || trimmed === both;
}
