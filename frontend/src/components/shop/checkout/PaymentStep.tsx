"use client";

import { CreditCard, Info } from "lucide-react";

export function PaymentStep() {
  return (
    <div className="space-y-4">
      <div className="flex items-start gap-2 rounded-lg bg-secondary/10 px-3 py-2 text-sm text-secondary">
        <Info className="mt-0.5 h-4 w-4 shrink-0" />
        <span>Bu bir ödeme simülasyonudur — gerçek kart bilgisi kaydedilmez veya işleme alınmaz.</span>
      </div>

      <div className="rounded-xl border border-border bg-surface p-5">
        <div className="mb-4 flex items-center gap-2">
          <CreditCard className="h-5 w-5 text-secondary" />
          <span className="text-sm font-semibold text-text-main">Kart Bilgileri</span>
        </div>

        <div className="space-y-3">
          <div>
            <label htmlFor="cardNumber" className="mb-1 block text-sm font-medium text-text-main">Kart Numarası</label>
            <input id="cardNumber" type="text" inputMode="numeric" placeholder="4242 4242 4242 4242" maxLength={19}
              className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label htmlFor="expiry" className="mb-1 block text-sm font-medium text-text-main">Son Kullanma Tarihi</label>
              <input id="expiry" type="text" placeholder="AA/YY" maxLength={5}
                className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
            </div>
            <div>
              <label htmlFor="cvv" className="mb-1 block text-sm font-medium text-text-main">CVV</label>
              <input id="cvv" type="text" inputMode="numeric" placeholder="123" maxLength={3}
                className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
            </div>
          </div>

          <div>
            <label htmlFor="cardName" className="mb-1 block text-sm font-medium text-text-main">Kart Üzerindeki İsim</label>
            <input id="cardName" type="text" placeholder="Ad Soyad"
              className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
          </div>
        </div>
      </div>
    </div>
  );
}