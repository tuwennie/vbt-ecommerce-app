import type { Metadata } from "next";
import { Suspense } from "react";
import { HomeContent } from "@/components/shop/HomeContent";

export const metadata: Metadata = {
  title: "ShopSwift · Ana Sayfa",
};

export default function HomePage() {
  return (
    <Suspense fallback={null}>
      <HomeContent />
    </Suspense>
  );
}