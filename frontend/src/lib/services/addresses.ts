import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type Address = components["schemas"]["Address"];
export type AddressInput = components["schemas"]["AddressInput"];

function unwrapList<T>(raw: unknown): T[] {
  const candidate = raw as { data?: T[] } | T[];
  if (Array.isArray(candidate)) return candidate;
  return (candidate as { data?: T[] })?.data ?? [];
}

function unwrapItem<T>(raw: unknown): T {
  const candidate = raw as { data?: T };
  return candidate?.data ?? (candidate as T);
}

export async function listAddresses(): Promise<Address[]> {
  const { data, error } = await apiClient.GET("/addresses", {});
  if (error) throw error as ApiErrorResponse;
  return unwrapList<Address>(data);
}

export async function createAddress(input: AddressInput): Promise<Address> {
  const { data, error } = await apiClient.POST("/addresses", { body: input });
  if (error) throw error as ApiErrorResponse;
  return unwrapItem<Address>(data);
}

export async function updateAddress(addressId: string, input: AddressInput): Promise<Address> {
  const { data, error } = await apiClient.PUT("/addresses/{addressId}", {
    params: { path: { addressId } },
    body: input,
  });
  if (error) throw error as ApiErrorResponse;
  return unwrapItem<Address>(data);
}

export async function deleteAddress(addressId: string): Promise<void> {
  const { error } = await apiClient.DELETE("/addresses/{addressId}", {
    params: { path: { addressId } },
  });
  if (error) throw error as ApiErrorResponse;
}