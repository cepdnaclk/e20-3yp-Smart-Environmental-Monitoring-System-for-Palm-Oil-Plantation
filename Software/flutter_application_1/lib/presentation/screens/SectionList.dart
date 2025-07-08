import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';

// Screen that displays a list of sections under a selected state
class SectionListScreen extends StatefulWidget {
  final String stateId;   // ID of the selected state (used to query Firestore)
  final String stateName; // Display name of the selected state

  const SectionListScreen({required this.stateId, required this.stateName});

  @override
  _SectionListScreenState createState() => _SectionListScreenState();
}

class _SectionListScreenState extends State<SectionListScreen> {
  late CollectionReference sectionsRef;

  @override
  void initState() {
    super.initState();
    // Set up reference to 'sections' subcollection of the selected state document
    sectionsRef = FirebaseFirestore.instance
        .collection('states')
        .doc(widget.stateId)
        .collection('sections');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Sections of ${widget.stateName}"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: sectionsRef.snapshots(), // Real-time updates from Firestore
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Show loading indicator while fetching data
            return Center(child: CircularProgressIndicator());
          }

          final sections = snapshot.data!.docs;

          // Build a list of section cards
          return ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              var section = sections[index];
              String sectionId = section.id;
              String sectionName = section['sectionName'] ?? 'No Name';
              String sectionNumber = section['sectionNumber']?.toString() ?? 'N/A';

              return Card(
                color: Colors.green.shade50,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),side: BorderSide(color: Colors.green.shade100),),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section main info with clickable tile
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.map_rounded, color: Colors.green[700], size: 28),
                        title: Text(
                          sectionName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text("Section Number: $sectionNumber"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to the field screen and pass section data
                          Navigator.pushNamed(
                            context,
                            AppRoutes.field,
                            arguments: {
                              'stateId': widget.stateId,
                              'sectionId': sectionId,
                              'sectionName': sectionName,
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 8),
/*
                      // Display list of subsections under this section
                      FutureBuilder<QuerySnapshot>(
                        future: sectionsRef.doc(sectionId).collection('subsections').get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            // If no subsections found
                            return Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text("No subsections", style: TextStyle(color: Colors.grey)),
                            );
                          }

                          final subs = snapshot.data!.docs;

                          // Build list of subsection items
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: subs.map((sub) {
                              final subName = sub['name'] ?? 'Unnamed';
                              final subNum = sub['number']?.toString() ?? 'N/A';

                              return Padding(
                                padding: const EdgeInsets.only(left: 12.0, top: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.circle, size: 6, color: Colors.green[700]),
                                    SizedBox(width: 6),
                                    Text(
                                      "$subName (No. $subNum)",
                                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),*/
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
