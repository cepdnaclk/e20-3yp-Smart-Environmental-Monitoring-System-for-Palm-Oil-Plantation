import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/LatestReading.dart';
import 'package:flutter_application_1/data/services/FirebaseServiced.dart';
import 'package:flutter_application_1/presentation/widgets/widgets.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/routes.dart';
import 'package:flutter_application_1/data/services/AuthService.dart';
import '../widgets/widgets.dart';
import 'package:another_flushbar/flushbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentDate = "";
  final AuthServices _auth = AuthServices();
  int _selectedIndex = 0;
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  List<Map<String, String>> _recentAlerts = [];


  @override
  void initState() {
    super.initState();
    updateDateTime();
    initNotifications();
    setupRealtimeSensorListener();
  }

  void updateDateTime() {
    final now = DateTime.now();
    setState(() {
      currentDate = DateFormat('EEEE, d MMM yyyy').format(now);
    });
  }

  void initNotifications() {
    const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    notificationsPlugin.initialize(initSettings);
  }

  void showFlushbarNotification(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
      margin: EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(Icons.warning, color: Colors.white),
    ).show(context);
  }


  void setupRealtimeSensorListener() {
    FirebaseFirestore.instance
        .collection('WeatherData')
        .doc('3hYbno5U6fGVUMG57On5')
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        checkThresholdsAndNotify(data);
      }
    });
  }

  void checkThresholdsAndNotify(Map<String, dynamic> data) {
    double rainfall = (data['rainfall'] ?? 0).toDouble();
    double lux = (data['lux'] ?? 0).toDouble();

    final now = DateFormat('hh:mm a').format(DateTime.now());

    if (rainfall < 30.0) {
      _logAlert("Low Rainfall", now);
      showFlushbarNotification(
          "Low Rainfall", "$rainfall% is below safe range.");
    }
    if (rainfall > 80.0) {
      _logAlert("High Rainfall", now);
      showFlushbarNotification(
          "High Rainfall", "$rainfall% exceeds safe limit.");
    }

    if (lux < 5000.0) {
      _logAlert("Low Light Intensity", now);
      showFlushbarNotification("Low Light Intensity", "$lux lux is too low.");
    }
    if (lux > 40000.0) {
      _logAlert("High Light Intensity", now);
      showFlushbarNotification("High Light Intensity", "$lux lux is too high.");
    }
  }


  void _logAlert(String title, String time) {
    setState(() {
      _recentAlerts.insert(0, {"title": title, "time": "Today - $time"});
      if (_recentAlerts.length > 5) _recentAlerts
          .removeLast(); // limit to 5 items
    });
  }


  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> stateData = [
      {'id': 'e6jApQOvbm3Aa3GL47sa', 'name': 'Homadola', 'desc': 'Main estate section'},
      {'id': 'state2', 'name': 'Nakiadeniya', 'desc': 'High elevation zone'},
      {'id': 'state3', 'name': 'Talangaha', 'desc': 'Experimental area'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔼 Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Hello", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text(currentDate, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white, size: 28),
                          onPressed: () async => await _auth.signOut(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🌤️ Weather Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: WeatherSummaryCard(),
              ),

              // ⚡ Quick Access
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quick Access", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _quickButton("Sensor Data", AppRoutes.sensorDataDisplay, Colors.green[700]!),
                        _quickButton("Tipping Bucket", AppRoutes.deviceTwoScreen, Colors.blue[700]!),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _quickButton("Tree Detection", AppRoutes.treeDetection, Colors.deepPurple),
                        _quickButton("Export Charts", AppRoutes.chart, Colors.indigo[700]!),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 🕓 Recent Activities - scrollable
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recent Activities",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 360, // Set desired scrollable height
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: FutureBuilder<List<LatestReading>>(
                        future: fetchLatestReadings(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text("No recent activities found."));
                          }

                          final readings = snapshot.data!;
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: readings.length,
                            itemBuilder: (context, index) {
                              final reading = readings[index];
                              final formattedTime = DateFormat('MMM d, yyyy – h:mm a').format(reading.timestamp);
                              return recentActivityItemNew(
                                stateName: reading.stateName,
                                sectionName: reading.sectionName,
                                fieldId: reading.fieldId,
                                time: formattedTime,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quick Access", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.sensorDataDisplay);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Sensor Data", style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.deviceTwoScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Device Two", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // // Recent Activities Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         "Recent Activities",
            //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //       ),
            //       const SizedBox(height: 10),
            //       // Here I have to display the recent acvities
            //         FutureBuilder<List<LatestReading>>(
            //           future: fetchLatestReadings(),
            //           builder: (context, snapshot) {
            //             if (snapshot.connectionState == ConnectionState.waiting) {
            //               return const Center(child: CircularProgressIndicator());
            //             } else if (snapshot.hasError) {
            //               return Text("Error: ${snapshot.error}");
            //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //               return const Text("No recent activities found.");
            //             }

            //             final readings = snapshot.data!;
            //             return Column(
            //               children: readings.map((reading) {
            //                 final formattedTime = DateFormat('MMM d, yyyy – h:mm a').format(reading.timestamp);
            //                 return recentActivityItemNew(
            //                   stateName: reading.stateName,
            //                   sectionName: reading.sectionName,
            //                   fieldId: reading.fieldId,
            //                   time: formattedTime,
            //                 );
            //               }).toList(),
            //             );
            //           },
            //         ),

            //     ],
            //   ),
            // ),
            // SizedBox(height: 20),


              SizedBox(height: 20),

              // 📊 Statistics
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Statistics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index) {
                        final division = stateData[index];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.section,
                                arguments: {
                                  'stateId': division['id'],
                                  'stateName': division['name'],
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Image.asset(
                                      'assets/images/division${index + 1}.jpg',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(division['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text(division['desc']!, style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),


                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNav(selectedIndex: _selectedIndex),
    );
  }

  Widget _quickButton(String title, String route, Color color) {
    return SizedBox(
      width: 160,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(title, style: TextStyle(color: Colors.white)),
      ),
    );
  }

}

