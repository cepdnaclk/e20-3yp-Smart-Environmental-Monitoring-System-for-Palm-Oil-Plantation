import React from "react";
import { LineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from "recharts";

type Props = {
  data: { name: string; value: number }[];
  title: string;
  subtitle?: string;
  lineColor?: string;
  updated?: string;
};

export default function FieldChartCard({ data, title, subtitle, lineColor = "#2563eb", updated }: Props) {
  return (
    <div className="bg-white rounded-xl shadow p-6 flex flex-col h-full justify-between">
      <div>
        <div className="font-bold text-lg mb-2">{title}</div>
        <div className="text-gray-500 text-sm mb-3">{subtitle}</div>
        <ResponsiveContainer width="100%" height={180}>
          <LineChart data={data}>
            <CartesianGrid stroke="#e5e7eb" strokeDasharray="3 3" />
            <XAxis dataKey="name" fontSize={12} />
            <YAxis fontSize={12} />
            <Tooltip />
            <Line
              type="monotone"
              dataKey="value"
              stroke={lineColor}
              strokeWidth={3}
              dot={{ r: 4 }}
              activeDot={{ r: 6 }}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>
      {updated && (
        <div className="flex items-center gap-2 text-gray-400 text-xs mt-3">
          <span>🕒</span> updated {updated}
        </div>
      )}
    </div>
  );
}
