class SensorData {
  final String id;
  final double humidity;
  final double temperature;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double soilMoisture;

  SensorData({
    required this.id,
    required this.humidity,
    required this.temperature,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.soilMoisture,
  });
}
