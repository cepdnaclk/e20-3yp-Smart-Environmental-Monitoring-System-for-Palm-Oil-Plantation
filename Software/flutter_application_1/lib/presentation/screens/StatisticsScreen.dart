// import 'package:flutter/material.dart';

// class StatisticsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.green[700],
//         title: Text("Division 001", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Chart Placeholder
//               Container(
//                 height: 200,
//                 color: Colors.white,
//                 child: Center(child: Text("Graph Placeholder")),
//               ),

//               SizedBox(height: 20),

//               // Data Table Placeholder
//               Container(
//                 color: Colors.white,
//                 padding: EdgeInsets.all(16),
//                 child: Text("Data Table Placeholder"),
//               ),

//               SizedBox(height: 20),

//               // Sensor Buttons
//               Column(
//                 children: [
//                   sensorButton("Humidity", Colors.blue),
//                   sensorButton("Soil Moisture", Colors.brown),
//                   sensorButton("NPK Levels", Colors.green),
//                   sensorButton("Temperature", Colors.yellow),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget sensorButton(String text, Color color) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 5),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(backgroundColor: color),
//         onPressed: () {},
//         child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  final ButtonStyle sensorButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 18),
    padding: const EdgeInsets.symmetric(vertical: 10),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Division 001", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Chart Placeholder
          RepaintBoundary(
            child: Container(
              height: 200,
              color: Colors.white,
              child: const Center(child: Text("Graph Placeholder")),
            ),
          ),

          const SizedBox(height: 20),

          // Data Table Placeholder
          RepaintBoundary(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: const Text("Data Table Placeholder"),
            ),
          ),

          const SizedBox(height: 20),

          // Sensor Buttons
          RepaintBoundary(
            child: Column(
              children: [
                sensorButton("Humidity", Colors.blue),
                sensorButton("Soil Moisture", Colors.brown),
                sensorButton("NPK Levels", Colors.green),
                sensorButton("Temperature", Colors.yellow[700]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sensorButton(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: sensorButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(color),
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }
}
