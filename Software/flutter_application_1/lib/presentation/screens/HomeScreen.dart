import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../core/routes.dart';

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
    updateDateTime();
    Timer.periodic(Duration(seconds: 1), (timer) {
      updateDateTime();
    });
  }

  void updateDateTime() {
    final now = DateTime.now();
    setState(() {
      currentDate = DateFormat('EEEE, d MMM yyyy').format(now);
      currentTime = DateFormat('hh:mm a').format(now);
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
            Text(currentDate, style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
          child: Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
