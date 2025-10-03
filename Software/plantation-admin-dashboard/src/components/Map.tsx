// import { GoogleMap, Polygon, Marker, useJsApiLoader } from "@react-google-maps/api";
// import { GOOGLE_MAP_LIBRARIES } from "./constants";

// const containerStyle = { width: "100%", height: "100%" };

// const center = { lat: 6.9271, lng: 79.8612 }; // Example: Colombo

// const polygonCoords = [
//   { lat: 6.166448935794875, lng: 80.32652089999084 },
//   { lat: 6.33403784273662 , lng: 80.32652089999084},
//   { lat: 6.33403784273662, lng: 80.15380859900881 },
//   { lat: 6.166448935794875, lng: 80.15380859900881 },
//   { lat: 6.166448935794875, lng: 80.32652089999084 },
// ];

// export default function MyMap() {
//   const { isLoaded } = useJsApiLoader({
//     id: "google-map-script",
//     googleMapsApiKey: 'AIzaSyCW2VWhUQvG4G31LjozUbD5ff460s9YC2U',
//     libraries: GOOGLE_MAP_LIBRARIES,
//   });

//   if (!isLoaded) return <p>Loading...</p>;

//   return (
//     <GoogleMap mapContainerStyle={containerStyle} center={center} zoom={13}>
//       {/* Marker */}
//       <Marker position={center} />

//       {/* Polygon */}
//       <Polygon
//         paths={polygonCoords}
//         options={{
//           fillColor: "#ff9d00ff",
//           fillOpacity: 0.4,
//           strokeColor: "#3c0810ff",
//           strokeOpacity: 1,
//           strokeWeight: 2,
//         }}
//       />
//     </GoogleMap>
//   );
// }

import React, { useEffect, useState } from "react";
import { useParams, useNavigate, useLocation } from "react-router-dom";
import { Button } from "../components/ui/button"; // adjust if you don’t use shadcn
import EstateMap from "../components/EstateMap"; // your map component
import FieldInfoPanel from "../components/FieldInfoPanel"; // your info panel
// import {
//   fetchSections,
//   fetchStateDetails,
// } from "../services/FirestoreEstateServices";
import { mockEstate, mockGeoLocation } from "../lib/constants";

export default function MapPage() {
  const { estateId } = useParams<{ estateId: string }>();
  const navigate = useNavigate();
  const location = useLocation();

  // const [estate, setEstate] = useState<any>(null);
  // const [sections, setSections] = useState<any[]>([]);
  // const [selectedFieldId, setSelectedFieldId] = useState<string | number | null>(null);
  // const [selectedSectionId, setSelectedSectionId] = useState<number | null>(null);
  const [selectedFieldId, setSelectedFieldId] = useState<string | null>(null);
  const [selectedSectionId, setSelectedSectionId] = useState<string | null>(null);

  // parse query params
  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const sectionParam = params.get("section");
    const fieldParam = params.get("field");

    console.log("Received query params:", { sectionParam, fieldParam });

    if (sectionParam) setSelectedSectionId(sectionParam);
    if (fieldParam) setSelectedFieldId(fieldParam);
  }, [location.search]);
  

  // fetch estate + sections
  // useEffect(() => {
  //   if (estateId) {
  //     fetchStateDetails(estateId).then(setEstate);
  //     fetchSections(estateId).then(setSections);
  //   }
  // }, [estateId]);
  const estate = mockEstate;
  const sections = mockEstate.sections;

  // const section = sections.find((s) => s.id === selectedSectionId);
  // const field = section?.fields.find((f: { id: number }) => f.id === selectedFieldId);
// section/field lookup
  const section = sections.find((s) => s.id === selectedSectionId);
  const field = section?.fields.find((f) => f.id === selectedFieldId);


  // if (!estate) {
  //   return (
  //     <div className="h-screen flex items-center justify-center bg-background">
  //       <p className="text-muted-foreground">Loading estate map...</p>
  //     </div>
  //   );
  // }

  // return (
  //   <div className="h-screen flex flex-col bg-background">
  //     <header className="border-b bg-card z-10">
  //       <div className="px-6 py-4 flex items-center justify-between">
  //         <div className="flex items-center gap-3">
  //           <Button variant="ghost" size="sm" onClick={() => navigate(-1)}>
  //             Back
  //           </Button>
  //           <div>
  //             <h1 className="text-lg font-bold text-foreground">Estate Map View</h1>
  //             <p className="text-sm text-muted-foreground">{estate.stateName}</p>
  //           </div>
  //         </div>
  //       </div>
  //     </header>

  //     <div className="flex-1 flex overflow-hidden">
  //       <div className="flex-1 relative">
  //         <EstateMap
  //           fields ={sections.flatMap((s) => s.fields)}
  //           selectedFieldId={selectedFieldId}
  //           onFieldSelect={(id) => setSelectedFieldId(id)}
  //         />
  //       </div>

  //       <div className="w-96 border-l bg-card overflow-y-auto">
  //         <div className="p-6 space-y-6">
  //           <h2 className="text-xl font-bold mb-4 text-foreground">Field Information</h2>
  //           <FieldInfoPanel
  //             field ={field || null}
  //             section={section || null}
  //             isHighlighted={!!field}
  //           />
  //         </div>
  //       </div>
  //     </div>
  //   </div>
  // );
  return (
  <div className="h-screen flex flex-col bg-background">
    <header className="border-b bg-card z-10">
      <div className="px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Button variant="ghost" size="sm" onClick={() => navigate(-1)}>
            Back
          </Button>
          <div>
            <h1 className="text-lg font-bold text-foreground">Estate Map View</h1>
            <p className="text-sm text-muted-foreground">{estate.estateName}</p>
          </div>
        </div>
      </div>
    </header>

    <div className="flex-1 flex overflow-hidden">
      <div className="flex-1 relative">
        <EstateMap
          fields={sections.flatMap((s) => s.fields)}
          selectedFieldId={selectedFieldId}
          onFieldSelect={(id) => setSelectedFieldId(id)}
        />
      </div>

      <div className="w-96 border-l bg-card overflow-y-auto">
        <div className="p-6 space-y-6">
          <h2 className="text-xl font-bold mb-4 text-foreground">Field Information</h2>
          <FieldInfoPanel
            field={field || null}
            section={section || null}
            isHighlighted={!!field}
          />
        </div>
      </div>
    </div>
  </div>
);

}