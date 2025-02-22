import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentDate = "";
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    updateDateTime(); // Initial fetch
    Timer.periodic(Duration(seconds: 1), (timer) {
      updateDateTime();
    });
  }

  void updateDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMM yyyy').format(now); // Example: Monday, 3 Feb 2025
    final formattedTime = DateFormat('hh:mm a').format(now); // Example: 10:35 AM

    setState(() {
      currentDate = formattedDate;
      currentTime = formattedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(currentDate, style: TextStyle(fontSize: 14, color: Colors.white70)), // Auto-updating date
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Open menu drawer or other actions
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200], // Background color for better contrast
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Weather Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  children: [
                    Text("Weather", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        weatherTile(Icons.wb_sunny, "Lux Level", "120 W/m²"),
                        weatherTile(Icons.cloud, "Rainfall", "80 mm"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Activity Log with Real-Time Update
              Text("Today", style: sectionTitleStyle),
              activityLog("Location", currentTime), // Uses real-time clock
              SizedBox(height: 20),

              // Statistics Section
              Text("Statistics", style: sectionTitleStyle),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  statisticsCard("assets/images/division1.jpg", "Division 001", "Description #0027"),
                  statisticsCard("assets/images/division2.jpg", "Division 002", "Description #0025"),
                ],
              ),
              SizedBox(height: 30),

              // Logout Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login'); // Navigate back to Login
                  },
                  child: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Weather Tile Widget
  Widget weatherTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.orange),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  // Activity Log Widget
  Widget activityLog(String location, String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        children: [
          Icon(Icons.location_pin, color: Colors.black54),
          SizedBox(width: 10),
          Expanded(child: Text(location, style: TextStyle(fontSize: 16))),
          Text(time, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  // Statistics Card Widget
  Widget statisticsCard(String imagePath, String title, String description) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(imagePath, height: 90, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Title Text Style
  final TextStyle sectionTitleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}
