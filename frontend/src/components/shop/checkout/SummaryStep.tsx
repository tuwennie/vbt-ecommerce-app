"use client";

import type { Cart } from "@/lib/services/cart";
import type { Address } from "@/lib/services/addresses";

function formatPrice(value: number | undefined) {
  if (value === undefined) return "—";
  return value.toLocaleString("tr-TR", { style: "currency", currency: "TRY", maximumFractionDigits: 2 });
}

interface SummaryStepProps {
  cart: Cart;
  address: Address;
  isSubmitting: boolean;
  errorMessage: string | null;
  onConfirm: () => void;
}

export function SummaryStep({ cart, address, isSubmitting, errorMessage, onConfirm }: SummaryStepProps) {
  const items = cart.items ?? [];

  return (
    <div className="space-y-4">
      <div className="rounded-xl border border-border bg-surface p-5">
        <h3 className="text-sm font-semibold text-text-main">Teslimat Adresi</h3>
        <p className="mt-2 text-sm text-text-main">{address.title || "Adres"} — {address.recipientName}</p>
        <p className="text-sm text-text-muted">{address.addressLine}, {address.district}/{address.city} {address.postalCode}</p>
        <p className="text-sm text-text-muted">{address.phone}</p>
      </div>

      <div className="rounded-xl border border-border bg-surface p-5">
        <h3 className="text-sm font-semibold text-text-main">Ürünler</h3>
        <div className="mt-3 space-y-2">
          {items.map((item) => (
            <div key={item.id} className="flex items-center justify-between text-sm">
              <span className="text-text-main">{item.productName} <span className="text-text-muted">× {item.quantity}</span></span>
              <span className="font-medium text-text-main">{formatPrice(item.subtotal)}</span>
            </div>
          ))}
        </div>
        <div className="mt-4 flex items-center justify-between border-t border-border pt-3">
          <span className="text-sm font-semibold text-text-main">Toplam</span>
          <span className="text-lg font-semibold text-text-main">{formatPrice(cart.total)}</span>
        </div>
      </div>

      {errorMessage && (
        <p data-testid="order-error" className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">{errorMessage}</p>
      )}

      <button type="button" onClick={onConfirm} disabled={isSubmitting} data-testid="confirm-order-button"
        className="flex w-full items-center justify-center gap-2 rounded-lg bg-tertiary py-3 text-sm font-semibold text-white hover:bg-tertiary/90 disabled:cursor-not-allowed disabled:opacity-70">
        {isSubmitting ? "Sipariş Oluşturuluyor..." : "Siparişi Onayla"}
      </button>
    </div>
  );
}