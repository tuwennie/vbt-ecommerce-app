import {
  LayoutGrid,
  ShoppingCart,
  Package,
  Workflow,
  Users,
  BarChart3,
  Settings,
  type LucideIcon,
} from "lucide-react";

export interface NavItem {
  label: string;
  href: string;
  icon: LucideIcon;
}

export const NAV_ITEMS: NavItem[] = [
  { label: "Kontrol Paneli", href: "/admin/dashboard", icon: LayoutGrid },
  { label: "Siparişler", href: "/admin/orders", icon: ShoppingCart },
  { label: "Ürünler", href: "/admin/products", icon: Package },
  { label: "Kategoriler", href: "/admin/categories", icon: Workflow },
  { label: "Müşteriler", href: "/admin/customers", icon: Users },
  { label: "Raporlar", href: "/admin/reports", icon: BarChart3 },
  { label: "Ayarlar", href: "/admin/settings", icon: Settings },
];