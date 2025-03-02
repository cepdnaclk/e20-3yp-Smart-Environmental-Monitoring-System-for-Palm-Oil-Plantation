import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/entities/SoilParameters.dart';
import 'package:flutter_application_1/domain/entities/SensorData.dart';
import 'package:flutter_application_1/domain/entities/DeviceTwoData.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch Soil Parameters from Firestore
  Future<List<SoilParameters>> getSoilParameters() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('soilParameters').get();
      return snapshot.docs.map((doc) {
        return SoilParameters(
          id: doc.id,
          section: doc['section'] ?? '',
          nitrogenN: (doc['nitrogenN'] ?? 0).toDouble(),
          phosphorusP: (doc['phosphorusP'] ?? 0).toDouble(),
          potassiumK: (doc['potassiumK'] ?? 0).toDouble(),
        );
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch soil parameters: $e");
    }
  }

  // Fetch Sensor Data from Firestore
  Future<List<SensorData>> getSensorData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('SensorData').get();
      return snapshot.docs.map((doc) {
        return SensorData(
          id: doc.id,
          humidity: (doc['humidity'] ?? 0).toDouble(),
          temperature: (doc['temperature'] ?? 0).toDouble(),
          soilMoisture: (doc['soilMoisture'] ?? 0).toDouble(),
          latitude: (doc['latitude'] ?? 0).toDouble(),
          longitude: (doc['longitude'] ?? 0).toDouble(),
          timestamp: (doc['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch sensor data: $e");
    }
  }

    // Fetch Sensor Data - Device-2 from Firestore
  Future<List<DeviceTwoData>> getDeviceTwoData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('DeviceTwoData').get();
      return snapshot.docs.map((doc) {
        return DeviceTwoData(
          id: doc.id,
          lux: (doc['lux'] ?? 0).toDouble(),
          tipCount: (doc['tipCount'] ?? 0).toDouble(),
        );
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch sensor data: $e");
    }
  }
}

