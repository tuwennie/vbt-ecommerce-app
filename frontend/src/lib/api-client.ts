import createClient, { type Middleware } from "openapi-fetch";
import type { paths } from "@/types/api.generated";

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8080/api/v1";

function getAccessTokenFromCookie(): string | null {
  if (typeof document === "undefined") return null;
  const match = document.cookie.match(/(?:^|; )access_token=([^;]*)/);
  return match ? decodeURIComponent(match[1]) : null;
}

const authMiddleware: Middleware = {
  onRequest({ request }) {
    request.headers.set("X-Client-Type", "WEB");
    const token = getAccessTokenFromCookie();
    if (token) {
      request.headers.set("Authorization", `Bearer ${token}`);
    }
    return request;
  },
};

export const apiClient = createClient<paths>({
  baseUrl: API_BASE_URL,
  credentials: "include",
});

apiClient.use(authMiddleware);