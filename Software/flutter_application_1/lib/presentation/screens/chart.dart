// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_application_1/presentation/widgets/StatWidgets.dart';
// import 'package:intl/intl.dart';

// class HumidityChart extends StatefulWidget {
//   final List<Map<String, dynamic>> sensorData;

//   const HumidityChart({super.key, required this.sensorData});

//   @override
//   State<HumidityChart> createState() => _HumidityChartState();
// }

// class _HumidityChartState extends State<HumidityChart> {
//   late List<FlSpot> spots;
//   late Map<int, String> labels;

//   @override
//   void initState() {
//     super.initState();
//     _prepareChartData();
//   }

//   void _prepareChartData() {
//     final dateFormat = DateFormat('HH:mm');
//     spots = [];
//     labels = {};

//     for (int i = 0; i < widget.sensorData.length; i++) {
//       final data = widget.sensorData[i];
//       final time = data['timestamp'].toDate();
//       spots.add(FlSpot(i.toDouble(), (data['humidity'] ?? 0).toDouble()));
//       labels[i] = dateFormat.format(time);
//     }
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
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Division 001'),
//             Text(
//               'Description #3532689',
//               style: TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SensorChart(
//                 title: 'Humidity',
//                 spots: spots,
//                 labels: labels,
//               ),
//               const SizedBox(height: 8),
//               const Center(
//                 child: Text(
//                   'Date Range – 3rd FEB - 28th JAN',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const StatsTable(
//                 data: [
//                   ['Mean', '27.20', '82.74'],
//                   ['Standard error', '0.01', '0.04'],
//                   ['Median', '27.20', '82.50'],
//                   ['Mode', '27.10', '83.30'],
//                   ['Standard deviation', '1.15', '5.00'],
//                   ['Sample variance', '1.31', '25.01'],
//                   ['Kurtosis', '57.85', '42.89'],
//                   ['Skewness', '-2.54', '-2.38'],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/presentation/widgets/StatWidgets.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

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

  Future<Uint8List> _captureWidget(GlobalKey key) async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // Future<void> _exportToPdf() async {
  //   final chartImage = await _captureWidget(chartKey);
  //   final tableImage = await _captureWidget(tableKey);

  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.MultiPage(
  //       build: (context) => [
  //         pw.Text('Humidity Report', style: pw.TextStyle(fontSize: 24)),
  //         pw.SizedBox(height: 20),
  //         pw.Image(pw.MemoryImage(chartImage), height: 300),
  //         pw.SizedBox(height: 20),
  //         pw.Image(pw.MemoryImage(tableImage), height: 300),
  //       ],
  //     ),
  //   );

  //   await Printing.layoutPdf(onLayout: (format) => pdf.save());
  // }
  Future<void> _exportToPdf() async {
  final chartImage = await _captureWidget(chartKey);
  final tableImage = await _captureWidget(tableKey);

  final pdf = pw.Document();

  final pageHeight = 792.0; // A4 page height in points (pt)

  // Add chart image (fixed height)
  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text('Humidity Report', style: pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 20),
        pw.Image(pw.MemoryImage(chartImage), height: 300),
        pw.SizedBox(height: 20),
      ],
    ),
  );

  // Process table image into multiple page chunks
  final ui.Image fullImage = await decodeImageFromList(tableImage);
  final fullHeight = fullImage.height;
  final fullWidth = fullImage.width;

  const pageImageHeightPx = 1000; // Approx. pixels per page slice

  for (int offset = 0; offset < fullHeight; offset += pageImageHeightPx) {
    final cropHeight = (offset + pageImageHeightPx > fullHeight)
        ? fullHeight - offset
        : pageImageHeightPx;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint();
    canvas.drawImageRect(
      fullImage,
      Rect.fromLTWH(0, offset.toDouble(), fullWidth.toDouble(), cropHeight.toDouble()),
      Rect.fromLTWH(0, 0, fullWidth.toDouble(), cropHeight.toDouble()),
      paint,
    );

    final slicedImage = await recorder
        .endRecording()
        .toImage(fullWidth, cropHeight);
    final byteData = await slicedImage.toByteData(format: ui.ImageByteFormat.png);
    final slicedBytes = byteData!.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Image(pw.MemoryImage(slicedBytes)),
        ),
      ),
    );
  }

  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}


Future<void> exportTableToExcel() async {
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    print("Permission denied");
    return;
  }

  var excel = Excel.createExcel(); // Creates a blank Excel file
  Sheet sheet = excel['Stats'];

  // Header
  sheet.appendRow(['Metric', 'Temperature', 'Humidity']);

  // Data (your table)
  List<List<String>> data = [
    ['Mean', '27.20', '82.74'],
    ['Standard error', '0.01', '0.04'],
    ['Median', '27.20', '82.50'],
    ['Mode', '27.10', '83.30'],
    ['Standard deviation', '1.15', '5.00'],
    ['Sample variance', '1.31', '25.01'],
    ['Kurtosis', '57.85', '42.89'],
    ['Skewness', '-2.54', '-2.38'],
  ];

  for (final row in data) {
    sheet.appendRow(row);
  }

  // Save file
  final directory = await getExternalStorageDirectory();
  final path = "${directory!.path}/humidity_report.xlsx";
  final bytes = excel.encode();
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!);

  print("Excel file saved at $path");
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
            onPressed: _exportToPdf,
            // onPressed: () async {
            //   await exportTableToExcel();
            // },
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


// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_application_1/presentation/widgets/StatWidgets.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class HumidityChart extends StatefulWidget {
//   final List<Map<String, dynamic>> sensorData;

//   const HumidityChart({super.key, required this.sensorData});

//   @override
//   State<HumidityChart> createState() => _HumidityChartState();
// }

// class _HumidityChartState extends State<HumidityChart> {
//   late List<FlSpot> spots;
//   late Map<int, String> labels;
//   final GlobalKey chartKey = GlobalKey();

//   // Raw data for PDF table rendering
//   final List<List<String>> statsData = const [
//     ['Mean', '27.20', '82.74'],
//     ['Standard error', '0.01', '0.04'],
//     ['Median', '27.20', '82.50'],
//     ['Mode', '27.10', '83.30'],
//     ['Standard deviation', '1.15', '5.00'],
//     ['Sample variance', '1.31', '25.01'],
//     ['Kurtosis', '57.85', '42.89'],
//     ['Skewness', '-2.54', '-2.38'],
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _prepareChartData();
//   }

//   void _prepareChartData() {
//     final dateFormat = DateFormat('HH:mm');
//     spots = [];
//     labels = {};

//     for (int i = 0; i < widget.sensorData.length; i++) {
//       final data = widget.sensorData[i];
//       final time = data['timestamp'].toDate();
//       spots.add(FlSpot(i.toDouble(), (data['humidity'] ?? 0).toDouble()));
//       labels[i] = dateFormat.format(time);
//     }
//   }

//   Future<Uint8List> _captureWidget(GlobalKey key) async {
//     final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
//     final image = await boundary.toImage(pixelRatio: 3.0);
//     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     return byteData!.buffer.asUint8List();
//   }

//   pw.Widget _buildPdfTable() {
//     return pw.Table.fromTextArray(
//       headers: ['Metric', 'Temperature', 'Humidity'],
//       data: statsData,
//       headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//       cellAlignment: pw.Alignment.center,
//       cellStyle: const pw.TextStyle(fontSize: 10),
//       border: pw.TableBorder.all(),
//       headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE0E0E0)),
//     );
//   }

//   // Future<void> _exportToPdf() async {
//   //   final chartImage = await _captureWidget(chartKey);
//   //   final pdf = pw.Document();

//   //   pdf.addPage(
//   //     pw.MultiPage(
//   //       build: (context) => [
//   //         pw.Text('Humidity Report', style: pw.TextStyle(fontSize: 24)),
//   //         pw.SizedBox(height: 20),
//   //         pw.Image(pw.MemoryImage(chartImage), height: 300),
//   //         pw.SizedBox(height: 20),
//   //         pw.Text('Statistical Summary', style: pw.TextStyle(fontSize: 18)),
//   //         pw.SizedBox(height: 10),
//   //         _buildPdfTable(),
//   //       ],
//   //     ),
//   //   );

//   //   await Printing.layoutPdf(onLayout: (format) => pdf.save());
//   // }

//   Future<void> _exportToPdf() async {
//   final chartImage = await _captureWidget(chartKey);
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       build: (context) => [
//         pw.Text('Humidity Report', style: pw.TextStyle(fontSize: 24)),
//         pw.SizedBox(height: 20),
//         pw.Image(pw.MemoryImage(chartImage), height: 300),
//         pw.SizedBox(height: 20),
//         pw.Text('Statistical Summary', style: pw.TextStyle(fontSize: 18)),
//         pw.SizedBox(height: 10),

//         // This helps handle overflow on long tables
//         pw.Wrap(
//           children: [
//             _buildPdfTable(),
//           ],
//         ),
//       ],
//     ),
//   );

//   await Printing.layoutPdf(onLayout: (format) => pdf.save());
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Division 001'),
//             Text(
//               'Description #3532689',
//               style: TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.picture_as_pdf),
//             onPressed: _exportToPdf,
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
//                   title: 'Humidity',
//                   spots: spots,
//                   labels: labels,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Center(
//                 child: Text(
//                   'Date Range – 3rd FEB - 28th JAN',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // Still showing the visual table in the app
//               const StatsTable(
//                 data: [
//                   ['Mean', '27.20', '82.74'],
//                   ['Standard error', '0.01', '0.04'],
//                   ['Median', '27.20', '82.50'],
//                   ['Mode', '27.10', '83.30'],
//                   ['Standard deviation', '1.15', '5.00'],
//                   ['Sample variance', '1.31', '25.01'],
//                   ['Kurtosis', '57.85', '42.89'],
//                   ['Skewness', '-2.54', '-2.38'],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
