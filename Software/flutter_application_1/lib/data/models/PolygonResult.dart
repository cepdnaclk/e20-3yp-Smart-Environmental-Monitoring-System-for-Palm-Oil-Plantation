import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonResult {
  final Set<Polygon> polygons;
  final List<LatLng> selectedFieldCoords;

  PolygonResult({
    required this.polygons,
    required this.selectedFieldCoords,
  });
}