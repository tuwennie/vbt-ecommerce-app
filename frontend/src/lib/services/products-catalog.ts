import type { components } from "@/types/api.generated";
import type { ApiErrorResponse } from "@/lib/api-error";

export type Product = components["schemas"]["Product"];

export interface CatalogProduct extends Product {
  originalPrice?: number;
  categorySlug: string;
}

export type SortOption = "name" | "-name" | "price" | "-price" | "createdAt" | "-createdAt";

export const SORT_OPTIONS: { value: SortOption; label: string }[] = [
  { value: "-createdAt", label: "En Yeni" },
  { value: "price", label: "Fiyat: Düşükten Yükseğe" },
  { value: "-price", label: "Fiyat: Yüksekten Düşüğe" },
  { value: "name", label: "İsim: A-Z" },
];

const MOCK_CATALOG: CatalogProduct[] = [
  { id: "prod_201", name: "Nordic Oak Dining Table", description: "Doğal meşe ahşaptan 6 kişilik yemek masası.", price: 849, originalPrice: 1200, currency: "TRY", stock: 5, isActive: true, categorySlug: "ev-ofis", category: { id: "cat_furniture", name: "Furniture", slug: "furniture", isActive: true }, images: [] },
  { id: "prod_202", name: "Velvet Accent Armchair", description: "Kadife kaplama, pirinç ayaklı koltuk.", price: 320, currency: "TRY", stock: 12, isActive: true, categorySlug: "ev-ofis", category: { id: "cat_seating", name: "Seating", slug: "seating", isActive: true }, images: [] },
  { id: "prod_203", name: "Modern Culinary Set (12-pc)", description: "12 parça modern mutfak gereçleri seti.", price: 149.5, currency: "TRY", stock: 20, isActive: true, categorySlug: "ev-ofis", category: { id: "cat_kitchenware", name: "Kitchenware", slug: "kitchenware", isActive: true }, images: [] },
  { id: "prod_204", name: "Geometric Glass Pendant", description: "Geometrik tasarımlı cam sarkıt aydınlatma.", price: 195, originalPrice: 245, currency: "TRY", stock: 8, isActive: true, categorySlug: "ev-ofis", category: { id: "cat_lighting", name: "Lighting", slug: "lighting", isActive: true }, images: [] },
  { id: "prod_205", name: "Terracotta Ceramic Trio", description: "El yapımı 3'lü terracotta vazo seti.", price: 85, currency: "TRY", stock: 15, isActive: true, categorySlug: "ev-ofis", category: { id: "cat_decor", name: "Decor", slug: "decor", isActive: true }, images: [] },
  { id: "prod_206", name: "Woven Merino Throw", description: "Merino yünden dokuma battaniye.", price: 125, currency: "TRY", stock: 18, isActive: true, categorySlug: "ev-ofis", category: { id: "cat_textiles", name: "Textiles", slug: "textiles", isActive: true }, images: [] },
  { id: "prod_207", name: "Industrial Walnut Bookshelf", description: "Endüstriyel stil, ceviz kaplamalı kitaplık.", price: 540, currency: "TRY", stock: 4, isActive: true, categorySlug: "ev-ofis", category: { id: "cat_furniture", name: "Furniture", slug: "furniture", isActive: true }, images: [] },
  { id: "prod_208", name: "Barista-Grade Espresso Maker", description: "Profesyonel seviye espresso makinesi.", price: 1299, currency: "TRY", stock: 3, isActive: true, categorySlug: "ev-ofis", category: { id: "cat_appliances", name: "Appliances", slug: "appliances", isActive: true }, images: [] },
  { id: "prod_101", name: "SonicFlow Wireless Headphones", description: "Aktif gürültü engelleme özellikli kablosuz kulaklık.", price: 3499, originalPrice: 4299, currency: "TRY", stock: 24, isActive: true, categorySlug: "elektronik", category: { id: "cat_audio", name: "Audio Pro", slug: "audio-pro", isActive: true }, images: [] },
  { id: "prod_102", name: "SwiftWatch Ultra G2", description: "Kalp ritmi ve uyku takibi yapan akıllı saat.", price: 7999, currency: "TRY", stock: 12, isActive: true, categorySlug: "elektronik", category: { id: "cat_wearables", name: "Wearables", slug: "wearables", isActive: true }, images: [] },
];

const CATEGORY_META: Record<string, { title: string; description: string }> = {
  "ev-ofis": { title: "Ev & Ofis", description: "Yaşam alanın için premium mobilya ve dekorasyon ürünlerini keşfet." },
  elektronik: { title: "Elektronik", description: "En yeni teknoloji ürünleri ve aksesuarlar." },
  moda: { title: "Moda", description: "Sezonun trend kıyafet ve aksesuarları." },
  guzellik: { title: "Güzellik", description: "Cilt bakımı ve kişisel bakım ürünleri." },
  spor: { title: "Spor", description: "Aktif yaşam için spor ekipmanları." },
  kitap: { title: "Kitap", description: "Bestseller ve öne çıkan kitaplar." },
};

export function getCategoryMeta(slug: string | null) {
  if (!slug) return { title: "Tüm Ürünler", description: "Tüm kategorilerdeki ürünleri keşfet." };
  return CATEGORY_META[slug] ?? { title: slug, description: "" };
}

export interface ListProductsParams {
  category?: string | null;
  search?: string | null;
  sort?: SortOption;
  page?: number;
  simulateError?: boolean;
}

export interface ListProductsResult {
  items: CatalogProduct[];
  page: number;
  totalPages: number;
}

// TODO: Backend hazır olunca gerçek GET /products isteğiyle değişecek.
// URL parametre adları (search, sort, page) zaten sözleşmeyle birebir aynı
// tutuldu; sadece `category` (slug) yerine backend'in beklediği `categoryId`
// çözümlemesi eklenecek.
export async function listProductsMock(
  params: ListProductsParams = {},
): Promise<ListProductsResult> {
  await new Promise((resolve) => setTimeout(resolve, 700));

  if (params.simulateError) {
    const error: ApiErrorResponse = {
      success: false,
      message: "Ürünler şu anda yüklenemedi. Lütfen tekrar deneyin.",
      statusCode: 500,
      status: "INTERNAL_SERVER_ERROR",
    };
    throw error;
  }

  let items = [...MOCK_CATALOG];

  if (params.category) {
    items = items.filter((p) => p.categorySlug === params.category);
  }

  if (params.search) {
    const term = params.search.toLowerCase();
    items = items.filter((p) => p.name?.toLowerCase().includes(term));
  }

  switch (params.sort) {
    case "price":
      items.sort((a, b) => (a.price ?? 0) - (b.price ?? 0));
      break;
    case "-price":
      items.sort((a, b) => (b.price ?? 0) - (a.price ?? 0));
      break;
    case "name":
      items.sort((a, b) => (a.name ?? "").localeCompare(b.name ?? ""));
      break;
    default:
      break;
  }

  return {
    items,
    page: params.page ?? 1,
    totalPages: 12,
  };
}