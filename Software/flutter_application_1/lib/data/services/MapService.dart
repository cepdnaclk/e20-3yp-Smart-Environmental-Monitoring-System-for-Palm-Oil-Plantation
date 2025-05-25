import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/PolygonResult.dart';
import 'package:flutter_application_1/data/repositories/fieldRepository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapService {
  final Fieldrepository _fieldrepository = Fieldrepository();

  // Future<PolygonResult> loadFieldPolygons({
  //   String? selectedStateId,
  //   String? selectedSectionId,
  //   String? selectedFieldId,
  // }) async {
  //   final rawData = await _fieldrepository.fetchAllFieldData();
  //   final List<dynamic> allFields = rawData['fields'];

  //   final Set<Polygon> polygons = {};
  //   final Set<Marker> markers = {};
  //   List<LatLng> selectedCoords = [];

  //   for (final field in allFields) {
  //     final List<LatLng> coords = field['coordinates'];
  //     final String fieldId = field['fieldId'];
  //     final bool isSelected =
  //         field['stateId'] == selectedStateId &&
  //         field['sectionId'] == selectedSectionId &&
  //         field['fieldId'] == selectedFieldId;

  //     polygons.add(
  //       Polygon(
  //         polygonId: PolygonId(fieldId),
  //         points: coords,
  //         strokeColor: isSelected ? Colors.red : Colors.blue,
  //         fillColor:
  //             isSelected ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.2),
  //         strokeWidth: 2,
  //       ),
  //     );

  //     if (field['latestReading'] == null) {
  //       print("❌ $fieldId skipped - latestReading is null");
  //     } else if (field['latestReading']['location'] == null) {
  //       print("❌ $fieldId skipped - location inside latestReading is null");
  //     } else {
  //       final GeoPoint geo = field['latestReading']['location'];
  //       print("✅ $fieldId location found: ${geo.latitude}, ${geo.longitude}");

  //       markers.add(
  //         Marker(
  //           markerId: MarkerId('marker_$fieldId'),
  //           position: LatLng(geo.latitude, geo.longitude),
  //           infoWindow: InfoWindow(title: 'Latest Reading - $fieldId'),
  //           icon: BitmapDescriptor.defaultMarkerWithHue(
  //             isSelected ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
  //           ),
  //         ),
  //       );
  //     }



  //     if (isSelected) {
  //       selectedCoords = coords;
  //     }
  //   }

  //   return PolygonResult(polygons: polygons, selectedFieldCoords: selectedCoords, markers: markers);
  //   // return PolygonResult(polygons: polygons, selectedFieldCoords: selectedCoords);
  // }
  Future<PolygonResult> loadFieldPolygons({
    String? selectedStateId,
    String? selectedSectionId,
    String? selectedFieldId,
  }) async {
    final rawData = await _fieldrepository.fetchAllFieldData();
    final List<dynamic> allFields = rawData['fields'];

    final Set<Polygon> polygons = {};
    final Set<Marker> markers = {};
    List<LatLng> selectedCoords = [];

    for (final field in allFields) {
      final List<LatLng> coords = field['coordinates'];
      final String fieldId = field['fieldId'];
      final bool isSelected =
          field['stateId'] == selectedStateId &&
          field['sectionId'] == selectedSectionId &&
          field['fieldId'] == selectedFieldId;

      // Always add polygon
      polygons.add(
        Polygon(
          polygonId: PolygonId(fieldId),
          points: coords,
          strokeColor: isSelected ? Colors.red : Colors.blue,
          fillColor: isSelected
              ? Colors.red.withOpacity(0.3)
              : Colors.blue.withOpacity(0.2),
          strokeWidth: 2,
        ),
      );

      // If this is the selected field, capture coords and place a marker
      print("DEBUG: full field object for $fieldId: $field");
      if (isSelected) {
        selectedCoords = coords;

        final latestReading = field['latestReading'];
        if (latestReading == null) {
          print("❌ $fieldId skipped - latestReading is null");
        } else if (latestReading['location'] == null) {
          print("❌ $fieldId skipped - location inside latestReading is null");
        } else {
          final GeoPoint geo = latestReading['location'];
          print("✅ $fieldId location found: ${geo.latitude}, ${geo.longitude}");

          markers.add(
            Marker(
              markerId: MarkerId('marker_$fieldId'),
              position: LatLng(geo.latitude, geo.longitude),
              infoWindow: InfoWindow(title: 'Latest Reading - $fieldId'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
        }
      }
    }

    return PolygonResult(
      polygons: polygons,
      selectedFieldCoords: selectedCoords,
      markers: markers,
    );
  }
}
