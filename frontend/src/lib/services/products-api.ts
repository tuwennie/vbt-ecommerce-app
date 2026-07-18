import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type Product = components["schemas"]["Product"];
export type Pagination = components["schemas"]["Pagination"];

export type SortOption = "name" | "-name" | "price" | "-price" | "createdAt" | "-createdAt";

export const SORT_OPTIONS: { value: SortOption; label: string }[] = [
  { value: "-createdAt", label: "En Yeni" },
  { value: "price", label: "Fiyat: Düşükten Yükseğe" },
  { value: "-price", label: "Fiyat: Yüksekten Düşüğe" },
  { value: "name", label: "İsim: A-Z" },
];

interface RawPaginatedProducts {
  items: Product[];
  pagination: Pagination;
}

function unwrapPaginatedProducts(raw: unknown): RawPaginatedProducts {
  const candidate = raw as { data?: RawPaginatedProducts; items?: Product[] };
  const paginated = candidate?.data ?? (candidate as RawPaginatedProducts);

  return {
    items: paginated?.items ?? [],
    pagination: paginated?.pagination ?? {},
  };
}

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
    params: {
      query: {
        size: 4,
        sort: "-createdAt",
      },
    },
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  return unwrapPaginatedProducts(data).items;
}

export interface ListProductsParams {
  page?: number;
  size?: number;
  search?: string | null;
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

  const { items, pagination } = unwrapPaginatedProducts(data);

  return {
    items,
    page: pagination?.page ?? params.page ?? 1,
    totalPages: pagination?.totalPages ?? 1,
  };
}