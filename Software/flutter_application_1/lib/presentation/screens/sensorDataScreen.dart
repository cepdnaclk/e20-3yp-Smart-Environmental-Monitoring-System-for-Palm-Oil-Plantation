import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/SensorData.dart';
import 'package:flutter_application_1/data/repositories/databaseService.dart' as dbService;
import 'package:flutter_application_1/data/repositories/sensorDataRepository.dart' as sensorRepo;

class SensorDataDisplay extends StatefulWidget {
  const SensorDataDisplay({super.key});

  @override
  _SensorDataDisplayState createState() => _SensorDataDisplayState();
}

class _SensorDataDisplayState extends State<SensorDataDisplay> {
  final sensorRepo.FirestoreRepository firestoreRepository = sensorRepo.FirestoreRepository();
  late Future<List<SensorData>> futureSensorData;

  @override
  void initState() {
    super.initState();
    futureSensorData = firestoreRepository.getSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor Data")),
      body: FutureBuilder<List<SensorData>>(
        future: futureSensorData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          } else {
            List<SensorData> sensorDataList = snapshot.data!;
            return ListView.builder(
              itemCount: sensorDataList.length,
              itemBuilder: (context, index) {
                SensorData sensor = sensorDataList[index];
                return ListTile(
                  title: Text("Humidity: ${sensor.humidity}%"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Temperature: ${sensor.temperature}°C"),
                      Text("Timestamp: ${sensor.timestamp}"),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
