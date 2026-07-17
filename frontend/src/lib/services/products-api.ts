import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type Product = components["schemas"]["Product"];

export type SortOption = "name" | "-name" | "price" | "-price" | "createdAt" | "-createdAt";

export const SORT_OPTIONS: { value: SortOption; label: string }[] = [
  { value: "-createdAt", label: "En Yeni" },
  { value: "price", label: "Fiyat: Düşükten Yükseğe" },
  { value: "-price", label: "Fiyat: Yüksekten Düşüğe" },
  { value: "name", label: "İsim: A-Z" },
];

export interface FeaturedProduct extends Product {
  originalPrice?: number;
}

interface ListFeaturedProductsOptions {
  simulateError?: boolean;
}

export async function listFeaturedProducts(
  options?: ListFeaturedProductsOptions,
): Promise<FeaturedProduct[]> {
  if (options?.simulateError) {
    const error: ApiErrorResponse = {
      success: false,
      message: "Ürünler şu anda yüklenemedi. Lütfen tekrar deneyin.",
      statusCode: 500,
      status: "INTERNAL_SERVER_ERROR",
    };
    throw error;
  }

  const { data, error } = await apiClient.GET("/products", {
    params: { query: { size: 4, sort: "-createdAt" } },
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  return data.data?.items ?? [];
}

export interface ListProductsParams {
  page?: number;
  size?: number;
  search?: string | null;
  // NOT: Bu alan backend'in beklediği gerçek kategori ID'sidir (slug değil).
  // Sidebar şu an gerçek kategorilere bağlı olmadığı için, buraya elle
  // uydurulmuş bir slug geçilirse backend hiçbir şeyle eşleşmez ve boş
  // sonuç döner - bu bir hata değil, beklenen bir ara durumdur.
  categoryId?: string | null;
  sort?: SortOption;
  simulateError?: boolean;
}

export interface ListProductsResult {
  items: Product[];
  page: number;
  totalPages: number;
}

export async function listProducts(
  params: ListProductsParams = {},
): Promise<ListProductsResult> {
  if (params.simulateError) {
    const error: ApiErrorResponse = {
      success: false,
      message: "Ürünler şu anda yüklenemedi. Lütfen tekrar deneyin.",
      statusCode: 500,
      status: "INTERNAL_SERVER_ERROR",
    };
    throw error;
  }

  const { data, error } = await apiClient.GET("/products", {
    params: {
      query: {
        page: params.page ?? 1,
        size: params.size ?? 20,
        search: params.search || undefined,
        categoryId: params.categoryId || undefined,
        sort: params.sort,
      },
    },
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  const paginated = data.data;

  return {
    items: paginated?.items ?? [],
    page: paginated?.pagination?.page ?? params.page ?? 1,
    totalPages: paginated?.pagination?.totalPages ?? 1,
  };
}