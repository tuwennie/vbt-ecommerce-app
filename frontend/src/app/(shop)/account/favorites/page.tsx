import type { Metadata } from "next";
import { FavoritesContent } from "@/components/shop/account/FavoritesContent";

export const metadata: Metadata = {
  title: "Favorilerim · ShopSwift",
};

export default function FavoritesPage() {
  return <FavoritesContent />;
}