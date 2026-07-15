"use client";

import { useState, type FormEvent } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Mail, Lock, User, Eye, EyeOff, ArrowRight } from "lucide-react";
import {
  getApiErrorMessage,
  type ApiErrorResponse,
  type ApiValidationErrorResponse,
} from "@/lib/api-error";

export function UserRegisterForm() {
  const router = useRouter();
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState<ApiErrorResponse | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError(null);
    setIsSubmitting(true);

    const formData = new FormData(event.currentTarget);
    const fullName = String(formData.get("fullName") ?? "").trim();
    const email = String(formData.get("email") ?? "").trim();
    // TODO: Backend entegrasyonunda POST /auth/register body'sine (email, password, fullName) eklenecek.
    void email;
    const password = String(formData.get("password") ?? "");
    const confirmPassword = String(formData.get("confirmPassword") ?? "");
    const acceptTerms = formData.get("acceptTerms") === "on";

    const validationErrors: { field: string; message: string }[] = [];

    if (fullName.length < 2) {
      validationErrors.push({ field: "fullName", message: "Ad Soyad en az 2 karakter olmalı." });
    }
    if (password.length < 8) {
      validationErrors.push({ field: "password", message: "Şifre en az 8 karakter olmalı." });
    }
    if (password !== confirmPassword) {
      validationErrors.push({ field: "confirmPassword", message: "Şifreler eşleşmiyor." });
    }
    if (!acceptTerms) {
      validationErrors.push({ field: "acceptTerms", message: "Devam etmek için şartları kabul etmelisin." });
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
      setIsSubmitting(false);
      return;
    }

    router.push("/");
  }

  return (
    <form className="w-full max-w-sm" onSubmit={handleSubmit}>
      <h1 className="text-[clamp(1.125rem,4.5vw,1.5rem)] font-semibold text-text-main">Kayıt Ol</h1>
      <p className="mt-1 text-[clamp(0.75rem,3vw,0.875rem)] text-text-muted">Alışverişe başlamak için hesap oluştur.</p>

      <div className="mt-[clamp(1rem,4vw,1.5rem)]">
        <label htmlFor="fullName" className="mb-1.5 block text-[clamp(0.75rem,2.5vw,0.875rem)] font-medium text-text-main">Ad Soyad</label>
        <div className="relative">
          <User className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
          <input id="fullName" name="fullName" type="text" autoComplete="name" placeholder="Ayşe Yılmaz"
            className="w-full rounded-lg border border-border bg-neutral py-[clamp(0.5rem,2vw,0.625rem)] pl-9 pr-3 text-[clamp(0.8125rem,3vw,0.875rem)] text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
        </div>
      </div>

      <div className="mt-[clamp(0.75rem,3vw,1rem)]">
        <label htmlFor="email" className="mb-1.5 block text-[clamp(0.75rem,2.5vw,0.875rem)] font-medium text-text-main">E-posta</label>
        <div className="relative">
          <Mail className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
          <input id="email" name="email" type="email" autoComplete="email" placeholder="ornek@mail.com"
            className="w-full rounded-lg border border-border bg-neutral py-[clamp(0.5rem,2vw,0.625rem)] pl-9 pr-3 text-[clamp(0.8125rem,3vw,0.875rem)] text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
        </div>
      </div>

      <div className="mt-[clamp(0.75rem,3vw,1rem)]">
        <label htmlFor="password" className="mb-1.5 block text-[clamp(0.75rem,2.5vw,0.875rem)] font-medium text-text-main">Şifre</label>
        <div className="relative">
          <Lock className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
          <input id="password" name="password" type={showPassword ? "text" : "password"} autoComplete="new-password" placeholder="En az 8 karakter"
            className="w-full rounded-lg border border-border bg-neutral py-[clamp(0.5rem,2vw,0.625rem)] pl-9 pr-9 text-[clamp(0.8125rem,3vw,0.875rem)] text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
          <button type="button" onClick={() => setShowPassword((v) => !v)} aria-label={showPassword ? "Şifreyi gizle" : "Şifreyi göster"}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text-main">
            {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
          </button>
        </div>
      </div>

      <div className="mt-[clamp(0.75rem,3vw,1rem)]">
        <label htmlFor="confirmPassword" className="mb-1.5 block text-[clamp(0.75rem,2.5vw,0.875rem)] font-medium text-text-main">Şifre Tekrar</label>
        <div className="relative">
          <Lock className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-text-muted" />
          <input id="confirmPassword" name="confirmPassword" type={showPassword ? "text" : "password"} autoComplete="new-password" placeholder="••••••••"
            className="w-full rounded-lg border border-border bg-neutral py-[clamp(0.5rem,2vw,0.625rem)] pl-9 pr-3 text-[clamp(0.8125rem,3vw,0.875rem)] text-text-main placeholder:text-text-muted focus:border-secondary focus:outline-none focus:ring-1 focus:ring-secondary" />
        </div>
      </div>

      <div className="mt-[clamp(0.75rem,3vw,1rem)] flex items-start gap-2">
        <input id="acceptTerms" name="acceptTerms" type="checkbox" className="mt-0.5 h-4 w-4 rounded border-border text-secondary focus:ring-secondary" />
        <label htmlFor="acceptTerms" className="text-[clamp(0.75rem,2.5vw,0.875rem)] text-text-main">
          <a href="#" className="text-secondary hover:underline">Kullanım Şartları</a>{"'"}nı ve{" "}
          <a href="#" className="text-secondary hover:underline">Gizlilik Politikası</a>{"'"}nı kabul ediyorum.
        </label>
      </div>

      {error && (
        <div className="mt-[clamp(0.75rem,3vw,1rem)] rounded-lg bg-error/10 px-3 py-2 text-[clamp(0.75rem,2.5vw,0.875rem)] text-error">
          <p>{getApiErrorMessage(error)}</p>
        </div>
      )}

      <button type="submit" disabled={isSubmitting}
        className="mt-[clamp(1rem,4vw,1.5rem)] flex w-full items-center justify-center gap-2 rounded-lg bg-tertiary py-[clamp(0.5rem,2vw,0.625rem)] text-[clamp(0.8125rem,3vw,0.875rem)] font-semibold text-white transition-colors hover:bg-tertiary/90 focus:outline-none focus:ring-2 focus:ring-tertiary focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-70">
        {isSubmitting ? "Kayıt oluşturuluyor..." : "Kayıt Ol"}
        <ArrowRight className="h-4 w-4" />
      </button>

      <p className="mt-[clamp(1rem,4vw,1.5rem)] text-center text-[clamp(0.75rem,2.5vw,0.875rem)] text-text-muted">
        Zaten hesabın var mı?{" "}
        <Link href="/login" className="font-medium text-secondary hover:underline">Giriş Yap</Link>
      </p>
    </form>
  );
}