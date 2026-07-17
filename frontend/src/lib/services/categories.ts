import {
  Laptop2,
  Shirt,
  Armchair,
  Sparkles,
  Dumbbell,
  BookOpen,
  type LucideIcon,
} from "lucide-react";

export interface ShopCategory {
  slug: string;
  label: string;
  icon: LucideIcon;
}

// NOT: Bu liste şu an elle (mock) tanımlı — backend'in gerçek kategori
// seed'i hazır olunca GET /categories'ten dinamik çekilecek şekilde  güncellenecek 
export const SHOP_CATEGORIES: ShopCategory[] = [
  { slug: "elektronik", label: "Elektronik", icon: Laptop2 },
  { slug: "moda", label: "Moda", icon: Shirt },
  { slug: "ev-ofis", label: "Ev & Ofis", icon: Armchair },
  { slug: "guzellik", label: "Güzellik", icon: Sparkles },
  { slug: "spor", label: "Spor", icon: Dumbbell },
  { slug: "kitap", label: "Kitap", icon: BookOpen },
];

export function getCategoryLabel(slug: string | null): string {
  if (!slug) return "Tüm Ürünler";
  return SHOP_CATEGORIES.find((c) => c.slug === slug)?.label ?? slug;
}