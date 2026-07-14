import type { LucideIcon } from "lucide-react";
import { TrendingUp, TrendingDown } from "lucide-react";

interface StatCardProps {
  label: string;
  value: string;
  icon: LucideIcon;
  deltaLabel: string;
  direction: "up" | "down";
}

export function StatCard({
  label,
  value,
  icon: Icon,
  deltaLabel,
  direction,
}: StatCardProps) {
  const isUp = direction === "up";
  const DeltaIcon = isUp ? TrendingUp : TrendingDown;

  return (
    <div className="rounded-xl border border-border bg-surface p-5">
      <div className="flex items-start justify-between">
        <p className="text-xs font-medium tracking-wide text-text-muted">
          {label.toUpperCase()}
        </p>
        <Icon className="h-4 w-4 text-text-muted" />
      </div>

      <p className="mt-2 text-2xl font-semibold text-text-main">{value}</p>

      <div className="mt-3 flex items-center gap-1.5">
        <span
          className={`inline-flex items-center gap-1 rounded-md px-1.5 py-0.5 text-xs font-medium ${
            isUp ? "bg-tertiary/10 text-tertiary" : "bg-error/10 text-error"
          }`}
        >
          <DeltaIcon className="h-3 w-3" />
          {deltaLabel}
        </span>
        <span className="text-xs text-text-muted">vs geçen ay</span>
      </div>
    </div>
  );
}