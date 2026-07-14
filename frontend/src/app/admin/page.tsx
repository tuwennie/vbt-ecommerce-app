import type { Metadata } from "next";
import { Suspense } from "react";
import { ShoppingCart } from "lucide-react";
import { LoginForm } from "@/components/auth/LoginForm";
import { LoginPromoPanel } from "@/components/auth/LoginPromoPanel";

export const metadata: Metadata = {
  title: "Giriş Yap · ShopSwift Admin",
};

export default function LoginPage() {
  return (
    <div className="flex min-h-screen">
      {/* Tablet ve mobilde tamamen kaldırılıyor (yer kaplamasın diye hidden, sadece display:none değil) */}
      <div className="hidden lg:block lg:w-2/5">
        <LoginPromoPanel />
      </div>

      <div className="flex w-full flex-col items-center justify-center gap-[clamp(1rem,4vw,2rem)] bg-surface p-[clamp(1.5rem,6vw,3rem)] lg:w-3/5 lg:justify-between lg:gap-0 lg:px-16 lg:py-16">
        {/* Sadece tablet/mobilde görünür: soldaki tanıtım paneli gizlendiği için marka burada gösteriliyor */}
        <div className="flex flex-col items-center gap-[clamp(0.5rem,2vw,0.75rem)] lg:hidden">
          <span className="flex h-[clamp(2.75rem,10vw,3.5rem)] w-[clamp(2.75rem,10vw,3.5rem)] items-center justify-center rounded-2xl bg-white shadow-sm ring-1 ring-border">
            <ShoppingCart className="h-[clamp(1.125rem,4vw,1.5rem)] w-[clamp(1.125rem,4vw,1.5rem)] text-secondary" />
          </span>
          <span className="text-[clamp(1rem,4vw,1.25rem)] font-semibold text-text-main">
            ShopSwift Admin
          </span>
        </div>

        <Suspense fallback={null}>
          <LoginForm />
        </Suspense>

        <p className="text-[clamp(0.6875rem,2.5vw,0.75rem)] text-text-muted">
          © {new Date().getFullYear()} ShopSwift Admin. Tüm hakları saklıdır.
        </p>
      </div>
    </div>
  );
}