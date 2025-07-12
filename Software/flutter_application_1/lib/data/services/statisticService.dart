import 'package:cloud_functions/cloud_functions.dart';
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