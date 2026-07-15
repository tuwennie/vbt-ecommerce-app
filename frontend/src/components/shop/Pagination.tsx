    "use client";

import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { ChevronLeft, ChevronRight } from "lucide-react";

interface PaginationProps {
  currentPage: number;
  totalPages: number;
}

function buildPageList(current: number, total: number): (number | "ellipsis")[] {
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1);

  const pages = new Set<number>([1, 2, total - 1, total, current - 1, current, current + 1]);
  const sorted = [...pages].filter((p) => p >= 1 && p <= total).sort((a, b) => a - b);

  const result: (number | "ellipsis")[] = [];
  let prev = 0;
  for (const page of sorted) {
    if (prev && page - prev > 1) result.push("ellipsis");
    result.push(page);
    prev = page;
  }
  return result;
}

export function Pagination({ currentPage, totalPages }: PaginationProps) {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();

  function goToPage(page: number) {
    const params = new URLSearchParams(searchParams.toString());
    params.set("page", String(page));
    router.push(`${pathname}?${params.toString()}`);
  }

  const pages = buildPageList(currentPage, totalPages);

  return (
    <nav className="flex items-center justify-center gap-1.5" aria-label="Sayfalama">
      <button type="button" onClick={() => goToPage(Math.max(1, currentPage - 1))} disabled={currentPage === 1} aria-label="Önceki sayfa"
        className="flex h-9 w-9 items-center justify-center rounded-lg border border-border text-text-main hover:bg-neutral disabled:cursor-not-allowed disabled:opacity-40">
        <ChevronLeft className="h-4 w-4" />
      </button>

      {pages.map((page, i) =>
        page === "ellipsis" ? (
          <span key={`ellipsis-${i}`} className="px-1 text-text-muted">…</span>
        ) : (
          <button key={page} type="button" onClick={() => goToPage(page)} aria-current={page === currentPage ? "page" : undefined}
            className={`flex h-9 w-9 items-center justify-center rounded-lg text-sm font-medium ${
              page === currentPage ? "bg-secondary text-white" : "border border-border text-text-main hover:bg-neutral"
            }`}>
            {page}
          </button>
        ),
      )}

      <button type="button" onClick={() => goToPage(Math.min(totalPages, currentPage + 1))} disabled={currentPage === totalPages} aria-label="Sonraki sayfa"
        className="flex h-9 w-9 items-center justify-center rounded-lg border border-border text-text-main hover:bg-neutral disabled:cursor-not-allowed disabled:opacity-40">
        <ChevronRight className="h-4 w-4" />
      </button>
    </nav>
  );
}