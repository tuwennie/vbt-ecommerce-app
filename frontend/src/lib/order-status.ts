import type { OrderStatus } from "@/lib/services/orders";

export const ORDER_STATUS_LABELS: Record<OrderStatus, string> = {
  PENDING: "Beklemede",
  PAID: "Ödendi",
  SHIPPED: "Kargoda",
  DELIVERED: "Teslim Edildi",
};

export const ORDER_STATUS_STYLES: Record<OrderStatus, string> = {
  PENDING: "bg-warning/10 text-warning",
  PAID: "bg-secondary/10 text-secondary",
  SHIPPED: "bg-secondary/10 text-secondary",
  DELIVERED: "bg-tertiary/10 text-tertiary",
};

export function formatOrderDate(value: string | undefined) {
  if (!value) return "—";
  return new Date(value).toLocaleDateString("tr-TR", { year: "numeric", month: "long", day: "numeric" });
}

export function formatOrderPrice(value: number | undefined) {
  if (value === undefined) return "—";
  return value.toLocaleString("tr-TR", { style: "currency", currency: "TRY", maximumFractionDigits: 2 });
}