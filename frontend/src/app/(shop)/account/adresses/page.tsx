import type { Metadata } from "next";
import { AddressBookContent } from "@/components/shop/account/AddressBookContent";

export const metadata: Metadata = {
  title: "Adres Defterim · ShopSwift",
};

export default function AddressBookPage() {
  return <AddressBookContent />;
}