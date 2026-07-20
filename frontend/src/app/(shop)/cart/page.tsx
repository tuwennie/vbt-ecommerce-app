import type { Metadata } from "next";
import { CartContent } from "@/components/shop/cart/CartContent";

export const metadata: Metadata = {
  title: "Sepetim · ShopSwift",
};

export default function CartPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-text-main">Sepetim</h1>
      <CartContent />
    </div>
  );
}