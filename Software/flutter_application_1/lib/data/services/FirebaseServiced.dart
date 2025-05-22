import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/LatestReading.dart';

Future<List<Map<String, dynamic>>> fetchSensorData() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('SensorData')
      .orderBy('timestamp')
      .get();

  return snapshot.docs.map((doc) => doc.data()).toList();
}



// For recent activities, latest reaings fetch
Future<List<LatestReading>> fetchLatestReadings() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('latest')
      .orderBy('timestamp', descending: true)
      .limit(10)
      .get();

  return snapshot.docs
      .map((doc) => LatestReading.fromFirestore(doc.data()))
      .toList();
}


// To fectch the rainfall data
Future<List<Map<String, dynamic>>> fetchRainfallReadings() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('rainfall_readings')
      .orderBy('timestamp', descending: true) // newest first
      .get();

  return querySnapshot.docs.map((doc) => doc.data()).toList();
}

// import 'package:flutter_application_1/data/models/SensorDataModel.dart';


// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<List<sensorData>> getSensorData() {
//     return _firestore.collection('sensorData').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return sensorData.fromJson(doc.data(), doc.id);
//       }).toList();
//     });
//   }
// }