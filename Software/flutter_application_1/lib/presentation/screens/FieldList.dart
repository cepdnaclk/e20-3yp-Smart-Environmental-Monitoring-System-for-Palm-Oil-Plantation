import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  @override
  Widget build(BuildContext context) {
    final fieldsRef = FirebaseFirestore.instance
        .collection('states')
        .doc(widget.stateId)
        .collection('sections')
        .doc(widget.sectionId)
        .collection('fields');

    return Scaffold(
      appBar: AppBar(title: Text("Details of ${widget.sectionName}")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Section ID: ${widget.sectionId}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Section Name: ${widget.sectionName}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text("Fields:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fieldsRef.snapshots(),
                // builder: (context, snapshot) {
                //   if (snapshot.connectionState == ConnectionState.waiting) {
                //     return Center(child: CircularProgressIndicator());
                //   }

                //   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                //     return Center(child: Text("No fields found."));
                //   }

                //   return ListView(
                //     children: snapshot.data!.docs.map((doc) {
                //       final fieldData = doc.data() as Map<String, dynamic>;
                //       final fieldName = fieldData['fieldName'] ?? 'Unnamed Field';

                //       return ListTile(
                //         title: Text(fieldName),
                //       );
                //     }).toList(),
                //   );
                // },
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  print("Docs fetched: ${snapshot.data!.docs.length}");

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No fields found."));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final fieldData = doc.data() as Map<String, dynamic>;
                      print("Field document: ${fieldData}");

                      final fieldName = fieldData['fieldName'] ?? 'Unnamed Field';

                      return ListTile(
                        title: Text(fieldName),
                      );
                    }).toList(),
                  );
                }

              ),
            ),
          ],
        ),
      ),
    );
  }
}


