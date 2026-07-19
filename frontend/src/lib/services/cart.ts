import { apiClient } from "@/lib/api-client";
import type { ApiErrorResponse } from "@/lib/api-error";
import type { components } from "@/types/api.generated";

export type Cart = components["schemas"]["Cart"];
export type CartItem = components["schemas"]["CartItem"];

// GEÇİCİ (workaround): Daha önce auth/products'ta gördüğümüz gibi backend
// bazı sayısal alanları (Prisma Decimal) string olarak dönebiliyor. Sepet
// toplamları için bu özellikle riskli (yanlış toplam gösterimi), bu yüzden
// burada da Number() ile güvenli dönüşüm + esnek zarf okuma yapıyoruz.
function toNumber(value: number | string | undefined): number {
  if (value === undefined) return 0;
  const numeric = typeof value === "string" ? Number(value) : value;
  return Number.isNaN(numeric) ? 0 : numeric;
}

function unwrapCart(raw: unknown): Cart {
  const candidate = raw as { data?: Cart; items?: CartItem[] };
  const cart = candidate?.data ?? (candidate as Cart);

  return {
    ...cart,
    items: (cart?.items ?? []).map((item) => ({
      ...item,
      unitPrice: toNumber(item.unitPrice),
      subtotal: toNumber(item.subtotal),
    })),
    total: toNumber(cart?.total),
  };
}

export async function getCart(): Promise<Cart> {
  const { data, error } = await apiClient.GET("/cart", {});

  if (error) {
    throw error as ApiErrorResponse;
  }

  return unwrapCart(data);
}

export async function addCartItem(productId: string, quantity: number): Promise<Cart> {
  const { data, error } = await apiClient.POST("/cart/items", {
    body: { productId, quantity },
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  return unwrapCart(data);
}

export async function updateCartItem(itemId: string, quantity: number): Promise<Cart> {
  const { data, error } = await apiClient.PUT("/cart/items/{itemId}", {
    params: { path: { itemId } },
    body: { quantity },
  });

  if (error) {
    throw error as ApiErrorResponse;
  }

  return unwrapCart(data);
}

export async function removeCartItem(itemId: string): Promise<void> {
  const { error } = await apiClient.DELETE("/cart/items/{itemId}", {
    params: { path: { itemId } },
  });

  if (error) {
    throw error as ApiErrorResponse;
  }
}