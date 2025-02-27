import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Division 001", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Chart Placeholder
              Container(
                height: 200,
                color: Colors.white,
                child: Center(child: Text("Graph Placeholder")),
              ),

              SizedBox(height: 20),

              // Data Table Placeholder
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Text("Data Table Placeholder"),
              ),

              SizedBox(height: 20),

              // Sensor Buttons
              Column(
                children: [
                  sensorButton("Humidity", Colors.blue),
                  sensorButton("Soil Moisture", Colors.brown),
                  sensorButton("NPK Levels", Colors.green),
                  sensorButton("Temperature", Colors.yellow),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sensorButton(String text, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: () {},
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
