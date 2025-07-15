// src/components/landing/HeroSection.tsx

const HeroSection = () => {
    return (
      <section className="relative min-h-[90vh] flex items-center justify-center bg-gradient-to-br from-green-50 via-blue-50 to-green-100 overflow-hidden">
        {/* Animated Color Blobs */}
        <div className="absolute inset-0 opacity-20 pointer-events-none select-none">
          <div className="absolute top-24 left-20 w-96 h-96 bg-green-300 rounded-full filter blur-3xl animate-pulse"></div>
          <div className="absolute top-1/3 right-24 w-96 h-96 bg-blue-200 rounded-full filter blur-3xl animate-pulse delay-500"></div>
          <div className="absolute bottom-10 left-1/2 w-96 h-96 bg-emerald-200 rounded-full filter blur-3xl animate-pulse delay-1000"></div>
        </div>
  
        {/* Main Content */}
        <div className="relative max-w-7xl mx-auto w-full px-4 sm:px-8 text-center z-10">
          <div className="max-w-4xl mx-auto">
            <h1 className="text-5xl md:text-7xl font-extrabold text-gray-900 mb-6 leading-tight">
              Smart Agricultural
              <span className="bg-gradient-to-r from-green-600 to-blue-600 bg-clip-text text-transparent font-extrabold">
                {" "}Monitoring{" "}
              </span>
              System
            </h1>
            <p className="text-xl md:text-2xl text-gray-700 mb-12 font-medium">
              Revolutionize your farming with <span className="font-bold text-green-700">AI-powered monitoring</span>, real-time analytics,
              and predictive insights for optimal crop management.
            </p>
  
            {/* Feature Cards */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
              <div className="bg-white/90 backdrop-blur rounded-xl p-8 shadow-lg hover:shadow-2xl transition">
                <div className="text-4xl font-extrabold text-green-600 mb-2">50%</div>
                <div className="text-lg font-semibold text-gray-800 mb-1">Increased Yield</div>
                {/* <div className="text-gray-500 text-sm">Increased Yield</div> */}
              </div>
              <div className="bg-white/90 backdrop-blur rounded-xl p-8 shadow-lg hover:shadow-2xl transition">
                <div className="text-4xl font-extrabold text-blue-600 mb-2">30%</div>
                <div className="text-lg font-semibold text-gray-800 mb-1">Labour Cost Savings</div>
                {/* <div className="text-gray-500 text-sm">Labour Cost Savings</div> */}
              </div>
              <div className="bg-white/90 backdrop-blur rounded-xl p-8 shadow-lg hover:shadow-2xl transition">
                <div className="text-4xl font-extrabold text-emerald-600 mb-2">24/7</div>
                <div className="text-lg font-semibold text-gray-800 mb-1">Monitoring</div>
                {/* <div className="text-gray-500 text-sm">Monitoring</div> */}
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  };
  
  export default HeroSection;
  