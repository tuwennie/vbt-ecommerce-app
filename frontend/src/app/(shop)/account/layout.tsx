"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { User, MapPin, Package, Shield } from "lucide-react";
import type { ReactNode } from "react";

const TABS = [
  { href: "/account", label: "Profil", icon: User },
  { href: "/account/addresses", label: "Adres Defterim", icon: MapPin },
  { href: "/account/orders", label: "Siparişlerim", icon: Package },
  { href: "/account/security", label: "Güvenlik", icon: Shield },
];

export default function AccountLayout({ children }: { children: ReactNode }) {
  const pathname = usePathname();

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-text-main">Hesabım</h1>

      <nav className="flex gap-1 overflow-x-auto border-b border-border" data-testid="account-tabs">
        {TABS.map((tab) => {
          const isActive = tab.href === "/account" ? pathname === "/account" : pathname.startsWith(tab.href);
          const Icon = tab.icon;
          return (
            <Link key={tab.href} href={tab.href}
              className={`flex items-center gap-1.5 whitespace-nowrap border-b-2 px-3 py-2.5 text-sm font-medium transition-colors ${
                isActive ? "border-secondary text-secondary" : "border-transparent text-text-muted hover:text-text-main"
              }`}>
              <Icon className="h-4 w-4" />
              {tab.label}
            </Link>
          );
        })}
      </nav>

      {children}
    </div>
  );
}