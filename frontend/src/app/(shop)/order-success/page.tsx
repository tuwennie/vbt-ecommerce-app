import type { Metadata } from "next";
import { Suspense } from "react";
import { OrderSuccessContent } from "@/components/shop/checkout/OrderSuccessContent";

export const metadata: Metadata = {
  title: "Sipariş Alındı · ShopSwift",
};

export default function OrderSuccessPage() {
  return (
    <Suspense fallback={null}>
      <OrderSuccessContent />
    </Suspense>
  );
}