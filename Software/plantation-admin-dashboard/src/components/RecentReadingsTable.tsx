import React, { useState } from "react";

// Example data
type Reading = {
  estate: string;
  section: string;
  datetime: string;
};

const readings: Reading[] = [
  {
    estate: "Palm Estate 1",
    section: "Section A",
    datetime: "2024-07-10 09:15 AM",
  },
  {
    estate: "Palm Estate 2",
    section: "Section D",
    datetime: "2024-07-10 09:12 AM",
  },
  {
    estate: "Green Field",
    section: "North",
    datetime: "2024-07-10 08:55 AM",
  },
  {
    estate: "Palm Estate 1",
    section: "Section B",
    datetime: "2024-07-10 08:30 AM",
  },
  // Add more rows here to see the scroll & show all effect
  {
    estate: "Palm Estate 3",
    section: "Section F",
    datetime: "2024-07-10 08:20 AM",
  },
  {
    estate: "North Field",
    section: "East",
    datetime: "2024-07-10 08:15 AM",
  },
  {
    estate: "West Palm",
    section: "Block 3",
    datetime: "2024-07-10 08:10 AM",
  },
];

export default function RecentReadingsTable() {
    const [showAll, setShowAll] = useState(false);
    const VISIBLE_ROWS = 4;
    const visibleRows = showAll ? readings : readings.slice(0, VISIBLE_ROWS);
  
    return (
      <div className="bg-white rounded-2xl shadow p-6 mt-8">
        <div className="mb-2">
          <h2 className="text-2xl font-bold text-gray-800">Recent Readings</h2>
          <p className="text-gray-400 text-sm">Latest data from all estates</p>
        </div>
        <div className="overflow-x-auto">
          <div className={`${showAll ? "" : "max-h-64"} overflow-y-auto`}>
            <table className="min-w-full">
              <thead>
                <tr className="text-left text-gray-400 font-semibold text-sm">
                  <th className="py-3 pr-4">Estate</th>
                  <th className="py-3 pr-4">Section</th>
                  <th className="py-3 pr-4">Date & Time</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {visibleRows.map((r, i) => (
                  <tr key={i} className="border-t last:border-b border-gray-100 hover:bg-gray-50 transition">
                    <td className="py-4 pr-4 flex items-center gap-3">
                      <div className="bg-blue-100 rounded-lg w-10 h-10 flex items-center justify-center font-bold text-blue-500 text-lg">
                        {r.estate[0]}
                      </div>
                      <span className="text-gray-700 font-medium">{r.estate}</span>
                    </td>
                    <td className="py-4 pr-4 text-gray-600">{r.section}</td>
                    <td className="py-4 pr-4 text-gray-500">{r.datetime}</td>
                    <td className="py-4 text-right pr-1 text-gray-400 hover:text-gray-600 cursor-pointer">⋮</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          {readings.length > VISIBLE_ROWS && (
            <div className="flex justify-center mt-3">
              <button
                className="px-4 py-1 rounded-full bg-blue-50 hover:bg-blue-100 text-blue-700 font-medium text-sm shadow transition"
                onClick={() => setShowAll((prev) => !prev)}
              >
                {showAll ? "Show Less" : "Show All"}
              </button>
            </div>
          )}
        </div>
      </div>
    );
  }