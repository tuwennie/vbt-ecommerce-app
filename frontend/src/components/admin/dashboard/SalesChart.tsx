"use client";

import {
  Bar,
  BarChart,
  ResponsiveContainer,
  XAxis,
  Tooltip,
  Cell,
} from "recharts";

const data = [
  { date: "01 MAY", value: 32 },
  { date: "04 MAY", value: 45 },
  { date: "07 MAY", value: 38 },
  { date: "10 MAY", value: 52 },
  { date: "14 MAY", value: 68 },
  { date: "17 MAY", value: 41 },
  { date: "21 MAY", value: 58 },
  { date: "24 MAY", value: 63 },
  { date: "28 MAY", value: 47 },
];

const HIGHLIGHT_DATE = "14 MAY";

export function SalesChart() {
  return (
    <div className="h-64 w-full">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data} barCategoryGap="30%">
          <XAxis
            dataKey="date"
            axisLine={false}
            tickLine={false}
            tick={{ fontSize: 11, fill: "var(--color-text-muted)" }}
            interval={1}
          />
          <Tooltip
            cursor={{ fill: "var(--color-neutral)" }}
            contentStyle={{
              borderRadius: 8,
              borderColor: "var(--color-border)",
              fontSize: 12,
            }}
          />
          <Bar dataKey="value" radius={[4, 4, 0, 0]}>
            {data.map((entry) => (
              <Cell
                key={entry.date}
                fill="var(--color-secondary)"
                fillOpacity={entry.date === HIGHLIGHT_DATE ? 1 : 0.25}
              />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}