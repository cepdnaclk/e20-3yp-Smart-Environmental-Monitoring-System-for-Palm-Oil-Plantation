import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/data/services/statisticService.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/services/ExportService.dart';
import 'package:flutter_application_1/presentation/widgets/StatWidgets.dart';
import 'package:flutter_application_1/data/services/ConnectivityService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_1/presentation/widgets/NetworkErrorWidget.dart';
import 'package:flutter_application_1/presentation/widgets/OfflineBanner.dart';

class NewParameterChart extends StatefulWidget {
  final String title;
  final String parameter;
  final String collection;

  const NewParameterChart({
    super.key,
    required this.title,
    required this.parameter,
    required this.collection,
  });

  @override
  State<NewParameterChart> createState() => _NewParameterChartState();
}

class _NewParameterChartState extends State<NewParameterChart> {
  List<Map<String, dynamic>> sensorData = [];
  Map<String, dynamic> stats = {};
  List<FlSpot> spots = [];
  Map<int, String> labels = {};
  bool isLoading = true;
  bool isOffline = false;
  String? fetchError;

  final GlobalKey chartKey = GlobalKey();
  final GlobalKey tableKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    ConnectivityService().onConnectivityChanged.listen((status) {
      setState(() {
        isOffline = status == ConnectivityResult.none;
      });
    });

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      fetchError = null;
    });

    try {
      final statisticsService = StatisticsService();
      final result = await statisticsService.getCollectionStats(
        collectionName: widget.collection,
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
    } catch (e) {
      print("Error: $e");
      if (e.toString().contains('offline')) {
        fetchError = "You are offline. No cached data available.";
      } else {
        fetchError = "Something went wrong. Try again.";
      }
    } finally {
      setState(() {
        isLoading = false;
      });
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

  Widget _buildChartContent() {
    if (fetchError != null) {
      return NetworkErrorWidget(
        errorMessage: fetchError!,
        onRetry: _loadData,
      );
    }

    return SingleChildScrollView(
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
                  'No data points available.',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
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
      body: Column(
        children: [
          OfflineBanner(isOffline: isOffline),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildChartContent(),
          ),
        ],
      ),
    );
  }
}
