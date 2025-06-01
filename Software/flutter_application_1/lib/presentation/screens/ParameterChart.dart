// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_application_1/data/services/ExportService.dart';
// import 'package:flutter_application_1/presentation/widgets/StatWidgets.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ParameterChart extends StatefulWidget {
//   final String title;
//   final String parameter;
//   final String sectionName;
//   final String sectionDescription;
//   final List<Map<String, dynamic>> sensorData;
//   final Map<String, dynamic> stats;


//   const ParameterChart({
//     super.key,
//     required this.title,
//     required this.parameter,
//     required this.sectionName,
//     required this.sectionDescription,
//     required this.sensorData, 
//     required this.stats,
//   });

//   @override
//   State<ParameterChart> createState() => _ParameterChartState();
// }

// class _ParameterChartState extends State<ParameterChart> {
//   late List<FlSpot> spots;
//   late Map<int, String> labels;
//   final GlobalKey chartKey = GlobalKey();
//   final GlobalKey tableKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     _prepareChartData();
//   }

//   // void _prepareChartData() {
//   //   final dateFormat = DateFormat('HH:mm');
//   //   spots = [];
//   //   labels = {};

//   //   for (int i = 0; i < widget.sensorData.length; i++) {
//   //     final data = widget.sensorData[i];
//   //     final time = (data['timestamp'] as Timestamp).toDate();
//   //     final value = (data[widget.parameter] ?? 0).toDouble();

//   //     spots.add(FlSpot(i.toDouble(), value));
//   //     labels[i] = dateFormat.format(time);
//   //   }
//   // }

//   void _prepareChartData() {
//     final dateFormat = DateFormat('HH:mm');
//     spots = [];
//     labels = {};

//     for (int i = 0; i < widget.sensorData.length; i++) {
//       final data = widget.sensorData[i];
//       final time = (data['timestamp'] as Timestamp).toDate();
//       final value = (data[widget.parameter] ?? 0).toDouble();

//       spots.add(FlSpot(i.toDouble(), value));
//       labels[i] = dateFormat.format(time);
//     }
//   }


//   void _handleExportPdf() {
//     ExportUtils.exportToPdf(
//       title: "${widget.title} Report",
//       chartKey: chartKey,
//       tableKey: tableKey,
//     );
//   }

//   void _handleExportExcel() {
//     ExportUtils.exportToExcel(
//       fileName: '${widget.title}_Report',
//       headers: ['Metric', widget.parameter],
//       data: const [
//         ['Mean', '27.20'],
//         ['Standard error', '0.01'],
//         ['Median', '27.20'],
//         ['Mode', '27.10'],
//         ['Standard deviation', '1.15'],
//         ['Sample variance', '1.31'],
//         ['Kurtosis', '57.85'],
//         ['Skewness', '-2.54'],
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.sectionName),
//             Text(
//               widget.sectionDescription,
//               style: const TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.picture_as_pdf),
//             onPressed: _handleExportPdf,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RepaintBoundary(
//                 key: chartKey,
//                 child: SensorChart(
//                   title: widget.title,
//                   spots: spots,
//                   labels: labels,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Center(
//                 child: Text(
//                   'Date Range – 3rd FEB - 28th JAN', // Replace with real range if needed
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               RepaintBoundary(
//                 key: tableKey,
//                 child: const StatsTable(
//                   data: [
//                     ['Mean', '27.20'],
//                     ['Standard error', '0.01'],
//                     ['Median', '27.20'],
//                     ['Mode', '27.10'],
//                     ['Standard deviation', '1.15'],
//                     ['Sample variance', '1.31'],
//                     ['Kurtosis', '57.85'],
//                     ['Skewness', '-2.54'],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/data/services/ExportService.dart';
import 'package:flutter_application_1/presentation/widgets/StatWidgets.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParameterChart extends StatefulWidget {
  final String title;
  final String parameter;
  final String sectionName;
  final String sectionDescription;
  final List<Map<String, dynamic>> sensorData;
  final Map<String, dynamic> stats;

  const ParameterChart({
    super.key,
    required this.title,
    required this.parameter,
    required this.sectionName,
    required this.sectionDescription,
    required this.sensorData,
    required this.stats,
  });

  @override
  State<ParameterChart> createState() => _ParameterChartState();
}

class _ParameterChartState extends State<ParameterChart> {
  List<FlSpot> spots = [];
  Map<int, String> labels = {};
  final GlobalKey chartKey = GlobalKey();
  final GlobalKey tableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _prepareChartData();
  }

  void _prepareChartData() {
    if (widget.sensorData.isEmpty) return;

    final dateFormat = DateFormat('HH:mm');
    for (int i = 0; i < widget.sensorData.length; i++) {
      final data = widget.sensorData[i];
      final timestamp = (data['timestamp'] as Timestamp).toDate();
      final value = (data[widget.parameter] ?? 0).toDouble();

      spots.add(FlSpot(i.toDouble(), value));
      labels[i] = dateFormat.format(timestamp);
    }
  }

  void _handleExportPdf() {
    ExportUtils.exportToPdf(
      title: "${widget.title} Report",
      chartKey: chartKey,
      tableKey: tableKey,
    );
  }

  void _handleExportExcel() {
    final keys = [
      'mean',
      'median',
      'mode',
      'standardDeviation',
      'variance',
      'skewness',
      'kurtosis',
      'min',
      'max',
      'count',
    ];

    final rows = keys.map((key) {
      final label = key[0].toUpperCase() + key.substring(1);
      final value = widget.stats[key];
      return [
        label,
        value is num ? value.toStringAsFixed(2) : value.toString()
      ];
    }).toList();

    ExportUtils.exportToExcel(
      fileName: '${widget.title}_Report',
      headers: ['Metric', widget.parameter],
      data: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasData = widget.sensorData.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.sectionName),
            Text(
              widget.sectionDescription,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _handleExportPdf,
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            onPressed: _handleExportExcel,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasData)
              RepaintBoundary(
                key: chartKey,
                child: SensorChart(
                  title: widget.title,
                  spots: spots,
                  labels: labels,
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No data points available for this parameter.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Date Range – Last 30 days',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            RepaintBoundary(
              key: tableKey,
              child: StatsTable(
                data: _buildStatsData(widget.stats),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<List<String>> _buildStatsData(Map<String, dynamic> stats) {
    final keys = [
      'mean',
      'median',
      'mode',
      'standardDeviation',
      'variance',
      'skewness',
      'kurtosis',
      'min',
      'max',
      'count',
    ];

    return keys
        .where((k) => stats.containsKey(k))
        .map((k) => [
              _capitalize(k),
              stats[k] is num
                  ? (stats[k] as num).toStringAsFixed(2)
                  : stats[k].toString()
            ])
        .toList();
  }

  String _capitalize(String input) {
    return input[0].toUpperCase() + input.substring(1);
  }
}
