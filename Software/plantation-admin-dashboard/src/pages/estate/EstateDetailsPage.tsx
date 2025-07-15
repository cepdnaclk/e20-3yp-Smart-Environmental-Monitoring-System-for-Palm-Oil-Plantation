// import React, { useState } from "react";
// import { useParams } from "react-router-dom";
// import EstateSidebar from "../../components/EstateSidebar";
// import FieldChartCard from "../../components/FieldChartCard";

// // --- Example Data ---
// const estates = [
//   {
//     id: "e6jApQOvbm3Aa3GL47sa",
//     name: "Homadola",
//     description: "Area: 15 acres. Humid climate. Best for oil palm.",
//     imageUrl: "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
//     location: "Southern Province, Sri Lanka",
//     manager: "Mr. Ruwan Fernando",
//     lastUpdated: "2025-07-13 16:00",
//     numSections: 2,
//     totalFields: 3,
//     sections: [
//       {
//         id: 1,
//         name: "Section A",
//         fields: [
//           { id: 101, name: "Field 1" },
//           { id: 102, name: "Field 2" }
//         ]
//       },
//       {
//         id: 2,
//         name: "Section B",
//         fields: [
//           { id: 201, name: "Field 3" }
//         ]
//       }
//     ]
//   },
//   {
//     id: "state2",
//     name: "Nakiadeniya",
//     description: "Area: 20 acres. Flat terrain. Good for coconut intercropping.",
//     imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
//     location: "Western Province, Sri Lanka",
//     manager: "Ms. Sanduni Jayasinghe",
//     lastUpdated: "2025-07-12 10:30",
//     numSections: 2,
//     totalFields: 3,
//     sections: [
//       {
//         id: 3,
//         name: "Section X",
//         fields: [
//           { id: 301, name: "Field Alpha" },
//           { id: 302, name: "Field Beta" }
//         ]
//       },
//       {
//         id: 4,
//         name: "Section Y",
//         fields: [
//           { id: 401, name: "Field Gamma" }
//         ]
//       }
//     ]
//   },
//   {
//     id: "state3",
//     name: "Mahaweli",
//     description: "Area: 30 acres. Fertile soil. Regular rainfall.",
//     imageUrl: "https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=400&q=80",
//     location: "Central Province, Sri Lanka",
//     manager: "Eng. Dilan Perera",
//     lastUpdated: "2025-07-14 09:20",
//     numSections: 1,
//     totalFields: 2,
//     sections: [
//       {
//         id: 5,
//         name: "Section Q",
//         fields: [
//           { id: 501, name: "Field East" },
//           { id: 502, name: "Field West" }
//         ]
//       }
//     ]
//   }
// ];

// // --- Mock Data: One set of data per field ---
// const fieldCharts = {
//   101: {
//     N: [
//       { name: "Apr", value: 100 },
//       { name: "May", value: 110 },
//       { name: "Jun", value: 150 },
//       { name: "Jul", value: 170 },
//       { name: "Aug", value: 140 },
//       { name: "Sep", value: 200 },
//       { name: "Oct", value: 180 },
//     ],
//     // Add more data types as needed...
//   },
//   102: { N: [/* ... */] },
//   201: { N: [/* ... */] },
//   301: { N: [/* ... */] },
//   302: { N: [/* ... */] },
//   401: { N: [/* ... */] },
//   501: { N: [/* ... */] },
//   502: { N: [/* ... */] }
// };

// // Helper: Find section and field for breadcrumbs
// function findSectionAndField(sections: any[], selectedSectionId: number | null, selectedFieldId: number | null) {
//   const section = sections.find(sec => sec.id === selectedSectionId);
//   const field = section?.fields.find(f => f.id === selectedFieldId) || null;
//   return { section, field };
// }

// export default function EstateDetailsPage() {
//   const { estateId } = useParams();
//   const estate = estates.find(e => e.id === estateId);

//   // State for which section/field is selected
//   const [selectedSectionId, setSelectedSectionId] = useState<number | null>(null);
//   const [selectedFieldId, setSelectedFieldId] = useState<number | null>(null);

//   if (!estate) {
//     return <div className="p-10 text-red-600">Estate not found.</div>;
//   }

//   const { section, field } = findSectionAndField(
//     estate.sections,
//     selectedSectionId,
//     selectedFieldId
//   );

//   return (
//     <div className="flex min-h-screen bg-gray-50">
//       <EstateSidebar
//         title={`${estate.name} Sections`}
//         sections={estate.sections}
//         selectedSectionId={selectedSectionId}
//         selectedFieldId={selectedFieldId}
//         onSelect={(sectionId, fieldId) => {
//           setSelectedSectionId(sectionId);
//           setSelectedFieldId(fieldId);
//         }}
//       />
//       <main className="flex-1 p-8">
//         {/* Estate Info (always at top) */}
//         <div className="flex flex-col gap-3 mb-2">
//           <div className="flex items-center gap-6">
//             <img src={estate.imageUrl} alt={estate.name} className="w-24 h-24 rounded-2xl object-cover" />
//             <div>
//               <h1 className="text-3xl font-bold">{estate.name} Sections</h1>
//               <div className="text-gray-500">{estate.description}</div>
//             </div>
//           </div>
//           <div className="bg-white rounded-xl shadow flex flex-wrap md:flex-nowrap gap-6 px-8 py-6 my-2 items-center">
//             <div className="flex-1">
//               <div className="text-sm text-gray-400 font-semibold mb-1">Estate Manager</div>
//               <div className="font-bold text-lg mb-2">{estate.manager}</div>
//               <div className="text-gray-500 mb-1">
//                 <span className="font-semibold">Location:</span> {estate.location}
//               </div>
//               <div className="text-gray-500 mb-1">
//                 <span className="font-semibold">Sections:</span> {estate.numSections}
//                 &nbsp; • &nbsp;
//                 <span className="font-semibold">Fields:</span> {estate.totalFields}
//               </div>
//             </div>
//             <div className="flex flex-col items-end text-right flex-shrink-0">
//               <div className="text-gray-500 text-sm mb-2">Last Updated</div>
//               <div className="font-mono bg-gray-100 rounded px-3 py-1 text-xs text-gray-700">
//                 {estate.lastUpdated}
//               </div>
//             </div>
//           </div>
//         </div>

//         {/* Breadcrumbs & Open in Map, only if a field is selected */}
//         {selectedFieldId && (
//           <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-8 mt-2">
//             <div className="flex items-center gap-2 mb-2 md:mb-0">
//               <span className="text-gray-500 font-semibold">{estate.name}</span>
//               {section && (
//                 <>
//                   <span className="text-gray-400">/</span>
//                   <span className="text-gray-500">{section.name}</span>
//                 </>
//               )}
//               {field && (
//                 <>
//                   <span className="text-gray-400">/</span>
//                   <span className="border-b-4 border-blue-900 font-bold text-blue-900 px-1 pb-1">
//                     {field.name}
//                   </span>
//                 </>
//               )}
//             </div>
//             <button
//               className="px-6 py-3 rounded-lg bg-green-600 text-white font-semibold shadow hover:bg-green-700 transition"
//             >
//               Open in map
//             </button>
//           </div>
//         )}

//         {/* Field Details and Charts */}
//         {selectedFieldId && fieldCharts[selectedFieldId] && (
//           <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
//             <FieldChartCard
//               title="Nitrogen (N)"
//               data={fieldCharts[selectedFieldId]?.N ?? []}
//               lineColor="#3b82f6"
//               subtitle="Variation in Nitrogen content"
//               updated="4 min ago"
//             />
//             {/* Add more FieldChartCards as needed (P, K, Rainfall, etc.) */}
//           </div>
//         )}
//       </main>
//     </div>
//   );
// }


import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import EstateSidebar from "../../components/EstateSidebar";
import FieldChartCard from "../../components/FieldChartCard";
import { fetchFieldReadings, fetchSections, fetchStateDetails } from "../../services/FirestoreEstateServices";
import { useNavigate } from "react-router-dom";


import homadolaImg from "../../assets/homadola.jpg";
import estate2Img from "../../assets/estate2.jpg";
import talangahaImg from "../../assets/WhatsApp Image 2025-07-13 at 10.27.51_08b3aa04.jpg";

const estateImageMap: Record<string, string> = {
  "e6jApQOvbm3Aa3GL47sa": homadolaImg,
  "state2": estate2Img,
  "state3": talangahaImg,
};

// // --- Example Data ---
// const estates = [
//   {
//     id: "e6jApQOvbm3Aa3GL47sa",
//     name: "Homadola",
//     description: "Area: 15 acres. Humid climate. Best for oil palm.",
//     imageUrl: homadolaImg,
//     location: "Southern Province, Sri Lanka",
//     manager: "Mr. Ruwan Fernando",
//     lastUpdated: "2025-07-13 16:00",
//     numSections: 2,
//     totalFields: 3,
//     sections: [
//       {
//         id: 1,
//         name: "Section A",
//         fields: [
//           { id: 101, name: "Field 1" },
//           { id: 102, name: "Field 2" }
//         ]
//       },
//       {
//         id: 2,
//         name: "Section B",
//         fields: [
//           { id: 201, name: "Field 3" }
//         ]
//       }
//     ]
//   },
//   {
//     id: "state2",
//     name: "Nakiadeniya",
//     description: "Area: 20 acres. Flat terrain. Good for coconut intercropping.",
//     imageUrl: estate2Img ,
//     location: "Western Province, Sri Lanka",
//     manager: "Ms. Sanduni Jayasinghe",
//     lastUpdated: "2025-07-12 10:30",
//     numSections: 2,
//     totalFields: 3,
//     sections: [
//       {
//         id: 3,
//         name: "Section X",
//         fields: [
//           { id: 301, name: "Field Alpha" },
//           { id: 302, name: "Field Beta" }
//         ]
//       },
//       {
//         id: 4,
//         name: "Section Y",
//         fields: [
//           { id: 401, name: "Field Gamma" }
//         ]
//       }
//     ]
//   },
//   {
//     id: "state3",
//     name: "Talangaha",
//     description: "Area: 30 acres. Fertile soil. Regular rainfall.",
//     imageUrl: talangahaImg,
//     location: "Central Province, Sri Lanka",
//     manager: "Eng. Dilan Perera",
//     lastUpdated: "2025-07-14 09:20",
//     numSections: 1,
//     totalFields: 2,
//     sections: [
//       {
//         id: 5,
//         name: "Section Q",
//         fields: [
//           { id: 501, name: "Field East" },
//           { id: 502, name: "Field West" }
//         ]
//       }
//     ]
//   }
// ];



export default function EstateDetailsPage() {
  const { estateId } = useParams<{ estateId: string }>();
  const [estate, setEstate] = useState<any>(null);
  const [sections, setSections] = useState<any[]>([]);
  const [selectedSectionId, setSelectedSectionId] = useState<number | null>(null);
  const [selectedFieldId, setSelectedFieldId] = useState<number | null>(null);
  const [fieldReadings, setFieldReadings] = useState<any[]>([]);
  const navigate = useNavigate();


  useEffect(() => {
  if (estateId && selectedSectionId && selectedFieldId) {
    const sectionId = selectedSectionId.toString();
    const fieldId = selectedFieldId.toString();

    fetchFieldReadings(estateId, sectionId, fieldId).then(setFieldReadings);
  }
}, [estateId, selectedSectionId, selectedFieldId]);

  useEffect(() => {
    if (estateId) {
      fetchStateDetails(estateId).then(setEstate);
      fetchSections(estateId).then(setSections);
    }
  }, [estateId]);

  const section = sections.find(s => s.id === selectedSectionId);
  const field = section?.fields.find((f: { id: number | null; }) => f.id === selectedFieldId);

  if (!estate) return <div className="p-10 text-gray-600">Loading estate...</div>;

  return (
    <div className="flex min-h-screen bg-gray-50">
      <EstateSidebar
        title={`${estate.stateName} Sections`}
        sections={sections}
        selectedSectionId={selectedSectionId}
        selectedFieldId={selectedFieldId}
        onSelect={(sectionId, fieldId) => {
          setSelectedSectionId(sectionId);
          setSelectedFieldId(fieldId);
        }}
      />
      <main className="flex-1 p-8">
        {/* Estate Info */}
        <div className="flex flex-col gap-3 mb-2">
          <div className="flex items-center gap-6">
            <img
              src={estateImageMap[estateId] || "https://via.placeholder.com/100x100?text=No+Image"}
              alt={estate.stateName}
              className="w-24 h-24 rounded-2xl object-cover"
            />
            <div>
              <h1 className="text-3xl font-bold">{estate.stateName} Sections</h1>
              <div className="text-gray-500">{estate.description}</div>
            </div>
          </div>
          <div className="bg-white rounded-xl shadow flex flex-wrap md:flex-nowrap gap-6 px-8 py-6 my-2 items-center">
            <div className="flex-1">
              <div className="text-sm text-gray-400 font-semibold mb-1">Estate Manager</div>
              <div className="font-bold text-lg mb-2">{estate.manager}</div>
              <div className="text-gray-500 mb-1">
                <span className="font-semibold">Location:</span> {estate.location}
              </div>
              <div className="text-gray-500 mb-1">
                <span className="font-semibold">Sections:</span> {sections.length}
                &nbsp; • &nbsp;
                <span className="font-semibold">Fields:</span> {sections.reduce((acc, s) => acc + (s.fields?.length || 0), 0)}
              </div>
            </div>
          </div>
        </div>

        {/* Breadcrumbs */}
        {selectedFieldId && section && field && (
          <div className="flex justify-between mb-6">
            <div className="text-gray-500 font-semibold">
              {estate.stateName} / {section.name} / <span className="font-bold text-blue-900">{field.name}</span>
            </div>
            {/* <button className="px-6 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition">Open in Map</button> */}
            <button
              onClick={() => navigate("/map")}
              className="px-6 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition"
            >
              Open in Map
            </button>

          </div>
        )}

        {/* Charts */}
        {/* {selectedFieldId && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <FieldChartCard
              title="Nitrogen (N)"
              data={[]} // TODO: Replace with real chart data
              lineColor="#3b82f6"
              subtitle="Variation in Nitrogen content"
              updated="Just now"
            />
          </div>
        )} */}
        {selectedFieldId && fieldReadings.length > 0 && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <FieldChartCard
              title="Nitrogen (N)"
              data={fieldReadings.map(r => ({ name: r.timestamp.toLocaleDateString(), value: r.nitrogen }))}
              lineColor="#3b82f6"
              subtitle="Variation in Nitrogen content"
              updated="Just now"
            />
            <FieldChartCard
              title="Phosphorus (P)"
              data={fieldReadings.map(r => ({ name: r.timestamp.toLocaleDateString(), value: r.phosphorus }))}
              lineColor="#10b981"
              subtitle="Variation in Phosphorus content"
              updated="Just now"
            />
            <FieldChartCard
              title="Potassium (K)"
              data={fieldReadings.map(r => ({ name: r.timestamp.toLocaleDateString(), value: r.potassium }))}
              lineColor="#f59e0b"
              subtitle="Variation in Potassium content"
              updated="Just now"
            />
            <FieldChartCard
              title="Soil Moisture"
              data={fieldReadings.map(r => ({ name: r.timestamp.toLocaleDateString(), value: r.soilMoisture }))}
              lineColor="#6366f1"
              subtitle="Soil moisture level over time"
              updated="Just now"
            />
          </div>
        )}

      </main>
    </div>
  );
}
