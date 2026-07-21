import type { Metadata } from "next";
import { CheckoutContent } from "@/components/shop/checkout/CheckoutContent";

export const metadata: Metadata = {
  title: "Siparişi Tamamla · ShopSwift",
};

export default function CheckoutPage() {
  return (
    <div className="mx-auto max-w-2xl space-y-6">
      <h1 className="text-2xl font-bold text-text-main">Siparişi Tamamla</h1>
      <CheckoutContent />
    </div>
  );
}