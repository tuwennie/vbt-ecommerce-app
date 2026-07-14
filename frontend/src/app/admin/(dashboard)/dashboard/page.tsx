import type { Metadata } from "next";
import { Download, Plus, Wallet, ShoppingBag, UserPlus, LineChart } from "lucide-react";
import { StatCard } from "@/components/admin/dashboard/StatCard";
import { SalesChart } from "@/components/admin/dashboard/SalesChart";
import { RecentOrdersTable } from "@/components/admin/dashboard/RecentOrdersTable";

export const metadata: Metadata = {
  title: "Kontrol Paneli · ShopSwift Admin",
};

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
        <div>
          <h1 className="text-2xl font-semibold text-text-main">Kontrol Paneli Genel Bakış</h1>
          <p className="mt-1 text-sm text-text-muted">ShopSwift Enterprise için gerçek zamanlı performans ölçümleri.</p>
        </div>

        <div className="flex shrink-0 gap-3">
          <button type="button" className="inline-flex items-center gap-2 rounded-lg border border-border bg-surface px-4 py-2 text-sm font-medium text-text-main hover:bg-neutral">
            <Download className="h-4 w-4" />
            Raporu İndir
          </button>
          <button type="button" className="inline-flex items-center gap-2 rounded-lg bg-tertiary px-4 py-2 text-sm font-semibold text-white hover:bg-tertiary/90">
            <Plus className="h-4 w-4" />
            Sipariş Oluştur
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard label="Toplam Satış" value="₺724,500" icon={Wallet} deltaLabel="+12%" direction="up" />
        <StatCard label="Sipariş Sayısı" value="2,500" icon={ShoppingBag} deltaLabel="+5%" direction="up" />
        <StatCard label="Yeni Müşteriler" value="450" icon={UserPlus} deltaLabel="+8%" direction="up" />
        <StatCard label="Ort Sipariş Değeri" value="₺600" icon={LineChart} deltaLabel="-2%" direction="down" />
      </div>

      <div className="rounded-xl border border-border bg-surface p-5">
        <div className="flex items-start justify-between">
          <div>
            <h2 className="text-base font-semibold text-text-main">Satış Performansı</h2>
            <p className="text-sm text-text-muted">Brüt gelir trend analizi</p>
          </div>
          <select className="rounded-lg border border-border bg-surface px-3 py-1.5 text-sm text-text-main">
            <option>Son 30 gün</option>
            <option>Son 7 gün</option>
            <option>Son 90 gün</option>
          </select>
        </div>
        <div className="mt-4">
          <SalesChart />
        </div>
      </div>

      <div className="rounded-xl border border-border bg-surface p-5">
        <div className="flex items-start justify-between">
          <div>
            <h2 className="text-base font-semibold text-text-main">Son Siparişler</h2>
            <p className="text-sm text-text-muted">Tüm bölgelerde gerçekleştirilen son 10 işlem.</p>
          </div>
          <a href="/admin/orders" className="text-sm font-medium text-secondary hover:underline">Tüm Siparişleri Görüntüle</a>
        </div>
        <div className="mt-4">
          <RecentOrdersTable />
        </div>
      </div>
    </div>
  );
}