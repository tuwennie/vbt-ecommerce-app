const COOKIE_NAME = "access_token";

export function setAccessTokenCookie(token: string, maxAgeSeconds: number) {
  document.cookie = `${COOKIE_NAME}=${token}; path=/; max-age=${maxAgeSeconds}; SameSite=Lax`;
}

export function clearAccessTokenCookie() {
  document.cookie = `${COOKIE_NAME}=; path=/; max-age=0`;
}

export function getAccessTokenFromCookie(): string | null {
  if (typeof document === "undefined") return null;
  const match = document.cookie.match(/(?:^|; )access_token=([^;]*)/);
  return match ? decodeURIComponent(match[1]) : null;
}