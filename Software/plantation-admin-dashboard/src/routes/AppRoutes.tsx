// src/routes/AppRoutes.tsx
import React from "react";
import { Routes, Route } from "react-router-dom";
import LandingPage from "../pages/LandingPage";   // <-- new!
import DashboardPage from "../pages/Dashboard";
import TreeHealthAnalyzer from "../pages/TreeCount";
import SignIn from "../pages/auth/Signin";
import SignUp from "../pages/auth/Signup";
// import NotFound from "../pages/NotFound"; // optional
import ProtectedRoute from "./ProtectedRoute";
import EstateDetailsPage from "../pages/estate/EstateDetailsPage";
import MapScreen from "../pages/MapScreen";


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
      <Route path="/estate/:estateId" element={<EstateDetailsPage />} />
      <Route path="/map/:estateId" element={<MapScreen />} />
      {/* Protect the dashboard route */}
      <Route
        path="/dashboard"
        element={
          <ProtectedRoute>
            <DashboardPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/count"
        element={
          <ProtectedRoute>
            <TreeHealthAnalyzer />
          </ProtectedRoute>
        }
      />
      {/* Optionally handle unknown routes */}
      {/* <Route path="*" element={<NotFound />} /> */}
    </Routes>
  );
}

export default AppRoutes;
