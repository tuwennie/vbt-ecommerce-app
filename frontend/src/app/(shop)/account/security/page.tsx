import type { Metadata } from "next";
import { SecurityContent } from "@/components/shop/account/SecurityContent";

export const metadata: Metadata = {
  title: "Güvenlik · ShopSwift",
};

export default function SecurityPage() {
  return <SecurityContent />;
}