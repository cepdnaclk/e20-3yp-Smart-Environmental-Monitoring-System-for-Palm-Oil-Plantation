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
              // return ListTile(
              //   title: Text(section['sectionName']),
              // );
              return ListTile(
                title: Text(section['sectionName'] ?? 'No Name'),
                subtitle: Text("Section Number: ${section['sectionNumber'] ?? 'N/A'}"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.field,
                        arguments: {
                          'stateId': widget.stateId,
                          'sectionId': section.id,
                          'sectionName': section['sectionName'],
                        },
                      );
                    },
                  );
                },
              );
            },
          )
        );
        }
      
  }

