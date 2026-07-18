"use client";

import { useState, type FormEvent } from "react";
import { User as UserIcon, Mail, Phone, Calendar, Pencil, Check, X } from "lucide-react";
import { useCurrentUser, useUpdateCurrentUser } from "@/hooks/use-current-user";
import { getApiErrorMessage } from "@/lib/api-error";
import { setUserDisplayName } from "@/lib/auth-token";

function initialsOf(name: string) {
  return name
    .split(" ")
    .map((part) => part[0])
    .filter(Boolean)
    .slice(0, 2)
    .join("")
    .toUpperCase();
}

function ProfileSkeleton() {
  return (
    <div className="animate-pulse rounded-xl border border-border bg-surface p-6">
      <div className="flex items-center gap-4">
        <div className="h-16 w-16 rounded-full bg-neutral" />
        <div className="space-y-2">
          <div className="h-4 w-40 rounded bg-neutral" />
          <div className="h-3 w-28 rounded bg-neutral" />
        </div>
      </div>
      <div className="mt-6 space-y-3">
        <div className="h-3 w-full rounded bg-neutral" />
        <div className="h-3 w-2/3 rounded bg-neutral" />
      </div>
    </div>
  );
}

export function AccountContent() {
  const { data: user, isLoading, isError, error, refetch } = useCurrentUser();
  const updateUser = useUpdateCurrentUser();

  const [isEditing, setIsEditing] = useState(false);
  const [formError, setFormError] = useState<string | null>(null);

  function handleEditSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setFormError(null);

    const formData = new FormData(event.currentTarget);
    const fullName = String(formData.get("fullName") ?? "").trim();
    const phone = String(formData.get("phone") ?? "").trim();

    if (fullName.length < 2) {
      setFormError("Ad Soyad en az 2 karakter olmalı.");
      return;
    }

    updateUser.mutate(
      { fullName, phone: phone || undefined },
      {
        onSuccess: (updated) => {
          if (updated.fullName) {
            setUserDisplayName(updated.fullName);
          }
          setIsEditing(false);
        },
        onError: (err) => {
          setFormError(getApiErrorMessage(err));
        },
      },
    );
  }

  if (isLoading) {
    return <ProfileSkeleton />;
  }

  if (isError) {
    return (
      <div className="rounded-xl border border-border bg-surface p-6 text-center">
        <p className="text-sm font-semibold text-text-main">Profil yüklenemedi</p>
        <p className="mt-1 text-sm text-text-muted">{getApiErrorMessage(error)}</p>
        <button
          type="button"
          onClick={() => refetch()}
          className="mt-4 rounded-lg bg-secondary px-4 py-2 text-sm font-semibold text-white hover:bg-secondary/90"
        >
          Tekrar Dene
        </button>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="space-y-6">
      <div className="rounded-xl border border-border bg-surface p-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <span className="flex h-16 w-16 items-center justify-center rounded-full bg-secondary text-lg font-semibold text-white">
              {user.fullName ? initialsOf(user.fullName) : "?"}
            </span>
            <div>
              <p className="text-lg font-semibold text-text-main">{user.fullName}</p>
              <p className="text-sm text-text-muted">{user.role === "ADMIN" ? "Yönetici" : "Üye"}</p>
            </div>
          </div>

          {!isEditing && (
            <button
              type="button"
              onClick={() => setIsEditing(true)}
              className="flex items-center gap-1.5 rounded-lg border border-border px-3 py-1.5 text-sm font-medium text-text-main hover:bg-neutral"
            >
              <Pencil className="h-3.5 w-3.5" />
              Düzenle
            </button>
          )}
        </div>

        {!isEditing ? (
          <div className="mt-6 space-y-3 border-t border-border pt-4">
            <div className="flex items-center gap-3 text-sm">
              <Mail className="h-4 w-4 text-text-muted" />
              <span className="text-text-main">{user.email}</span>
            </div>
            <div className="flex items-center gap-3 text-sm">
              <Phone className="h-4 w-4 text-text-muted" />
              <span className="text-text-main">{user.phone ?? "Kayıtlı telefon yok"}</span>
            </div>
            {user.createdAt && (
              <div className="flex items-center gap-3 text-sm">
                <Calendar className="h-4 w-4 text-text-muted" />
                <span className="text-text-main">
                  {new Date(user.createdAt).toLocaleDateString("tr-TR", {
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                  })}{" "}
                  tarihinden beri üye
                </span>
              </div>
            )}
          </div>
        ) : (
          <form onSubmit={handleEditSubmit} className="mt-6 space-y-4 border-t border-border pt-4">
            <div>
              <label htmlFor="fullName" className="mb-1.5 block text-sm font-medium text-text-main">
                Ad Soyad
              </label>
              <div className="relative">
                <UserIcon className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
                <input
                  id="fullName"
                  name="fullName"
                  type="text"
                  defaultValue={user.fullName ?? ""}
                  className="w-full rounded-lg border border-border bg-neutral py-2 pl-9 pr-3 text-sm text-text-main focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary"
                />
              </div>
            </div>

            <div>
              <label htmlFor="phone" className="mb-1.5 block text-sm font-medium text-text-main">
                Telefon
              </label>
              <div className="relative">
                <Phone className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
                <input
                  id="phone"
                  name="phone"
                  type="tel"
                  defaultValue={user.phone ?? ""}
                  placeholder="+905551234567"
                  className="w-full rounded-lg border border-border bg-neutral py-2 pl-9 pr-3 text-sm text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary"
                />
              </div>
            </div>

            {formError && (
              <p className="rounded-lg bg-error/10 px-3 py-2 text-sm text-error">{formError}</p>
            )}

            <div className="flex gap-2">
              <button
                type="submit"
                disabled={updateUser.isPending}
                className="flex items-center gap-1.5 rounded-lg bg-tertiary px-4 py-2 text-sm font-semibold text-white hover:bg-tertiary/90 disabled:opacity-70"
              >
                <Check className="h-4 w-4" />
                {updateUser.isPending ? "Kaydediliyor..." : "Kaydet"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setIsEditing(false);
                  setFormError(null);
                }}
                className="flex items-center gap-1.5 rounded-lg border border-border px-4 py-2 text-sm font-medium text-text-main hover:bg-neutral"
              >
                <X className="h-4 w-4" />
                Vazgeç
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}