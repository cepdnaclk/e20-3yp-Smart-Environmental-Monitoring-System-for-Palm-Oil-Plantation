import 'package:flutter_application_1/domain/entities/SoilParameters.dart';


class SoilParametersModel extends SoilParameters {
  SoilParametersModel({
    required String id,
    required String section,
    required double nitrogenN,
    required double phosphorusP,
    required double potassiumK,
  }) : super(
          id: id,
          section: section,
          nitrogenN: nitrogenN,
          phosphorusP: phosphorusP,
          potassiumK: potassiumK,
        );

  // Convert Firestore JSON to Model
  factory SoilParametersModel.fromJson(Map<String, dynamic> json, String id) {
    return SoilParametersModel(
      id: id,
      section: json['section'] ?? '',
      nitrogenN: (json['nitrogenN'] ?? 0).toDouble(),
      phosphorusP: (json['phosphorusP'] ?? 0).toDouble(),
      potassiumK: (json['potassiumK'] ?? 0).toDouble(),
    );
  }

  // Convert Model to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'nitrogenN': nitrogenN,
      'phosphorusP': phosphorusP,
      'potassiumK': potassiumK,
    };
  }
}
