import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceTwoData {
  final String id;
  final double lux;
  final int tipCount;

  DeviceTwoData({required this.id, required this.lux, required this.tipCount});
}

class DeviceTwoScreen extends StatefulWidget {
  @override
  _DeviceTwoScreenState createState() => _DeviceTwoScreenState();
}

class _DeviceTwoScreenState extends State<DeviceTwoScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DeviceTwoData>> getDeviceTwoData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('DeviceTwoData').get();
      return snapshot.docs.map((doc) {
        return DeviceTwoData(
          id: doc.id,
          lux: (doc['lux'] ?? 0).toDouble(),
          tipCount: (doc['tipCount'] ?? 0).toInt(),
        );
      }).toList();
    } catch (e) {
      print("Error fetching data: $e");
      throw Exception("Failed to fetch sensor data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Device Two Data")),
      body: FutureBuilder<List<DeviceTwoData>>(
        future: getDeviceTwoData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading spinner
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }

          List<DeviceTwoData> deviceData = snapshot.data!;

          return ListView.builder(
            itemCount: deviceData.length,
            itemBuilder: (context, index) {
              final data = deviceData[index];
              return ListTile(
                title: Text("Lux: ${data.lux.toStringAsFixed(2)}"),
                subtitle: Text("Tip Count: ${data.tipCount}"),
                leading: Icon(Icons.sensors),
                trailing: Text("#${data.id}"),
              );
            },
          );
        },
      ),
    );
  }
}
