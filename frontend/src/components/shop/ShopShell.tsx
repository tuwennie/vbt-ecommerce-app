"use client";

import { useState, Suspense, type ReactNode } from "react";
import { ShopSidebar } from "./ShopSidebar";
import { ShopTopbar } from "./ShopTopbar";

export function ShopShell({ children }: { children: ReactNode }) {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <div className="flex min-h-screen bg-neutral">
      <Suspense fallback={null}>
        <ShopSidebar open={sidebarOpen} onClose={() => setSidebarOpen(false)} />
      </Suspense>

      <div className="flex min-w-0 flex-1 flex-col">
        <ShopTopbar onMenuClick={() => setSidebarOpen(true)} />
        <main className="flex-1 px-4 py-6 sm:px-6 lg:px-8">{children}</main>
      </div>
    </div>
  );
}