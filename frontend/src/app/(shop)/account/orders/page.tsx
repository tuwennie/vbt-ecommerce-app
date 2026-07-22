import type { Metadata } from "next";
import { OrderHistoryContent } from "@/components/shop/account/OrderHistoryContent";

export const metadata: Metadata = {
  title: "Siparişlerim · ShopSwift",
};

export default function OrdersPage() {
  return <OrderHistoryContent />;
}