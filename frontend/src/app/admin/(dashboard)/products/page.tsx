import { listProductsMock } from "@/lib/services/products";

export default async function ProductsPage() {
  const products = await listProductsMock();

  return (
    <div className="rounded-xl border border-border bg-surface p-5">
      <div>
        <h1 className="text-xl font-semibold text-text-main">Ürünler</h1>
        <p className="mt-1 text-sm text-text-muted">
          Şu an mock servisten geliyor — backend hazır olunca{" "}
          <code className="rounded bg-neutral px-1 py-0.5 text-xs">listProductsMock()</code>{" "}
          fonksiyonunun içi gerçek isteğe çevrilecek, bu tablo değişmeyecek.
        </p>
      </div>

      <div className="mt-4 overflow-x-auto">
        <table className="w-full min-w-[560px] text-left text-sm">
          <thead>
            <tr className="border-b border-border text-xs uppercase tracking-wide text-text-muted">
              <th className="py-3 pr-4 font-medium">Ürün</th>
              <th className="py-3 pr-4 font-medium">Kategori</th>
              <th className="py-3 pr-4 font-medium">Fiyat</th>
              <th className="py-3 pr-4 font-medium">Stok</th>
              <th className="py-3 pr-0 font-medium">Durum</th>
            </tr>
          </thead>
          <tbody>
            {products.map((product) => (
              <tr key={product.id} className="border-b border-border last:border-0">
                <td className="py-3 pr-4 text-text-main">{product.name}</td>
                <td className="py-3 pr-4 text-text-muted">{product.category?.name ?? "—"}</td>
                <td className="py-3 pr-4 text-text-main">
                  {product.price?.toLocaleString("tr-TR", { style: "currency", currency: product.currency ?? "TRY" })}
                </td>
                <td className="py-3 pr-4">
                  <span className={(product.stock ?? 0) === 0 ? "text-error" : "text-text-main"}>
                    {product.stock ?? 0}
                  </span>
                </td>
                <td className="py-3 pr-0">
                  <span
                    className={`inline-flex rounded-md px-2 py-0.5 text-xs font-medium ${
                      product.isActive ? "bg-tertiary/10 text-tertiary" : "bg-text-muted/10 text-text-muted"
                    }`}
                  >
                    {product.isActive ? "AKTİF" : "PASİF"}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}