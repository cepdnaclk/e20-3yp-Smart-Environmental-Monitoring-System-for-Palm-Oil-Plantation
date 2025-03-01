class SensorData {
  final String id;
  final double humidity;
  final double temperature;
  final DateTime timestamp;

  SensorData({
    required this.id,
    required this.humidity,
    required this.temperature,
    required this.timestamp,
  });
}
