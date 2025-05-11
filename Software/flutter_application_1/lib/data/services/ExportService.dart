import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ExportUtils {
  static Future<Uint8List> captureWidget(GlobalKey key) async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<void> exportToPdf({
    required String title,
    required GlobalKey chartKey,
    required GlobalKey tableKey,
  }) async {
    final chartImage = await captureWidget(chartKey);
    final tableImage = await captureWidget(tableKey);

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(title, style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 20),
          pw.Image(pw.MemoryImage(chartImage), height: 300),
          pw.SizedBox(height: 20),
        ],
      ),
    );

    final ui.Image fullImage = await decodeImageFromList(tableImage);
    final fullHeight = fullImage.height;
    final fullWidth = fullImage.width;
    const pageImageHeightPx = 1000;

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

      final slicedImage = await recorder.endRecording().toImage(fullWidth, cropHeight);
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

  static Future<void> exportToExcel({
    required String fileName,
    required List<String> headers,
    required List<List<String>> data,
  }) async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        var result = await Permission.manageExternalStorage.request();
        if (!result.isGranted) {
          print("Permission denied");
          await openAppSettings();
          return;
        }
      }
    }

    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Stats'];

      sheet.appendRow(headers);
      for (final row in data) {
        sheet.appendRow(row);
      }

      final bytes = excel.encode();
      final directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final path = '${directory.path}/$fileName.xlsx';
      final file = File(path);
      await file.writeAsBytes(bytes!, flush: true);

      print("Excel file saved at $path");
      await OpenFile.open(path);
    } catch (e) {
      print("Error exporting to Excel: $e");
    }
  }
}
