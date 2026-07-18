const COOKIE_NAME = "access_token";
const NAME_COOKIE = "user_name";

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
export function setUserDisplayName(name: string) {
  document.cookie = `${NAME_COOKIE}=${encodeURIComponent(name)}; path=/; max-age=${60 * 60 * 24 * 7}; SameSite=Lax`;
}

export function clearUserDisplayName() {
  document.cookie = `${NAME_COOKIE}=; path=/; max-age=0`;
}

export function getUserDisplayName(): string | null {
  if (typeof document === "undefined") return null;
  const match = document.cookie.match(/(?:^|; )user_name=([^;]*)/);
  return match ? decodeURIComponent(match[1]) : null;
}

export function persistAuthSession(auth: {
  accessToken?: string;
  expiresIn?: number;
  user?: { fullName?: string };
}) {
  if (!auth.accessToken) {
    throw new Error("Giriş başarılı ama token alınamadı.");
  }

  const maxAge = auth.expiresIn && auth.expiresIn > 0 ? auth.expiresIn : 900;
  setAccessTokenCookie(auth.accessToken, maxAge);

  if (auth.user?.fullName) {
    setUserDisplayName(auth.user.fullName);
  }
}