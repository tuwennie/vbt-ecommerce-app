import type { Metadata } from "next";
import { AccountContent } from "@/components/shop/account/AccountContent";

export const metadata: Metadata = {
  title: "Hesabım · ShopSwift",
};

export default function AccountPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-text-main">Hesabım</h1>
      <AccountContent />
    </div>
  );
}