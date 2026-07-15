export function ProductGridSkeleton({ count = 4 }: { count?: number }) {
  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
      {Array.from({ length: count }).map((_, i) => (
        <div key={i} className="animate-pulse overflow-hidden rounded-xl border border-border bg-surface">
          <div className="aspect-square bg-neutral" />
          <div className="space-y-2 p-4">
            <div className="h-3 w-1/3 rounded bg-neutral" />
            <div className="h-4 w-4/5 rounded bg-neutral" />
            <div className="h-4 w-1/3 rounded bg-neutral" />
            <div className="mt-3 h-9 w-full rounded-lg bg-neutral" />
          </div>
        </div>
      ))}
    </div>
  );
}