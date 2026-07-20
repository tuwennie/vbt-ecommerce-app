export type AuthArea = "admin" | "shop";

function tokenCookieName(area: AuthArea) {
  return area === "admin" ? "admin_access_token" : "access_token";
}

function nameCookieName(area: AuthArea) {
  return area === "admin" ? "admin_user_name" : "user_name";
}

export function setAccessTokenCookie(
  token: string,
  maxAgeSeconds: number,
  area: AuthArea = "shop",
) {
  document.cookie = `${tokenCookieName(area)}=${token}; path=/; max-age=${maxAgeSeconds}; SameSite=Lax`;
}

export function clearAccessTokenCookie(area: AuthArea = "shop") {
  document.cookie = `${tokenCookieName(area)}=; path=/; max-age=0`;
}

export function getAccessTokenFromCookie(area: AuthArea = "shop"): string | null {
  if (typeof document === "undefined") return null;
  const name = tokenCookieName(area);
  const match = document.cookie.match(new RegExp(`(?:^|; )${name}=([^;]*)`));
  return match ? decodeURIComponent(match[1]) : null;
}

export function setUserDisplayName(name: string, area: AuthArea = "shop") {
  document.cookie = `${nameCookieName(area)}=${encodeURIComponent(name)}; path=/; max-age=${60 * 60 * 24 * 7}; SameSite=Lax`;
}

export function clearUserDisplayName(area: AuthArea = "shop") {
  document.cookie = `${nameCookieName(area)}=; path=/; max-age=0`;
}

export function getUserDisplayName(area: AuthArea = "shop"): string | null {
  if (typeof document === "undefined") return null;
  const name = nameCookieName(area);
  const match = document.cookie.match(new RegExp(`(?:^|; )${name}=([^;]*)`));
  return match ? decodeURIComponent(match[1]) : null;
}

export function persistAuthSession(
  auth: {
    accessToken?: string;
    expiresIn?: number;
    user?: { fullName?: string };
  },
  area: AuthArea = "shop",
) {
  if (!auth.accessToken) {
    throw new Error("Giriş başarılı ama token alınamadı.");
  }

  const maxAge = auth.expiresIn && auth.expiresIn > 0 ? auth.expiresIn : 900;
  setAccessTokenCookie(auth.accessToken, maxAge, area);

  if (auth.user?.fullName) {
    setUserDisplayName(auth.user.fullName, area);
  }
}