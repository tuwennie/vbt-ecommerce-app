import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type Order = components["schemas"]["Order"];

function unwrapItem<T>(raw: unknown): T {
  const candidate = raw as { data?: T };
  return candidate?.data ?? (candidate as T);
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