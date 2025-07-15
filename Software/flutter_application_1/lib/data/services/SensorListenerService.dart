/*import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Thresholds {
  final double minMoisture;
  final double maxMoisture;
  final double minNitrogen;
  final double maxNitrogen;
  final double minPhosphorus;
  final double maxPhosphorus;
  final double minPotassium;
  final double maxPotassium;

  Thresholds({
    required this.minMoisture,
    required this.maxMoisture,
    required this.minNitrogen,
    required this.maxNitrogen,
    required this.minPhosphorus,
    required this.maxPhosphorus,
    required this.minPotassium,
    required this.maxPotassium,
  });

  factory Thresholds.fromFirestore(Map<String, dynamic> data) {
    return Thresholds(
      minMoisture: (data['soilMoisture']['lower'] ?? 6).toDouble(),
      maxMoisture: (data['soilMoisture']['upper'] ?? 100).toDouble(),
      minNitrogen: (data['nitrogen']['lower'] ?? 3).toDouble(),
      maxNitrogen: (data['nitrogen']['upper'] ?? 60).toDouble(),
      minPhosphorus: (data['phosphorus']['lower'] ?? 2).toDouble(),
      maxPhosphorus: (data['phosphorus']['upper'] ?? 50).toDouble(),
      minPotassium: (data['potassium']['lower'] ?? 5).toDouble(),
      maxPotassium: (data['potassium']['upper'] ?? 50).toDouble(),
    );
  }
}

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

  Future<void> startListening() async {
    if (_started) return;
    _started = true;

    final thresholdSnapshot = await FirebaseFirestore.instance
        .collection('config')
        .doc('thresholds')
        .get();

    if (!thresholdSnapshot.exists) return;
    final thresholds = Thresholds.fromFirestore(thresholdSnapshot.data()!);

    FirebaseFirestore.instance
        .collection('raw_readings')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final now = DateFormat('hh:mm a').format(DateTime.now());

        double moisture = (data['soilMoisture'] ?? -1).toDouble();
        double n = (data['nitrogen'] ?? -1).toDouble();
        double p = (data['phosphorus'] ?? -1).toDouble();
        double k = (data['potassium'] ?? -1).toDouble();

        if (moisture != -1 && moisture < thresholds.minMoisture) {
          _notify("Low Moisture", "$moisture% moisture at $now");
        } else if (moisture > thresholds.maxMoisture) {
          _notify("High Moisture", "$moisture% moisture at $now");
        }

        if (n != -1 && n < thresholds.minNitrogen) {
          _notify("Low Nitrogen", "Nitrogen=$n at $now");
        } else if (n > thresholds.maxNitrogen) {
          _notify("High Nitrogen", "Nitrogen=$n at $now");
        }

        if (p != -1 && p < thresholds.minPhosphorus) {
          _notify("Low Phosphorus", "Phosphorus=$p at $now");
        } else if (p > thresholds.maxPhosphorus) {
          _notify("High Phosphorus", "Phosphorus=$p at $now");
        }

        if (k != -1 && k < thresholds.minPotassium) {
          _notify("Low Potassium", "Potassium=$k at $now");
        } else if (k > thresholds.maxPotassium) {
          _notify("High Potassium", "Potassium=$k at $now");
        }
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

        if (moisture != -1 && moisture < 6) {
          _notify("Low Moisture", "$moisture% moisture detected at $now");
        }

        if (n != -1 && n < 3) _notify("Low Nitrogen", "Nitrogen=$n is detected at $now");
        if (p != -1 && p < 2) _notify("Low Phosphorus", "Phosphorus=$p is detected at $now");
        if (k != -1 && k < 5) _notify("Low Potassium", "Potassium=$k is detected at $now");

        if (moisture != -1 && moisture > 100) {
          _notify("High Moisture", "$moisture% moisture detected at $now");
        }

        if (n != -1 && n > 60) _notify("High Nitrogen", "Nitrogen=$n is detected at $now");
        if (p != -1 && p > 50) _notify("High Phosphorus", "Phosphorus=$p is detected at $now");
        if (k != -1 && k > 50) _notify("High Potassium", "Potassium=$k is detected at $now");
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
*/
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

        if (moisture != -1 && moisture < 6) {
          _notify("Low Moisture", "$moisture% moisture detected at $now");
        }

        if (n != -1 && n < 3) _notify("Low Nitrogen", "Nitrogen=$n is detected at $now");
        if (p != -1 && p < 2) _notify("Low Phosphorus", "Phosphorus=$p is detected at $now");
        if (k != -1 && k < 5) _notify("Low Potassium", "Potassium=$k is detected at $now");

        if (moisture != -1 && moisture > 100) {
          _notify("High Moisture", "$moisture% moisture detected at $now");
        }

        if (n != -1 && n > 60) _notify("High Nitrogen", "Nitrogen=$n is detected at $now");
        if (p != -1 && p > 50) _notify("High Phosphorus", "Phosphorus=$p is detected at $now");
        if (k != -1 && k > 50) _notify("High Potassium", "Potassium=$k is detected at $now");
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


