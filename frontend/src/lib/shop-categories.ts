import {
  Laptop2,
  Shirt,
  Armchair,
  Sparkles,
  Dumbbell,
  BookOpen,
  Tag,
  type LucideIcon,
} from "lucide-react";

const ICONS_BY_SLUG: Record<string, LucideIcon> = {
  elektronik: Laptop2,
  moda: Shirt,
  "ev-ofis": Armchair,
  guzellik: Sparkles,
  spor: Dumbbell,
  kitap: BookOpen,
};

export function getCategoryIcon(slug: string | undefined): LucideIcon {
  if (!slug) return Tag;
  return ICONS_BY_SLUG[slug] ?? Tag;
}