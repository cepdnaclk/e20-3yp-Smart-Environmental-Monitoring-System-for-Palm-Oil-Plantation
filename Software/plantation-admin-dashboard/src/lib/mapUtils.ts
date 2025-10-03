import type { Coordinate } from "@shared/schema";

// Point-in-polygon algorithm using ray casting
export function isPointInPolygon(point: Coordinate, polygon: Coordinate[]): boolean {
  let inside = false;
  const x = point.lat;
  const y = point.lng;

  for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    const xi = polygon[i].lat;
    const yi = polygon[i].lng;
    const xj = polygon[j].lat;
    const yj = polygon[j].lng;

    const intersect =
      yi > y !== yj > y && x < ((xj - xi) * (y - yi)) / (yj - yi) + xi;

    if (intersect) {
      inside = !inside;
    }
  }

  return inside;
}

// Calculate polygon center for map centering
export function getPolygonCenter(coordinates: Coordinate[]): Coordinate {
  const latSum = coordinates.reduce((sum, coord) => sum + coord.lat, 0);
  const lngSum = coordinates.reduce((sum, coord) => sum + coord.lng, 0);

  return {
    lat: latSum / coordinates.length,
    lng: lngSum / coordinates.length,
  };
}

// Calculate bounds for all polygons
export function getPolygonsBounds(polygons: Coordinate[][]): google.maps.LatLngBounds {
  const bounds = new google.maps.LatLngBounds();
  
  polygons.forEach(polygon => {
    polygon.forEach(coord => {
      bounds.extend(new google.maps.LatLng(coord.lat, coord.lng));
    });
  });

  return bounds;
}
