import React from "react";
import { LineChart, Line, BarChart, Bar, Tooltip, ResponsiveContainer } from "recharts";

type StatChartCardProps = {
  icon: React.ReactNode;
  title: string;
  value: string | number;
  chartType?: "line" | "bar";
  chartData: { value: number }[];
  color?: string;
  chartColor?: string;
  unit?: string;
};

export default function StatChartCard({
  icon,
  title,
  value,
  chartType = "line",
  chartData,
  color = "bg-white",
  chartColor = "#2563eb",
  unit
}: StatChartCardProps) {
  return (
    <div className={`rounded-2xl p-6 flex flex-col justify-between min-h-[180px] w-full ${color}
      shadow transition-all duration-200
      hover:shadow-xl hover:scale-[1.04] cursor-pointer
    `}>
      {/* Top Row: Icon, Title, More menu */}
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-2">
          <span className="">{icon}</span>
          <span className="text-lg font-medium text-gray-700">{title}</span>
        </div>
        <span className="text-gray-400 text-lg font-bold">⋮</span>
      </div>
      {/* Middle: Value and Chart, neatly aligned */}
      <div className="flex flex-row items-end justify-between flex-1">
        <div className="flex flex-col justify-end mb-1">
          <span className="text-4xl font-extrabold text-gray-800 leading-none">{value}{unit && <span className="text-2xl font-bold">{unit}</span>}</span>
        </div>
        <div className="h-14 w-28 flex items-end ml-2">
          <ResponsiveContainer width="100%" height="100%">
            {chartType === "line" ? (
              <LineChart data={chartData}>
                <Tooltip
                  wrapperClassName="!rounded-xl !bg-white !px-3 !py-1 !shadow-xl !border"
                  contentStyle={{ borderRadius: '12px', fontSize: '14px' }}
                  labelFormatter={() => ""}
                  formatter={(value: number) => [`${value}`, "Value"]}
                />
                <Line type="monotone" dataKey="value" stroke={chartColor} strokeWidth={3} dot={false} />
              </LineChart>
            ) : (
              <BarChart data={chartData}>
                <Tooltip
                  wrapperClassName="!rounded-xl !bg-white !px-3 !py-1 !shadow-xl !border"
                  contentStyle={{ borderRadius: '12px', fontSize: '14px' }}
                  labelFormatter={() => ""}
                  formatter={(value: number) => [`${value}`, "Value"]}
                />
                <Bar dataKey="value" fill={chartColor} radius={[6, 6, 0, 0]} />
              </BarChart>
            )}
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}
