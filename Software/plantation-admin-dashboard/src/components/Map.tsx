import { GoogleMap, Polygon, Marker, useJsApiLoader } from "@react-google-maps/api";
import { GOOGLE_MAP_LIBRARIES } from "./constants";

const containerStyle = { width: "100%", height: "100%" };

const center = { lat: 6.9271, lng: 79.8612 }; // Example: Colombo

const polygonCoords = [
  { lat: 6.166448935794875, lng: 80.32652089999084 },
  { lat: 6.33403784273662 , lng: 80.32652089999084},
  { lat: 6.33403784273662, lng: 80.15380859900881 },
  { lat: 6.166448935794875, lng: 80.15380859900881 },
  { lat: 6.166448935794875, lng: 80.32652089999084 },
];

export default function MyMap() {
  const { isLoaded } = useJsApiLoader({
    id: "google-map-script",
    googleMapsApiKey: 'AIzaSyCW2VWhUQvG4G31LjozUbD5ff460s9YC2U',
    libraries: GOOGLE_MAP_LIBRARIES,
  });

  if (!isLoaded) return <p>Loading...</p>;

  return (
    <GoogleMap mapContainerStyle={containerStyle} center={center} zoom={13}>
      {/* Marker */}
      <Marker position={center} />

      {/* Polygon */}
      <Polygon
        paths={polygonCoords}
        options={{
          fillColor: "#ff9d00ff",
          fillOpacity: 0.4,
          strokeColor: "#3c0810ff",
          strokeOpacity: 1,
          strokeWeight: 2,
        }}
      />
    </GoogleMap>
  );
}
