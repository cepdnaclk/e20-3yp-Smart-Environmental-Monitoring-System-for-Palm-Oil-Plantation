import 'package:flutter_application_1/data/models/FiledReading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonResult {
  final Set<Polygon> polygons;
  final List<LatLng> selectedFieldCoords;
  final Set<Marker> markers;
  final FieldReading? latestReading;

  PolygonResult({
    required this.polygons,
    required this.selectedFieldCoords,
    required this.markers,
    this.latestReading,
  });
}