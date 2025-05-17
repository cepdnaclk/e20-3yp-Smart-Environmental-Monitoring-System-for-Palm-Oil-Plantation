import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class TreeDetectionPage extends StatefulWidget {
  const TreeDetectionPage({Key? key}) : super(key: key);

  @override
  State<TreeDetectionPage> createState() => _TreeDetectionPageState();
}

class _TreeDetectionPageState extends State<TreeDetectionPage> {
  Uint8List? selectedImageBytes;
  String? processedImageBase64;
  int? totalTrees;
  int? unhealthyTrees;
  bool isLoading = false;

  Widget buildResult() {
    if (processedImageBase64 == null) return SizedBox.shrink();

    final imageBytes = base64Decode(processedImageBase64!);

    return Column(
      children: [
        const SizedBox(height: 16),
        Text("Total Trees: \$totalTrees", style: TextStyle(fontSize: 16)),
        Text("Unhealthy Trees: \$unhealthyTrees", style: TextStyle(fontSize: 16, color: Colors.red)),
        const SizedBox(height: 16),
        Image.memory(imageBytes),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tree Health Detection")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ImageUploadBox(
              onPickFile: () {
                // Placeholder action
                print("Pick file tapped");
              },
            ),
            const SizedBox(height: 16),
            if (selectedImageBytes != null)
              Image.memory(selectedImageBytes!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Placeholder for detection logic
              },
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Detect Tree Health"),
            ),
            const SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: buildResult())),
          ],
        ),
      ),
    );
  }
}

class ImageUploadBox extends StatelessWidget {
  final VoidCallback onPickFile;

  const ImageUploadBox({super.key, required this.onPickFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey[700]),
          SizedBox(height: 12),
          Text("Drag or drop file here", style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 6),
          Text("- OR -", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: onPickFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("Choose file", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}