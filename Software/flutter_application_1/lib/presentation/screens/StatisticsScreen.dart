import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final String divisionNumber; // ✅ Accepts division ID dynamically

  StatisticsScreen({required this.divisionNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Division $divisionNumber", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('divisions')
            .doc(divisionNumber).snapshots(), // ✅ Listen for live updates
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator()); // ✅ Loading State
          }

          var data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return Center(child: Text("No Data Available", style: TextStyle(fontSize: 18)));
          }

          // ✅ Extract values safely
          List<double> humidityValues = List<double>.from(data['humidity'] ?? [0]);
          List<double> temperatureValues = List<double>.from(data['temperature'] ?? [0]);
          String dateRange = data['date_range'] ?? "N/A";

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ✅ Real-Time Line Chart
                  Container(
                    height: 200,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text("Humidity & Temperature Graph", style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: LineChart(_buildLineChart(humidityValues, temperatureValues) as LineChartData)),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  // ✅ Date Range
                  Text("Date Range: $dateRange", textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),

                  SizedBox(height: 10),

                  // ✅ Dynamic Data Table
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: _buildDataTable(data),
                  ),

                  SizedBox(height: 20),

                  // ✅ Sensor Buttons
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
          );
        },
      ),
    );
  }

  // ✅ Function to Create a Line Chart with Real-Time Data
  LineChart _buildLineChart(List<double> humidity, List<double> temperature) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: humidity.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]), // ✅ Updated
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: temperature.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            gradient: LinearGradient(colors: [Colors.red, Colors.orange]), // ✅ Updated
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  // ✅ Function to Generate a Dynamic Data Table
  Widget _buildDataTable(Map<String, dynamic> data) {
    List<String> columnTitles = ["Metric", "T (°C)", "Rh %"];
    List<List<dynamic>> rows = [
      ["Mean", data['mean_temp'] ?? "N/A", data['mean_humidity'] ?? "N/A"],
      ["Standard Error", data['std_error_temp'] ?? "N/A", data['std_error_humidity'] ?? "N/A"],
      ["Median", data['median_temp'] ?? "N/A", data['median_humidity'] ?? "N/A"],
      ["Mode", data['mode_temp'] ?? "N/A", data['mode_humidity'] ?? "N/A"],
      ["Standard Deviation", data['std_dev_temp'] ?? "N/A", data['std_dev_humidity'] ?? "N/A"],
      ["Sample Variance", data['variance_temp'] ?? "N/A", data['variance_humidity'] ?? "N/A"],
      ["Kurtosis", data['kurtosis_temp'] ?? "N/A", data['kurtosis_humidity'] ?? "N/A"],
      ["Skewness", data['skewness_temp'] ?? "N/A", data['skewness_humidity'] ?? "N/A"],
      ["Maximum", data['max_temp'] ?? "N/A", data['max_humidity'] ?? "N/A"],
      ["Count", data['count_temp'] ?? "N/A", data['count_humidity'] ?? "N/A"],
    ];

    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        // Table Header
        TableRow(
          children: columnTitles.map((title) => _buildTableCell(title, isHeader: true)).toList(),
        ),
        // Table Rows
        ...rows.map((row) => TableRow(
          children: row.map((cell) => _buildTableCell(cell.toString())).toList(),
        )),
      ],
    );
  }

  // ✅ Table Cell Formatting
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 16 : 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ✅ Sensor Buttons for Navigation
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
