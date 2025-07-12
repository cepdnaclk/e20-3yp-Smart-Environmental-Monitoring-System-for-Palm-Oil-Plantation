import { Cpu, Cloud, BarChart3, Bell, Droplets, Sun } from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../ui/card';

export const FeaturesSection = () => {
  const features = [
    {
      icon: Cpu,
      title: "AI-Powered Analytics",
      description: "Advanced machine learning algorithms analyze crop health, predict diseases, and optimize growing conditions."
    },
    {
      icon: Cloud,
      title: "Cloud Integration",
      description: "Secure cloud storage with real-time data synchronization across all your devices and team members."
    },
    {
      icon: BarChart3,
      title: "Real-time Monitoring",
      description: "Monitor soil moisture, temperature, humidity, and other critical parameters in real-time."
    },
    {
      icon: Bell,
      title: "Smart Alerts",
      description: "Receive instant notifications about critical changes requiring immediate attention."
    },
    {
      icon: Droplets,
      title: "Water Management",
      description: "Optimize irrigation schedules and reduce water waste with intelligent water management systems."
    },
    {
      icon: Sun,
      title: "Weather Integration",
      description: "Integrate local weather data and forecasts to make informed agricultural decisions."
    }
  ];

  return (
    <section id="features" className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Title */}
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
            Powerful Features for
            <span className="text-green-600"> Modern Farming</span>
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Discover how SAMS transforms traditional agriculture with cutting-edge technology 
            and intelligent automation.
          </p>
        </div>

        {/* Feature Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <Card 
              key={index} 
              className="hover:shadow-xl transition-all duration-300 hover:-translate-y-1 border-0 shadow-lg bg-gradient-to-br from-white to-gray-50"
            >
              <CardHeader className="text-center pb-4">
                <div className="mx-auto w-16 h-16 bg-gradient-to-br from-green-500 to-blue-500 rounded-xl flex items-center justify-center mb-4">
                  <feature.icon className="h-8 w-8 text-white" />
                </div>
                <CardTitle className="text-xl font-semibold text-gray-900">
                  {feature.title}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <CardDescription className="text-gray-600 text-center leading-relaxed">
                  {feature.description}
                </CardDescription>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default FeaturesSection;
