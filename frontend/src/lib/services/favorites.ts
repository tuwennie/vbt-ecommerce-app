import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type Favorite = components["schemas"]["Favorite"];

function unwrapList<T>(raw: unknown): T[] {
  const candidate = raw as { data?: T[] } | T[];
  if (Array.isArray(candidate)) return candidate;
  return (candidate as { data?: T[] })?.data ?? [];
}

function unwrapItem<T>(raw: unknown): T {
  const candidate = raw as { data?: T };
  return candidate?.data ?? (candidate as T);
}

export async function listFavorites(): Promise<Favorite[]> {
  const { data, error } = await apiClient.GET("/favorites", {});
  if (error) throw error as ApiErrorResponse;
  return unwrapList<Favorite>(data);
}

export async function addFavorite(productId: string): Promise<Favorite> {
  const { data, error } = await apiClient.POST("/favorites", { body: { productId } });
  if (error) throw error as ApiErrorResponse;
  return unwrapItem<Favorite>(data);
}

export async function removeFavorite(productId: string): Promise<void> {
  const { error } = await apiClient.DELETE("/favorites/{productId}", {
    params: { path: { productId } },
  });
  if (error) throw error as ApiErrorResponse;
}