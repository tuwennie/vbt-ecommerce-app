import Image from "next/image";
import { ShoppingBag } from "lucide-react";

const stats = [
  { value: "50K+", label: "Ürün Çeşidi" },
  { value: "Aynı Gün", label: "Kargo" },
];

export function ShopPromoPanel() {
  return (
    <div className="relative hidden h-full flex-col justify-center overflow-hidden bg-gradient-to-br from-secondary to-primary p-10 text-white lg:flex">
      
      <div className="relative max-w-sm flex flex-col gap-8">
      
        <div className="flex items-center gap-2">
          <span className="flex h-8 w-8 items-center justify-center rounded-md bg-white/15">
            <ShoppingBag className="h-4 w-4" />
          </span>
          <span className="text-3xl font-semibold">ShopSwift</span>
        </div>

        <div>
          <h2 className="text-2xl font-semibold">ShopSwift&apos;e Hoş Geldin</h2>
          <p className="mt-3 text-sm text-white/80">
            Binlerce ürünü keşfet, favorilerini kaydet ve siparişlerini tek
            yerden takip et. Güvenli ödeme, hızlı teslimat.
          </p>

          <div className="mt-6 flex gap-3">
            {stats.map((stat) => (
              <div key={stat.label} className="rounded-lg bg-white/10 px-4 py-3 backdrop-blur-sm">
                <p className="text-lg font-semibold">{stat.value}</p>
                <p className="text-xs text-white/70">{stat.label}</p>
              </div>
            ))}
          </div>
        </div>

      </div>

    </div>
  );
}