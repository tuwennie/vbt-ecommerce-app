"use client";

import Link from "next/link";
import { Package, ChevronRight } from "lucide-react";
import { useOrders } from "@/hooks/use-orders";
import { getApiErrorMessage } from "@/lib/api-error";
import { ORDER_STATUS_LABELS, ORDER_STATUS_STYLES, formatOrderDate, formatOrderPrice } from "@/lib/order-status";
import type { OrderStatus } from "@/lib/services/orders";

function OrdersSkeleton() {
  return (
    <div className="animate-pulse space-y-3">
      {[1, 2, 3].map((i) => (
        <div key={i} className="h-20 rounded-xl border border-border bg-surface" />
      ))}
    </div>
  );
}

export function OrderHistoryContent() {
  const { data, isLoading, isError, error, refetch } = useOrders();

  if (isLoading) return <OrdersSkeleton />;

  if (isError) {
    return (
      <div className="rounded-xl border border-border bg-surface p-6 text-center">
        <p className="text-sm font-semibold text-text-main">Siparişler yüklenemedi</p>
        <p className="mt-1 text-sm text-text-muted">{getApiErrorMessage(error)}</p>
        <button type="button" onClick={() => refetch()} className="mt-4 rounded-lg bg-secondary px-4 py-2 text-sm font-semibold text-white hover:bg-secondary/90">
          Tekrar Dene
        </button>
      </div>
    );
  }

  const orders = data?.items ?? [];

  if (orders.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center rounded-xl border border-border bg-surface px-6 py-12 text-center">
        <Package className="h-8 w-8 text-text-muted" />
        <p className="mt-3 text-sm font-semibold text-text-main">Henüz siparişin yok</p>
        <p className="mt-1 text-sm text-text-muted">Verdiğin siparişler burada listelenecek.</p>
      </div>
    );
  }

  return (
    <div className="space-y-3" data-testid="order-list">
      {orders.map((order) => {
        const status = (order.status ?? "PENDING") as OrderStatus;
        return (
          <Link key={order.id} href={`/account/orders/${order.id}`} data-testid="order-row"
            className="flex items-center justify-between gap-4 rounded-xl border border-border bg-surface p-4 hover:border-secondary">
            <div className="min-w-0">
              <p className="truncate text-sm font-semibold text-text-main">Sipariş #{order.id?.slice(0, 8)}</p>
              <p className="mt-1 text-sm text-text-muted">{formatOrderDate(order.createdAt)}</p>
            </div>
            <div className="flex shrink-0 items-center gap-4">
              <span data-testid="order-status-badge" className={`rounded-full px-2.5 py-1 text-xs font-semibold ${ORDER_STATUS_STYLES[status]}`}>
                {ORDER_STATUS_LABELS[status]}
              </span>
              <span className="text-sm font-semibold text-text-main">{formatOrderPrice(order.total)}</span>
              <ChevronRight className="h-4 w-4 text-text-muted" />
            </div>
          </Link>
        );
      })}
    </div>
  );
}