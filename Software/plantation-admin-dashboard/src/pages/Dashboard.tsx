// src/pages/Dashboard.tsx
import SidebarLayout from "../layouts/SidebarLayout";
import StatChartCard from "../components/StatChartCard";
import SunIcon from "../components/SunIcon";
import RainIcon from "../components/RainIcon";
import TemperatureIcon from "../components/TemperatureIcon";
import HumidityIcon from "../components/HumidityIcon";
import RecentReadingsTable from "../components/RecentReadingsTable";
import EstateCard from "../components/EstateCard";
import { useEffect, useState } from "react";
import { fetchLatestSensorData, fetchLast7SensorReadings } from "../layouts/services/FirestoreServices";




const rainfallData = [
  { value: 5 }, { value: 18 }, { value: 8 }, { value: 24 }, { value: 16 }, { value: 11 }, { value: 13 }
];
// const luxData = [
//   { value: 120 }, { value: 180 }, { value: 250 }, { value: 320 }, { value: 280 }, { value: 340 }, { value: 410 }
// ];
// const temperatureData = [
//   { value: 29 }, { value: 31 }, { value: 28 }, { value: 33 }, { value: 32 }, { value: 30 }, { value: 34 }
// ];
// const humidityData = [
//   { value: 72 }, { value: 68 }, { value: 75 }, { value: 70 }, { value: 74 }, { value: 73 }, { value: 69 }
// ];




const estates = [
  {
    imageUrl: "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
    name: "Homadola",
    description: "Area: 15 acres",
    owner: "Palm Estate",
  },
  {
    imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
    name: "Nakiadeniya",
    description: "Area: 20 acres ",
    owner: "Green Field",
  },
];


function DashboardPage() {

    // inside DashboardPage component
  const [sensorData, setSensorData] = useState({
    humidity: 0,
    lux: 0,
    temperature: 0,
    timestamp: "",
  });

  // useEffect(() => {
  //   const getData = async () => {
  //     const data = await fetchLatestSensorData();
  //     if (data) setSensorData(data);
  //   };
  //   getData();
  // }, []);

   const [chartData, setChartData] = useState({
    humidity: [] as { value: number }[],
    lux: [] as { value: number }[],
    temperature: [] as { value: number }[],
  });

  useEffect(() => {
    const getData = async () => {
      const latest = await fetchLatestSensorData();
      const last7 = await fetchLast7SensorReadings();

      if (latest) setSensorData(latest);

      setChartData({
        humidity: last7.map((d) => ({ value: d.humidity })),
        lux: last7.map((d) => ({ value: d.lux })),
        temperature: last7.map((d) => ({ value: d.temperature })),
      });
    };

    getData();
  }, []);

  
  return (
    <SidebarLayout>
      <h1 className="text-3xl font-bold mb-8">Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-10">
        <StatChartCard
          icon={<RainIcon />}
          title="Rainfall"
          value={24}
          unit=" mm"
          chartType="line"
          chartData={rainfallData}
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
            <EstateCard key={idx} {...estate} />
          ))}
        </div>
      </div>
    </SidebarLayout>
  );
}

export default DashboardPage;
