"use client";

import { useQuery } from "@tanstack/react-query";
import {
  listFeaturedProducts,
  type FeaturedProduct,
} from "@/lib/services/products-api";
import type { ApiErrorResponse } from "@/lib/api-error";

export function useFeaturedProducts(simulateError: boolean) {
  return useQuery<FeaturedProduct[], ApiErrorResponse>({
    queryKey: ["featured-products", simulateError],
    queryFn: () => listFeaturedProducts({ simulateError }),
  });
}