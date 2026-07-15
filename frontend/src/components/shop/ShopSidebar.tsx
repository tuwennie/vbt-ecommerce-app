"use client";

import Link from "next/link";
import { usePathname, useSearchParams } from "next/navigation";
import { X, Home, Laptop2, Shirt, Armchair, Sparkles, Dumbbell, BookOpen } from "lucide-react";

interface ShopSidebarProps {
  open: boolean;
  onClose: () => void;
}

const CATEGORIES = [
  { label: "Elektronik", slug: "elektronik", icon: Laptop2 },
  { label: "Moda", slug: "moda", icon: Shirt },
  { label: "Ev & Ofis", slug: "ev-ofis", icon: Armchair },
  { label: "Güzellik", slug: "guzellik", icon: Sparkles },
  { label: "Spor", slug: "spor", icon: Dumbbell },
  { label: "Kitap", slug: "kitap", icon: BookOpen },
];

export function ShopSidebar({ open, onClose }: ShopSidebarProps) {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const activeCategory = pathname === "/search" ? searchParams.get("category") : null;

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
        <div className="flex items-center justify-between px-6 py-6 md:hidden">
          <Link href="/" onClick={onClose} className="text-lg font-bold text-secondary">ShopSwift</Link>
          <button type="button" onClick={onClose} aria-label="Menüyü kapat" className="text-text-muted hover:text-text-main">
            <X className="h-5 w-5" />
          </button>
        </div>

        <nav className="flex-1 space-y-1 px-3 pt-3 md:pt-6">
          <Link
            href="/"
            onClick={onClose}
            className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
              pathname === "/" ? "bg-secondary/10 text-secondary" : "text-text-main hover:bg-neutral"
            }`}
          >
            <Home className="h-4 w-4 shrink-0" />
            Ana Sayfa
          </Link>

          <p className="px-3 pb-1 pt-4 text-xs font-medium uppercase tracking-wide text-text-muted">Categories</p>

          {CATEGORIES.map((category) => {
            const href = `/search?category=${category.slug}`;
            const Icon = category.icon;
            const isActive = activeCategory === category.slug;
            return (
              <Link
                key={category.slug}
                href={href}
                onClick={onClose}
                className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
                  isActive ? "bg-secondary/10 text-secondary" : "text-text-main hover:bg-neutral"
                }`}
              >
                <Icon className="h-4 w-4 shrink-0" />
                {category.label}
              </Link>
            );
          })}
        </nav>

        <div className="flex items-center gap-3 border-t border-border px-6 py-4">
          <span className="flex h-9 w-9 items-center justify-center rounded-full bg-secondary text-sm font-semibold text-white">JD</span>
          <div>
            <p className="text-sm font-medium text-text-main">John Doe</p>
            <p className="text-xs text-text-muted">Premium Member</p>
          </div>
        </div>
      </aside>
    </>
  );
}