import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/PolygonResult.dart';
import 'package:flutter_application_1/data/repositories/fieldRepository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapService {
  final Fieldrepository _fieldrepository = Fieldrepository();

  Future<PolygonResult> loadFieldPolygons({
    String? selectedStateId,
    String? selectedSectionId,
    String? selectedFieldId,
  }) async {
    final rawData = await _fieldrepository.fetchAllFieldData();
    final List<dynamic> allFields = rawData['fields'];

    final Set<Polygon> polygons = {};
    List<LatLng> selectedCoords = [];

    for (final field in allFields) {
      final List<LatLng> coords = field['coordinates'];
      final String fieldId = field['fieldId'];
      final bool isSelected =
          field['stateId'] == selectedStateId &&
          field['sectionId'] == selectedSectionId &&
          field['fieldId'] == selectedFieldId;

      polygons.add(
        Polygon(
          polygonId: PolygonId(fieldId),
          points: coords,
          strokeColor: isSelected ? Colors.red : Colors.blue,
          fillColor:
              isSelected ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.2),
          strokeWidth: 2,
        ),
      );

      if (isSelected) {
        selectedCoords = coords;
      }
    }

    return PolygonResult(polygons: polygons, selectedFieldCoords: selectedCoords);
  }
}
