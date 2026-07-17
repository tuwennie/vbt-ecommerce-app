"use client";

import { useState, type FormEvent } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { Mail, Lock, Eye, EyeOff, ArrowRight } from "lucide-react";
import { getApiErrorMessage, type ApiErrorResponse } from "@/lib/api-error";
import { login } from "@/lib/services/auth";
import { setAccessTokenCookie } from "@/lib/auth-token";

const NOT_ADMIN_ERROR: ApiErrorResponse = {
  success: false,
  message: "Bu hesabın yönetim paneline erişim yetkisi yok.",
  statusCode: 403,
  status: "FORBIDDEN",
};

export function LoginForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState<ApiErrorResponse | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError(null);
    setIsSubmitting(true);

    const formData = new FormData(event.currentTarget);
    const email = String(formData.get("email") ?? "").trim();
    const password = String(formData.get("password") ?? "");

    try {
      const auth = await login({ email, password });

      if (auth.user?.role !== "ADMIN") {
        setError(NOT_ADMIN_ERROR);
        setIsSubmitting(false);
        return;
      }

      setAccessTokenCookie(auth.accessToken ?? "", auth.expiresIn ?? 900);
      const redirectTo = searchParams.get("redirectTo") || "/admin/dashboard";
      router.push(redirectTo);
    } catch (err) {
      setError(err as ApiErrorResponse);
      setIsSubmitting(false);
    }
  }

  return (
    <form className="w-full max-w-sm" onSubmit={handleSubmit}>
      <h1 className="text-[clamp(1.125rem,4.5vw,1.5rem)] font-semibold text-text-main">
        Giriş Yap
      </h1>
      <p className="mt-1 text-[clamp(0.75rem,3vw,0.875rem)] text-text-muted">
        Yönetim paneline erişmek için bilgilerinizi girin.
      </p>

      <div className="mt-[clamp(1rem,4vw,1.5rem)]">
        <label
          htmlFor="email"
          className="mb-1.5 block text-[clamp(0.75rem,2.5vw,0.875rem)] font-medium text-text-main"
        >
          E-posta
        </label>
        <div className="relative">
          <Mail className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
          <input
            id="email"
            name="email"
            type="email"
            autoComplete="email"
            placeholder="ornek@shopswift.com"
            className="w-full rounded-lg border border-border bg-neutral py-[clamp(0.5rem,2vw,0.625rem)] pl-9 pr-3 text-[clamp(0.8125rem,3vw,0.875rem)] text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary"
          />
        </div>
      </div>

      <div className="mt-[clamp(0.75rem,3vw,1rem)]">
        <label
          htmlFor="password"
          className="mb-1.5 block text-[clamp(0.75rem,2.5vw,0.875rem)] font-medium text-text-main"
        >
          Şifre
        </label>
        <div className="relative">
          <Lock className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
          <input
            id="password"
            name="password"
            type={showPassword ? "text" : "password"}
            autoComplete="current-password"
            placeholder="••••••••"
            className="w-full rounded-lg border border-border bg-neutral py-[clamp(0.5rem,2vw,0.625rem)] pl-9 pr-9 text-[clamp(0.8125rem,3vw,0.875rem)] text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary"
          />
          <button
            type="button"
            onClick={() => setShowPassword((v) => !v)}
            aria-label={showPassword ? "Şifreyi gizle" : "Şifreyi göster"}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text-main"
          >
            {showPassword ? (
              <EyeOff className="h-4 w-4" />
            ) : (
              <Eye className="h-4 w-4" />
            )}
          </button>
        </div>
      </div>

      <div className="mt-[clamp(0.75rem,3vw,1rem)] flex items-center gap-2">
        <input
          id="remember"
          name="remember"
          type="checkbox"
          className="h-4 w-4 rounded border-border text-secondary focus:ring-secondary"
        />
        <label
          htmlFor="remember"
          className="text-[clamp(0.75rem,2.5vw,0.875rem)] text-text-main"
        >
          Beni hatırla
        </label>
      </div>

        {error && (
          <p data-testid="auth-error" className="mt-[clamp(0.75rem,3vw,1rem)] rounded-lg bg-error/10 px-3 py-2 text-[clamp(0.75rem,2.5vw,0.875rem)] text-error">
    {getApiErrorMessage(error)}
          </p>
        )}

      <button
        type="submit"
        disabled={isSubmitting}
        className="mt-[clamp(1rem,4vw,1.5rem)] flex w-full items-center justify-center gap-2 rounded-lg bg-tertiary py-[clamp(0.5rem,2vw,0.625rem)] text-[clamp(0.8125rem,3vw,0.875rem)] font-semibold text-white transition-colors hover:bg-tertiary/90 focus:outline-none focus:ring-2 focus:ring-tertiary focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-70"
      >
        {isSubmitting ? "Giriş yapılıyor..." : "Giriş Yap"}
        <ArrowRight className="h-4 w-4" />
      </button>

      <hr className="mt-[clamp(1rem,4vw,1.5rem)] border-border" />

      <div className="mt-[clamp(0.75rem,3vw,1rem)] flex flex-col items-center justify-center gap-2 text-[clamp(0.75rem,2.5vw,0.875rem)] text-text-muted sm:flex-row sm:gap-4">
        <a href="#" className="hover:text-text-main">
          Yardım ve Destek
        </a>
        <span className="hidden text-border sm:inline">|</span>
        <a href="#" className="hover:text-text-main">
          Güvenlik Politikası
        </a>
      </div>
    </form>
  );
}