"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname, useSearchParams, useRouter } from "next/navigation";
import { X, Home, LogOut, LogIn, User as UserIcon } from "lucide-react";
import { SHOP_CATEGORIES } from "@/lib/shop-categories";
import {
  clearAccessTokenCookie,
  clearUserDisplayName,
  getAccessTokenFromCookie,
  getUserDisplayName,
} from "@/lib/auth-token";
import { useCurrentUser } from "@/hooks/use-current-user";

interface ShopSidebarProps {
  open: boolean;
  onClose: () => void;
}

function initialsOf(name: string) {
  return name
    .split(" ")
    .map((part) => part[0])
    .filter(Boolean)
    .slice(0, 2)
    .join("")
    .toUpperCase();
}

export function ShopSidebar({ open, onClose }: ShopSidebarProps) {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const router = useRouter();
  const activeCategory = pathname === "/search" ? searchParams.get("category") : null;

  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [cachedName, setCachedName] = useState<string | null>(null);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setIsLoggedIn(!!getAccessTokenFromCookie());
    setCachedName(getUserDisplayName());
  }, [pathname]);

  const { data: user } = useCurrentUser();
  const displayName = user?.fullName ?? cachedName ?? "Kullanıcı";

  function handleLogout() {
    clearAccessTokenCookie();
    clearUserDisplayName();
    setIsLoggedIn(false);
    setCachedName(null);
    onClose();
    router.push("/login");
  }

  return (
    <>
      {open && (
        <div
          className="fixed inset-0 z-40 bg-primary/40 md:hidden"
          onClick={onClose}
          aria-hidden="true"
        />
      )}

      <aside
        className={`fixed inset-y-0 left-0 z-50 flex w-72 -translate-x-full flex-col border-r border-border bg-surface transition-transform duration-200 md:w-64 md:translate-x-0 ${
          open ? "translate-x-0" : ""
        }`}
      >
        <div className="flex items-center justify-between px-6 py-6 md:hidden">
          <Link href="/" onClick={onClose} className="text-lg font-bold text-secondary">
            ShopSwift
          </Link>
          <button
            type="button"
            onClick={onClose}
            aria-label="Menüyü kapat"
            className="text-text-muted hover:text-text-main"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <nav className="flex-1 space-y-1 overflow-y-auto px-3 pt-3 md:pt-6">
          <Link
            href="/"
            onClick={onClose}
            className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
              pathname === "/"
                ? "bg-secondary/10 text-secondary"
                : "text-text-main hover:bg-neutral"
            }`}
          >
            <Home className="h-4 w-4 shrink-0" />
            Ana Sayfa
          </Link>

          {isLoggedIn && (
            <Link
              href="/account"
              onClick={onClose}
              className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
                pathname === "/account"
                  ? "bg-secondary/10 text-secondary"
                  : "text-text-main hover:bg-neutral"
              }`}
            >
              <UserIcon className="h-4 w-4 shrink-0" />
              Profilim
            </Link>
          )}

          <p className="px-3 pb-1 pt-4 text-xs font-medium uppercase tracking-wide text-text-muted">
            Categories
          </p>

          {SHOP_CATEGORIES.map((category) => {
            const href = `/search?category=${category.slug}`;
            const Icon = category.icon;
            const isActive = activeCategory === category.slug;
            return (
              <Link
                key={category.slug}
                href={href}
                onClick={onClose}
                className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
                  isActive
                    ? "bg-secondary/10 text-secondary"
                    : "text-text-main hover:bg-neutral"
                }`}
              >
                <Icon className="h-4 w-4 shrink-0" />
                {category.label}
              </Link>
            );
          })}
        </nav>

        <div className="shrink-0 border-t border-border">
          {isLoggedIn ? (
            <>
              <Link
                href="/account"
                onClick={onClose}
                className="flex items-center gap-3 px-6 py-4 hover:bg-neutral"
              >
                <span className="flex h-9 w-9 items-center justify-center rounded-full bg-secondary text-sm font-semibold text-white">
                  {initialsOf(displayName)}
                </span>
                <div className="min-w-0">
                  <p className="truncate text-sm font-medium text-text-main">
                    {displayName}
                  </p>
                </div>
              </Link>
              <button
                type="button"
                onClick={handleLogout}
                className="flex w-full items-center gap-3 px-6 py-3 text-sm font-medium text-error hover:bg-error/5"
              >
                <LogOut className="h-4 w-4" />
                Çıkış Yap
              </button>
            </>
          ) : (
            <Link
              href="/login"
              onClick={onClose}
              className="flex w-full items-center gap-3 px-6 py-4 text-sm font-medium text-secondary hover:bg-neutral"
            >
              <LogIn className="h-4 w-4" />
              Giriş Yap
            </Link>
          )}
        </div>
      </aside>
    </>
  );
}