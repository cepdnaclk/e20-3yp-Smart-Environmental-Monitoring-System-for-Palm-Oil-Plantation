import 'package:flutter/material.dart';

class FieldStatisticsPanel extends StatelessWidget {
  final String sectionName;

  const FieldStatisticsPanel({super.key, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Text(
            "📊 Statistics for $sectionName",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Card(

          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                _statButton(context, "Humidity", Colors.blue, Icons.water_drop),
                const SizedBox(height: 12),
                _statButton(context, "Soil Moisture", Colors.brown, Icons.terrain),
                const SizedBox(height: 12),
                _statButton(context, "NPK Levels", Colors.green, Icons.eco),
                const SizedBox(height: 12),
                _statButton(context, "Temperature", Colors.orange, Icons.thermostat),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statButton(BuildContext context, String label, Color color, IconData icon) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        // Implement navigation or interaction here
        print("Tapped $label");
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
