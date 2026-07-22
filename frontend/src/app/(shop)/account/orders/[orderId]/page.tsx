import type { Metadata } from "next";
import { OrderDetailContent } from "@/components/shop/account/OrderDetailContent";

export const metadata: Metadata = {
  title: "Sipariş Detayı · ShopSwift",
};

export default async function OrderDetailPage({
  params,
}: {
  params: Promise<{ orderId: string }>;
}) {
  const { orderId } = await params;
  return <OrderDetailContent orderId={orderId} />;
}