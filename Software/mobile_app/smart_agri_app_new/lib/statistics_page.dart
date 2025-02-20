import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});
  @override
  StatisticsPageState createState() => StatisticsPageState();
}


class StatisticsPageState extends State<StatisticsPage> {
  String currentDate = "";
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    updateDateTime();
  }

  void updateDateTime() {
    final now = DateTime.now();
    setState(() {
      currentDate = DateFormat('EEEE, d MMM y').format(now); // Example: Monday, 3rd Feb 2025
      currentTime = DateFormat('hh:mm a').format(now); // Example: 10:35 AM
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row (Title + Menu Icon)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello",
                            style: GoogleFonts.lato(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            currentDate, // Dynamic Date
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.menu, size: 30, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Weather Information Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Weather",
                      style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        weatherItem(Icons.wb_sunny, "Lux Level", "120 W/m²"),
                        weatherItem(Icons.water_drop, "Rainfall", "80 mm"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Location History Section
            buildSectionTitle("Today"),
            buildLocationItem(currentTime),
            buildLocationItem("11:24 AM"),
            buildLocationItem("2:15 PM"),

            buildSectionTitle("Yesterday"),
            buildLocationItem("8:45 PM"),

            SizedBox(height: 20),

            // Statistics Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Statistics",
                    style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statisticsCard("assets/images/division1.jpg", "Division 001", "Description #9087"),
                      statisticsCard("assets/images/division2.jpg", "Division 002", "Description #9085"),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Weather Item Widget
  Widget weatherItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.orange),
        SizedBox(height: 5),
        Text(title, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500)),
        Text(value, style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }

  // Section Title Widget
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Location Item Widget
  Widget buildLocationItem(String time) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.black54),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Location", style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(time, style: GoogleFonts.lato(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Statistics Card Widget
  Widget statisticsCard(String imagePath, String title, String description) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imagePath, width: 120, height: 100, fit: BoxFit.cover),
          ),
          SizedBox(height: 10),
          Text(title, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(description, style: GoogleFonts.lato(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }
}
