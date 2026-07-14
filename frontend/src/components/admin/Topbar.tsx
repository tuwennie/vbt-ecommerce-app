"use client";

import { Menu, Search, Bell } from "lucide-react";

interface TopbarProps {
  onMenuClick: () => void;
}

export function Topbar({ onMenuClick }: TopbarProps) {
  return (
    <header className="flex items-center gap-3 border-b border-border bg-surface px-4 py-3 sm:px-6">
      <button
        type="button"
        onClick={onMenuClick}
        aria-label="Menüyü aç"
        className="text-text-muted hover:text-text-main md:hidden"
      >
        <Menu className="h-5 w-5" />
      </button>

      <div className="relative flex-1">
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
        <input
          type="search"
          placeholder="Siparişleri, ürünleri veya müşterileri arayın..."
          className="w-full rounded-lg border border-border bg-neutral py-2 pl-9 pr-3 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary"
        />
      </div>

      <button
        type="button"
        aria-label="Bildirimler"
        className="relative text-text-muted hover:text-text-main"
      >
        <Bell className="h-5 w-5" />
        <span className="absolute -right-0.5 -top-0.5 h-2 w-2 rounded-full bg-error" />
      </button>
    </header>
  );
}