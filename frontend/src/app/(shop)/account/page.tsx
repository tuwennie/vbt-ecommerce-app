import type { Metadata } from "next";
import { AccountContent } from "@/components/shop/account/AccountContent";

export const metadata: Metadata = {
  title: "Profilim · ShopSwift",
};

export default function AccountPage() {
  return <AccountContent />;
}