class FieldReadingStat {
  final DateTime timestamp;
  final double soilMoisture;
  final double nitrogen;
  final double phosphorous;
  final double potassium;

  final List<Map<String, dynamic>> soilMoistureHistory;
  final List<Map<String, dynamic>> nitrogenHistory;
  final List<Map<String, dynamic>> phosphorousHistory;
  final List<Map<String, dynamic>> potassiumHistory;

  FieldReadingStat({
    required this.timestamp,
    required this.soilMoisture,
    required this.nitrogen,
    required this.phosphorous,
    required this.potassium,
    this.soilMoistureHistory = const [],
    this.nitrogenHistory = const [],
    this.phosphorousHistory = const [],
    this.potassiumHistory = const [],
  });

  FieldReadingStat copyWithHistory(List<FieldReadingStat> history) {
    return FieldReadingStat(
      timestamp: timestamp,
      soilMoisture: soilMoisture,
      nitrogen: nitrogen,
      phosphorous: phosphorous,
      potassium: potassium,
      soilMoistureHistory: history.map((e) => {
        'value': e.soilMoisture,
        'timestamp': e.timestamp,
      }).toList(),
      nitrogenHistory: history.map((e) => {
        'value': e.nitrogen,
        'timestamp': e.timestamp,
      }).toList(),
      phosphorousHistory: history.map((e) => {
        'value': e.phosphorous,
        'timestamp': e.timestamp,
      }).toList(),
      potassiumHistory: history.map((e) => {
        'value': e.potassium,
        'timestamp': e.timestamp,
      }).toList(),
    );
  }
}
