import 'package:flutter_application_1/domain/entities/SensorData.dart';

class SensorDataModel extends SensorData {
  SensorDataModel({
    required super.id,
    required super.humidity,
    required super.temperature,
    required super.timestamp,
  });

  // Convert Firestore JSON to Model
  factory SensorDataModel.fromJson(Map<String, dynamic> json, String id) {
    return SensorDataModel(
      id: id,
      humidity: (json['humidity'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Convert Model to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'humidity': humidity,
      'temperature': temperature,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
