import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type User = components["schemas"]["User"];

export interface UpdateUserPayload {
  fullName?: string;
  phone?: string;
}

function unwrapUser(raw: unknown): User {
  const candidate = raw as { data?: User; id?: string };
  return candidate?.data ?? (candidate as User);
}

export async function getCurrentUser(): Promise<User> {
  const { data, error } = await apiClient.GET("/users/me", {});

  if (error) {
    throw error as ApiErrorResponse;
  }

  return unwrapUser(data);
}

export async function updateCurrentUser(payload: UpdateUserPayload): Promise<User> {
  const { data, error } = await apiClient.PATCH("/users/me", {
    body: payload,
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  return unwrapUser(data);
}