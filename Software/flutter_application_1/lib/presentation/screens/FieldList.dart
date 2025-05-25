import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/widgets.dart';
import 'FieldDetailScreen.dart';

// Screen that lists all fields under a given section
class FieldListScreen extends StatefulWidget {
  final String stateId;     // ID of the selected state
  final String sectionId;   // ID of the selected section
  final String sectionName; // Name of the selected section

  FieldListScreen({
    required this.stateId,
    required this.sectionId,
    required this.sectionName,
  });

  @override
  _FieldListScreenState createState() => _FieldListScreenState();
}

class _FieldListScreenState extends State<FieldListScreen> {
  // This is unused and should be removed. The correct fieldId is obtained from each Firestore document.
  get fieldId => null;

  @override
  Widget build(BuildContext context) {
    // Firestore reference to the 'fields' subcollection under the selected section
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
            // Section info cards
            _buildInfoBox("Section ID", widget.sectionId),
            SizedBox(height: 8),
            _buildInfoBox("Section Name", widget.sectionName),
            SizedBox(height: 16),
            Text("Fields", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
            SizedBox(height: 8),

            // StreamBuilder listens for real-time updates to the fields collection
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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

                  // If data is available, build a list of cards for each field
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final fieldData = doc.data() as Map<String, dynamic>;
                      final fieldId = doc.id; // Correct field ID from Firestore document ID
                      final fieldName = fieldData['fieldName'] ?? 'Unnamed Field';

                      return GestureDetector(
                        // onTap: () {
                        //   // Navigate to detail screen and pass field info
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => FieldDetailScreen(
                        //         fieldName: fieldName,
                        //         fieldData: fieldData,
                        //         fieldId: fieldId, // Correct usage of fieldId
                        //       ),
                        //     ),
                        //   );
                        // },
                        onTap: () {
                            print('Navigating to MapScreen with:');
                            print('stateId: ${widget.stateId}');
                            print('sectionId: ${widget.sectionId}');
                            print('fieldId: $fieldId');
                          Navigator.pushNamed(
                            context,
                            '/mapScreen', // or the route name you've defined for the map screen
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper widget to display labeled info (Section ID, Section Name, etc.)
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
}

// A circular widget for displaying a parameter value (used in detail screens, not this one directly)
Widget _parameterCircle(String label, String value, Color color) {
  return Column(
    children: [
      Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 13)),
    ],
  );
}
