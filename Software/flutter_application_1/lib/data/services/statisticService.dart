import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/services/ConnectivityService.dart';

class StatisticsService {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivityService = ConnectivityService();

  /// Section-based statistics (Cloud Function + Cache fallback)
  Future<Map<String, dynamic>> getSectionStats({
    required String sectionPath,
    required String parameter,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final docRef = firestore.doc('$sectionPath/statistics/$parameter');

    bool isOnline = false;
    try {
      isOnline = await _connectivityService.isConnected();
    } catch (e) {
      print('⚠️ Failed to check connectivity: $e');
    }

    if (!isOnline) {
      print('📴 Offline: Trying to load cached stats...');
      try {
        final cachedSnapshot = await docRef.get(
          const GetOptions(source: Source.cache),
        );
        if (cachedSnapshot.exists) {
          print("📦 Loaded statistics from cache.");
          return cachedSnapshot.data()!;
        } else {
          print("🚫 No cached stats found.");
          throw Exception("No cached data found");
        }
      } catch (e) {
        print("❌ Cache fetch error: $e");
        throw Exception("offline");
      }
    }

    try {
      final HttpsCallable callable =
      functions.httpsCallable('getSectionParameterStatistics');

      print('📤 Calling Cloud Function with:');
      print('  sectionPath: $sectionPath');
      print('  parameter: $parameter');

      final result = await callable.call(<String, dynamic>{
        'sectionPath': sectionPath,
        'parameter': parameter,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
      });

      print('✅ Cloud Function responded: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      print('❌ Error calling cloud function: $e');
      rethrow;
    }
  }

  /// General collection-based statistics (Firestore native)
  Future<Map<String, dynamic>> getCollectionStats({
    required String collectionName,
    required String parameter,
  }) async {
    final collectionRef = firestore.collection(collectionName);
    final querySnapshot = await collectionRef
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();

    final List<Map<String, dynamic>> dataPoints = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      if (data.containsKey(parameter)) {
        dataPoints.add({
          'timestamp': data['timestamp'],
          'value': (data[parameter] as num).toDouble(),
        });
      }
    }

    final values = dataPoints.map((e) => e['value'] as double).toList();

    if (values.isEmpty) {
      return {
        'dataPoints': [],
      };
    }

    values.sort();
    final mean = values.reduce((a, b) => a + b) / values.length;
    final median = values.length % 2 == 0
        ? (values[values.length ~/ 2 - 1] + values[values.length ~/ 2]) / 2
        : values[values.length ~/ 2];
    final mode = values.fold<Map<double, int>>({}, (map, value) {
      map[value] = (map[value] ?? 0) + 1;
      return map;
    }).entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final variance = values
        .map((v) => pow(v - mean, 2))
        .reduce((a, b) => a + b) /
        values.length;
    final stdDev = sqrt(variance);
    final skewness = values
        .map((v) => pow(v - mean, 3))
        .reduce((a, b) => a + b) /
        (values.length * pow(stdDev, 3));
    final kurtosis = values
        .map((v) => pow(v - mean, 4))
        .reduce((a, b) => a + b) /
        (values.length * pow(variance, 2));

    return {
      'dataPoints': dataPoints,
      'mean': mean,
      'median': median,
      'mode': mode,
      'standardDeviation': stdDev,
      'variance': variance,
      'skewness': skewness,
      'kurtosis': kurtosis,
      'min': values.first,
      'max': values.last,
      'count': values.length,
    };
  }
}

/*import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/services/ConnectivityService.dart';

class StatisticsService {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivityService = ConnectivityService();

  Future<Map<String, dynamic>> getSectionStats({
    required String sectionPath,
    required String parameter,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final docRef = firestore.doc('$sectionPath/statistics/$parameter');

    bool isOnline = false;
    try {
      isOnline = await _connectivityService.isConnected();
    } catch (e) {
      print('⚠️ Failed to check connectivity: $e');
    }

    // 🔌 Try loading from cache when offline
    if (!isOnline) {
      print('📴 Offline: Trying to load cached stats...');
      try {
        final cachedSnapshot = await docRef.get(
          const GetOptions(source: Source.cache),
        );
        if (cachedSnapshot.exists) {
          print("📦 Loaded statistics from cache.");
          return cachedSnapshot.data()!;
        } else {
          print("🚫 No cached stats found.");
          throw Exception("No cached data found");
        }
      } catch (e) {
        print("❌ Cache fetch error: $e");
        throw Exception("offline");
      }
    }

    // 🌐 Online: Fetch from Cloud Function
    try {
      final HttpsCallable callable =
      functions.httpsCallable('getSectionParameterStatistics');

      print('📤 Calling Cloud Function with:');
      print('  sectionPath: $sectionPath');
      print('  parameter: $parameter');

      final result = await callable.call(<String, dynamic>{
        'sectionPath': sectionPath,
        'parameter': parameter,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
      });

      print('✅ Cloud Function responded: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      print('❌ Error calling cloud function: $e');
      rethrow;
    }
  }
}

  // Future<Map<String, dynamic>> getSectionStats({
  //   required String sectionPath,
  //   required String parameter,
  //   DateTime? startTime,
  //   DateTime? endTime,
  // }) async {
  //   final HttpsCallable callable = functions.httpsCallable('getSectionParameterStatistics');

  //   final result = await callable.call(<String, dynamic>{
  //     'sectionPath': sectionPath,
  //     'parameter': parameter,
  //     'startTime': startTime?.toIso8601String(),
  //     'endTime': endTime?.toIso8601String(),
  //   });

  //   return Map<String, dynamic>.from(result.data);
  // }








    /*
    final _connectivityService = ConnectivityService();
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getSectionParameterStatistics');

    print('📤 Calling getSectionParameterStatistics with:');
    print('  sectionPath: $sectionPath');
    print('  parameter: $parameter');

    if (!await _connectivityService.isConnected()) {
      print('🚫 Offline detected. Skipping Cloud Function call.');
      throw Exception('offline');
    }

    try {
      final result = await callable.call(<String, dynamic>{
        'sectionPath': sectionPath,
        'parameter': parameter,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
      });

      print('✅ Cloud Function responded: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      print('❌ Error calling cloud function: $e');
      rethrow;
    }

  }

}*/

*/
