import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/data/services/weatherService.dart';

// ✅ Custom Button
Widget customButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: onPressed,
    child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}

// Social Media Login Button
Widget socialIconNew(String iconPath, VoidCallback onPressed) {
  return IconButton(
    icon: Image.asset(
      iconPath,
      width: 50,
      height: 50,
    ),
    onPressed: onPressed,
  );
}

Widget socialIcon(String iconPath) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 22,
      child: Image.asset(iconPath, width: 25),
    ),
  );
}

// // ✅ Custom TextField Widget (with controller support)
// Widget customTextField(String label, {bool obscureText = false, TextEditingController? controller, required Null Function(dynamic val) onChanged}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: TextField(
//       controller: controller, // ✅ Now supports input controllers
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     ),
//   );
// }

Widget customTextField(
    String label, {
      bool obscureText = false,
      TextEditingController? controller,
      Function(dynamic val)? onChanged,
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged, // this works fine even if it's null
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

// class WeatherSummaryCard extends StatelessWidget {
//   const WeatherSummaryCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Map<String, String>>(
//       stream: weatherSummaryStream(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return const Center(child: Text("Error loading weather data"));
//         }

//         final weatherData = snapshot.data!;
//         final lux = weatherData['lux']!;
//         final rainfall = weatherData['rainfall']!;

//         return Container(
//           margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.lightGreenAccent.shade100, Colors.greenAccent.shade100],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black87)],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Weather",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _weatherItem("Lux Level", "assets/images/sunlight.png", lux),
//                   _weatherItem("Rainfall", "assets/images/rainfall.png", rainfall),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _weatherItem(String title, String imagePath, String value) {
//     return Column(
//       children: [

//         Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black38, width: 2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: AnimatedScale(
//             scale: 1.0,
//             duration: Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             child: Image.asset(imagePath, width: 40, height: 40),
//           ),

//         ),

//         const SizedBox(height: 6),
//         Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 4),
//         Text(value),
//       ],
//     );
//   }
// }

class WeatherSummaryCard extends StatelessWidget {
  const WeatherSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
      stream: weatherSummaryStream(), // unchanged
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading weather data"));
        }

        final weatherData = snapshot.data!;
        final lux = weatherData['lux']!;
        final rainfall = weatherData['rainfall']!;
        final temp = weatherData['temp'] ?? '25'; // default fallback
        final humidity = weatherData['humidity'] ?? '40'; // fallback

        final double luxVal = double.tryParse(lux) ?? 0;
        final double rainVal = double.tryParse(rainfall) ?? 0;
        final double tempVal = double.tryParse(temp) ?? 0;

        final isSunny = luxVal > 300 && rainVal < 2;
        final isRainy = rainVal >= 2;

        print("Hello, $rainfall");

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Section: Temperature and Weather Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Temperature", // or dynamically from GPS
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "+${tempVal.toStringAsFixed(0)}°C",
                        style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Image.asset(
                    isRainy
                        ? 'assets/images/rainy.webp'
                        : (isSunny ? 'assets/images/sunny.png' : 'assets/icons/cloudy.png'),
                    height: 70,
                    width: 70,
                  ),
                ],
              ),

              // const SizedBox(height: 20),
              const SizedBox(height: 10),
              const Divider(thickness: 1.5, color: Colors.black12),
              const SizedBox(height: 10),
              // Middle Weather Data
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _weatherItem("Humidity", "assets/images/humidity.png", "$humidity%"),
                  _weatherItem("Rainfall", "assets/images/rainy.webp", "$rainfall mm"),
                  _weatherItem("Lux Level", "assets/images/sunlight.png", lux),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _weatherItem(String title, String iconPath, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.black26, width: 1.5),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          child: Image.asset(iconPath, height: 30, width: 30),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}



class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNav({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 8,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey,
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == selectedIndex) return;

        if (index == 0) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (index == 1) {
          Navigator.pushNamed(context, AppRoutes.settingsScreen);
        } else if (index == 2) {
          Navigator.pushNamed(context, AppRoutes.chart);
        } else if (index == 3) {
          Navigator.pushNamed(context, AppRoutes.recentActivities);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
        BottomNavigationBarItem(icon: Icon(Icons.local_activity), label: 'Activity'),
      ],
    );
  }
}



Widget recentActivityItemNew({
  required String stateName,
  required String sectionName,
  required String fieldId,
  required String time,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      leading: const Icon(Icons.history, color: Colors.green),
      title: Text(
        "Estate - $stateName",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Section: $sectionName"),
          Text("Field ID: $fieldId"),
          Text(time),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        // Optional: Navigate to detailed view
      },
    ),
  );
}
