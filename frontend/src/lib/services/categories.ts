import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type Category = components["schemas"]["Category"];

function unwrapList<T>(raw: unknown): T[] {
  const candidate = raw as { data?: T[] } | T[];
  if (Array.isArray(candidate)) return candidate;
  return (candidate as { data?: T[] })?.data ?? [];
}

export async function fetchCategories(includeInactive = false): Promise<Category[]> {
  const { data, error } = await apiClient.GET("/categories", {
    params: { query: { includeInactive } },
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  return unwrapList<Category>(data);
}