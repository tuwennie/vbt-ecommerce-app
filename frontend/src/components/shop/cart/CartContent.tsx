"use client";

import Link from "next/link";
import { Minus, Plus, Trash2, ShoppingBag } from "lucide-react";
import { useCart, useUpdateCartItem, useRemoveCartItem } from "@/hooks/use-cart";
import { getApiErrorMessage } from "@/lib/api-error";

function formatPrice(value: number | undefined) {
  if (value === undefined) return "—";
  return value.toLocaleString("tr-TR", {
    style: "currency",
    currency: "TRY",
    maximumFractionDigits: 2,
  });
}

function CartSkeleton() {
  return (
    <div className="animate-pulse space-y-4">
      {[1, 2, 3].map((i) => (
        <div key={i} className="flex gap-4 rounded-xl border border-border bg-surface p-4">
          <div className="h-20 w-20 shrink-0 rounded-lg bg-neutral" />
          <div className="flex-1 space-y-2">
            <div className="h-4 w-2/3 rounded bg-neutral" />
            <div className="h-3 w-1/3 rounded bg-neutral" />
          </div>
        </div>
      ))}
    </div>
  );
}

export function CartContent() {
  const { data: cart, isLoading, isError, error, refetch } = useCart();
  const updateItem = useUpdateCartItem();
  const removeItem = useRemoveCartItem();

  if (isLoading) {
    return <CartSkeleton />;
  }

  if (isError) {
    return (
      <div className="rounded-xl border border-border bg-surface p-6 text-center">
        <p className="text-sm font-semibold text-text-main">Sepet yüklenemedi</p>
        <p className="mt-1 text-sm text-text-muted">{getApiErrorMessage(error)}</p>
        <button
          type="button"
          onClick={() => refetch()}
          className="mt-4 rounded-lg bg-secondary px-4 py-2 text-sm font-semibold text-white hover:bg-secondary/90"
        >
          Tekrar Dene
        </button>
      </div>
    );
  }

  const items = cart?.items ?? [];

  if (items.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center rounded-xl border border-border bg-surface px-6 py-16 text-center">
        <ShoppingBag className="h-10 w-10 text-text-muted" />
        <p className="mt-4 text-sm font-semibold text-text-main">Sepetin boş</p>
        <p className="mt-1 text-sm text-text-muted">
          Alışverişe başlamak için ürünlere göz at.
        </p>
        <Link
          href="/"
          className="mt-4 rounded-lg bg-tertiary px-4 py-2 text-sm font-semibold text-white hover:bg-tertiary/90"
        >
          Alışverişe Başla
        </Link>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
      <div className="space-y-3 lg:col-span-2">
        {items.map((item) => (
          <div
            key={item.id}
            data-testid="cart-item"
            className="flex flex-col gap-3 rounded-xl border border-border bg-surface p-4 sm:flex-row sm:items-center"
          >
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-semibold text-text-main">
                {item.productName}
              </p>
              <p className="mt-1 text-sm text-text-muted">
                {formatPrice(item.unitPrice)} / adet
              </p>
            </div>

            <div className="flex items-center gap-2">
              <button
                type="button"
                aria-label="Azalt"
                disabled={updateItem.isPending || (item.quantity ?? 1) <= 1}
                onClick={() =>
                  item.id &&
                  updateItem.mutate({ itemId: item.id, quantity: (item.quantity ?? 1) - 1 })
                }
                className="flex h-8 w-8 items-center justify-center rounded-lg border border-border text-text-main hover:bg-neutral disabled:cursor-not-allowed disabled:opacity-40"
              >
                <Minus className="h-3.5 w-3.5" />
              </button>
              <span className="w-6 text-center text-sm font-medium text-text-main">
                {item.quantity}
              </span>
              <button
                type="button"
                aria-label="Artır"
                disabled={updateItem.isPending}
                onClick={() =>
                  item.id &&
                  updateItem.mutate({ itemId: item.id, quantity: (item.quantity ?? 1) + 1 })
                }
                className="flex h-8 w-8 items-center justify-center rounded-lg border border-border text-text-main hover:bg-neutral disabled:cursor-not-allowed disabled:opacity-40"
              >
                <Plus className="h-3.5 w-3.5" />
              </button>
            </div>

            <div className="flex items-center justify-between gap-4 sm:w-32 sm:justify-end">
              <span className="text-sm font-semibold text-text-main">
                {formatPrice(item.subtotal)}
              </span>
              <button
                type="button"
                aria-label="Üründen çıkar"
                disabled={removeItem.isPending}
                onClick={() => item.id && removeItem.mutate(item.id)}
                className="text-text-muted hover:text-error disabled:cursor-not-allowed disabled:opacity-40"
              >
                <Trash2 className="h-4 w-4" />
              </button>
            </div>
          </div>
        ))}
      </div>

      <div className="h-fit rounded-xl border border-border bg-surface p-5">
        <h2 className="text-base font-semibold text-text-main">Sipariş Özeti</h2>
        <div className="mt-4 flex items-center justify-between text-sm">
          <span className="text-text-muted">Toplam</span>
          <span className="text-lg font-semibold text-text-main">{formatPrice(cart?.total)}</span>
        </div>
        <button
          type="button"
          disabled
          title="Sipariş akışı henüz kurulmadı"
          className="mt-4 w-full cursor-not-allowed rounded-lg bg-tertiary py-2.5 text-sm font-semibold text-white opacity-60"
        >
          Ödemeye Geç
        </button>
      </div>
    </div>
  );
}