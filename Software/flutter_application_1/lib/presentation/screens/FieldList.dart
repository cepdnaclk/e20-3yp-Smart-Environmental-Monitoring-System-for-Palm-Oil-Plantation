import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/widgets.dart';
import 'FieldDetailScreen.dart';
import 'FieldStatisticsPanel.dart';

class FieldListScreen extends StatefulWidget {
  final String stateId;
  final String sectionId;
  final String sectionName;

  FieldListScreen({
    required this.stateId,
    required this.sectionId,
    required this.sectionName,
  });

  @override
  _FieldListScreenState createState() => _FieldListScreenState();
}

class _FieldListScreenState extends State<FieldListScreen> {
  bool showStatistics = false;

  @override
  Widget build(BuildContext context) {
    final fieldsRef = FirebaseFirestore.instance
        .collection('states')
        .doc(widget.stateId)
        .collection('sections')
        .doc(widget.sectionId)
        .collection('fields');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Section: ${widget.sectionName}", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBox("Section ID", widget.sectionId),
            SizedBox(height: 8),
            _buildInfoBox("Section Name", widget.sectionName),
            SizedBox(height: 16),
            Text("Fields", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
            SizedBox(height: 8),

            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  showStatistics ? "Field Statistics" : "Field List",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: showStatistics,
                  onChanged: (value) {
                    setState(() {
                      showStatistics = value;
                    });
                  },
                  activeColor: Colors.green[700],
                ),
              ],
            ),*/
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showStatistics = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !showStatistics ? Colors.green[700] : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Fields",
                            style: TextStyle(
                              color: !showStatistics ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showStatistics = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: showStatistics ? Colors.green[700] : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Statistics",
                            style: TextStyle(
                              color: showStatistics ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            Expanded(
              child: showStatistics
                  ? _buildStatisticsView()
                  : _buildFieldListView(fieldsRef),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green.shade100),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: Colors.green[700]),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldListView(CollectionReference fieldsRef) {
    return StreamBuilder<QuerySnapshot>(
      stream: fieldsRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No fields found."));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final fieldData = doc.data() as Map<String, dynamic>;
            final fieldId = doc.id;
            final fieldName = fieldData['fieldName'] ?? 'Unnamed Field';

            return GestureDetector(
              onTap: () {
                print('Navigating to MapScreen with:');
                print('stateId: ${widget.stateId}');
                print('sectionId: ${widget.sectionId}');
                print('fieldId: $fieldId');
                Navigator.pushNamed(
                  context,
                  '/mapScreen',
                  arguments: {
                    'stateId': widget.stateId,
                    'sectionId': widget.sectionId,
                    'fieldId': fieldId,
                  },
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        fieldName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                      SizedBox(height: 8),
                      Text("Tap to view full details", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatisticsView() {
    return SingleChildScrollView(
      child: FieldStatisticsPanel(sectionName: widget.sectionName),
    );
  }
}
