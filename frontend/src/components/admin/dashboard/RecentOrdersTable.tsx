import { MoreVertical } from "lucide-react";

type OrderStatus = "COMPLETED" | "PENDING" | "CANCELLED";

interface Order {
  id: string;
  customer: string;
  amount: string;
  status: OrderStatus;
  date: string;
}

const orders: Order[] = [
  { id: "#SW-12402", customer: "Elena Rodriguez", amount: "₺340.50", status: "COMPLETED", date: "May 24, 2026" },
  { id: "#SW-12401", customer: "Mehmet K.", amount: "₺1,995.00", status: "PENDING", date: "May 24, 2026" },
  { id: "#SW-12400", customer: "Ayşe Yılmaz", amount: "₺89.90", status: "CANCELLED", date: "May 23, 2026" },
  { id: "#SW-12399", customer: "Can Demir", amount: "₺512.00", status: "COMPLETED", date: "May 23, 2026" },
];

const STATUS_STYLES: Record<OrderStatus, string> = {
  COMPLETED: "bg-tertiary/10 text-tertiary",
  PENDING: "bg-warning/10 text-warning",
  CANCELLED: "bg-error/10 text-error",
};

const AVATAR_COLORS = ["bg-secondary", "bg-tertiary", "bg-primary"];

function initialsOf(name: string) {
  return name.split(" ").map((part) => part[0]).slice(0, 2).join("").toUpperCase();
}

export function RecentOrdersTable() {
  return (
    <div className="overflow-x-auto">
      <table className="w-full min-w-[640px] text-left text-sm">
        <thead>
          <tr className="border-b border-border text-xs uppercase tracking-wide text-text-muted">
            <th className="py-3 pr-4 font-medium">Sipariş No</th>
            <th className="py-3 pr-4 font-medium">Müşteri</th>
            <th className="py-3 pr-4 font-medium">Tutar</th>
            <th className="py-3 pr-4 font-medium">Durum</th>
            <th className="py-3 pr-4 font-medium">Tarih</th>
            <th className="py-3 pr-0 text-right font-medium">Aksiyon</th>
          </tr>
        </thead>
        <tbody>
          {orders.map((order, index) => (
            <tr key={order.id} className="border-b border-border last:border-0">
              <td className="py-3 pr-4">
                <a href="#" className="font-medium text-secondary hover:underline">
                  {order.id}
                </a>
              </td>
              <td className="py-3 pr-4">
                <div className="flex items-center gap-2">
                  <span
                    className={`flex h-7 w-7 items-center justify-center rounded-full text-[11px] font-semibold text-white ${AVATAR_COLORS[index % AVATAR_COLORS.length]}`}
                  >
                    {initialsOf(order.customer)}
                  </span>
                  <span className="text-text-main">{order.customer}</span>
                </div>
              </td>
              <td className="py-3 pr-4 text-text-main">{order.amount}</td>
              <td className="py-3 pr-4">
                <span className={`inline-flex rounded-md px-2 py-0.5 text-xs font-medium ${STATUS_STYLES[order.status]}`}>
                  {order.status}
                </span>
              </td>
              <td className="py-3 pr-4 text-text-muted">{order.date}</td>
              <td className="py-3 pr-0 text-right">
                <button type="button" aria-label="Sipariş aksiyonları" className="text-text-muted hover:text-text-main">
                  <MoreVertical className="h-4 w-4" />
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}