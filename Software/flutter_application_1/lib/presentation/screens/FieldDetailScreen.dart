import 'package:flutter/material.dart';

class FieldDetailScreen extends StatelessWidget {
  final String fieldName;
  final Map<String, dynamic> fieldData;

  const FieldDetailScreen({
    required this.fieldName,
    required this.fieldData, required fieldId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fieldName),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Field: $fieldName", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                _parameterCircle("Humidity", fieldData['humidity'] ?? '--', Colors.teal),
                _parameterCircle("Temperature", fieldData['temperature'] ?? '--', Colors.amber),
                _parameterCircle("Soil Moisture", fieldData['soilMoisture'] ?? '--', Colors.brown),
                _parameterCircle("Nitrogen", fieldData['nitrogen'] ?? '--', Colors.pinkAccent),
                _parameterCircle("Phosphorus", fieldData['phosphorus'] ?? '--', Colors.lightBlue),
                _parameterCircle("Potassium", fieldData['potassium'] ?? '--', Colors.green),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _parameterCircle(String label, dynamic value, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13)),
      ],
    );
  }
}
