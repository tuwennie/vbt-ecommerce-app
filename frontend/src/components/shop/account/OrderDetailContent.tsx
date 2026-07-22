"use client";

import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { useOrder } from "@/hooks/use-orders";
import { getApiErrorMessage } from "@/lib/api-error";
import { ORDER_STATUS_LABELS, ORDER_STATUS_STYLES, formatOrderDate, formatOrderPrice } from "@/lib/order-status";
import type { OrderStatus } from "@/lib/services/orders";

interface OrderDetailContentProps {
  orderId: string;
}

export function OrderDetailContent({ orderId }: OrderDetailContentProps) {
  const { data: order, isLoading, isError, error, refetch } = useOrder(orderId);

  return (
    <div className="space-y-4">
      <Link href="/account/orders" className="inline-flex items-center gap-1.5 text-sm font-medium text-text-muted hover:text-text-main">
        <ArrowLeft className="h-4 w-4" />
        Siparişlerime Dön
      </Link>

      {isLoading && <div className="h-48 animate-pulse rounded-xl bg-neutral" />}

      {isError && (
        <div className="rounded-xl border border-border bg-surface p-6 text-center">
          <p className="text-sm font-semibold text-text-main">Sipariş yüklenemedi</p>
          <p className="mt-1 text-sm text-text-muted">{getApiErrorMessage(error)}</p>
          <button type="button" onClick={() => refetch()} className="mt-4 rounded-lg bg-secondary px-4 py-2 text-sm font-semibold text-white hover:bg-secondary/90">
            Tekrar Dene
          </button>
        </div>
      )}

      {order && (
        <>
          <div className="flex flex-wrap items-center justify-between gap-3 rounded-xl border border-border bg-surface p-5">
            <div>
              <p className="text-sm font-semibold text-text-main">Sipariş #{order.id?.slice(0, 8)}</p>
              <p className="mt-1 text-sm text-text-muted">{formatOrderDate(order.createdAt)}</p>
            </div>
            <span className={`rounded-full px-3 py-1 text-xs font-semibold ${ORDER_STATUS_STYLES[(order.status ?? "PENDING") as OrderStatus]}`}>
              {ORDER_STATUS_LABELS[(order.status ?? "PENDING") as OrderStatus]}
            </span>
          </div>

          {order.shippingAddress && (
            <div className="rounded-xl border border-border bg-surface p-5">
              <h3 className="text-sm font-semibold text-text-main">Teslimat Adresi</h3>
              <p className="mt-2 text-sm text-text-main">{order.shippingAddress.recipientName}</p>
              <p className="text-sm text-text-muted">{order.shippingAddress.addressLine}, {order.shippingAddress.district}/{order.shippingAddress.city} {order.shippingAddress.postalCode}</p>
              <p className="text-sm text-text-muted">{order.shippingAddress.phone}</p>
            </div>
          )}

          <div className="rounded-xl border border-border bg-surface p-5">
            <h3 className="text-sm font-semibold text-text-main">Ürünler</h3>
            <div className="mt-3 space-y-2">
              {(order.items ?? []).map((item, i) => (
                <div key={`${item.productId}-${i}`} className="flex items-center justify-between text-sm">
                  <span className="text-text-main">{item.productName} <span className="text-text-muted">× {item.quantity}</span></span>
                  <span className="font-medium text-text-main">{formatOrderPrice(item.subtotal)}</span>
                </div>
              ))}
            </div>
            <div className="mt-4 flex items-center justify-between border-t border-border pt-3">
              <span className="text-sm font-semibold text-text-main">Toplam</span>
              <span className="text-lg font-semibold text-text-main">{formatOrderPrice(order.total)}</span>
            </div>
          </div>
        </>
      )}
    </div>
  );
}