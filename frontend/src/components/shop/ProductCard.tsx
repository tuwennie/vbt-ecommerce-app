"use client";

import { useState } from "react";
import { Heart, ShoppingCart, ImageOff } from "lucide-react";
import type { FeaturedProduct } from "@/lib/services/featured-products";

function formatPrice(value: number | undefined, currency: string | undefined) {
  if (value === undefined) return "—";
  return value.toLocaleString("tr-TR", {
    style: "currency",
    currency: currency ?? "TRY",
    maximumFractionDigits: 0,
  });
}

export function ProductCard({ product }: { product: FeaturedProduct }) {
  const [isFavorite, setIsFavorite] = useState(false);
  const imageUrl = product.images?.[0]?.imageUrl;

  return (
    <div className="flex flex-col overflow-hidden rounded-xl border border-border bg-surface">
      <div className="relative aspect-square bg-neutral">
        {imageUrl ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={imageUrl} alt={product.name ?? ""} className="h-full w-full object-cover" />
        ) : (
          <div className="flex h-full w-full items-center justify-center text-text-muted">
            <ImageOff className="h-8 w-8" />
          </div>
        )}

        <button
          type="button"
          onClick={() => setIsFavorite((v) => !v)}
          aria-label={isFavorite ? "Favorilerden çıkar" : "Favorilere ekle"}
          aria-pressed={isFavorite}
          className="absolute right-3 top-3 flex h-8 w-8 items-center justify-center rounded-full bg-white/90 shadow-sm hover:bg-white"
        >
          <Heart className={`h-4 w-4 ${isFavorite ? "fill-error text-error" : "text-text-muted"}`} />
        </button>
      </div>

      <div className="flex flex-1 flex-col p-4">
        <p className="text-xs font-medium uppercase tracking-wide text-text-muted">
          {product.category?.name ?? "Genel"}
        </p>
        <p className="mt-1 line-clamp-2 text-sm font-semibold text-text-main">{product.name}</p>

        <div className="mt-2 flex items-baseline gap-2">
          <span className="text-base font-semibold text-text-main">
            {formatPrice(product.price, product.currency)}
          </span>
          {product.originalPrice && (
            <span className="text-sm text-text-muted line-through">
              {formatPrice(product.originalPrice, product.currency)}
            </span>
          )}
        </div>

        <button
          type="button"
          className="mt-3 flex items-center justify-center gap-2 rounded-lg bg-tertiary py-2 text-sm font-semibold text-white transition-colors hover:bg-tertiary/90"
        >
          <ShoppingCart className="h-4 w-4" />
          Sepete Ekle
        </button>
      </div>
    </div>
  );
}