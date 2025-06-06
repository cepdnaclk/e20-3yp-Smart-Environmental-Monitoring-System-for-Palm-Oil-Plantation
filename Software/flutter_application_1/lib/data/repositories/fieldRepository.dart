import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/FiledReading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Fieldrepository {
  Future<Map<String, dynamic>> fetchAllFieldData() async {
    final firestore = FirebaseFirestore.instance;
    final statesSnapshot = await firestore.collection('states').get();

    final List<Map<String, dynamic>> allFields = [];

    for (var stateDoc in statesSnapshot.docs) {
      final sections = await stateDoc.reference.collection('sections').get();

      for (var sectionDoc in sections.docs) {
        final fields = await sectionDoc.reference.collection('fields').get();

        for (var fieldDoc in fields.docs) {
          final data = fieldDoc.data();
          if (data.containsKey('boundary')) {
            final boundary = data['boundary'] as Map<String, dynamic>;
            final coordinatesList = boundary['coordinates'];

            List<LatLng> coords = [];

            if (data.containsKey('boundary')) {
                final boundary = data['boundary'] as Map<String, dynamic>;
                final coordinatesList = boundary['coordinates'];

                if (coordinatesList is List) {
                  coords = coordinatesList.map<LatLng>((point) {
                    if (point is GeoPoint) {
                      return LatLng(point.latitude, point.longitude);
                    } else if (point is Map) {
                      // fallback for Firestore weirdness
                      return LatLng(point['_latitude'], point['_longitude']);
                    } else {
                      return LatLng(0, 0); // fallback to avoid crash
                    }
                  }).toList();
                }

                // Ensure polygon is closed
                if (coords.isNotEmpty && coords.first != coords.last) {
                  coords.add(coords.first);
                }
              }


            allFields.add({
              'stateId': stateDoc.id,
              'sectionId': sectionDoc.id,
              'fieldId': fieldDoc.id,
              'coordinates': coords,
              'latestReading': data['latestReading'],
            });
          }
        }
      }
    }

    return {'fields': allFields};
  }



  Future<FieldReading?> fetchLatestReading({
    required String stateId,
    required String sectionId,
    required String fieldId,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final docRef = firestore
        .collection('states')
        .doc(stateId)
        .collection('sections')
        .doc(sectionId)
        .collection('fields')
        .doc(fieldId);

    final fieldSnapshot = await docRef.get();

    if (fieldSnapshot.exists) {
      final data = fieldSnapshot.data();
      if (data != null && data.containsKey('latestReading')) {
        final latestReading = data['latestReading'] as Map<String, dynamic>;
        return FieldReading.fromMap(latestReading);
      }
    }

    return null;
  }
}

