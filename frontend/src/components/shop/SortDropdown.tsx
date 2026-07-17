"use client";

import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { SORT_OPTIONS } from "@/lib/services/products-api";


export function SortDropdown() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const currentSort = searchParams.get("sort") ?? "-createdAt";

  function handleChange(event: React.ChangeEvent<HTMLSelectElement>) {
    const params = new URLSearchParams(searchParams.toString());
    params.set("sort", event.target.value);
    params.delete("page");
    router.push(`${pathname}?${params.toString()}`);
  }

  return (
    <label className="flex items-center gap-2 text-sm text-text-main">
      <span className="hidden text-text-muted sm:inline">Sıralama ölçütü:</span>
      <select
        value={currentSort}
        onChange={handleChange}
        aria-label="Sıralama ölçütü"
        className="rounded-lg border border-border bg-surface px-3 py-1.5 text-sm text-text-main focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary"
      >
        {SORT_OPTIONS.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </label>
  );
}