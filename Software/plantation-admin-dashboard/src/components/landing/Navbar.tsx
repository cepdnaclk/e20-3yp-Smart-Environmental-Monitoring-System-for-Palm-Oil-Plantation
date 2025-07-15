import React from "react";
import { Link } from "react-router-dom";

export default function Navbar() {
  return (
    <header className="flex justify-between items-center px-10 py-6 bg-white/80 backdrop-blur border-b sticky top-0 z-50">
      <div className="flex items-center gap-3">
        <img src="img/Logonew.png" alt="SAMS" className="h-8" />
        {/* <span className="font-bold text-xl">SAMS</span> */}
      </div>
      <nav className="flex gap-5 items-center">
        <a href="#features" className="text-gray-700 hover:underline">Features</a>
        <a href="#contact" className="text-gray-700 hover:underline">Contact</a>
        <Link to="/login">
          <button className="px-4 py-2 bg-white border rounded hover:bg-gray-100">Sign In</button>
        </Link>
        <Link to="/signup">
          <button className="ml-2 px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">Sign Up</button>
        </Link>
      </nav>
    </header>
  );
}
