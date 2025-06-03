import 'package:cloud_firestore/cloud_firestore.dart';

class LatestReading {
  final String stateName;
  final String stateId;
  final String sectionName;
  final String sectionId;
  final String fieldId;
  final DateTime timestamp;

  LatestReading({
    required this.stateName,
    required this.stateId,
    required this.sectionName,
    required this.sectionId,
    required this.fieldId,
    required this.timestamp,
  });

  factory LatestReading.fromFirestore(Map<String, dynamic> data) {
    return LatestReading(
      stateName: data['stateName'] ?? 'Unknown',
      stateId: data['stateId'] ?? 'Unknown',
      sectionName: data['sectionName'] ?? 'Unknown',
      sectionId: data['sectionId'] ?? 'Unknown',
      fieldId: data['fieldId'] ?? 'Unknown',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
