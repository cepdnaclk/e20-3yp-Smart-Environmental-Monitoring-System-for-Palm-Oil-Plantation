import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchSensorData() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('SensorData')
      .orderBy('timestamp')
      .get();

  return snapshot.docs.map((doc) => doc.data()).toList();
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