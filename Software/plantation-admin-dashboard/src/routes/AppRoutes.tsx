// src/routes/AppRoutes.tsx
import React from "react";
import { Routes, Route } from "react-router-dom";
import DashboardPage from "../pages/Dashboard";
import SignIn from "../pages/auth/Signin";
// import LoginPage from "../pages/Login"; // for later
// import NotFound from "../pages/NotFound"; // optional

function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<DashboardPage />} />
      <Route path="/login" element={<SignIn />} />
      {/* <Route path="*" element={<NotFound />} /> */}
    </Routes>
  );
}

export default AppRoutes;
