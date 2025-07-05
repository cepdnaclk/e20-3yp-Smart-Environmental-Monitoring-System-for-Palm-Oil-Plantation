import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/services/statisticService.dart';
import 'package:flutter_application_1/presentation/screens/ParameterChart.dart';

class FieldStatisticsPanel extends StatelessWidget {
  final String sectionName;

  // const FieldStatisticsPanel({super.key, required this.sectionName});
  final String sectionPath; // like "states/{stateId}/sections/{sectionId}"
  const FieldStatisticsPanel({
    Key? key,
    required this.sectionName,
    required this.sectionPath,
  }) : super(key: key);


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
                _statButton(context, "Soil Moisture", Colors.brown, Icons.terrain),
                const SizedBox(height: 12),
                _statButton(context, "Nitrogen", Colors.blue, Icons.water_drop),
                const SizedBox(height: 12),
                _statButton(context, "Phosphorus", Colors.green, Icons.eco),
                const SizedBox(height: 12),
                _statButton(context, "Potassium", Colors.orange, Icons.thermostat),
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
      

// onPressed: () async {
//   try {
//     final statisticsService = StatisticsService();

//     // Debugging steps
//     debugPrint('📤 Calling getSectionStats with:');
//     debugPrint('  Section Path: $sectionPath');
//     debugPrint('  Parameter: ${_mapLabelToParameter(label)}');

//     final result = await statisticsService.getSectionStats(
//       sectionPath: sectionPath,
//       // sectionPath: "states/e6jApQOvbm3Aa3GL47sa/sections/YYmmnKIUdP1yUdeVaTeU",
//       parameter: _mapLabelToParameter(label),
//       // parameter: "soilMoisture",
//     );

//     // ✅ Print the full result from the cloud function
//     debugPrint('Cloud Function Result:\n$result');

//     final rawDataPoints = result['dataPoints'];
//     List<Map<String, dynamic>> sensorData = [];

//     if (rawDataPoints != null && rawDataPoints is List) {

//       // Debugging steps
//       if (sensorData.isEmpty) {
//         debugPrint('⚠️ No sensor data found in the result!');
//       } else {
//         debugPrint('✅ Parsed ${sensorData.length} sensor data points.');
//       }

//       sensorData = rawDataPoints.map<Map<String, dynamic>>((dp) {
//         final timestamp = dp['timestamp'];
//         DateTime parsedTime;

//         // Debugging steps
//         debugPrint('🕒 Raw timestamp value: $timestamp (${timestamp.runtimeType})');

//         if (timestamp is Timestamp) {
//           parsedTime = timestamp.toDate();
//         } else if (timestamp is String) {
//           parsedTime = DateTime.tryParse(timestamp) ?? DateTime.now();
//         } else if (timestamp is DateTime) {
//           parsedTime = timestamp;
//         } else {
//           parsedTime = DateTime.now();
//         }

//         return {
//           'timestamp': Timestamp.fromDate(parsedTime),
//           _mapLabelToParameter(label): dp['value'],
//         };
//       }).toList();
//     }

//     // Navigator.of(context).push(MaterialPageRoute(
//     //   builder: (_) => ParameterChart(
//     //     title: label,
//     //     parameter: _mapLabelToParameter(label),
//     //     sectionName: sectionName,
//     //     sectionDescription: 'Description for $sectionName', // Replace with actual if available
//     //     sensorData: sensorData,
//     //     stats: result,
//     //   ),
//     // ));


//       Navigator.of(context).pushNamed(
//         '/parameterChart',
//         arguments: {
//           'title': label,
//           'parameter': _mapLabelToParameter(label),
//           'sectionName': sectionName,
//           'sectionDescription': 'Description for $sectionName', // Replace with actual if needed
//           'sensorData': sensorData,
//           'stats': result,
//         },
//       );


//     debugPrint('Navigating with:');
//     debugPrint('  Section Name: $sectionName');
//     debugPrint('  Section Path: $sectionPath');
//     debugPrint('  Parameter: ${_mapLabelToParameter(label)}');
//     debugPrint('  Sensor Data Count: ${sensorData.length}');


//   } catch (e) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Error"),
//         content: Text("Failed to fetch stats: $e"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Close"),
//           )
//         ],
//       ),
//     );
//   }
// }

onPressed: () {
  Navigator.of(context).pushNamed(
    '/parameterChart',
    arguments: {
      'title': label,
      'parameter': _mapLabelToParameter(label),
      'sectionName': sectionName,
      'sectionPath': sectionPath,
      'sectionDescription': 'Description for $sectionName',
      // sensorData and stats will be loaded in screen
    },
  );
}



    ,

      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}


String _mapLabelToParameter(String label) {
  switch (label) {
    case "Soil Moisture":
      return "soilMoisture";
    case "Nitrogen":
      return "npk.nitrogen";
    case "Phosphorus":
      return "npk.phosphorus";
    case "Potassium":
      return "npk.potassium";
    default:
      return label;
  }
}
