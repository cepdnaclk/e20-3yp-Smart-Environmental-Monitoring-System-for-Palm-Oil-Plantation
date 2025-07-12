import React from "react";

type StatCardProps = {
  title: string;
  value: string | number;
  icon?: React.ReactNode;
  color?: string; // tailwind color e.g. 'bg-green-100'
};

export default function StatCard({ title, value, icon, color = "bg-gray-50" }: StatCardProps) {
  return (
    <div className={`flex items-center p-4 rounded-xl shadow-sm ${color}`}>
      {icon && <div className="mr-4 text-2xl">{icon}</div>}
      <div>
        <div className="text-sm text-gray-500">{title}</div>
        <div className="text-2xl font-bold text-gray-800">{value}</div>
      </div>
    </div>
  );
}
