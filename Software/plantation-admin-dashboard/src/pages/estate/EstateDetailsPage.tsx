// import React, { useEffect, useState } from "react";
// import { useParams } from "react-router-dom";
// import EstateSidebar from "../../components/EstateSidebar";
// import FieldChartCard from "../../components/FieldChartCard";
// import { fetchFieldReadings, fetchSections, fetchStateDetails } from "../../services/FirestoreEstateServices";
// import { useNavigate } from "react-router-dom";


// import homadolaImg from "../../assets/homadola.jpg";
// import estate2Img from "../../assets/estate2.jpg";
// import talangahaImg from "../../assets/WhatsApp Image 2025-07-13 at 10.27.51_08b3aa04.jpg";

// const estateImageMap: Record<string, string> = {
//   "e6jApQOvbm3Aa3GL47sa": homadolaImg,
//   "state2": estate2Img,
//   "state3": talangahaImg,
// };

// export default function EstateDetailsPage() {
//   const { estateId } = useParams<{ estateId: string }>();
//   const [estate, setEstate] = useState<any>(null);
//   const [sections, setSections] = useState<any[]>([]);
//   const [selectedSectionId, setSelectedSectionId] = useState<number | null>(null);
//   const [selectedFieldId, setSelectedFieldId] = useState<number | null>(null);
//   const [fieldReadings, setFieldReadings] = useState<any[]>([]);
//   const navigate = useNavigate();


//   useEffect(() => {
//   if (estateId && selectedSectionId && selectedFieldId) {
//     const sectionId = selectedSectionId.toString();
//     const fieldId = selectedFieldId.toString();

//     fetchFieldReadings(estateId, sectionId, fieldId).then(setFieldReadings);
//   }
// }, [estateId, selectedSectionId, selectedFieldId]);

//   useEffect(() => {
//     if (estateId) {
//       fetchStateDetails(estateId).then(setEstate);
//       fetchSections(estateId).then(setSections);
//     }
//   }, [estateId]);

//   const section = sections.find(s => s.id === selectedSectionId);
//   const field = section?.fields.find((f: { id: number | null; }) => f.id === selectedFieldId);

//   if (!estate) return <div className="p-10 text-gray-600">Loading estate...</div>;

//   return (
//     <div className="flex min-h-screen bg-gray-50">
//       <EstateSidebar
//         title={`${estate.stateName} Sections`}
//         sections={sections}
//         selectedSectionId={selectedSectionId}
//         selectedFieldId={selectedFieldId}
//         onSelect={(sectionId, fieldId) => {
//           setSelectedSectionId(sectionId);
//           setSelectedFieldId(fieldId);
//         }}
//       />
//       <main className="flex-1 p-8">
//         {/* Estate Info */}
//         <div className="flex flex-col gap-3 mb-2">
//           <div className="flex items-center gap-6">
//             <img
//               src={estateImageMap[estateId] || "https://via.placeholder.com/100x100?text=No+Image"}
//               alt={estate.stateName}
//               className="w-24 h-24 rounded-2xl object-cover"
//             />
//             <div>
//               <h1 className="text-3xl font-bold">{estate.stateName} Sections</h1>
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
//                 <span className="font-semibold">Sections:</span> {sections.length}
//                 &nbsp; • &nbsp;
//                 <span className="font-semibold">Fields:</span> {sections.reduce((acc, s) => acc + (s.fields?.length || 0), 0)}
//               </div>
//             </div>
//           </div>
//         </div>

//         {/* Breadcrumbs */}
//         {selectedFieldId && section && field && (
//           <div className="flex justify-between mb-6">
//             <div className="text-gray-500 font-semibold">
//               {estate.stateName} / {section.name} / <span className="font-bold text-blue-900">{field.name}</span>
//             </div>
//             {/* <button className="px-6 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition">Open in Map</button> */}
//             <button
//               onClick={() => navigate("/map")}
//               className="px-6 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition"
//             >
//               Open in Map
//             </button>

//           </div>
//         )}

//         {/* Charts */}
//         {/* {selectedFieldId && (
//           <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
//             <FieldChartCard
//               title="Nitrogen (N)"
//               data={[]} // TODO: Replace with real chart data
//               lineColor="#3b82f6"
//               subtitle="Variation in Nitrogen content"
//               updated="Just now"
//             />
//           </div>
//         )} */}
//         {selectedFieldId && fieldReadings.length > 0 && (
//           <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
//             <FieldChartCard
//               title="Nitrogen (N)"
//               data={fieldReadings.map(r => ({ name: r.timestamp.toLocaleDateString(), value: r.nitrogen }))}
//               lineColor="#3b82f6"
//               subtitle="Variation in Nitrogen content"
//               updated="Just now"
//             />
//             <FieldChartCard
//               title="Phosphorus (P)"
//               data={fieldReadings.map(r => ({ name: r.timestamp.toLocaleDateString(), value: r.phosphorus }))}
//               lineColor="#10b981"
//               subtitle="Variation in Phosphorus content"
//               updated="Just now"
//             />
//             <FieldChartCard
//               title="Potassium (K)"
//               data={fieldReadings.map(r => ({ name: r.timestamp.toLocaleDateString(), value: r.potassium }))}
//               lineColor="#f59e0b"
//               subtitle="Variation in Potassium content"
//               updated="Just now"
//             />
//             <FieldChartCard
//               title="Soil Moisture"
//               data={fieldReadings.map(r => ({ name: r.timestamp.toLocaleDateString(), value: r.soilMoisture }))}
//               lineColor="#6366f1"
//               subtitle="Soil moisture level over time"
//               updated="Just now"
//             />
//           </div>
//         )}

//       </main>
//     </div>
//   );
// }


import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import EstateSidebar from "../../components/EstateSidebar";
import FieldChartCard from "../../components/FieldChartCard";
import {
  fetchFieldReadings,
  fetchSections,
  fetchStateDetails,
  prepareChartData,
} from "../../services/FirestoreEstateServices";

import homadolaImg from "../../assets/homadola.jpg";
import estate2Img from "../../assets/estate2.jpg";
import talangahaImg from "../../assets/WhatsApp Image 2025-07-13 at 10.27.51_08b3aa04.jpg";

const estateImageMap: Record<string, string> = {
  "e6jApQOvbm3Aa3GL47sa": homadolaImg,
  state2: estate2Img,
  state3: talangahaImg,
};

export default function EstateDetailsPage() {
  const { estateId } = useParams<{ estateId: string }>();
  const [estate, setEstate] = useState<any>(null);
  const [sections, setSections] = useState<any[]>([]);
  const [selectedSectionId, setSelectedSectionId] = useState<number | null>(null);
  const [selectedFieldId, setSelectedFieldId] = useState<number | null>(null);
  const [fieldReadings, setFieldReadings] = useState<any[]>([]);
  const [updated, setUpdated] = useState<string>("");
  const navigate = useNavigate();

  useEffect(() => {
    if (estateId && selectedSectionId && selectedFieldId) {
      const sectionId = selectedSectionId.toString();
      const fieldId = selectedFieldId.toString();

      fetchFieldReadings(estateId, sectionId, fieldId).then(data => {
        setFieldReadings(data);
        setUpdated(new Date().toLocaleTimeString());
      });
    }
  }, [estateId, selectedSectionId, selectedFieldId]);

  useEffect(() => {
    if (estateId) {
      fetchStateDetails(estateId).then(setEstate);
      fetchSections(estateId).then(setSections);
    }
  }, [estateId]);

  const section = sections.find(s => s.id === selectedSectionId);
  const field = section?.fields.find((f: { id: number | null }) => f.id === selectedFieldId);

  if (!estate) return <div className="p-10 text-gray-600">Loading estate...</div>;

  return (
    <div className="flex min-h-screen bg-gray-50">
      {/* Sidebar */}
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

      {/* Main */}
      <main className="flex-1 p-8">
        {/* Estate Info */}
        <div className="flex flex-col gap-3 mb-2">
          <div className="flex items-center gap-6">
            <img
              src={
                estateImageMap[estateId!] ||
                "https://via.placeholder.com/100x100?text=No+Image"
              }
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
              <div className="text-sm text-gray-400 font-semibold mb-1">
                Estate Manager
              </div>
              <div className="font-bold text-lg mb-2">{estate.manager}</div>
              <div className="text-gray-500 mb-1">
                <span className="font-semibold">Location:</span> {estate.location}
              </div>
              <div className="text-gray-500 mb-1">
                <span className="font-semibold">Sections:</span> {sections.length}
                &nbsp; • &nbsp;
                <span className="font-semibold">Fields:</span>{" "}
                {sections.reduce((acc, s) => acc + (s.fields?.length || 0), 0)}
              </div>
            </div>
          </div>
        </div>

        {/* Breadcrumbs */}
        {selectedFieldId && section && field && (
          <div className="flex justify-between mb-6">
            <div className="text-gray-500 font-semibold">
              {estate.stateName} / {section.name} /{" "}
              <span className="font-bold text-blue-900">{field.name}</span>
            </div>
            <button
              onClick={() => navigate("/map")}
              className="px-6 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition"
            >
              Open in Map
            </button>
          </div>
        )}

        {/* Charts */}
        {selectedFieldId && fieldReadings.length > 0 && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <FieldChartCard
              title="Nitrogen (N)"
              data={prepareChartData(fieldReadings, "nitrogen")}
              lineColor="#3b82f6"
              subtitle="Variation in Nitrogen content"
              updated={updated}
            />
            <FieldChartCard
              title="Phosphorus (P)"
              data={prepareChartData(fieldReadings, "phosphorus")}
              lineColor="#10b981"
              subtitle="Variation in Phosphorus content"
              updated={updated}
            />
            <FieldChartCard
              title="Potassium (K)"
              data={prepareChartData(fieldReadings, "potassium")}
              lineColor="#f59e0b"
              subtitle="Variation in Potassium content"
              updated={updated}
            />
            <FieldChartCard
              title="Soil Moisture"
              data={prepareChartData(fieldReadings, "soilMoisture")}
              lineColor="#6366f1"
              subtitle="Soil moisture level over time"
              updated={updated}
            />
          </div>
        )}
      </main>
    </div>
  );
}
