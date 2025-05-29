import 'package:cloud_firestore/cloud_firestore.dart';

class FieldReading {
  final DateTime timestamp;
  final int soilMoisture;
  final int nitrogen;
  final int phosphorous;
  final int potassium;

  FieldReading({
    required this.timestamp,
    required this.soilMoisture,
    required this.nitrogen,
    required this.phosphorous,
    required this.potassium,
  });

  factory FieldReading.fromMap(Map<String, dynamic> data) {
    final npk = data['npk'] ?? {};
    return FieldReading(
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      soilMoisture: data['soilMoisture'] ?? 0,
      nitrogen: npk['nitrogen'] ?? 0,
      phosphorous: npk['phosphorous'] ?? 0,
      potassium: npk['potassium'] ?? 0,
    );
  }
}