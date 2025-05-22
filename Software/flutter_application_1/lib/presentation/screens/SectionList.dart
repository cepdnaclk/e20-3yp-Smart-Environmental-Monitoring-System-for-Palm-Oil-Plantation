import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/presentation/screens/FieldList.dart';

class SectionListScreen extends StatefulWidget {
  final String stateId;
  final String stateName;

  SectionListScreen({required this.stateId, required this.stateName});

  @override
  _SectionListScreenState createState() => _SectionListScreenState();
}

class _SectionListScreenState extends State<SectionListScreen> {
  late CollectionReference sectionsRef;

  @override
  void initState() {
    super.initState();
    sectionsRef = FirebaseFirestore.instance
        .collection('states')
        .doc(widget.stateId)
        .collection('sections');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sections of ${widget.stateName}")),
      body: StreamBuilder<QuerySnapshot>(
        stream: sectionsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final sections = snapshot.data!.docs;

          return ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              var section = sections[index];
              String sectionId = section.id;
              String sectionName = section['sectionName'] ?? 'No Name';
              String sectionNumber = section['sectionNumber']?.toString() ?? 'N/A';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          sectionName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text("Section Number: $sectionNumber"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
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

                      // ✅ Subsections (visually shown, not navigable)
                      FutureBuilder<QuerySnapshot>(
                        future: sectionsRef.doc(sectionId).collection('subsections').get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("No subsections", style: TextStyle(color: Colors.grey)),
                            );
                          }

                          final subs = snapshot.data!.docs;

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
                                    Text("$subName (No. $subNum)", style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );

        },
          )
        );
        }
      
  }

