// // src/components/MapView.tsx
// import React, { useEffect, useRef } from "react";
// import {
//   GoogleMap,
//   useJsApiLoader,
//   Polygon,
//   Marker,
// } from "@react-google-maps/api";

// // Map container style
// const containerStyle = {
//   width: "100%",
//   height: "100%",
// };

// // Dummy polygon boundary (near Ratnapura/Balangoda)
// const boundaryCoords = [
//   { lat: 7.052168565032545, lng: 80.26080882137637 },
//   { lat: 6.594052871760965, lng: 80.33269794901872 },
//   { lat: 6.576043326504944, lng: 80.95193287297519 },
//   { lat: 7.11189540859958, lng: 80.89180664437885 },
//   { lat: 7.052168565032545, lng: 80.26080882137637 },
// ];

// // Center point of polygon (approximate)
// const center = { lat: 6.9, lng: 80.6 };

// // Marker positions (unrelated to polygon)
// const markers = [
//   { lat: 7.875, lng: 80.76 },
//   { lat: 7.879, lng: 80.772 },
// ];

// // Required Google Maps libraries
// const libraries: (
//   | "drawing"
//   | "geometry"
//   | "places"
//   | "visualization"
//   | "marker"
// )[] = ["marker"];

// const MapView: React.FC = () => {
//   const mapRef = useRef<google.maps.Map | null>(null);

//   const { isLoaded, loadError } = useJsApiLoader({
//     googleMapsApiKey: "AIzaSyCIgiuerHvVIueSJcb4p_bPIoi4W-4NHpw", // 🔐 Hardcoded key
//     libraries,
//   });

//   // 🔍 Debug: log polygon data
//   useEffect(() => {
//     console.log("Boundary coordinates:", boundaryCoords);
//   }, []);

//   // ✅ Auto-zoom to fit polygon bounds
//   const handleMapLoad = (map: google.maps.Map) => {
//     mapRef.current = map;
//     const bounds = new window.google.maps.LatLngBounds();
//     boundaryCoords.forEach((coord) => bounds.extend(coord));
//     map.fitBounds(bounds); // Force map to show polygon
//     console.log("Map loaded and bounds fitted.");
//   };

//   // ⛔ Temporarily disable AdvancedMarkers while debugging
//   // useEffect(() => {
//   //   if (isLoaded && mapRef.current && window.google?.maps?.marker) {
//   //     const { AdvancedMarkerElement } = window.google.maps.marker;
//   //     markers.forEach((position) => {
//   //       new AdvancedMarkerElement({
//   //         map: mapRef.current!,
//   //         position,
//   //         title: "Tree Marker",
//   //       });
//   //     });
//   //   }
//   // }, [isLoaded]);

//   if (loadError) return <div>Error loading map</div>;
//   if (!isLoaded) return <div>Loading map...</div>;

//   return (
//     <GoogleMap
//       mapContainerStyle={containerStyle}
//       onLoad={handleMapLoad}
//       mapTypeId="hybrid" // Optional: adds more contrast
//     >
//       {/* ✅ Debug center marker */}
//       <Marker position={center} />

//       {/* ✅ Polygon Boundary */}
//       <Polygon
//         paths={boundaryCoords}
//         options={{
//           fillColor: "#00FF00",
//           fillOpacity: 0.5,
//           strokeColor: "#FF0000",
//           strokeOpacity: 1.0,
//           strokeWeight: 4,
//           clickable: true,
//           editable: false,
//           zIndex: 10,
//         }}
//       />
//     </GoogleMap>
//   );
// };

// export default MapView;


// src/components/MapView.tsx
import React, { useRef } from "react";
import {
  GoogleMap,
  useJsApiLoader,
  Polygon,
  Marker,
} from "@react-google-maps/api";

const containerStyle = {
  width: "100%",
  height: "100%", // Parent must have height!
};

const boundaryCoords = [
  { lat: 7.052168565032545, lng: 80.26080882137637 },
  { lat: 6.594052871760965, lng: 80.33269794901872 },
  { lat: 6.576043326504944, lng: 80.95193287297519 },
  { lat: 7.11189540859958, lng: 80.89180664437885 },
  { lat: 7.052168565032545, lng: 80.26080882137637 },
];

const center = { lat: 6.9, lng: 80.6 };

const markers = [
  { lat: 7.875, lng: 80.76 },
  { lat: 7.879, lng: 80.772 },
];

const libraries: ("drawing" | "geometry" | "places" | "visualization" | "marker")[] = ["marker"];

const MapView: React.FC = () => {
  const mapRef = useRef<google.maps.Map | null>(null);

  const { isLoaded, loadError } = useJsApiLoader({
    googleMapsApiKey: "AIzaSyCIgiuerHvVIueSJcb4p_bPIoi4W-4NHpw", // Replace with your real API key
    libraries,
  });

  const handleMapLoad = (map: google.maps.Map) => {
    mapRef.current = map;
    const bounds = new window.google.maps.LatLngBounds();
    boundaryCoords.forEach((coord) => bounds.extend(coord));
    map.fitBounds(bounds);
  };

  if (loadError) return <div>Error loading map</div>;
  if (!isLoaded) return <div>Loading map...</div>;

  return (
    <GoogleMap
      mapContainerStyle={containerStyle}
      onLoad={handleMapLoad}
      mapTypeId="hybrid"
    >
      <Marker position={center} />
      {markers.map((m, idx) => (
        <Marker key={idx} position={m} />
      ))}
      <Polygon
        paths={boundaryCoords}
        options={{
          fillColor: "#00FF00",
          fillOpacity: 0.5,
          strokeColor: "#FF0000",
          strokeOpacity: 1.0,
          strokeWeight: 4,
          clickable: true,
          editable: false,
          zIndex: 10,
        }}
      />
    </GoogleMap>
  );
};

export default MapView;