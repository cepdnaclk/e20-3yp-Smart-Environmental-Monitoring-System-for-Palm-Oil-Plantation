// import {
//     Home,
//     UserCircle,
//     Table,
//     Info,
//     LogIn,
//     UserPlus,
//   } from "lucide-react";
// import { useNavigate } from "react-router-dom";
  
//   const navItems = [
//     { name: "Dashboard", icon: <Home size={22} />, path: "/", active: true },
//     { name: "Profile", icon: <UserCircle size={22} />, path: "/profile" },
//     { name: "Tables", icon: <Table size={22} />, path: "/tables" },
//     { name: "Notifications", icon: <Info size={22} />, path: "/notifications" },
//   ];
  
//   const authNavItems = [
//     { name: "Sign In", icon: <LogIn size={22} />, path: "/signin" },
//     { name: "Sign Up", icon: <UserPlus size={22} />, path: "/signup" },
//   ];
  
//   export default function Sidebar() {

//       const navigate = useNavigate();

//       // Function called when Sign In button clicked
//       const handleSignInClick = () => {
//         // For example, navigate to the sign-in page
//         navigate("/auth/sign-in");
//         // Or do any other logic you want here
//         console.log("Sign In button clicked!");
//       };
//     return (
//       <aside className="min-h-[90vh] w-80 m-4 bg-white rounded-2xl shadow border border-gray-200 flex flex-col p-8">
//         {/* Logo/Brand */}
//         <div className="mb-8 text-xl font-bold text-center text-gray-700">
//           SAMS
//         </div>
  
//         {/* Main nav */}
//         <nav className="flex flex-col gap-3">
//           {navItems.map((item) => (
//             <a
//               key={item.name}
//               href={item.path}
//               className={`flex items-center gap-3 px-4 py-3 rounded-lg text-lg font-medium transition
//                 ${item.active
//                   ? "bg-gradient-to-r from-gray-800 to-gray-700 text-white shadow-md"
//                   : "text-slate-500 hover:bg-gray-100"
//                 }
//               `}
//             >
//               {item.icon}
//               <span>{item.name}</span>
//             </a>
//           ))}
//         </nav>
  
//         {/* Auth pages header */}
//         <div className="mt-8 mb-2 text-sm font-bold text-slate-600 tracking-wide">
//           AUTH PAGES
//         </div>
//         {/* Auth nav */}
//         <nav className="flex flex-col gap-2">
//           {authNavItems.map((item) => (
//             <a
//               key={item.name}
//               href={item.path}
//               className="flex items-center gap-3 px-4 py-2 rounded-lg text-base font-medium text-slate-500 hover:bg-gray-100 transition"
//             >
//               {item.icon}
//               <span>{item.name}</span>
//             </a>
//           ))}
//         </nav>
//       </aside>
//     );
//   }
  

import React from "react";
import {
  Home,
  UserCircle,
  Table,
  Info,
  LogIn,
  UserPlus,
} from "lucide-react";
import { NavLink } from "react-router-dom";

const navItems = [
  { name: "Dashboard", icon: <Home size={22} />, path: "/" },
  { name: "Profile", icon: <UserCircle size={22} />, path: "/profile" },
  { name: "Tables", icon: <Table size={22} />, path: "/tables" },
  { name: "Notifications", icon: <Info size={22} />, path: "/notifications" },
];

const authNavItems = [
  { name: "Sign In", icon: <LogIn size={22} />, path: "/login" },
  { name: "Sign Up", icon: <UserPlus size={22} />, path: "/signup" },
];

export default function Sidebar() {
  return (
    <aside className="min-h-[90vh] w-80 m-4 bg-white rounded-2xl shadow border border-gray-200 flex flex-col p-8">
      {/* Logo/Brand */}
      <div className="mb-8 text-xl font-bold text-center text-gray-700">SAMS</div>

      {/* Main nav */}
      <nav className="flex flex-col gap-3">
        {navItems.map((item) => (
          <NavLink
            key={item.name}
            to={item.path}
            end={item.path === "/"} // to ensure exact matching for root
            className={({ isActive }) =>
              `flex items-center gap-3 px-4 py-3 rounded-lg text-lg font-medium transition
              ${
                isActive
                  ? "bg-gradient-to-r from-gray-800 to-gray-700 text-white shadow-md"
                  : "text-slate-500 hover:bg-gray-100"
              }`
            }
          >
            {item.icon}
            <span>{item.name}</span>
          </NavLink>
        ))}
      </nav>

      {/* Auth pages header */}
      <div className="mt-8 mb-2 text-sm font-bold text-slate-600 tracking-wide">AUTH PAGES</div>

      {/* Auth nav */}
      <nav className="flex flex-col gap-2">
        {authNavItems.map((item) => (
          <NavLink
            key={item.name}
            to={item.path}
            className={({ isActive }) =>
              `flex items-center gap-3 px-4 py-2 rounded-lg text-base font-medium transition
              ${
                isActive
                  ? "bg-gray-200 text-gray-900"
                  : "text-slate-500 hover:bg-gray-100"
              }`
            }
          >
            {item.icon}
            <span>{item.name}</span>
          </NavLink>
        ))}
      </nav>
    </aside>
  );
}
