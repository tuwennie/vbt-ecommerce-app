"use client";

import { useQuery } from "@tanstack/react-query";
import { getFeaturedProducts, type FeaturedProduct } from "@/lib/services/featured-products";
import type { ApiErrorResponse } from "@/lib/api-error";

export function useFeaturedProducts(simulateError: boolean) {
  return useQuery<FeaturedProduct[], ApiErrorResponse>({
    queryKey: ["featured-products", simulateError],
    queryFn: () => getFeaturedProducts({ simulateError }),
  });
}