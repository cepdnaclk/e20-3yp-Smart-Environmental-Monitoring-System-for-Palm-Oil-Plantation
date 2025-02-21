class soilParameters {
  String id;
  int nitrogenN;
  int phosphorusP;
  int potassiumK;
  String section;

  soilParameters({
    required this.id,
    required this.nitrogenN,
    required this.phosphorusP,
    required this.potassiumK,
    required this.section,
  });

  // Convert Firestore document to SoilParameter object
  factory soilParameters.fromMap(String id, Map<String, dynamic> data) {
    return soilParameters(
      id: id,
      nitrogenN: data['nitrogenN'] ?? 0,
      phosphorusP: data['phosphorusP'] ?? 0,
      potassiumK: data['potassiumK'] ?? 0,
      section: data['section'] ?? '',
    );
  }

  // Convert SoilParameter object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'nitrogenN': nitrogenN,
      'phosphorusP': phosphorusP,
      'potassiumK': potassiumK,
      'section': section,
    };
  }
}
