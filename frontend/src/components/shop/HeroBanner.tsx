import Image from "next/image";
import { ArrowRight } from "lucide-react";

export function HeroBanner() {
  return (
    <div className="relative overflow-hidden rounded-2xl">
      <div className="relative aspect-[21/9] w-full sm:aspect-[16/7]">
        <Image src="/images/hero-banner.jpg" alt="" fill priority className="object-cover" />
        <div className="absolute inset-0 bg-gradient-to-r from-primary/90 via-primary/60 to-transparent" />
      </div>

      <div className="absolute inset-0 flex flex-col justify-center gap-4 p-6 sm:p-10 lg:max-w-lg">
        <span className="inline-flex w-fit items-center rounded-full bg-tertiary px-3 py-1 text-xs font-semibold uppercase tracking-wide text-white">
          Sezonun En Hit Ürünleri
        </span>
        <h1 className="text-2xl font-bold text-white sm:text-3xl lg:text-4xl">
          Geleceği Bugün Keşfetmeye Başla
        </h1>
        <p className="text-sm text-white/80 sm:text-base">
          Teknolojiden modaya, hayatını kolaylaştıracak en yeni trendler özel indirimlerle seni bekliyor.
        </p>
        <button
          type="button"
          className="flex w-fit items-center gap-2 rounded-lg bg-tertiary px-5 py-2.5 text-sm font-semibold text-white hover:bg-tertiary/90"
        >
          Fırsatları Keşfet
          <ArrowRight className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
}