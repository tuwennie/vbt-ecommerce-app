"use client";

import { useSearchParams } from "next/navigation";
import { useProducts } from "@/hooks/use-products";
import { useCategories } from "@/hooks/use-categories";
import type { SortOption } from "@/lib/services/products-api";
import { ProductCard } from "@/components/shop/ProductCard";
import { ProductGridSkeleton } from "@/components/shop/ProductGridSkeleton";
import { ProductGridError } from "@/components/shop/ProductGridError";
import { SortDropdown } from "@/components/shop/SortDropdown";
import { Pagination } from "@/components/shop/Pagination";
import { getApiErrorMessage } from "@/lib/api-error";

export function SearchContent() {
  const searchParams = useSearchParams();
  const categoryId = searchParams.get("category");
  const search = searchParams.get("search");
  const sort = (searchParams.get("sort") as SortOption | null) ?? "-createdAt";
  const page = Number(searchParams.get("page") ?? "1");
  const simulateError = searchParams.get("simulateError") === "true";

  const { data: categories } = useCategories();
  const activeCategory = categories?.find((c) => c.id === categoryId);

  const title = search
    ? `"${search}" için sonuçlar`
    : (activeCategory?.name ?? (categoryId ? "Kategori" : "Tüm Ürünler"));

  const { data, isLoading, isError, error, refetch } = useProducts({
    categoryId,
    search,
    sort,
    page,
    simulateError,
  });

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-text-main">{title}</h1>
        </div>
        <SortDropdown />
      </div>

      <div data-testid="search-results-region">
        {isLoading && <ProductGridSkeleton count={8} />}

        {isError && (
          <ProductGridError message={getApiErrorMessage(error)} onRetry={() => refetch()} />
        )}

        {data && !isLoading && !isError && (
          <>
            {data.items.length === 0 ? (
              <p className="py-16 text-center text-sm text-text-muted">
                Bu kritere uygun ürün bulunamadı.
              </p>
            ) : (
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
                {data.items.map((product) => (
                  <ProductCard key={product.id} product={product} />
                ))}
              </div>
            )}

            <div className="mt-8">
              <Pagination currentPage={data.page} totalPages={data.totalPages} />
            </div>
          </>
        )}
      </div>
    </div>
  );
}