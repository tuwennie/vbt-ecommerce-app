"use client";

import { useQuery, useMutation } from "@tanstack/react-query";
import {
  createOrder,
  getOrder,
  listOrders,
  type CreateOrderPayload,
  type Order,
  type ListOrdersParams,
  type ListOrdersResult,
} from "@/lib/services/orders";
import { getAccessTokenFromCookie } from "@/lib/auth-token";
import type { ApiErrorResponse } from "@/lib/api-error";

export function useCreateOrder() {
  return useMutation<Order, ApiErrorResponse, CreateOrderPayload>({
    mutationFn: createOrder,
  });
}

export function useOrder(orderId: string | null) {
  return useQuery<Order, ApiErrorResponse>({
    queryKey: ["order", orderId],
    queryFn: () => getOrder(orderId as string),
    enabled: !!orderId,
    retry: false,
  });
}

export function useOrders(params: ListOrdersParams = {}) {
  return useQuery<ListOrdersResult, ApiErrorResponse>({
    queryKey: ["orders", params],
    queryFn: () => listOrders(params),
    enabled: !!getAccessTokenFromCookie(),
    retry: false,
  });
}