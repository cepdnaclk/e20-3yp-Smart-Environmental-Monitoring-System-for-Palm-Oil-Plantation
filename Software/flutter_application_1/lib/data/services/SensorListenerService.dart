

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SensorListenerService {
  static final SensorListenerService _instance = SensorListenerService._internal();
  factory SensorListenerService() => _instance;
  SensorListenerService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _started = false;

  final Set<String> _skippedDocs = {};
  final Map<String, Map<String, double>> _lastValues = {}; // Track previous values

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
        final docId = doc.id;
        final data = doc.data();
        final now = DateFormat('hh:mm a').format(DateTime.now());

        double moisture = (data['soilMoisture'] ?? -1).toDouble();
        double n = (data['nitrogen'] ?? -1).toDouble();
        double p = (data['phosphorus'] ?? -1).toDouble();
        double k = (data['potassium'] ?? -1).toDouble();

        // Skip first time per docId
        if (!_skippedDocs.contains(docId)) {
          _skippedDocs.add(docId);
          _lastValues[docId] = {
            'moisture': moisture,
            'n': n,
            'p': p,
            'k': k,
          };
          continue;
        }

        final last = _lastValues[docId] ?? {};

        if (moisture != -1) {
          final lastMoisture = last['moisture'] ?? moisture;
          if (moisture < 6 && lastMoisture >= 6) {
            _notify("Low Moisture", "$moisture% detected at $now");
          } else if (moisture > 75 && lastMoisture <= 75) {
            _notify("High Moisture", "$moisture% detected at $now");
          }
        }

        if (n != -1) {
          final lastN = last['n'] ?? n;
          if (n < 3 && lastN >= 3) _notify("Low Nitrogen", "Nitrogen = $n at $now");
          if (n > 120 && lastN <= 120) _notify("High Nitrogen", "Nitrogen = $n at $now");
        }

        if (p != -1) {
          final lastP = last['p'] ?? p;
          if (p < 3 && lastP >= 3) _notify("Low Phosphorus", "Phosphorus = $p at $now");
          if (p > 120 && lastP <= 120) _notify("High Phosphorus", "Phosphorus = $p at $now");
        }

        if (k != -1) {
          final lastK = last['k'] ?? k;
          if (k < 3 && lastK >= 3) _notify("Low Potassium", "Potassium = $k at $now");
          if (k > 120 && lastK <= 120) _notify("High Potassium", "Potassium = $k at $now");
        }

        // ✅ Update the last known values
        _lastValues[docId] = {
          'moisture': moisture,
          'n': n,
          'p': p,
          'k': k,
        };
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

