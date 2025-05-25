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
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('WeatherData')
//           .doc('3ox9hwKCRHb9D7kK440E')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final data = snapshot.data!.data() as Map<String, dynamic>;

//         final String lux = "${data['lux'] ?? '0'} W/m²";
//         final String rainfall = "${data['rainfall'] ?? '0'} mm";

//         return Container(
//           margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
//           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
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


//   Widget _weatherItem(String label, String iconPath, String value) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black38, width: 2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Image.asset(iconPath, width: 40, height: 40),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           value,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//         ),
//         Text(
//           label,
//           style: TextStyle(color: Colors.grey[900], fontSize: 12),
//         ),
//       ],
//     );
//   }
// }

class WeatherSummaryCard extends StatelessWidget {
  const WeatherSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
      stream: weatherSummaryStream(),
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

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreenAccent.shade100, Colors.greenAccent.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black87)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Weather",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _weatherItem("Lux Level", "assets/images/sunlight.png", lux),
                  _weatherItem("Rainfall", "assets/images/rainfall.png", rainfall),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _weatherItem(String title, String imagePath, String value) {
    return Column(
      children: [

        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedScale(
            scale: 1.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Image.asset(iconPath, width: 40, height: 40),
          ),

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
