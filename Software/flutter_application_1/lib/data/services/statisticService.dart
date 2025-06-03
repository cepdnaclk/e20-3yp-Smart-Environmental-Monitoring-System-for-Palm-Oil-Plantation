import 'package:cloud_functions/cloud_functions.dart';

class StatisticsService {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

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


  Future<Map<String, dynamic>> getSectionStats({
  required String sectionPath,
  required String parameter,
  DateTime? startTime,
  DateTime? endTime,
}) async {
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getSectionParameterStatistics');

  print('📤 Calling getSectionParameterStatistics with:');
  print('  sectionPath: $sectionPath');
  print('  parameter: $parameter');

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

}
