import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

const PROTECTED_AREAS = [
  { prefix: "/admin", loginPath: "/admin", cookieName: "admin_access_token" },
  { prefix: "/account", loginPath: "/login", cookieName: "access_token" },
  { prefix: "/cart", loginPath: "/login", cookieName: "access_token" },
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

  const token = request.cookies.get(area.cookieName)?.value;

  if (!token) {
    const loginUrl = new URL(area.loginPath, request.url);
    loginUrl.searchParams.set("redirectTo", pathname);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/admin/:path*", "/account/:path*", "/cart/:path*"],
};