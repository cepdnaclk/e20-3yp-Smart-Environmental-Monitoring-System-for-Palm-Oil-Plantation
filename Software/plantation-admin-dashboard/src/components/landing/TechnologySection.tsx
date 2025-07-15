import { Smartphone, Wifi, Database, Zap } from 'lucide-react';
import { Link } from "react-router-dom";

const techStack = [
  {
    icon: Smartphone,
    title: "IoT Sensors",
    description: "Advanced sensors for soil, weather, and crop monitoring"
  },
  {
    icon: Wifi,
    title: "FireBase Connectivity",
    description: "Fast, reliable data transmission from field to cloud"
  },
  {
    icon: Database,
    title: "Big Data Analytics",
    description: "Process vast amounts of agricultural data for insights"
  },
  {
    icon: Zap,
    title: "Machine Learning",
    description: "AI algorithms that learn and improve over time"
  }
];

const TechnologySection = () => (
  <section id="technology" className="py-20 bg-gray-900">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      {/* Section Title */}
      <div className="text-center mb-16">
        <h2 className="text-4xl md:text-5xl font-bold text-white mb-4">
          Built on
          <span className="bg-gradient-to-r from-green-400 to-blue-400 bg-clip-text text-transparent">
            {" "}Cutting-Edge Technology
          </span>
        </h2>
        <p className="text-xl text-gray-300 max-w-3xl mx-auto">
          Our platform leverages the latest advancements in IoT, AI, and cloud computing 
          to deliver unparalleled agricultural insights.
        </p>
      </div>

      {/* Tech Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-16">
        {techStack.map((tech, index) => (
          <div 
            key={index}
            className="text-center group hover:scale-105 transition-transform duration-300"
          >
            <div className="w-20 h-20 mx-auto mb-4 bg-gradient-to-br from-green-500 to-blue-500 rounded-2xl flex items-center justify-center group-hover:shadow-xl transition-shadow">
              <tech.icon className="h-10 w-10 text-white" />
            </div>
            <h3 className="text-xl font-semibold text-white mb-2">
              {tech.title}
            </h3>
            <p className="text-gray-400">
              {tech.description}
            </p>
          </div>
        ))}
      </div>

      {/* CTA */}
      <div className="bg-gradient-to-r from-green-600 to-blue-600 rounded-2xl p-8 md:p-12 text-center">
        <h3 className="text-3xl font-bold text-white mb-4">
          Ready to Experience the Future of Farming?
        </h3>
        <p className="text-xl text-green-100 mb-8 max-w-2xl mx-auto">
          Join the agricultural revolution with SAMS. Get started with a free trial 
          and see the difference technology can make.
        </p>
        <Link
          to="/signup"
          className="inline-block bg-white text-green-600 px-8 py-4 rounded-xl font-semibold text-lg hover:bg-gray-100 transition-colors"
        >
          Sign Up Now
        </Link>
      </div>
    </div>
  </section>
);

export default TechnologySection;
