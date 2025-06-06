import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SensorListenerService {
  static final SensorListenerService _instance = SensorListenerService._internal();
  factory SensorListenerService() => _instance;
  SensorListenerService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _started = false;

  void initializePlugin() {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    notificationsPlugin.initialize(initSettings);
  }

  void startListening() {
    if (_started) return;
    _started = true;

    FirebaseFirestore.instance.collection('raw_readings').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final now = DateFormat('hh:mm a').format(DateTime.now());

        double moisture = (data['soilMoisture'] ?? -1).toDouble();
        double n = (data['nitrogen'] ?? -1).toDouble();
        double p = (data['phosphorus'] ?? -1).toDouble();
        double k = (data['potassium'] ?? -1).toDouble();

        if (moisture != -1 && moisture < 15) {
          _notify("Low Moisture", "$moisture% moisture detected at $now");
        }

        if (n != -1 && n < 10) _notify("Low Nitrogen", "Nitrogen=$n is low at $now");
        if (p != -1 && p < 5) _notify("Low Phosphorus", "Phosphorus=$p is low at $now");
        if (k != -1 && k < 5) _notify("Low Potassium", "Potassium=$k is low at $now");
      }
    });
  }

  void _notify(String title, String body) {
    const androidDetails = AndroidNotificationDetails(
      'alerts_channel',
      'Sensor Alerts',
      channelDescription: 'Notification channel for sensor threshold alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
    );
  }
}
