// src/pages/Dashboard.tsx
import { useEffect, useState } from "react";
import SidebarLayout from "../layouts/SidebarLayout";
import StatChartCard from "../components/StatChartCard";
import SunIcon from "../components/SunIcon";
import RainIcon from "../components/RainIcon";
import TemperatureIcon from "../components/TemperatureIcon";
import HumidityIcon from "../components/HumidityIcon";
import RecentReadingsTable from "../components/RecentReadingsTable";
import EstateCard from "../components/EstateCard";
import {
  listenToLatestSensorData,
  fetchEstatesByIds,
  listenToLatestRainfallData,
  listenToLast7RainfallReadings,
  listenToLast7SensorReadings,
} from "../services/FirestoreServices";
import { Link } from "react-router-dom";

// Optional static rainfall data
// const rainfallData = [
//   { value: 5 }, { value: 18 }, { value: 8 }, { value: 24 }, { value: 16 }, { value: 11 }, { value: 13 }
// ];

// const estates = [
//   {
//     imageUrl: "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
//     name: "Homadola",
//     description: "Area: 15 acres",
//     owner: "Palm Estate",
//   },
//   {
//     imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
//     name: "Nakiadeniya",
//     description: "Area: 20 acres ",
//     owner: "Green Field",
//   },
// ];

function DashboardPage() {
  const [sensorData, setSensorData] = useState({
    humidity: 0,
    lux: 0,
    temperature: 0,
    timestamp: "",
  });

  const [rainfallData, setRainfall] = useState({
    rainfall: 0,
    timestamp: "",
  });

  const [chartData, setChartData] = useState({
    rainfall: [] as { value: number }[],
    humidity: [] as { value: number }[],
    lux: [] as { value: number }[],
    temperature: [] as { value: number }[],
  });

  // 🔁 Real-time update for latest card values
  useEffect(() => {
    const unsubscribe = listenToLatestSensorData((latest) => {
      setSensorData(latest);
    });
    return () => unsubscribe(); // cleanup on unmount
  }, []);

   // 🔁 Real-time update for latest card value for rainfall
  useEffect(() => {
    const unsubscribe = listenToLatestRainfallData((latestRainfall) => {
      setRainfall(latestRainfall);
    });
    return () => unsubscribe(); // cleanup on unmount
  }, []);

  // Real time updating of the environmental conditions plots inside the cards 
useEffect(() => {
  const unsubscribeSensor = listenToLast7SensorReadings((last7) => {
    setChartData((prev) => ({
      ...prev,
      humidity: last7.map((d) => ({ value: d.humidity })),
      lux: last7.map((d) => ({ value: d.lux })),
      temperature: last7.map((d) => ({ value: d.temperature })),
    }));
  });

  const unsubscribeRainfall = listenToLast7RainfallReadings((last7Rainfall) => {
    setChartData((prev) => ({
      ...prev,
      rainfall: last7Rainfall.map((d) => ({ value: d.rainfall })),
    }));
  });

  return () => {
    unsubscribeSensor();
    unsubscribeRainfall();
  };
}, []);


  const [estates, setEstates] = useState<any[]>([]);

  useEffect(() => {
    const loadEstates = async () => {
      const estateIds = ["e6jApQOvbm3Aa3GL47sa", "state2", "state3"]; // replace with your actual document IDs
      const estateImageMap: Record<string, string> = {
        e6jApQOvbm3Aa3GL47sa: "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
        state2: "src/assets/estate2.jpg",
        state3: "src/assets/WhatsApp Image 2025-07-13 at 10.27.51_08b3aa04.jpg",
      };
      const data = await fetchEstatesByIds(estateIds);
      setEstates(data);
      const estatesWithImages = data.map((estate: any, idx: number) => {
      const id = estateIds[idx]; // assumes order is preserved
      return {
        ...estate,
        imageUrl: estateImageMap[id] || "https://via.placeholder.com/150", // fallback image
      };
    });

    setEstates(estatesWithImages);
    };

    loadEstates();
  }, []);

  return (
    <SidebarLayout>
      <h1 className="text-3xl font-bold mb-8">Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-10">
        <StatChartCard
          icon={<RainIcon />}
          title="Rainfall"
          value={rainfallData.rainfall}
          unit=" mm"
          chartType="line"
          chartData={chartData.rainfall}
          color="bg-blue-100"
          chartColor="#2563eb"
        />
        <StatChartCard
          icon={<SunIcon />}
          title="Lux Level"
          value={sensorData.lux}
          unit=" lux"
          chartType="bar"
          chartData={chartData.lux}
          color="bg-yellow-100"
          chartColor="#ca8a04"
        />
        <StatChartCard
          icon={<TemperatureIcon />}
          title="Temperature"
          value={sensorData.temperature}
          unit="°C"
          chartType="line"
          chartData={chartData.temperature}
          color="bg-orange-100"
          chartColor="#ea580c"
        />
        <StatChartCard
          icon={<HumidityIcon />}
          title="Humidity"
          value={sensorData.humidity}
          unit=" %"
          chartType="bar"
          chartData={chartData.humidity}
          color="bg-rose-100"
          chartColor="#be123c"
        />
      </div>

      <RecentReadingsTable />

      <div>
        <h2 className="text-2xl font-bold mt-12 mb-4">Estates</h2>
        <div className="flex flex-row gap-8 overflow-x-auto pb-4">
  {estates.map((estate, idx) => (
    <Link
      key={estate.id || idx}
      to={`/estate/${estate.id || estate.estateId || "unknown"}`} // Make sure to use the correct unique ID field here
      className="hover:scale-105 transition-transform duration-200"
      style={{ textDecoration: "none" }}
    >
      <EstateCard
  imageUrl={estate.imageUrl}
  name={estate.name || estate.stateName} // use whatever is available
  description={estate.description}
  owner={estate.owner}
/>
    </Link>
  ))}
</div>

      </div>
    </SidebarLayout>
  );
}

export default DashboardPage;
