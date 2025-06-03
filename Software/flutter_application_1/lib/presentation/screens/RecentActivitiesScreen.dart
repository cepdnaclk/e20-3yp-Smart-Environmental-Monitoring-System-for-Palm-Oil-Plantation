// import 'package:flutter/material.dart';
// import '../widgets/widgets.dart';

// class RecentActivitiesScreen extends StatelessWidget {
//   // const RecentActivitiesScreen({super.key});
//   const RecentActivitiesScreen({super.key, required List<Map<String, String>> activities});

//   @override
//   Widget build(BuildContext context) {
//     int _selectedIndex = 3;
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.green[700],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         children: [
//           // Section: Today
//           const Text("Today", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           _buildActivityList([
//             "Sensor: Soil Moisture",
//             "Sensor: Light Intensity",
//             "Device Two Accessed",
//             "High Lux Alert",
//           ]),

//           const SizedBox(height: 30),

//           // Section: Yesterday
//           const Text("Yesterday", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           _buildActivityList([
//             "Low Rainfall Warning",
//             "Tipping Bucket Accessed",
//             "Exported Chart",
//             "Tree Detection Run",
//           ]),
//         ],
//       ),
//       bottomNavigationBar: CustomBottomNav(selectedIndex: _selectedIndex),
//     );
//   }

//   Widget _buildActivityList(List<String> items) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       child: Column(
//         children: items.map((text) {
//           return Container(
//             width: double.infinity,
//             margin: const EdgeInsets.symmetric(vertical: 6),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/LatestReading.dart';
import 'package:flutter_application_1/data/services/FirebaseServiced.dart';
import 'package:intl/intl.dart';
import '../widgets/widgets.dart';      // For recentActivityItemNew and CustomBottomNav

class RecentActivitiesScreen extends StatelessWidget {
  const RecentActivitiesScreen({super.key});

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
        title: const Text(
          "Recent Activities",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<LatestReading>>(
        stream: streamLatestReadings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No recent activities found."));
          }

          final readings = snapshot.data!;
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));

          final todayReadings = readings.where(
            (r) => isSameDate(r.timestamp, today),
          ).toList();

          final yesterdayReadings = readings.where(
            (r) => isSameDate(r.timestamp, yesterday),
          ).toList();

          final earlierReadings = readings.where(
            (r) => !isSameDate(r.timestamp, today) &&
                  !isSameDate(r.timestamp, yesterday),
          ).toList();


          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              if (todayReadings.isNotEmpty) ...[
                const Text("Today", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildReadingList(todayReadings),
                const SizedBox(height: 20),
              ],
              if (yesterdayReadings.isNotEmpty) ...[
                const Text("Yesterday", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildReadingList(yesterdayReadings),
                const SizedBox(height: 20),
              ],
              if (earlierReadings.isNotEmpty) ...[
                const Text("Earlier", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildReadingList(earlierReadings),
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: _selectedIndex),
    );
  }

  Widget _buildReadingList(List<LatestReading> readings) {
    return Column(
      children: readings.map((reading) {
        final formattedTime = DateFormat('MMM d, yyyy – h:mm a').format(reading.timestamp);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: recentActivityItemNew(
            stateName: reading.stateName,
            sectionName: reading.sectionName,
            fieldId: reading.fieldId,
            time: formattedTime,
          ),
        );
      }).toList(),
    );
  }

  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
