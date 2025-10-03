import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import EstateSidebar from "../../components/EstateSidebar";
import FieldChartCard from "../../components/FieldChartCard";
// import {
//   fetchFieldReadings,
//   fetchSections,
//   fetchStateDetails,
//   prepareChartData,
// } from "../../services/FirestoreEstateServices";


import {
  fetchFieldReadings,
  fetchSections,
  fetchStateDetails,
  prepareChartData,
  calculateFieldAverages,
  fetchRainfallLast7Days,
  calculateAverageRainfall,
  fetchLuxLevelLast7Days,
  calculateLuxLevelAverages
} from "../../services/FirestoreEstateServices";
import { runRules } from "../../utils/rulesEngine";




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

  // useEffect(() => {
  //   if (estateId && selectedSectionId && selectedFieldId) {
  //     const sectionId = selectedSectionId.toString();
  //     const fieldId = selectedFieldId.toString();

  //     console.log("Field ID:", selectedFieldId);

  //     fetchFieldReadings(estateId, sectionId, fieldId).then(data => {
  //       setFieldReadings(data);
  //       setUpdated(new Date().toLocaleTimeString());
  //     });
  //   }
  // }, [estateId, selectedSectionId, selectedFieldId]);

  const [npkAverages, setNpkAverages] = useState<any>(null);
  const [rainfallAvg, setRainfallAvg] = useState<number | null>(null);
  const [luxAvg, setLuxAvg] = useState<any>(null);

  useEffect(() => {
    if (estateId && selectedSectionId && selectedFieldId) {
      const sectionId = selectedSectionId.toString();
      const fieldId = selectedFieldId.toString();

      (async () => {
        // 1️⃣ Fetch field readings
        const readings = await fetchFieldReadings(estateId, sectionId, fieldId);
        setFieldReadings(readings);
        setUpdated(new Date().toLocaleTimeString());

        // 2️⃣ Compute NPK & soil moisture averages
        const npkAverages = calculateFieldAverages(readings);
        setNpkAverages(npkAverages);

        // 3️⃣ Fetch last 7 days rainfall and compute average
        const rainfallReadings = await fetchRainfallLast7Days();
        const rainfallAvg = calculateAverageRainfall(rainfallReadings);
        setRainfallAvg(rainfallAvg);

        // 4️⃣ Fetch last 7 days lux readings and compute averages
        const luxReadings = await fetchLuxLevelLast7Days();
        const luxAvg = calculateLuxLevelAverages(luxReadings);
        setLuxAvg(luxAvg);

        // 5️⃣ Print all averages to console for debugging
        console.log("Field averages (NPK & Soil Moisture):", npkAverages);
        console.log("Rainfall last 7 days average:", rainfallAvg);
        console.log("Lux & Env last 7 days averages:", luxAvg);

        // ✅ Optional: you can store these in state to display in UI later
        // setFieldAverages({ npk: npkAverages, rainfall: rainfallAvg, lux: luxAvg });
      })();
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

  // Fetching for insights part
  useEffect(() => {
    if (estateId && selectedSectionId && selectedFieldId) {
      const sectionId = selectedSectionId.toString();
      const fieldId = selectedFieldId.toString();

      fetchFieldReadings(estateId, sectionId, fieldId).then(data => {
        console.log("📦 Fetched field readings:", data);
        setFieldReadings(data);
        setUpdated(new Date().toLocaleTimeString());

        // ✅ Optional debug
        // const evaluated = evaluateReadings(data, ruleset);
        // console.log("Evaluated Results:", evaluated);
      });
    }
  }, [estateId, selectedSectionId, selectedFieldId]);

  const testReading = {
    temp_c: luxAvg?.temperature ?? 25.0,
    humidity_pct: luxAvg?.humidity ?? 86.0,
    soil_moisture_pct: npkAverages?.soilMoisture ?? 45.0,
    rainfall_7d_mm: rainfallAvg,
    sunlight_h: luxAvg?.lux ?? 400,
    light_lux: luxAvg?.lux ?? 400,
    N_ppm: npkAverages?.nitrogen ?? 15.0,
    P_ppm: npkAverages?.phosphorus ?? 90.0,
    K_ppm: npkAverages?.potassium ?? 82.0,
    soil_ec_ds_m: 0.8,
    ml_tree_health: "Healthy"
  };
  console.log("Test reading:", testReading);

  const insights = runRules(testReading);
  console.log(insights);


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
              onClick={() => {
                console.log("Navigating with data:", {
                  estateId: estate.id,
                  sectionId: selectedSectionId,
                  fieldId: selectedFieldId,
                  section,
                  field,
                });
                navigate(`/map/${estate.id}?section=${selectedSectionId}&field=${selectedFieldId}`)
              }}
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


        {/* Insights */}
        {selectedFieldId && fieldReadings.length > 0 && (
          <div className="mt-8">
            <h2 className="text-2xl font-bold text-gray-800 mb-4">Insights</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {insights.map((ins, idx) => (
                <div
                  key={idx}
                  className={`rounded-xl shadow px-6 py-4 border-l-4 ${
                    ins.severity === "critical"
                      ? "bg-red-50 border-red-500"
                      : ins.severity === "warn"
                      ? "bg-yellow-50 border-yellow-500"
                      : "bg-green-50 border-green-500"
                  }`}
                >
                  <div className="font-bold text-lg mb-1 text-gray-800">
                    {ins.message}
                  </div>
                  <div className="text-gray-600 text-sm mb-2">
                    Related Parameters:{" "}
                    <span className="font-medium">
                      {ins.parameters.join(", ")}
                    </span>
                  </div>
                  <div className="text-gray-700">{ins.recommendation}</div>
                </div>
              ))}
            </div>
          </div>
        )}

      </main>
    </div>
  );
}
