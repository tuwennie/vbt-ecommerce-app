"use client";

import { useQuery, useMutation } from "@tanstack/react-query";
import { createOrder, getOrder, type CreateOrderPayload, type Order } from "@/lib/services/orders";
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