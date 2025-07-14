import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/data/services/weatherService.dart';
import 'package:flutter_application_1/presentation/screens/NewParameterChart.dart';


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

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isRainy
                  ? [const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)]
                  : isSunny
                  ? [const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)]
                  : [const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A6741).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 20),

                // Top Section: Temperature and Weather Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Temp",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${tempVal.toStringAsFixed(0)}°C",
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getConditionColor(isRainy, isSunny),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getAgricultureCondition(isRainy, isSunny, tempVal, rainVal),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8FBC8F).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        isRainy
                            ? 'assets/images/rainy.png'
                            : (isSunny ? 'assets/images/sunny.png' : 'assets/icons/cloudy.png'),
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Agriculture-focused metrics
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF8FBC8F).withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Humidity
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/newParameterChart',
                                  arguments: {
                                    'title': 'Humidity',
                                    'parameter': 'humidity',
                                    'collection': 'lux_level',
                                  },
                                );
                              },
                              child: _weatherItem("Humidity", "assets/images/humidity.png", "$humidity%"),
                            ),
                          ),
                          _weatherDivider(),

                          // Rainfall
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/newParameterChart',
                                  arguments: {
                                    'title': 'Rainfall',
                                    'parameter': 'rainfall',
                                    'collection': 'rainfall_readings',
                                  },
                                );
                              },
                              child: _weatherItem("Rainfall", "assets/images/rainy.png", "$rainfall mm"),
                            ),
                          ),
                          _weatherDivider(),

                          // Lux Level
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/newParameterChart',
                                  arguments: {
                                    'title': 'Lux Level',
                                    'parameter': 'lux',
                                    'collection': 'lux_level',
                                  },
                                );
                              },
                              child: _weatherItem("Lux Level", "assets/images/sunlight.png", "$lux "),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _weatherItem(String title, String iconPath, String value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 56,
            width: 56,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFDFF5DD), // light green like in screenshot
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 20, // Fixed height for all titles
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 4),

          SizedBox(
            height: 22, // Fixed height for value
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _weatherDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.white.withOpacity(0.4),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Color _getConditionColor(bool isRainy, bool isSunny) {
    if (isRainy) return const Color(0xFF4A6741);
    if (isSunny) return const Color(0xFFE8B86D);
    return const Color(0xFF6B8E5A);
  }

  String _getAgricultureCondition(bool isRainy, bool isSunny, double temp, double rain) {
    if (isRainy) return "Good for Irrigation";
    if (isSunny && temp > 20 && temp < 35) return "Ideal Growing Weather";
    if (temp > 35) return "Heat Stress Risk";
    if (temp < 10) return "Frost Risk";
    return "Moderate Conditions";
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
          Navigator.pushNamed(context, AppRoutes.map);
        } else if (index == 3) {
          Navigator.pushNamed(context, AppRoutes.recentActivities);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
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
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF8FDF8), // Very light green
          Color(0xFFF0F8F0), // Slightly darker light green
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF4A6741).withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: const Color(0xFF8FBC8F).withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Optional: Navigate to detailed view
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Enhanced Leading Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8FBC8F),
                      Color(0xFF6B8E5A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B8E5A).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 16),

              // Enhanced Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estate Name with enhanced styling
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8FBC8F).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "🏞️ Estate - $stateName",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2D5016),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section and Time with icons
                    Row(
                      children: [
                        // Section Info
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6B8E5A).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.grid_view,
                                  size: 14,
                                  color: Color(0xFF6B8E5A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  sectionName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A6741),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Time with icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8FBC8F).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Color(0xFF6B8E5A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color(0xFF4A6741).withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Enhanced Trailing Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8FBC8F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF6B8E5A),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}