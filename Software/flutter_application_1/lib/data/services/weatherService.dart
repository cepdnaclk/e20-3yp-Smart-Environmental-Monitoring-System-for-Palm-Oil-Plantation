import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

Stream<Map<String, String>> weatherSummaryStream() {
  final rainfallStream = FirebaseFirestore.instance
      .collection('rainfall_readings')
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots();

  final luxStream = FirebaseFirestore.instance
      .collection('lux_level')
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots();

  return Rx.combineLatest2<QuerySnapshot<Map<String, dynamic>>,
      QuerySnapshot<Map<String, dynamic>>, Map<String, String>>(
    rainfallStream,
    luxStream,
    (rainfallSnapshot, luxSnapshot) {
      final rainfallData = rainfallSnapshot.docs.isNotEmpty
          ? rainfallSnapshot.docs.first.data()
          : {};
      final luxData = luxSnapshot.docs.isNotEmpty
          ? luxSnapshot.docs.first.data()
          : {};

      final rainfall = "${rainfallData['rainfall'] ?? '0'}";
      final lux = "${luxData['lux'] ?? '0'} ";
      final temp = "${luxData['temp'] ?? '25'} ";
      final humidity = "${luxData['humidity'] ?? '40'} ";

      return {
        'rainfall': rainfall,
        'lux': lux,
        'temp' : temp,
        'humidity' : humidity,
      };
    },
  );
}