"use client";

import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { CheckCircle2 } from "lucide-react";
import { useOrder } from "@/hooks/use-orders";
import { getApiErrorMessage } from "@/lib/api-error";

function formatPrice(value: number | undefined) {
  if (value === undefined) return "—";
  return value.toLocaleString("tr-TR", { style: "currency", currency: "TRY", maximumFractionDigits: 2 });
}

export function OrderSuccessContent() {
  const searchParams = useSearchParams();
  const orderId = searchParams.get("orderId");
  const { data: order, isLoading, isError, error } = useOrder(orderId);

  return (
    <div className="mx-auto max-w-lg text-center">
      <span className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-tertiary/10">
        <CheckCircle2 className="h-9 w-9 text-tertiary" />
      </span>
      <h1 className="mt-4 text-2xl font-bold text-text-main">Siparişin Alındı!</h1>
      <p className="mt-2 text-sm text-text-muted">
        Teşekkürler, siparişin başarıyla oluşturuldu. Kısa süre içinde hazırlanmaya başlayacak.
      </p>

      {isLoading && <div className="mt-6 h-24 animate-pulse rounded-xl bg-neutral" />}

      {isError && (
        <p className="mt-6 text-sm text-text-muted">Sipariş detayları şu an görüntülenemiyor: {getApiErrorMessage(error)}</p>
      )}

      {order && (
        <div className="mt-6 rounded-xl border border-border bg-surface p-5 text-left">
          <div className="flex items-center justify-between text-sm">
            <span className="text-text-muted">Sipariş No</span>
            <span className="font-medium text-text-main">{order.id}</span>
          </div>
          <div className="mt-2 flex items-center justify-between text-sm">
            <span className="text-text-muted">Toplam</span>
            <span className="font-semibold text-text-main">{formatPrice(order.total)}</span>
          </div>
        </div>
      )}

      <Link href="/" className="mt-6 inline-block rounded-lg bg-tertiary px-5 py-2.5 text-sm font-semibold text-white hover:bg-tertiary/90">
        Alışverişe Devam Et
      </Link>
    </div>
  );
}