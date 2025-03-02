import 'package:flutter_application_1/domain/entities/SensorData.dart';

class SensorDataModel extends SensorData {
  SensorDataModel({
    required super.id,
    required super.humidity,
    required super.temperature,
    required super.timestamp,
    required super.latitude,
    required super.longitude,
    required super.soilMoisture,
  });

  // Convert Firestore JSON to Model
  factory SensorDataModel.fromJson(Map<String, dynamic> json, String id) {
    return SensorDataModel(
      id: id,
      humidity: (json['humidity'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      soilMoisture: (json['soilMoisture'] ?? 0).toDouble(),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Convert Model to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'humidity': humidity,
      'temperature': temperature,
      'latitude': latitude,
      'longitude': temperature,
      'soilMoisture': soilMoisture,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
