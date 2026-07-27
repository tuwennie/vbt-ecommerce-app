"use client";

import Link from "next/link";
import { Heart, Trash2 } from "lucide-react";
import { useFavorites, useRemoveFavorite } from "@/hooks/use-favorites";
import { getApiErrorMessage } from "@/lib/api-error";

function formatPrice(value: number | string | undefined) {
  if (value === undefined || value === null) return "—";
  const numeric = typeof value === "string" ? Number(value) : value;
  if (Number.isNaN(numeric)) return "—";
  return numeric.toLocaleString("tr-TR", { style: "currency", currency: "TRY", maximumFractionDigits: 0 });
}

function FavoritesSkeleton() {
  return (
    <div className="grid animate-pulse grid-cols-1 gap-4 sm:grid-cols-2">
      {[1, 2].map((i) => (
        <div key={i} className="h-24 rounded-xl border border-border bg-surface" />
      ))}
    </div>
  );
}

export function FavoritesContent() {
  const { data: favorites, isLoading, isError, error, refetch } = useFavorites();
  const removeFavorite = useRemoveFavorite();

  if (isLoading) return <FavoritesSkeleton />;

  if (isError) {
    return (
      <div className="rounded-xl border border-border bg-surface p-6 text-center">
        <p className="text-sm font-semibold text-text-main">Favoriler yüklenemedi</p>
        <p className="mt-1 text-sm text-text-muted">{getApiErrorMessage(error)}</p>
        <button type="button" onClick={() => refetch()} className="mt-4 rounded-lg bg-secondary px-4 py-2 text-sm font-semibold text-white hover:bg-secondary/90">
          Tekrar Dene
        </button>
      </div>
    );
  }

  const list = favorites ?? [];

  if (list.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center rounded-xl border border-border bg-surface px-6 py-12 text-center">
        <Heart className="h-8 w-8 text-text-muted" />
        <p className="mt-3 text-sm font-semibold text-text-main">Henüz favorin yok</p>
        <p className="mt-1 text-sm text-text-muted">Beğendiğin ürünlerin yanındaki kalbe tıklayarak buraya ekleyebilirsin.</p>
        <Link href="/" className="mt-4 rounded-lg bg-tertiary px-4 py-2 text-sm font-semibold text-white hover:bg-tertiary/90">
          Alışverişe Başla
        </Link>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2" data-testid="favorites-list">
      {list.map((favorite) => (
        <div key={favorite.id} data-testid="favorite-card" className="flex items-center gap-3 rounded-xl border border-border bg-surface p-4">
          <div className="min-w-0 flex-1">
            <p className="truncate text-sm font-semibold text-text-main">{favorite.product?.name ?? "Ürün"}</p>
            <p className="mt-1 text-sm text-text-muted">{formatPrice(favorite.product?.price)}</p>
          </div>
          <button type="button" aria-label="Favorilerden çıkar" disabled={removeFavorite.isPending}
            onClick={() => favorite.product?.id && removeFavorite.mutate(favorite.product.id)}
            className="shrink-0 text-text-muted hover:text-error disabled:opacity-40">
            <Trash2 className="h-4 w-4" />
          </button>
        </div>
      ))}
    </div>
  );
}