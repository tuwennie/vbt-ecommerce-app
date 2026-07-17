import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type AuthResponse = components["schemas"]["AuthResponse"];
export type User = components["schemas"]["User"];

export interface LoginPayload {
  email: string;
  password: string;
}

export interface RegisterPayload {
  email: string;
  password: string;
  fullName: string;
}

export async function login(payload: LoginPayload): Promise<AuthResponse> {
  const { data, error } = await apiClient.POST("/auth/login", {
    params: { header: { "X-Client-Type": "WEB" } },
    body: payload,
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  if (!data.data) {
    throw new Error("Beklenmeyen bir yanıt alındı.");
  }

  return data.data;
}

export async function register(payload: RegisterPayload): Promise<AuthResponse> {
  const { data, error } = await apiClient.POST("/auth/register", {
    params: { header: { "X-Client-Type": "WEB" } },
    body: payload,
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  if (!data.data) {
    throw new Error("Beklenmeyen bir yanıt alındı.");
  }

  return data.data;
}