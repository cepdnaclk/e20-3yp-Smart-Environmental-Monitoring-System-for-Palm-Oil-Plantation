import React from "react";
import { Link } from "react-router-dom";

// --- Components for Each Section ---
import HeroSection from "../components/landing/HeroSection";
import FeaturesSection from "../components/landing/FeaturesSection";
import BenefitsSection from "../components/landing/BenefitsSection";
import TechnologySection from "../components/landing/TechnologySection";
import ContactSection from "../components/landing/ContactSection";
import Navbar from "../components/landing/Navbar";

export default function LandingPage() {
  return (
    <div className="bg-gradient-to-tr from-green-50 to-blue-50 min-h-screen">
      <Navbar />
      <HeroSection />
      <FeaturesSection />
      <BenefitsSection />
      <TechnologySection />
      <ContactSection />
    </div>
  );
}
