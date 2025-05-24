import 'package:flutter/material.dart';

// A stateless screen that displays detailed sensor values for a selected field
class FieldDetailScreen extends StatelessWidget {
  final String fieldName;                    // The name of the field
  final Map<String, dynamic> fieldData;      // The sensor data associated with the field
  final String fieldId;                      // The ID of the field document in Firestore

  const FieldDetailScreen({
    required this.fieldName,
    required this.fieldData,
    required this.fieldId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar showing the field's name
      appBar: AppBar(
        title: Text(fieldName),
        backgroundColor: Colors.green[700],
      ),

      // Body of the screen with padding
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Heading text for the field
            Text(
              "Field: $fieldName",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // A responsive wrap layout to display sensor parameters as circular widgets
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,     // Horizontal space between circles
              runSpacing: 20,  // Vertical space when wrapping to next line
              children: [
                // Each circle shows a specific parameter and its value
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

  // A reusable widget to display each sensor value in a colored circle
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
        // Label below the circle
        Text(label, style: TextStyle(fontSize: 13)),
      ],
    );
  }
}
