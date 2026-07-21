"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useQueryClient } from "@tanstack/react-query";
import { Check } from "lucide-react";
import { useCart, CART_QUERY_KEY } from "@/hooks/use-cart";
import { useAddresses } from "@/hooks/use-addresses";
import { useCreateOrder } from "@/hooks/use-orders";
import { AddressStep } from "./AddressStep";
import { PaymentStep } from "./PaymentStep";
import { SummaryStep } from "./SummaryStep";
import { getApiErrorMessage } from "@/lib/api-error";

type Step = 1 | 2 | 3;

const STEP_LABELS: Record<Step, string> = {
  1: "Adres Seçimi",
  2: "Ödeme",
  3: "Sipariş Özeti",
};

function StepIndicator({ current }: { current: Step }) {
  return (
    <div className="flex items-center gap-2" data-testid="checkout-stepper">
      {([1, 2, 3] as Step[]).map((step, i) => (
        <div key={step} className="flex items-center gap-2">
          <div className="flex items-center gap-2">
            <span data-testid={`step-indicator-${step}`}
              className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-xs font-semibold ${
                step < current ? "bg-tertiary text-white" : step === current ? "bg-secondary text-white" : "bg-neutral text-text-muted"
              }`}>
              {step < current ? <Check className="h-3.5 w-3.5" /> : step}
            </span>
            <span className={`hidden text-sm font-medium sm:inline ${step === current ? "text-text-main" : "text-text-muted"}`}>
              {STEP_LABELS[step]}
            </span>
          </div>
          {i < 2 && <div className="h-px w-6 bg-border sm:w-10" />}
        </div>
      ))}
    </div>
  );
}

export function CheckoutContent() {
  const router = useRouter();
  const queryClient = useQueryClient();
  const { data: cart, isLoading: cartLoading } = useCart();
  const { data: addresses } = useAddresses();
  const createOrder = useCreateOrder();

  const [step, setStep] = useState<Step>(1);
  const [selectedAddressId, setSelectedAddressId] = useState<string | null>(null);
  const [orderError, setOrderError] = useState<string | null>(null);

  const items = cart?.items ?? [];

  if (cartLoading) {
    return <div className="h-40 animate-pulse rounded-xl bg-neutral" />;
  }

  if (items.length === 0) {
    return (
      <div className="rounded-xl border border-border bg-surface p-8 text-center">
        <p className="text-sm font-semibold text-text-main">Sepetin boş</p>
        <p className="mt-1 text-sm text-text-muted">Sipariş verebilmek için önce sepetine ürün eklemelisin.</p>
      </div>
    );
  }

  const selectedAddress = addresses?.find((a) => a.id === selectedAddressId) ?? null;

  function goToPayment() {
    if (!selectedAddressId) return;
    setStep(2);
  }

  function handleConfirmOrder() {
    if (!selectedAddressId) return;
    setOrderError(null);

    createOrder.mutate(
      { addressId: selectedAddressId, paymentMethod: "CREDIT_CARD" },
      {
        onSuccess: (order) => {
          queryClient.removeQueries({ queryKey: CART_QUERY_KEY });
          router.push(`/order-success?orderId=${order.id ?? ""}`);
        },
        onError: (err) => setOrderError(getApiErrorMessage(err)),
      },
    );
  }

  return (
    <div className="space-y-6">
      <StepIndicator current={step} />

      {step === 1 && (
        <div className="space-y-4">
          <AddressStep selectedAddressId={selectedAddressId} onSelect={setSelectedAddressId} />
          <button type="button" onClick={goToPayment} disabled={!selectedAddressId} data-testid="go-to-payment-button"
            className="w-full rounded-lg bg-tertiary py-2.5 text-sm font-semibold text-white hover:bg-tertiary/90 disabled:cursor-not-allowed disabled:opacity-40">
            Devam Et
          </button>
          {!selectedAddressId && (
            <p className="text-center text-xs text-text-muted">Devam etmek için bir teslimat adresi seç ya da ekle.</p>
          )}
        </div>
      )}

      {step === 2 && (
        <div className="space-y-4">
          <PaymentStep />
          <div className="flex gap-2">
            <button type="button" onClick={() => setStep(1)} className="flex-1 rounded-lg border border-border py-2.5 text-sm font-medium text-text-main hover:bg-neutral">
              Geri
            </button>
            <button type="button" onClick={() => setStep(3)} className="flex-1 rounded-lg bg-tertiary py-2.5 text-sm font-semibold text-white hover:bg-tertiary/90">
              Devam Et
            </button>
          </div>
        </div>
      )}

      {step === 3 && cart && selectedAddress && (
        <div className="space-y-4">
          <SummaryStep cart={cart} address={selectedAddress} isSubmitting={createOrder.isPending} errorMessage={orderError} onConfirm={handleConfirmOrder} />
          <button type="button" onClick={() => setStep(2)} disabled={createOrder.isPending}
            className="w-full rounded-lg border border-border py-2.5 text-sm font-medium text-text-main hover:bg-neutral disabled:opacity-40">
            Geri
          </button>
        </div>
      )}
    </div>
  );
}