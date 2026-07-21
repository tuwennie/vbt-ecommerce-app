"use client";

import { useState } from "react";
import { Plus, Pencil, Trash2, MapPin } from "lucide-react";
import { useAddresses, useDeleteAddress } from "@/hooks/use-addresses";
import { AddressFormModal } from "./AddressFormModal";
import { getApiErrorMessage } from "@/lib/api-error";
import type { Address } from "@/lib/services/addresses";

interface AddressStepProps {
  selectedAddressId: string | null;
  onSelect: (addressId: string) => void;
}

function AddressSkeleton() {
  return (
    <div className="animate-pulse space-y-3">
      {[1, 2].map((i) => (
        <div key={i} className="h-24 rounded-xl border border-border bg-surface" />
      ))}
    </div>
  );
}

export function AddressStep({ selectedAddressId, onSelect }: AddressStepProps) {
  const { data: addresses, isLoading, isError, error, refetch } = useAddresses();
  const deleteAddress = useDeleteAddress();

  const [modalOpen, setModalOpen] = useState(false);
  const [editingAddress, setEditingAddress] = useState<Address | null>(null);

  function openCreateModal() {
    setEditingAddress(null);
    setModalOpen(true);
  }

  function openEditModal(address: Address) {
    setEditingAddress(address);
    setModalOpen(true);
  }

  if (isLoading) return <AddressSkeleton />;

  if (isError) {
    return (
      <div className="rounded-xl border border-border bg-surface p-6 text-center">
        <p className="text-sm font-semibold text-text-main">Adresler yüklenemedi</p>
        <p className="mt-1 text-sm text-text-muted">{getApiErrorMessage(error)}</p>
        <button type="button" onClick={() => refetch()} className="mt-4 rounded-lg bg-secondary px-4 py-2 text-sm font-semibold text-white hover:bg-secondary/90">
          Tekrar Dene
        </button>
      </div>
    );
  }

  const list = addresses ?? [];

  return (
    <div className="space-y-3">
      {list.length === 0 && (
        <div className="flex flex-col items-center justify-center rounded-xl border border-border bg-surface px-6 py-10 text-center">
          <MapPin className="h-8 w-8 text-text-muted" />
          <p className="mt-3 text-sm font-semibold text-text-main">Kayıtlı adresin yok</p>
          <p className="mt-1 text-sm text-text-muted">Siparişe devam etmek için bir teslimat adresi ekle.</p>
        </div>
      )}

      {list.map((address) => {
        const isSelected = address.id === selectedAddressId;
        return (
          <div key={address.id} data-testid="address-option"
            className={`flex items-start gap-3 rounded-xl border p-4 transition-colors ${isSelected ? "border-secondary bg-secondary/5" : "border-border bg-surface"}`}>
            <button type="button" onClick={() => address.id && onSelect(address.id)} className="flex flex-1 items-start gap-3 text-left">
              <span className={`mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full border-2 ${isSelected ? "border-secondary bg-secondary" : "border-border"}`}>
                {isSelected && <span className="h-2 w-2 rounded-full bg-white" />}
              </span>
              <div className="min-w-0">
                <p className="text-sm font-semibold text-text-main">{address.title || "Adres"} — {address.recipientName}</p>
                <p className="mt-0.5 text-sm text-text-muted">{address.addressLine}, {address.district}/{address.city} {address.postalCode}</p>
                <p className="mt-0.5 text-sm text-text-muted">{address.phone}</p>
              </div>
            </button>

            <div className="flex shrink-0 gap-1">
              <button type="button" aria-label="Düzenle" onClick={() => openEditModal(address)} className="text-text-muted hover:text-text-main">
                <Pencil className="h-4 w-4" />
              </button>
              <button type="button" aria-label="Sil" disabled={deleteAddress.isPending} onClick={() => address.id && deleteAddress.mutate(address.id)} className="text-text-muted hover:text-error disabled:opacity-40">
                <Trash2 className="h-4 w-4" />
              </button>
            </div>
          </div>
        );
      })}

      <button type="button" onClick={openCreateModal} data-testid="add-address-button"
        className="flex w-full items-center justify-center gap-2 rounded-xl border border-dashed border-border py-3 text-sm font-medium text-secondary hover:bg-neutral">
        <Plus className="h-4 w-4" />
        Yeni Adres Ekle
      </button>

      <AddressFormModal open={modalOpen} onClose={() => setModalOpen(false)} editingAddress={editingAddress}
        onSaved={(address) => { if (address.id) onSelect(address.id); }} />
    </div>
  );
}