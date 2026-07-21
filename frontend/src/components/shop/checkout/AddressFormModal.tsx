"use client";

import { useState, type FormEvent } from "react";
import { X } from "lucide-react";
import { useCreateAddress, useUpdateAddress } from "@/hooks/use-addresses";
import { getApiErrorMessage } from "@/lib/api-error";
import type { Address, AddressInput } from "@/lib/services/addresses";
import type { ApiErrorResponse, ApiValidationErrorResponse } from "@/lib/api-error";

interface AddressFormModalProps {
  open: boolean;
  onClose: () => void;
  editingAddress?: Address | null;
  onSaved: (address: Address) => void;
}

export function AddressFormModal({ open, onClose, editingAddress, onSaved }: AddressFormModalProps) {
  const createAddress = useCreateAddress();
  const updateAddress = useUpdateAddress();
  const [error, setError] = useState<ApiErrorResponse | null>(null);

  const isEditing = !!editingAddress?.id;
  const isPending = createAddress.isPending || updateAddress.isPending;

  if (!open) return null;

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError(null);

    const formData = new FormData(event.currentTarget);
    const input: AddressInput = {
      title: String(formData.get("title") ?? "").trim() || undefined,
      recipientName: String(formData.get("recipientName") ?? "").trim(),
      phone: String(formData.get("phone") ?? "").trim(),
      city: String(formData.get("city") ?? "").trim(),
      district: String(formData.get("district") ?? "").trim(),
      addressLine: String(formData.get("addressLine") ?? "").trim(),
      postalCode: String(formData.get("postalCode") ?? "").trim(),
    };

    const validationErrors: { field: string; message: string }[] = [];
    if (input.recipientName.length < 2) {
      validationErrors.push({ field: "recipientName", message: "Alıcı adı en az 2 karakter olmalı." });
    }
    if (!/^\+?[0-9]{10,15}$/.test(input.phone)) {
      validationErrors.push({ field: "phone", message: "Telefon formatı geçersiz (örn. +905551234567)." });
    }
    if (input.addressLine.length < 10) {
      validationErrors.push({ field: "addressLine", message: "Adres en az 10 karakter olmalı." });
    }
    if (!/^[0-9]{5}$/.test(input.postalCode)) {
      validationErrors.push({ field: "postalCode", message: "Posta kodu 5 haneli olmalı (örn. 34000)." });
    }

    if (validationErrors.length > 0) {
      const validationError: ApiValidationErrorResponse = {
        success: false,
        message: "Girdiğin bilgileri kontrol et.",
        statusCode: 400,
        status: "BAD_REQUEST",
        errors: validationErrors,
      };
      setError(validationError);
      return;
    }

    if (isEditing && editingAddress?.id) {
      updateAddress.mutate(
        { addressId: editingAddress.id, input },
        {
          onSuccess: (address) => { onSaved(address); onClose(); },
          onError: (err) => setError(err),
        },
      );
    } else {
      createAddress.mutate(input, {
        onSuccess: (address) => { onSaved(address); onClose(); },
        onError: (err) => setError(err),
      });
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-primary/40 p-4">
      <div className="w-full max-w-md rounded-xl bg-surface p-6 shadow-lg">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold text-text-main">
            {isEditing ? "Adresi Düzenle" : "Yeni Adres Ekle"}
          </h2>
          <button type="button" onClick={onClose} aria-label="Kapat" className="text-text-muted hover:text-text-main">
            <X className="h-5 w-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="mt-4 space-y-3">
          <div>
            <label htmlFor="title" className="mb-1 block text-sm font-medium text-text-main">
              Adres Etiketi <span className="text-text-muted">(isteğe bağlı)</span>
            </label>
            <input id="title" name="title" type="text" defaultValue={editingAddress?.title ?? ""} placeholder="Ev, İş..."
              className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
          </div>

          <div>
            <label htmlFor="recipientName" className="mb-1 block text-sm font-medium text-text-main">Alıcı Adı Soyadı</label>
            <input id="recipientName" name="recipientName" type="text" required defaultValue={editingAddress?.recipientName ?? ""}
              className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
          </div>

          <div>
            <label htmlFor="phone" className="mb-1 block text-sm font-medium text-text-main">Telefon</label>
            <input id="phone" name="phone" type="tel" required defaultValue={editingAddress?.phone ?? ""} placeholder="+905551234567"
              className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label htmlFor="city" className="mb-1 block text-sm font-medium text-text-main">İl</label>
              <input id="city" name="city" type="text" required defaultValue={editingAddress?.city ?? ""}
                className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
            </div>
            <div>
              <label htmlFor="district" className="mb-1 block text-sm font-medium text-text-main">İlçe</label>
              <input id="district" name="district" type="text" required defaultValue={editingAddress?.district ?? ""}
                className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
            </div>
          </div>

          <div>
            <label htmlFor="addressLine" className="mb-1 block text-sm font-medium text-text-main">Açık Adres</label>
            <textarea id="addressLine" name="addressLine" required rows={2} defaultValue={editingAddress?.addressLine ?? ""}
              className="w-full resize-none rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
          </div>

          <div>
            <label htmlFor="postalCode" className="mb-1 block text-sm font-medium text-text-main">Posta Kodu</label>
            <input id="postalCode" name="postalCode" type="text" required defaultValue={editingAddress?.postalCode ?? ""} placeholder="34000"
              className="w-full rounded-lg border border-border bg-neutral px-3 py-2 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
          </div>

          {error && (
            <p data-testid="address-form-error" className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">
              {getApiErrorMessage(error)}
            </p>
          )}

          <div className="flex gap-2 pt-2">
            <button type="submit" disabled={isPending}
              className="flex-1 rounded-lg bg-tertiary py-2.5 text-sm font-semibold text-white hover:bg-tertiary/90 disabled:cursor-not-allowed disabled:opacity-70">
              {isPending ? "Kaydediliyor..." : "Kaydet"}
            </button>
            <button type="button" onClick={onClose} className="rounded-lg border border-border px-4 py-2.5 text-sm font-medium text-text-main hover:bg-neutral">
              Vazgeç
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}