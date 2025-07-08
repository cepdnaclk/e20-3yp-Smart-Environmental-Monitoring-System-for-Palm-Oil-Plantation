import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/fieldReadingStat.dart';

Future<List<FieldReadingStat>> fetchLast30DaysReadings({
  required String stateId,
  required String sectionId,
  required String fieldId,
}) async {
  final now = DateTime.now();
  final cutoffDate = now.subtract(const Duration(days: 30));

  final snapshot = await FirebaseFirestore.instance
      .collection('/states/$stateId/sections/$sectionId/fields/$fieldId/readings')
      .where('timestamp', isGreaterThan: cutoffDate)
      .orderBy('timestamp')
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return FieldReadingStat(
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      soilMoisture: (data['soilMoisture'] ?? 0).toDouble(),
      nitrogen: (data['nitrogen'] ?? 0).toDouble(),
      phosphorous: (data['phosphorous'] ?? 0).toDouble(),
      potassium: (data['potassium'] ?? 0).toDouble(),
    );
  }).toList();
}
