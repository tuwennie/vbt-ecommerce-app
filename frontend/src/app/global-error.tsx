"use client";

import { useEffect } from "react";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("Kritik uygulama hatası (kök layout):", error);
  }, [error]);

  return (
    <html lang="tr">
      <body
        style={{
          minHeight: "100vh",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          fontFamily: "system-ui, sans-serif",
          textAlign: "center",
          padding: "1.5rem",
          backgroundColor: "#F8FAFC",
        }}
      >
        <h1 style={{ fontSize: "1.25rem", fontWeight: 700, color: "#131B2E" }}>
          Bir şeyler yanlış gitti
        </h1>
        <p style={{ marginTop: "0.5rem", color: "#6B7280", maxWidth: "24rem" }}>
          Uygulama beklenmeyen bir hatayla karşılaştı. Lütfen sayfayı yenilemeyi dene.
        </p>
        <button
          type="button"
          onClick={() => reset()}
          style={{
            marginTop: "1.5rem",
            borderRadius: "0.5rem",
            backgroundColor: "#16A34A",
            color: "#FFFFFF",
            padding: "0.625rem 1.25rem",
            fontSize: "0.875rem",
            fontWeight: 600,
            border: "none",
            cursor: "pointer",
          }}
        >
          Tekrar Dene
        </button>
      </body>
    </html>
  );
}