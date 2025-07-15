import React from "react";
import MapView from "../components/Map";


export default function MapScreen() {
  return (
    <div className="flex h-screen w-full">
      {/* Left side empty */}
      <div className="flex-1 bg-white" />

      {/* Right side: MAP */}
      <div className="w-[500px] bg-gray-300 relative">
        <div className="h-full w-full">
          <MapView />
        </div>

        {/* Floating Expand Button */}
        <button
          onClick={() => window.open("/map-full", "_blank")}
          className="absolute top-2 right-2 text-gray-800 text-2xl"
          title="Open Fullscreen"
        >
          ⛶
        </button>
      </div>
    </div>
  );
}
