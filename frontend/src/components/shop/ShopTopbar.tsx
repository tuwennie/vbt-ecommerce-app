"use client";

import { useState, type FormEvent } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Menu, Search, Bell } from "lucide-react";

interface ShopTopbarProps {
  onMenuClick: () => void;
}

export function ShopTopbar({ onMenuClick }: ShopTopbarProps) {
  const router = useRouter();
  const [query, setQuery] = useState("");

  function handleSearchSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const trimmed = query.trim();
    if (!trimmed) return;
    router.push(`/search?search=${encodeURIComponent(trimmed)}`);
  }

  return (
    <header className="flex items-center gap-3 border-b border-border bg-surface px-4 py-3 sm:px-6">
      <button type="button" onClick={onMenuClick} aria-label="Menüyü aç" className="text-text-muted hover:text-text-main md:hidden">
        <Menu className="h-5 w-5" />
      </button>

      <Link href="/" className="hidden shrink-0 text-lg font-bold text-secondary md:block">ShopSwift</Link>

      <form onSubmit={handleSearchSubmit} className="relative flex-1" role="search">
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
        <input
          type="search"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Ürün ara..."
          aria-label="Ürün ara"
          className="w-full rounded-lg border border-border bg-neutral py-2 pl-9 pr-3 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary"
        />
      </form>

      <button type="button" aria-label="Bildirimler" className="relative text-text-muted hover:text-text-main">
        <Bell className="h-5 w-5" />
        <span className="absolute -right-0.5 -top-0.5 h-2 w-2 rounded-full bg-error" />
      </button>
    </header>
  );
}