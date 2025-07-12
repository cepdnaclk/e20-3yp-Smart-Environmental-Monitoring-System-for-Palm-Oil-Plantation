// src/routes/AppRoutes.tsx
import React from "react";
import { Routes, Route } from "react-router-dom";
import LandingPage from "../pages/LandingPage";   // <-- new!
import DashboardPage from "../pages/Dashboard";
import SignIn from "../pages/auth/Signin";
import SignUp from "../pages/auth/Signup";
// import NotFound from "../pages/NotFound"; // optional

function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />          {/* Landing Page */}
      <Route path="/dashboard" element={<DashboardPage />} /> {/* Dashboard */}
      <Route path="/login" element={<SignIn />} />            {/* Sign In */}
      <Route path="/signup" element={<SignUp />} />           {/* Sign Up */}
      {/* <Route path="*" element={<NotFound />} /> */}
    </Routes>
  );
}

export default AppRoutes;
