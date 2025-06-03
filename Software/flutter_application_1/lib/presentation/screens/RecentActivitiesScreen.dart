import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class RecentActivitiesScreen extends StatelessWidget {
  // const RecentActivitiesScreen({super.key});
  const RecentActivitiesScreen({super.key, required List<Map<String, String>> activities});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 3;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Section: Today
          const Text("Today", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildActivityList([
            "Sensor: Soil Moisture",
            "Sensor: Light Intensity",
            "Device Two Accessed",
            "High Lux Alert",
          ]),

          const SizedBox(height: 30),

          // Section: Yesterday
          const Text("Yesterday", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildActivityList([
            "Low Rainfall Warning",
            "Tipping Bucket Accessed",
            "Exported Chart",
            "Tree Detection Run",
          ]),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: _selectedIndex),
    );
  }

  Widget _buildActivityList(List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: items.map((text) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
      ),
    );
  }
}
