import createClient, { type Middleware } from "openapi-fetch";
import type { paths } from "@/types/api.generated";
import {
  getAccessTokenFromCookie,
  clearAccessTokenCookie,
  clearUserDisplayName,
  type AuthArea,
} from "@/lib/auth-token";

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8080/api/v1";

const AUTH_ENDPOINTS = ["/auth/login", "/auth/register", "/auth/refresh"];

function currentArea(): AuthArea {
  if (typeof window === "undefined") return "shop";
  return window.location.pathname.startsWith("/admin") ? "admin" : "shop";
}

const authMiddleware: Middleware = {
  onRequest({ request }) {
    request.headers.set("X-Client-Type", "WEB");

    const token = getAccessTokenFromCookie(currentArea());
    if (token) {
      request.headers.set("Authorization", `Bearer ${token}`);
    }

    return request;
  },

  onResponse({ request, response }) {
    const isAuthEndpoint = AUTH_ENDPOINTS.some((path) => request.url.includes(path));

    if (response.status === 401 && !isAuthEndpoint && typeof window !== "undefined") {
      const area = currentArea();
      clearAccessTokenCookie(area);
      clearUserDisplayName(area);

      const loginPath = area === "admin" ? "/admin" : "/login";

      if (window.location.pathname !== loginPath) {
        window.location.href = `${loginPath}?sessionExpired=true`;
      }
    }

    return response;
  },
};

export const apiClient = createClient<paths>({
  baseUrl: API_BASE_URL,
  credentials: "include",
});

apiClient.use(authMiddleware);