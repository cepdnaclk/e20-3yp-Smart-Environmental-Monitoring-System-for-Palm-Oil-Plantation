import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';


// 🌿 Custom Theme Colors for Tree Detection UI
const Color kPrimaryColor = Color(0xFF6B6F1D);   // Olive green
const Color kAccentColor = Color(0xFFFCE023);   // Bright yellow
const Color kTextColor = Color(0xFF000000);     // Black

class TreeDetectionPage extends StatefulWidget {
  const TreeDetectionPage({Key? key}) : super(key: key);

  @override
  State<TreeDetectionPage> createState() => _TreeDetectionPageState();
}

class _TreeDetectionPageState extends State<TreeDetectionPage> {
  Uint8List? selectedImageBytes;
  String? inputImageUrl;
  String? outputImageUrl;
  int? totalTrees;
  int? unhealthyTrees;
  int? healthyTrees;
  bool isLoading = false;
  bool showUploadScreen = true;
  File? selectedImageFile;
  final picker = ImagePicker();


  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDetectionSummary(String docId) async {
    setState(() => isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('tree_detection')
          .doc(docId)
          .get();

      final data = doc.data();
      final summary = data?['detection_summary'];
      final treeCount = data?['tree_count'];
      final inputUrl = data?['input_image_url'];
      final outputUrl = data?['output_image_url'];

      print("Fetched data: $data");

      if (summary != null) {
        setState(() {
          totalTrees = treeCount;
          unhealthyTrees = summary['Unhealthy'];
          healthyTrees = summary['Healthy'];
          inputImageUrl = inputUrl;
          outputImageUrl = outputUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load detection summary')),
      );
    }
    setState(() => isLoading = false);
  }
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      selectedImageFile = File(picked.path);
      outputImageUrl = null;
      totalTrees = 0;
      healthyTrees = 0;
      unhealthyTrees = 0;
    });

    try {
      final uri = Uri.parse('https://tree-health-901340579460.us-central1.run.app/predict/');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          picked.path,
          contentType: MediaType('image', 'jpeg'),
        ));

      final response = await http.Response.fromStream(await request.send());
      print("Direct response: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        setState(() {
          inputImageUrl = json['input_image_url'];
          outputImageUrl = json['output_image_url'];
          totalTrees = json['tree_count'];
          healthyTrees = json['detection_summary']?['Healthy'];
          unhealthyTrees = json['detection_summary']?['Unhealthy'];
        });
      } else {
        print("Upload failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during upload: $e");
    }
  }

  /*
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      selectedImageFile = File(picked.path);
      outputImageUrl = null;
      totalTrees = 0;
      healthyTrees = 0;
      unhealthyTrees = 0;
    });

    try {
      final originalUri = Uri.parse('https://tree-health-901340579460.us-central1.run.app/predict/');

      final request = http.MultipartRequest('POST', originalUri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          picked.path,
          contentType: MediaType('image', 'jpeg'),
        ));

      final client = http.Client();
      final streamedResponse = await client.send(request);

// Check for redirect
      if (streamedResponse.statusCode == 307) {
        final locationHeader = streamedResponse.headers['location'];
        if (locationHeader == null) {
          print("❌ Redirected, but no 'location' header found.");
          return;
        }
        final redirectedUri = Uri.parse(locationHeader);

        final redirectedRequest = http.MultipartRequest('POST', redirectedUri)
          ..files.add(await http.MultipartFile.fromPath(
            'file',
            picked.path,
            contentType: MediaType('image', 'jpeg'),
          ));
        final redirectedResponse = await redirectedRequest.send();
        final response = await http.Response.fromStream(redirectedResponse);
        print("Redirected response: ${response.statusCode}");
        print("Redirected body: ${response.body}");

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final newDocId = json['docId']; // Make sure your backend returns this

          selectedDocId = newDocId;
          await fetchDetectionSummary(newDocId);
        } else {
          print("Redirected upload failed: ${response.statusCode}");
        }

      } else if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
        print("Direct response: ${response.body}");

        final json = jsonDecode(response.body);
        final newDocId = json['docId'];

        selectedDocId = newDocId;
        await fetchDetectionSummary(newDocId);
      } else {
        print("Upload failed: ${streamedResponse.statusCode}");
      }
    } catch (e) {
      print("Error during upload: $e");
    }
  }*/


  Widget buildUploadScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload box
          Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ImageUploadBox(
                onPickFile: pickAndUploadImage,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Input Image section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Input Image",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor)),
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: kPrimaryColor.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: selectedImageFile != null
                  ? Image.file(selectedImageFile!, fit: BoxFit.cover)
                  : Text("No image selected", style: TextStyle(color: Colors.grey[600])),
            ),
          ),

          // ✅ Show output section only if image is uploaded and output is ready
          if (selectedImageFile != null && outputImageUrl != null) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Detection Output Image",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor)),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: kPrimaryColor.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.network(outputImageUrl!, fit: BoxFit.cover),
              ),
            ),
            const Divider(height: 32, thickness: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🌿 Tree Health Summary",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          )),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _buildInfoCard(Icons.forest, "Total Trees", "$totalTrees"),
                          _buildInfoCard(Icons.local_florist, "Healthy", "$healthyTrees"),
                          _buildInfoCard(Icons.warning_amber, "Unhealthy", "$unhealthyTrees"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }



  Widget buildResult() {
    if (totalTrees == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No summary data loaded yet."),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text("Tree Health Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildInfoCard(Icons.forest, "Total Trees", "$totalTrees"),
            _buildInfoCard(Icons.local_florist, "Healthy", "$healthyTrees"),
            _buildInfoCard(Icons.warning_amber, "Unhealthy", "$unhealthyTrees"),
          ],
        ),
        const SizedBox(height: 16),
        Text("Input Image", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 180,
            color: Colors.grey[100],
            child: inputImageUrl != null && inputImageUrl!.isNotEmpty
                ? Image.network(
              inputImageUrl!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 40),
                      SizedBox(height: 8),
                      Text("Failed to load input image", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                );
              },
            )
                : Center(child: Text("No image URL provided")),
          ),
        ),

        const SizedBox(height: 24),
        Text("Detection Output", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 180,
            color: Colors.grey[100],
            child: outputImageUrl != null && outputImageUrl!.isNotEmpty
                ? Image.network(
              outputImageUrl!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 40),
                      SizedBox(height: 8),
                      Text("Failed to load output image", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                );
              },
            )
                : Center(child: Text("No output image available")),
          ),
        ),

      ],

    );
  }
  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.green[800]),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.green[800])),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _buildFileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }




  Widget buildPastDetectionsScreen() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tree_detection')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No past detection data found."));
        }

        final docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final summary = data['detection_summary'] ?? {};
            final inputUrl = data['input_image_url'] ?? '';
            final outputUrl = data['output_image_url'] ?? '';
            final total = data['tree_count'] ?? 0;
            final healthy = summary['Healthy'] ?? 0;
            final unhealthy = summary['Unhealthy'] ?? 0;

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Detection Summary", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(Icons.forest, "Total", "$total"),
                        _buildInfoCard(Icons.local_florist, "Healthy", "$healthy"),
                        _buildInfoCard(Icons.warning_amber, "Unhealthy", "$unhealthy"),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        if (inputUrl.isNotEmpty)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Input Image",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    inputUrl,
                                    height: 120,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (inputUrl.isNotEmpty && outputUrl.isNotEmpty)
                          const SizedBox(width: 6), // spacing between columns
                        if (outputUrl.isNotEmpty)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Output Image",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    outputUrl,
                                    height: 120,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "🌱 Tree Health Detection",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle tab bar (Upload / Search)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() => showUploadScreen = true);
                    },
                    icon: Icon(Icons.upload_file),
                    label: Text("Upload"),
                    style: TextButton.styleFrom(
                      backgroundColor: showUploadScreen ? Colors.white : Colors.grey[200],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        showUploadScreen = false;
                        selectedImageFile = null; // ⬅️ This clears the previous upload
                      });
                    },
                    icon: Icon(Icons.search),
                    label: Text("History"),
                    style: TextButton.styleFrom(
                      backgroundColor: !showUploadScreen ? Colors.white : Colors.grey[200],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Body content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: showUploadScreen ? buildUploadScreen() : buildPastDetectionsScreen(),
            ),
          ),

        ],
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey[700]),
          const SizedBox(height: 12),
          Text("Drag or drop file here", style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 6),
          const Text("- OR -", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onPickFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Choose file", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}