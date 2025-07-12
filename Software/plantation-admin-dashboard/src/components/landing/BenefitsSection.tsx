import { TrendingUp, Shield, DollarSign, Clock } from 'lucide-react';

const benefits = [
  {
    icon: TrendingUp,
    title: "Increase Productivity",
    description: "Boost crop yields by up to 50% with data-driven farming decisions and optimized resource allocation.",
    stat: "50%",
    statLabel: "Yield Increase"
  },
  {
    icon: DollarSign,
    title: "Reduce Costs",
    description: "Cut operational costs by minimizing waste, optimizing inputs, and preventing crop losses.",
    stat: "35%",
    statLabel: "Cost Reduction"
  },
  {
    icon: Shield,
    title: "Risk Management",
    description: "Early detection of diseases, pests, and adverse conditions to protect your investment.",
    stat: "90%",
    statLabel: "Problem Detection"
  },
  {
    icon: Clock,
    title: "Save Time",
    description: "Automate monitoring tasks and receive actionable insights without manual field inspections.",
    stat: "60%",
    statLabel: "Time Saved"
  }
];

const BenefitsSection = () => (
  <section id="benefits" className="py-20 bg-gradient-to-br from-green-50 to-blue-50">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      {/* Section Title */}
      <div className="text-center mb-16">
        <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
          Transform Your
          <span className="text-blue-600"> Agricultural Business</span>
        </h2>
        <p className="text-xl text-gray-600 max-w-3xl mx-auto">
          Join thousands of farmers who have revolutionized their operations with SAMS technology.
        </p>
      </div>
      {/* Benefit Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {benefits.map((benefit, idx) => (
          <div
            key={idx}
            className="bg-white rounded-2xl p-8 shadow-xl hover:shadow-2xl transition-all duration-300 hover:-translate-y-1"
          >
            <div className="flex items-start space-x-6">
              <div className="flex-shrink-0">
                <div className="w-16 h-16 bg-gradient-to-br from-green-500 to-blue-500 rounded-xl flex items-center justify-center">
                  <benefit.icon className="h-8 w-8 text-white" />
                </div>
              </div>
              <div className="flex-grow">
                <h3 className="text-2xl font-bold text-gray-900 mb-3">
                  {benefit.title}
                </h3>
                <p className="text-gray-600 mb-4 leading-relaxed">
                  {benefit.description}
                </p>
                <div className="flex items-center space-x-2">
                  <span className="text-3xl font-bold bg-gradient-to-r from-green-600 to-blue-600 bg-clip-text text-transparent">
                    {benefit.stat}
                  </span>
                  <span className="text-gray-500">
                    {benefit.statLabel}
                  </span>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  </section>
);

export default BenefitsSection;
