import type { components } from "@/types/api.generated";
import type { ApiErrorResponse } from "@/lib/api-error";

export type Product = components["schemas"]["Product"];

// NOT: Sözleşmede "eski fiyat / indirim" alanı yok (Product şemasında sadece
// tek bir `price` var). originalPrice sadece mock/UI amaçlı eklendi —
// backend'e sorulması gereken bir nokta: indirimli fiyat gösterimi API'den mi
// gelecek yoksa tamamen frontend/kampanya mantığı mı olacak?
export interface FeaturedProduct extends Product {
  originalPrice?: number;
}

const MOCK_FEATURED_PRODUCTS: FeaturedProduct[] = [
  {
    id: "prod_101",
    name: "SonicFlow Wireless Headphones",
    description: "Aktif gürültü engelleme özellikli kablosuz kulaklık.",
    price: 3499,
    originalPrice: 4299,
    currency: "TRY",
    stock: 24,
    isActive: true,
    category: { id: "cat_audio", name: "Audio Pro", slug: "audio-pro", isActive: true },
    images: [],
  },
  {
    id: "prod_102",
    name: "SwiftWatch Ultra G2",
    description: "Kalp ritmi ve uyku takibi yapan akıllı saat.",
    price: 7999,
    currency: "TRY",
    stock: 12,
    isActive: true,
    category: { id: "cat_wearables", name: "Wearables", slug: "wearables", isActive: true },
    images: [],
  },
  {
    id: "prod_103",
    name: "Apex Pro Mechanical Keyboard",
    description: "RGB aydınlatmalı mekanik oyuncu klavyesi.",
    price: 2150,
    originalPrice: 2800,
    currency: "TRY",
    stock: 8,
    isActive: true,
    category: { id: "cat_gaming", name: "Gaming", slug: "gaming", isActive: true },
    images: [],
  },
  {
    id: "prod_104",
    name: "Aura Smart Home Hub",
    description: "Ev otomasyonu için sesli asistan destekli hub.",
    price: 1890,
    currency: "TRY",
    stock: 30,
    isActive: true,
    category: { id: "cat_home", name: "Home Smart", slug: "home-smart", isActive: true },
    images: [],
  },
];

// TODO: Backend hazır olunca içeriği gerçek GET /products?featured=true
// isteğiyle değişecek. Dönüş tipi (FeaturedProduct[]) büyük ölçüde
// sözleşmeyle uyumlu olduğu için component tarafı neredeyse hiç değişmeyecek.
export async function getFeaturedProducts(options?: {
  simulateError?: boolean;
}): Promise<FeaturedProduct[]> {
  await new Promise((resolve) => setTimeout(resolve, 700));

  if (options?.simulateError) {
    const error: ApiErrorResponse = {
      success: false,
      message: "Ürünler şu anda yüklenemedi. Lütfen tekrar deneyin.",
      statusCode: 500,
      status: "INTERNAL_SERVER_ERROR",
    };
    throw error;
  }

  return MOCK_FEATURED_PRODUCTS;
}