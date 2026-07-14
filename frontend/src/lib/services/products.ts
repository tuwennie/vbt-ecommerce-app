import type { components } from "@/types/api.generated";

export type Product = components["schemas"]["Product"];

// TODO: Backend hazır olunca bu fonksiyonun içi gerçek fetch() ile değişecek.
// Dönüş tipi (Product[]) sözleşmeyle birebir aynı olduğu için component
// tarafında hiçbir şey değişmeyecek.
export async function listProductsMock(): Promise<Product[]> {
  return [
    {
      id: "prod_1",
      name: "Kablosuz Kulaklık",
      description: "Gürültü engelleme özellikli bluetooth kulaklık.",
      price: 899.9,
      currency: "TRY",
      stock: 50,
      isActive: true,
      category: { id: "cat_1", name: "Elektronik", slug: "elektronik", isActive: true },
      images: [],
    },
    {
      id: "prod_2",
      name: "Akıllı Saat",
      description: "Kalp ritmi ve uyku takibi yapan akıllı saat.",
      price: 2499,
      currency: "TRY",
      stock: 0,
      isActive: true,
      category: { id: "cat_1", name: "Elektronik", slug: "elektronik", isActive: true },
      images: [],
    },
    {
      id: "prod_3",
      name: "Termos",
      description: "600ml paslanmaz çelik termos.",
      price: 249.5,
      currency: "TRY",
      stock: 120,
      isActive: false,
      category: { id: "cat_2", name: "Ev & Yaşam", slug: "ev-yasam", isActive: true },
      images: [],
    },
  ];
}