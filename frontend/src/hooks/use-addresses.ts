"use client";

import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  listAddresses,
  createAddress,
  updateAddress,
  deleteAddress,
  type Address,
  type AddressInput,
} from "@/lib/services/addresses";
import { getAccessTokenFromCookie } from "@/lib/auth-token";
import type { ApiErrorResponse } from "@/lib/api-error";

export const ADDRESSES_QUERY_KEY = ["addresses"];

export function useAddresses() {
  return useQuery<Address[], ApiErrorResponse>({
    queryKey: ADDRESSES_QUERY_KEY,
    queryFn: listAddresses,
    enabled: !!getAccessTokenFromCookie(),
    retry: false,
  });
}

export function useCreateAddress() {
  const queryClient = useQueryClient();
  return useMutation<Address, ApiErrorResponse, AddressInput>({
    mutationFn: createAddress,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ADDRESSES_QUERY_KEY }),
  });
}

export function useUpdateAddress() {
  const queryClient = useQueryClient();
  return useMutation<Address, ApiErrorResponse, { addressId: string; input: AddressInput }>({
    mutationFn: ({ addressId, input }) => updateAddress(addressId, input),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ADDRESSES_QUERY_KEY }),
  });
}

export function useDeleteAddress() {
  const queryClient = useQueryClient();
  return useMutation<void, ApiErrorResponse, string>({
    mutationFn: deleteAddress,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ADDRESSES_QUERY_KEY }),
  });
}