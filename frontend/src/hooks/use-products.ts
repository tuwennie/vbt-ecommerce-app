"use client";

import { useQuery } from "@tanstack/react-query";
import {
  listProductsMock,
  type ListProductsParams,
  type ListProductsResult,
} from "@/lib/services/products-catalog";
import type { ApiErrorResponse } from "@/lib/api-error";

export function useProducts(params: ListProductsParams) {
  return useQuery<ListProductsResult, ApiErrorResponse>({
    queryKey: ["products", params],
    queryFn: () => listProductsMock(params),
  });
}