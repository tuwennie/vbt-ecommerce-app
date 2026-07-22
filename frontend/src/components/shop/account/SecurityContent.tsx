"use client";

import { useRouter } from "next/navigation";
import { useQueryClient } from "@tanstack/react-query";
import { Lock, LogOut, Info } from "lucide-react";
import { clearAccessTokenCookie, clearUserDisplayName } from "@/lib/auth-token";
import { CART_QUERY_KEY } from "@/hooks/use-cart";

export function SecurityContent() {
  const router = useRouter();
  const queryClient = useQueryClient();

  function handleLogout() {
    clearAccessTokenCookie();
    clearUserDisplayName();
    queryClient.removeQueries({ queryKey: CART_QUERY_KEY });
    router.push("/login");
  }

  return (
    <div className="space-y-4">
      <div className="rounded-xl border border-border bg-surface p-5">
        <div className="flex items-center gap-2">
          <Lock className="h-4 w-4 text-text-muted" />
          <h3 className="text-sm font-semibold text-text-main">Şifre Değiştir</h3>
        </div>

        <div className="mt-3 flex items-start gap-2 rounded-lg bg-secondary/10 px-3 py-2 text-sm text-secondary">
          <Info className="mt-0.5 h-4 w-4 shrink-0" />
          <span>Şifre değiştirme özelliği yakında aktif olacak — backend tarafında bu işlem için henüz bir uç (endpoint) bulunmuyor.</span>
        </div>

        <fieldset disabled className="mt-4 space-y-3 opacity-50">
          <div>
            <label htmlFor="currentPassword" className="mb-1 block text-sm font-medium text-text-main">Mevcut Şifre</label>
            <input id="currentPassword" type="password" className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main" />
          </div>
          <div>
            <label htmlFor="newPassword" className="mb-1 block text-sm font-medium text-text-main">Yeni Şifre</label>
            <input id="newPassword" type="password" className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main" />
          </div>
          <button type="button" className="cursor-not-allowed rounded-lg bg-tertiary px-4 py-2 text-sm font-semibold text-white">
            Şifreyi Güncelle
          </button>
        </fieldset>
      </div>

      <div className="rounded-xl border border-border bg-surface p-5">
        <h3 className="text-sm font-semibold text-text-main">Oturum</h3>
        <p className="mt-1 text-sm text-text-muted">Bu cihazdaki oturumunu sonlandır.</p>
        <button type="button" onClick={handleLogout} data-testid="account-logout-button"
          className="mt-3 flex items-center gap-2 rounded-lg border border-error px-4 py-2 text-sm font-medium text-error hover:bg-error/5">
          <LogOut className="h-4 w-4" />
          Çıkış Yap
        </button>
      </div>
    </div>
  );
}