import type { Metadata } from "next";
import { Suspense } from "react";
import { SearchContent } from "@/components/shop/SearchContent";

export const metadata: Metadata = {
  title: "Ürünler · ShopSwift",
};

export default function SearchPage() {
  return (
    <Suspense fallback={null}>
      <SearchContent />
    </Suspense>
  );
}