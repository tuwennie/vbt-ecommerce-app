"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Heart, ShoppingCart, ImageOff, Check } from "lucide-react";
import type { FeaturedProduct } from "@/lib/services/products-api";
import { useAddCartItem } from "@/hooks/use-cart";
import { getAccessTokenFromCookie } from "@/lib/auth-token";
import { getApiErrorMessage } from "@/lib/api-error";

function formatPrice(value: number | string | undefined, currency: string | undefined) {
  if (value === undefined || value === null) return "—";
  const numeric = typeof value === "string" ? Number(value) : value;
  if (Number.isNaN(numeric)) return "—";

  return numeric.toLocaleString("tr-TR", {
    style: "currency",
    currency: currency ?? "TRY",
    maximumFractionDigits: 0,
  });
}

function isPlaceholderImage(url: string) {
  return /placeholder|dummyimage|via\.placeholder/i.test(url);
}

export function ProductCard({ product }: { product: FeaturedProduct }) {
  const router = useRouter();
  const [isFavorite, setIsFavorite] = useState(false);
  const [justAdded, setJustAdded] = useState(false);
  const addCartItem = useAddCartItem();

  const rawImageUrl = product.images?.[0]?.imageUrl;
  const imageUrl = rawImageUrl && !isPlaceholderImage(rawImageUrl) ? rawImageUrl : null;

  function handleAddToCart() {
    if (!getAccessTokenFromCookie()) {
      router.push(`/login?redirectTo=${encodeURIComponent(window.location.pathname)}`);
      return;
    }
    if (!product.id) return;

    addCartItem.mutate(
      { productId: product.id, quantity: 1 },
      {
        onSuccess: () => {
          setJustAdded(true);
          setTimeout(() => setJustAdded(false), 1500);
        },
      },
    );
  }

  return (
    <div className="flex flex-col overflow-hidden rounded-xl border border-border bg-surface">
      <div className="relative aspect-square bg-neutral">
        {imageUrl ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={imageUrl}
            alt={product.name ?? ""}
            className="h-full w-full object-cover"
          />
        ) : (
          <div className="flex h-full w-full flex-col items-center justify-center gap-2 text-text-muted">
            <ImageOff className="h-8 w-8" />
            <span className="text-xs">Görsel yakında</span>
          </div>
        )}

        <button
          type="button"
          onClick={() => setIsFavorite((v) => !v)}
          aria-label={isFavorite ? "Favorilerden çıkar" : "Favorilere ekle"}
          aria-pressed={isFavorite}
          className="absolute right-3 top-3 flex h-8 w-8 items-center justify-center rounded-full bg-white/90 shadow-sm hover:bg-white"
        >
          <Heart
            className={`h-4 w-4 ${isFavorite ? "fill-error text-error" : "text-text-muted"}`}
          />
        </button>
      </div>

      <div className="flex flex-1 flex-col p-4">
        <p className="text-xs font-medium uppercase tracking-wide text-text-muted">
          {product.category?.name ?? "Genel"}
        </p>
        <p className="mt-1 line-clamp-2 text-sm font-semibold text-text-main">
          {product.name}
        </p>

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
          onClick={handleAddToCart}
          disabled={addCartItem.isPending}
          data-testid="add-to-cart-button"
          className={`mt-3 flex items-center justify-center gap-2 rounded-lg py-2 text-sm font-semibold text-white transition-colors disabled:cursor-not-allowed disabled:opacity-70 ${
            justAdded ? "bg-secondary" : "bg-tertiary hover:bg-tertiary/90"
          }`}
        >
          {justAdded ? (
            <>
              <Check className="h-4 w-4" />
              Sepete Eklendi
            </>
          ) : (
            <>
              <ShoppingCart className="h-4 w-4" />
              {addCartItem.isPending ? "Ekleniyor..." : "Sepete Ekle"}
            </>
          )}
        </button>

        {addCartItem.isError && (
          <p className="mt-1.5 text-xs text-error">{getApiErrorMessage(addCartItem.error)}</p>
        )}
      </div>
    </div>
  );
}