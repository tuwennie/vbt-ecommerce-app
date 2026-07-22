"use client";

import { useState } from "react";
import { Plus, Pencil, Trash2, MapPin } from "lucide-react";
import { useAddresses, useDeleteAddress } from "@/hooks/use-addresses";
import { AddressFormModal } from "@/components/shop/checkout/AddressFormModal";
import { getApiErrorMessage } from "@/lib/api-error";
import type { Address } from "@/lib/services/addresses";

function AddressBookSkeleton() {
  return (
    <div className="grid animate-pulse grid-cols-1 gap-4 sm:grid-cols-2">
      {[1, 2].map((i) => (
        <div key={i} className="h-32 rounded-xl border border-border bg-surface" />
      ))}
    </div>
  );
}

export function AddressBookContent() {
  const { data: addresses, isLoading, isError, error, refetch } = useAddresses();
  const deleteAddress = useDeleteAddress();

  const [modalOpen, setModalOpen] = useState(false);
  const [editingAddress, setEditingAddress] = useState<Address | null>(null);
  const [pendingDeleteId, setPendingDeleteId] = useState<string | null>(null);

  function openCreateModal() {
    setEditingAddress(null);
    setModalOpen(true);
  }

  function openEditModal(address: Address) {
    setEditingAddress(address);
    setModalOpen(true);
  }

  function handleDelete(addressId: string) {
    setPendingDeleteId(addressId);
    deleteAddress.mutate(addressId, { onSettled: () => setPendingDeleteId(null) });
  }

  if (isLoading) return <AddressBookSkeleton />;

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
    <div className="space-y-4">
      {list.length === 0 ? (
        <div className="flex flex-col items-center justify-center rounded-xl border border-border bg-surface px-6 py-12 text-center">
          <MapPin className="h-8 w-8 text-text-muted" />
          <p className="mt-3 text-sm font-semibold text-text-main">Henüz kayıtlı adresin yok</p>
          <p className="mt-1 text-sm text-text-muted">Hızlı sipariş verebilmek için bir teslimat adresi ekle.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          {list.map((address) => (
            <div key={address.id} data-testid="address-card" className="flex flex-col rounded-xl border border-border bg-surface p-4">
              <div className="flex items-start justify-between">
                <p className="text-sm font-semibold text-text-main">{address.title || "Adres"}</p>
                <div className="flex shrink-0 gap-1">
                  <button type="button" aria-label="Düzenle" onClick={() => openEditModal(address)} className="text-text-muted hover:text-text-main">
                    <Pencil className="h-4 w-4" />
                  </button>
                  <button type="button" aria-label="Sil" disabled={pendingDeleteId === address.id} onClick={() => address.id && handleDelete(address.id)} className="text-text-muted hover:text-error disabled:opacity-40">
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>
              <p className="mt-2 text-sm text-text-main">{address.recipientName}</p>
              <p className="mt-1 text-sm text-text-muted">{address.addressLine}, {address.district}/{address.city} {address.postalCode}</p>
              <p className="mt-1 text-sm text-text-muted">{address.phone}</p>
            </div>
          ))}
        </div>
      )}

      <button type="button" onClick={openCreateModal} data-testid="add-address-button"
        className="flex w-full items-center justify-center gap-2 rounded-xl border border-dashed border-border py-3 text-sm font-medium text-secondary hover:bg-neutral sm:w-auto sm:px-6">
        <Plus className="h-4 w-4" />
        Yeni Adres Ekle
      </button>

      <AddressFormModal open={modalOpen} onClose={() => setModalOpen(false)} editingAddress={editingAddress} onSaved={() => {}} />
    </div>
  );
}