import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FieldDetailScreen extends StatelessWidget {
  final String fieldName;
  final Map<String, dynamic> fieldData;
  final String fieldId;

  const FieldDetailScreen({
    required this.fieldName,
    required this.fieldData,
    required this.fieldId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Placeholder for Google Map
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.green[100], // light green as "map" placeholder
            child: const Center(
              child: Icon(Icons.map, size: 100, color: Colors.green),
            ),
          ),
          Positioned(
            top: 40, // Adjust for padding (especially with status bar)
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),


          // Simulated marker position
          Positioned(
            top: 200,
            left: MediaQuery.of(context).size.width / 2 - 12,
            child: const Icon(Icons.location_on, size: 32, color: Colors.black),
          ),

          // Bottom overlay card with sensor data
          DraggableScrollableSheet(
            initialChildSize: 0.35, // starting height (e.g., 35% of screen)
            minChildSize: 0.25,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('d MMM yyyy hh:mm a').format(DateTime.now()),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 20,
                        children: [
                          _sensorBadge("Humidity", "${fieldData['humidity'] ?? '--'}", Colors.cyan),
                          _sensorBadge("Temperature", "${fieldData['temperature'] ?? '--'}", Colors.yellow[700]!),
                          _sensorBadge("Soil Moisture", "${fieldData['soilMoisture'] ?? '--'}", Colors.brown),
                          _sensorBadge("Nitrogen", "${fieldData['nitrogen'] ?? '--'}", Colors.pinkAccent),
                          _sensorBadge("Phosphorus", "${fieldData['phosphorus'] ?? '--'}", Colors.lightBlue),
                          _sensorBadge("Potassium", "${fieldData['potassium'] ?? '--'}", Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        ],
      ),
    );
  }

  Widget _sensorBadge(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
