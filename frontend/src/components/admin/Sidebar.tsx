"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { X, LogOut } from "lucide-react";
import { NAV_ITEMS } from "./nav-items";

interface SidebarProps {
  open: boolean;
  onClose: () => void;
}

function clearAccessTokenCookie() {
  document.cookie = "access_token=; path=/; max-age=0";
}

export function Sidebar({ open, onClose }: SidebarProps) {
  const pathname = usePathname();
  const router = useRouter();

  function handleLogout() {
    clearAccessTokenCookie();
    onClose();
    router.push("/admin");
  }

  return (
    <>
      {open && (
        <div className="fixed inset-0 z-40 bg-primary/40 md:hidden" onClick={onClose} aria-hidden="true" />
      )}

      <aside
        className={`fixed inset-y-0 left-0 z-50 flex w-72 -translate-x-full flex-col border-r border-border bg-surface transition-transform duration-200 md:static md:z-auto md:w-64 md:translate-x-0 ${
          open ? "translate-x-0" : ""
        }`}
      >
        <div className="flex items-center justify-between px-6 py-6">
          <Link href="/admin/dashboard" onClick={onClose}>
            <p className="text-lg font-bold leading-tight text-secondary">ShopSwift Admin</p>
            <p className="text-xs text-text-muted">Kurumsal Yönetim</p>
          </Link>
          <button
            type="button"
            onClick={onClose}
            aria-label="Menüyü kapat"
            className="text-text-muted hover:text-text-main md:hidden"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <nav className="flex-1 space-y-1 px-3">
          {NAV_ITEMS.map((item) => {
            const isActive = pathname.startsWith(item.href);
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
                onClick={onClose}
                className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
                  isActive ? "bg-secondary text-white" : "text-text-main hover:bg-neutral"
                }`}
              >
                <Icon className="h-4 w-4 shrink-0" />
                {item.label}
              </Link>
            );
          })}
        </nav>

        <div className="border-t border-border">
          <div className="flex items-center gap-3 px-6 py-4">
            <span className="flex h-9 w-9 items-center justify-center rounded-full bg-secondary text-sm font-semibold text-white">
              AD
            </span>
            <div>
              <p className="text-sm font-medium text-text-main">Admin User</p>
              <p className="text-xs text-text-muted">SUPER ADMIN</p>
            </div>
          </div>
          <button
            type="button"
            onClick={handleLogout}
            className="flex w-full items-center gap-3 px-6 py-3 text-sm font-medium text-error hover:bg-error/5"
          >
            <LogOut className="h-4 w-4" />
            Çıkış Yap
          </button>
        </div>
      </aside>
    </>
  );
}