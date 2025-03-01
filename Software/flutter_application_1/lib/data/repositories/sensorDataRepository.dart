import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/entities/SoilParameters.dart';
import 'package:flutter_application_1/domain/entities/SensorData.dart';

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
      QuerySnapshot snapshot = await _firestore.collection('sensorData').get();
      return snapshot.docs.map((doc) {
        return SensorData(
          id: doc.id,
          humidity: (doc['humidity'] ?? 0).toDouble(),
          temperature: (doc['temperature'] ?? 0).toDouble(),
          timestamp: (doc['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch sensor data: $e");
    }
  }
}

