import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

const AUTH_COOKIE = "access_token";

const PROTECTED_AREAS = [
  { prefix: "/admin", loginPath: "/admin" },
  { prefix: "/account", loginPath: "/login" },
] as const;

export function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;

  const area = PROTECTED_AREAS.find((a) => pathname.startsWith(a.prefix));
  if (!area) {
    return NextResponse.next();
  }

  if (pathname === area.loginPath) {
    return NextResponse.next();
  }

  const token = request.cookies.get(AUTH_COOKIE)?.value;

  if (!token) {
    const loginUrl = new URL(area.loginPath, request.url);
    loginUrl.searchParams.set("redirectTo", pathname);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/admin/:path*", "/account/:path*"],
};