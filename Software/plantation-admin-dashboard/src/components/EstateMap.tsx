import React from "react";
import { GoogleMap, Polygon, useJsApiLoader } from "@react-google-maps/api";

interface Coordinate {
  lat: number;
  lng: number;
}

interface Field {
  id: string;
  name: string;
  coordinates: Coordinate[];
}

interface EstateMapProps {
  fields: Field[];
  geoLocation?: { lat: number; lng: number } | null;
  selectedFieldId: string | null;
  onFieldSelect: (id: string) => void;
}

const containerStyle = {
  width: "100%",
  height: "100%",
};

export default function EstateMap({
  fields,
  geoLocation,
  selectedFieldId,
  onFieldSelect,
}: EstateMapProps) {
  // Load Google Maps
  const { isLoaded } = useJsApiLoader({
    id: "google-map-script",
    googleMapsApiKey: 'AIzaSyCW2VWhUQvG4G31LjozUbD5ff460s9YC2U', // replace with your key
  });

  if (!isLoaded) return <p>Loading map...</p>;

  // Default center: first field’s first coordinate, or fallback
  const center =
    fields[0]?.coordinates[0] || geoLocation || { lat: 6.144580, lng: 80.340407 };

  return (
    <div className="h-[600px] w-full">
      <GoogleMap
        mapContainerStyle={{ width: "100%", height: "600px" }}
        center={{ lat: 6.144580, lng: 80.340407 }}   // <-- change this to your desired starting point
        zoom={12}
      >
        {fields.map((field) => (
          <Polygon
            key={field.id}
            paths={field.coordinates}
            options={{
              fillColor: String(field.id) === String(selectedFieldId) ? "#ff0000" : "#00ff00",
              fillOpacity: 0.4,
              strokeColor: "#000",
              strokeWeight: 2,
            }}
            onClick={() => onFieldSelect(field.id)}
          />
        ))}
      </GoogleMap>
    </div>
  );
}