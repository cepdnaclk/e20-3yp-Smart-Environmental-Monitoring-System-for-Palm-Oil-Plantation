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
import 'package:flutter_application_1/data/services/statisticService.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/services/ExportService.dart';
import 'package:flutter_application_1/presentation/widgets/StatWidgets.dart';

class ParameterChart extends StatefulWidget {
  final String title;
  final String parameter;
  final String sectionName;
  final String sectionPath;
  final String sectionDescription;
  final List<Map<String, dynamic>>? sensorData;
  final Map<String, dynamic>? stats;

  const ParameterChart({
    super.key,
    required this.title,
    required this.parameter,
    required this.sectionName,
    required this.sectionDescription,
    this.sensorData,
    this.stats, 
    required this.sectionPath,
  });

  @override
  State<ParameterChart> createState() => _ParameterChartState();
}

class _ParameterChartState extends State<ParameterChart> {
  List<Map<String, dynamic>> sensorData = [];
  Map<String, dynamic> stats = {};
  List<FlSpot> spots = [];
  Map<int, String> labels = {};
  bool isLoading = true;

  final GlobalKey chartKey = GlobalKey();
  final GlobalKey tableKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (widget.sensorData != null && widget.stats != null) {
      sensorData = widget.sensorData!;
      stats = widget.stats!;
      _prepareChartData();
      isLoading = false;
    } else {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    try {
      final statisticsService = StatisticsService();
      final result = await statisticsService.getSectionStats(
        sectionPath: widget.sectionPath, // or widget.sectionPath if named that
        parameter: widget.parameter,
      );

      final rawDataPoints = result['dataPoints'];
      if (rawDataPoints != null && rawDataPoints is List) {
        sensorData = rawDataPoints.map<Map<String, dynamic>>((dp) {
          final timestamp = dp['timestamp'];
          DateTime parsedTime;

          if (timestamp is Timestamp) {
            parsedTime = timestamp.toDate();
          } else if (timestamp is String) {
            parsedTime = DateTime.tryParse(timestamp) ?? DateTime.now();
          } else if (timestamp is DateTime) {
            parsedTime = timestamp;
          } else {
            parsedTime = DateTime.now();
          }

          return {
            'timestamp': Timestamp.fromDate(parsedTime),
            widget.parameter: dp['value'],
          };
        }).toList();
      }

      stats = result;
      _prepareChartData();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to fetch stats: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            )
          ],
        ),
      );
    }
  }

  void _prepareChartData() {
    final dateFormat = DateFormat('HH:mm');
    spots.clear();
    labels.clear();

    for (int i = 0; i < sensorData.length; i++) {
      final data = sensorData[i];
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
      final label = _capitalize(key);
      final value = stats[key];
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
            onPressed: isLoading ? null : _handleExportPdf,
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            onPressed: isLoading ? null : _handleExportExcel,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sensorData.isNotEmpty)
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
                      data: _buildStatsData(stats),
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
