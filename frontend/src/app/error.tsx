"use client";

import { useEffect } from "react";
import Link from "next/link";
import { AlertTriangle, RotateCcw, Home } from "lucide-react";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("Beklenmeyen uygulama hatası:", error);
  }, [error]);

  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-neutral px-4 text-center">
      <span className="flex h-16 w-16 items-center justify-center rounded-full bg-error/10">
        <AlertTriangle className="h-8 w-8 text-error" />
      </span>
      <h1 className="mt-4 text-xl font-bold text-text-main">Bir şeyler yanlış gitti</h1>
      <p className="mt-2 max-w-sm text-sm text-text-muted">
        Beklenmeyen bir hata oluştu. Bu durum genelde geçicidir — tekrar denemek çoğu zaman sorunu çözer.
      </p>

      <div className="mt-6 flex gap-3">
        <button type="button" onClick={() => reset()}
          className="flex items-center gap-2 rounded-lg bg-tertiary px-4 py-2.5 text-sm font-semibold text-white hover:bg-tertiary/90">
          <RotateCcw className="h-4 w-4" />
          Tekrar Dene
        </button>
        <Link href="/" className="flex items-center gap-2 rounded-lg border border-border px-4 py-2.5 text-sm font-medium text-text-main hover:bg-surface">
          <Home className="h-4 w-4" />
          Ana Sayfaya Dön
        </Link>
      </div>
    </div>
  );
}