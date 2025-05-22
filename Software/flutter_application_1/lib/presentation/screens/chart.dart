import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/data/services/ExportService.dart';
import 'package:flutter_application_1/presentation/widgets/StatWidgets.dart';
import 'package:intl/intl.dart';

class HumidityChart extends StatefulWidget {
  final List<Map<String, dynamic>> sensorData;

  const HumidityChart({super.key, required this.sensorData});

  @override
  State<HumidityChart> createState() => _HumidityChartState();
}

class _HumidityChartState extends State<HumidityChart> {
  late List<FlSpot> spots;
  late Map<int, String> labels;
  final GlobalKey chartKey = GlobalKey();
  final GlobalKey tableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _prepareChartData();
  }

  void _prepareChartData() {
    final dateFormat = DateFormat('HH:mm');
    spots = [];
    labels = {};

    for (int i = 0; i < widget.sensorData.length; i++) {
      final data = widget.sensorData[i];
      final time = data['timestamp'].toDate();
      spots.add(FlSpot(i.toDouble(), (data['humidity'] ?? 0).toDouble()));
      labels[i] = dateFormat.format(time);
    }
  }

void _handleExportPdf() {
  ExportUtils.exportToPdf(
    title: "Humidity Report",
    chartKey: chartKey,
    tableKey: tableKey,
  );
}

void _handleExportExcel() {
  ExportUtils.exportToExcel(
    fileName: 'Humidity_Report',
    headers: ['Metric', 'Temperature', 'Humidity'],
    data: const [
      ['Mean', '27.20', '82.74'],
      ['Standard error', '0.01', '0.04'],
      ['Median', '27.20', '82.50'],
      ['Mode', '27.10', '83.30'],
      ['Standard deviation', '1.15', '5.00'],
      ['Sample variance', '1.31', '25.01'],
      ['Kurtosis', '57.85', '42.89'],
      ['Skewness', '-2.54', '-2.38'],
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Division 001'),
            Text(
              'Description #3532689',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            //onPressed: _handleExportExcel,
            onPressed: _handleExportPdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RepaintBoundary(
                key: chartKey,
                child: SensorChart(
                  title: 'Humidity',
                  spots: spots,
                  labels: labels,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Date Range – 3rd FEB - 28th JAN',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
              RepaintBoundary(
                key: tableKey,
                child: const StatsTable(
                  data: [
                    ['Mean', '27.20', '82.74'],
                    ['Standard error', '0.01', '0.04'],
                    ['Median', '27.20', '82.50'],
                    ['Mode', '27.10', '83.30'],
                    ['Standard deviation', '1.15', '5.00'],
                    ['Sample variance', '1.31', '25.01'],
                    ['Kurtosis', '57.85', '42.89'],
                    ['Skewness', '-2.54', '-2.38'],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

