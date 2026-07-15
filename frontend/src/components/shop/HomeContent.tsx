"use client";

import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { useFeaturedProducts } from "@/hooks/use-featured-products";
import { ProductCard } from "@/components/shop/ProductCard";
import { ProductGridSkeleton } from "@/components/shop/ProductGridSkeleton";
import { ProductGridError } from "@/components/shop/ProductGridError";
import { HeroBanner } from "@/components/shop/HeroBanner";
import { getApiErrorMessage } from "@/lib/api-error";

export function HomeContent() {
  const searchParams = useSearchParams();
  // QA'nın Playwright ile hata durumunu test edebilmesi için:
  // /?simulateError=true adresine gidildiğinde mock servis hata fırlatır.
  const simulateError = searchParams.get("simulateError") === "true";

  const { data, isLoading, isError, error, refetch } = useFeaturedProducts(simulateError);

  return (
    <div className="space-y-8">
      <HeroBanner />

      <div>
        <div className="flex items-center justify-between">
          <h2 className="text-xl font-semibold text-text-main">Öne Çıkan Ürünler</h2>
          <Link href="/search" className="flex items-center gap-1 text-sm font-medium text-secondary hover:underline">
            Tümünü Gör
            <ArrowRight className="h-4 w-4" />
          </Link>
        </div>

        <div className="mt-4" data-testid="featured-products-region">
          {isLoading && <ProductGridSkeleton />}

          {isError && (
            <ProductGridError message={getApiErrorMessage(error)} onRetry={() => refetch()} />
          )}

          {data && !isLoading && !isError && (
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
              {data.map((product) => (
                <ProductCard key={product.id} product={product} />
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}