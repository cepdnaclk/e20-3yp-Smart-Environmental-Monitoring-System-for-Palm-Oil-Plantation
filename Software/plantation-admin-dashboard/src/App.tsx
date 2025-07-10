import SidebarLayout from "./layouts/SidebarLayout";
import StatChartCard from "./components/StatChartCard";
import SunIcon from "./components/SunIcon";
import RainIcon from "./components/RainIcon";
import TemperatureIcon from "./components/TemperatureIcon";
import HumidityIcon from "./components/HumidityIcon";
import RecentReadingsTable from "./components/RecentReadingsTable";
import EstateCard from "./components/EstateCard";


const rainfallData = [
  { value: 5 }, { value: 18 }, { value: 8 }, { value: 24 }, { value: 16 }, { value: 11 }, { value: 13 }
];
const luxData = [
  { value: 120 }, { value: 180 }, { value: 250 }, { value: 320 }, { value: 280 }, { value: 340 }, { value: 410 }
];
const temperatureData = [
  { value: 29 }, { value: 31 }, { value: 28 }, { value: 33 }, { value: 32 }, { value: 30 }, { value: 34 }
];
const humidityData = [
  { value: 72 }, { value: 68 }, { value: 75 }, { value: 70 }, { value: 74 }, { value: 73 }, { value: 69 }
];
// Example data
const estates = [
  {
    imageUrl: "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80", // Replace with your real estate image URLs
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
  // Add more estates here...
];

function App() {
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
        value={410}
        unit=" lux"
        chartType="bar"
        chartData={luxData}
        color="bg-yellow-100"
        chartColor="#ca8a04"
      />

      <StatChartCard
        icon={<TemperatureIcon />}
        title="Temperature"
        value={34}
        unit="°C"
        chartType="line"
        chartData={temperatureData}
        color="bg-orange-100"
        chartColor="#ea580c"
      />

      <StatChartCard
        icon={<HumidityIcon />}
        title="Humidity"
        value={69}
        unit=" %"
        chartType="bar"
        chartData={humidityData}
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
      {/* You can add more dashboard content below */}
    </SidebarLayout>
  );
}

export default App;
