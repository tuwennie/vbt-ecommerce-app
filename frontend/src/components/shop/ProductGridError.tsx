import { AlertTriangle } from "lucide-react";

interface ProductGridErrorProps {
  message?: string;
  onRetry: () => void;
}

export function ProductGridError({ message, onRetry }: ProductGridErrorProps) {
  return (
    <div className="flex flex-col items-center justify-center rounded-xl border border-border bg-surface px-6 py-16 text-center">
      <span className="flex h-12 w-12 items-center justify-center rounded-full bg-error/10">
        <AlertTriangle className="h-6 w-6 text-error" />
      </span>
      <p className="mt-4 text-sm font-semibold text-text-main">Ürünler yüklenemedi</p>
      <p className="mt-1 max-w-sm text-sm text-text-muted">
        {message ?? "Bir şeyler ters gitti. Lütfen tekrar dene."}
      </p>
      <button
        type="button"
        onClick={onRetry}
        className="mt-4 rounded-lg bg-secondary px-4 py-2 text-sm font-semibold text-white hover:bg-secondary/90"
      >
        Tekrar Dene
      </button>
    </div>
  );
}