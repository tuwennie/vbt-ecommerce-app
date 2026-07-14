import Image from "next/image";
import { ShoppingCart } from "lucide-react";

const stats = [
  { value: "99.9%", label: "Çalışma Süresi" },
  { value: "24/7", label: "Canlı Destek" },
];

export function LoginPromoPanel() {
  return (
    <div className="relative hidden h-full flex-col justify-center overflow-hidden bg-gradient-to-br from-secondary to-primary p-10 text-white lg:flex">
      

      {/* İçerik Konteyneri: Artık her şey tek bir dikey hizada */}
      <div className="relative max-w-sm flex flex-col gap-6">
        
        {/* LOGO: Buraya taşındı ve başlıkla arasındaki mesafe ayarlandı */}
        <div className="flex items-center gap-2">
          <span className="flex h-8 w-8 items-center justify-center rounded-md bg-white/15">
            <ShoppingCart className="h-4 w-4" />
          </span>
          <span className="text-3xl font-semibold">ShopSwift</span>
        </div>

        {/* METİNLER */}
        <div>
          <h2 className="text-2xl font-semibold">Yönetim Gücünü Keşfedin</h2>
          <p className="mt-3 text-sm text-white/80">
            İşletmenizin her yönünü tek bir merkezden yönetin. Siparişleri
            takip edin, ürünlerinizi güncelleyin ve gerçek zamanlı raporlarla
            büyümeyi izleyin.
          </p>
        </div>

        {/* İSTATİSTİKLER */}
        <div className="flex gap-3">
          {stats.map((stat) => (
            <div key={stat.label} className="rounded-lg bg-white/10 px-20 py-4 backdrop-blur-sm">
              <p className="text-lg font-semibold">{stat.value}</p>
              <p className="text-xs text-white/70">{stat.label}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}