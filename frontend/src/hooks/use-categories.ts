"use client";

import { useQuery } from "@tanstack/react-query";
import { fetchCategories, type Category } from "@/lib/services/categories";
import type { ApiErrorResponse } from "@/lib/api-error";

export function useCategories() {
  return useQuery<Category[], ApiErrorResponse>({
    queryKey: ["categories"],
    queryFn: () => fetchCategories(false),
    staleTime: 5 * 60 * 1000,
  });
}