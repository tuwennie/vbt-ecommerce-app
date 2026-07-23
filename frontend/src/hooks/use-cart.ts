"use client";

import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getCart, addCartItem, updateCartItem, removeCartItem, type Cart } from "@/lib/services/cart";
import { getAccessTokenFromCookie } from "@/lib/auth-token";
import { getApiErrorMessage, type ApiErrorResponse } from "@/lib/api-error";
import { toast } from "@/lib/toast";

export const CART_QUERY_KEY = ["cart"];

export function useCart() {
  const [hasToken, setHasToken] = useState(false);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setHasToken(!!getAccessTokenFromCookie());
  }, []);

  return useQuery<Cart, ApiErrorResponse>({
    queryKey: CART_QUERY_KEY,
    queryFn: getCart,
    enabled: hasToken,
    retry: false,
  });
}

export function useAddCartItem() {
  const queryClient = useQueryClient();

  return useMutation<Cart, ApiErrorResponse, { productId: string; quantity: number }>({
    mutationFn: ({ productId, quantity }) => addCartItem(productId, quantity),
    onSuccess: (cart) => {
      queryClient.setQueryData(CART_QUERY_KEY, cart);
    },
    onError: (err) => {
      toast.error(getApiErrorMessage(err));
    },
  });
}

export function useUpdateCartItem() {
  const queryClient = useQueryClient();

  return useMutation<Cart, ApiErrorResponse, { itemId: string; quantity: number }>({
    mutationFn: ({ itemId, quantity }) => updateCartItem(itemId, quantity),
    onSuccess: (cart) => {
      queryClient.setQueryData(CART_QUERY_KEY, cart);
    },
    onError: (err) => {
      toast.error(getApiErrorMessage(err));
    },
  });
}

export function useRemoveCartItem() {
  const queryClient = useQueryClient();

  return useMutation<void, ApiErrorResponse, string>({
    mutationFn: (itemId) => removeCartItem(itemId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: CART_QUERY_KEY });
      toast.success("Ürün sepetten çıkarıldı.");
    },
    onError: (err) => {
      toast.error(getApiErrorMessage(err));
    },
  });
}