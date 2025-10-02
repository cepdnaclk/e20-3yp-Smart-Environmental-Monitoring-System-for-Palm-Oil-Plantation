import type { Estate } from "../shared/schema";

// Google Maps API configuration
export const GOOGLE_MAP_LIBRARIES: ("places" | "drawing" | "geometry")[] = ["places", "drawing", "geometry"];

// Mock estate data - todo: remove mock functionality
export const mockEstate: Estate = {
  id: "e6jApQOvbm3Aa3GL47sa",
  estateName: "Homadola",
  description: "Premium tea plantation estate",
  manager: "John Silva",
  location: "Nuwara Eliya, Sri Lanka",
  sections: [
    {
      id: "section_ar",
      name: "North Section",
      fields: [
        {
          id: "field-g",
          name: "Field A1",
          area: 12.5,
          coordinates: [
            { lat: 6.9271, lng: 80.7511 },
            { lat: 7.9371, lng: 80.7511 },
            { lat: 7.9371, lng: 90.7611 },
            { lat: 6.9271, lng: 90.7611 },
            { lat: 6.9271, lng: 80.7511 },
          ],
        },
        {
          id: "field-2",
          name: "Field A2",
          area: 15.3,
          coordinates: [
            { lat: 6.9271, lng: 80.7611 },
            { lat: 6.9371, lng: 80.7611 },
            { lat: 6.9371, lng: 80.7711 },
            { lat: 6.9271, lng: 80.7711 },
          ],
        },
      ],
    },
    {
      id: "section_com",
      name: "South Section",
      fields: [
        {
          id: "field-b",
          name: "Field B1",
          area: 18.7,
          coordinates: [
            { lat: 6.9171, lng: 80.7511 },
            { lat: 6.9271, lng: 80.7511 },
            { lat: 6.9271, lng: 80.7611 },
            { lat: 6.9171, lng: 80.7611 },
          ],
        },
        {
          id: "field-4",
          name: "Field B2",
          area: 14.2,
          coordinates: [
            { lat: 6.9171, lng: 80.7611 },
            { lat: 6.9271, lng: 80.7611 },
            { lat: 6.9271, lng: 80.7711 },
            { lat: 6.9171, lng: 80.7711 },
          ],
        },
      ],
    },
  ],
};

// Default geo location for testing - todo: remove mock functionality
export const mockGeoLocation = { lat: 6.144580, lng: 80.340407 }; // Inside field-1
