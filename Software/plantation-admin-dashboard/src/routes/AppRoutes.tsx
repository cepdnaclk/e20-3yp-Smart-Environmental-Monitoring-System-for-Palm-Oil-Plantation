// src/routes/AppRoutes.tsx
import React from "react";
import { Routes, Route } from "react-router-dom";
import LandingPage from "../pages/LandingPage";   // <-- new!
import DashboardPage from "../pages/Dashboard";
import SignIn from "../pages/auth/Signin";
import SignUp from "../pages/auth/Signup";
// import NotFound from "../pages/NotFound"; // optional
import ProtectedRoute from "./ProtectedRoute";

// function AppRoutes() {
//   return (
//     <Routes>
//       <Route path="/" element={<LandingPage />} />          {/* Landing Page */}
//       <Route path="/dashboard" element={<DashboardPage />} /> {/* Dashboard */}
//       <Route path="/login" element={<SignIn />} />            {/* Sign In */}
//       <Route path="/signup" element={<SignUp />} />           {/* Sign Up */}
//       {/* <Route path="*" element={<NotFound />} /> */}
//     </Routes>
//   );
// }

// export default AppRoutes;



function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/signup" element={<SignUp />} />
      <Route path="/login" element={<SignIn />} />

      {/* Protect the dashboard route */}
      <Route
        path="/dashboard"
        element={
          <ProtectedRoute>
            <DashboardPage />
          </ProtectedRoute>
        }
      />

      {/* Optionally handle unknown routes */}
      {/* <Route path="*" element={<NotFound />} /> */}
    </Routes>
  );
}

export default AppRoutes;
