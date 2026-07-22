import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type Order = components["schemas"]["Order"];
export type OrderStatus = "PENDING" | "PAID" | "SHIPPED" | "DELIVERED";

function unwrapItem<T>(raw: unknown): T {
  const candidate = raw as { data?: T };
  return candidate?.data ?? (candidate as T);
}

interface RawPaginated<T> {
  items: T[];
  pagination?: { page?: number; totalPages?: number };
}

function unwrapPaginated<T>(raw: unknown): { items: T[]; page: number; totalPages: number } {
  const candidate = raw as { data?: RawPaginated<T> } & Partial<RawPaginated<T>>;
  const paginated = candidate?.data ?? (candidate as RawPaginated<T>);

  return {
    items: paginated?.items ?? [],
    page: paginated?.pagination?.page ?? 1,
    totalPages: paginated?.pagination?.totalPages ?? 1,
  };
}

export interface CreateOrderPayload {
  addressId: string;
  paymentMethod: "CREDIT_CARD";
}

function generateIdempotencyKey(): string {
  if (typeof crypto !== "undefined" && "randomUUID" in crypto) {
    return crypto.randomUUID();
  }
  return `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

export async function createOrder(payload: CreateOrderPayload): Promise<Order> {
  const { data, error } = await apiClient.POST("/orders", {
    params: { header: { "Idempotency-Key": generateIdempotencyKey() } },
    body: payload,
  });
  if (error) throw error as ApiErrorResponse;
  return unwrapItem<Order>(data);
}

export async function getOrder(orderId: string): Promise<Order> {
  const { data, error } = await apiClient.GET("/orders/{orderId}", {
    params: { path: { orderId } },
  });
  if (error) throw error as ApiErrorResponse;
  return unwrapItem<Order>(data);
}

export interface ListOrdersParams {
  page?: number;
  size?: number;
}

export interface ListOrdersResult {
  items: Order[];
  page: number;
  totalPages: number;
}

export async function listOrders(params: ListOrdersParams = {}): Promise<ListOrdersResult> {
  const { data, error } = await apiClient.GET("/orders", {
    params: { query: { page: params.page ?? 1, size: params.size ?? 10 } },
  });
  if (error) throw error as ApiErrorResponse;
  return unwrapPaginated<Order>(data);
}