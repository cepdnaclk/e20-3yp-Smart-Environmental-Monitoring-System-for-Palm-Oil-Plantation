import 'package:flutter_application_1/domain/entities/DeviceTwoData.dart';

class DeviceTwoDataModel extends DeviceTwoData {
  DeviceTwoDataModel({
    required super.id,
    required super.lux,
    required super.tipCount,
  });

  // Convert Firestore JSON to Model
  factory DeviceTwoDataModel.fromJson(Map<String, dynamic> json, String id) {
    return DeviceTwoDataModel(
      id: id,
      lux: (json['lux'] ?? 0).toDouble(),
      tipCount: (json['tipCount'] ?? 0).toDouble(),
    );
  }

  // Convert Model to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'lux': lux,
      'tipCount': tipCount,
    };
  }
}