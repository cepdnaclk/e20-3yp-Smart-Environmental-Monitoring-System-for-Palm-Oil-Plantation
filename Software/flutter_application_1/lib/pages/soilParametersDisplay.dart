import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/soilParameters.dart';
import 'package:flutter_application_1/services/databaseService.dart';

class soilParametersDisplay extends StatefulWidget {
  @override
  _soilParametersDisplayState createState() => _soilParametersDisplayState();
}

class _soilParametersDisplayState extends State<soilParametersDisplay> {
  final FirestoreService firestoreService = FirestoreService();
  late Future<List<soilParameters>> futuresoilParameterss;

  @override
  void initState() {
    super.initState();
    futuresoilParameterss = firestoreService.getsoilParameterss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Soil Parameters")),
      body: FutureBuilder<List<soilParameters>>(
        future: futuresoilParameterss,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          } else {
            List<soilParameters> soilParams = snapshot.data!;
            return ListView.builder(
              itemCount: soilParams.length,
              itemBuilder: (context, index) {
                soilParameters soil = soilParams[index];
                return ListTile(
                  title: Text("Section: ${soil.section}"),
                  subtitle: Text("N: ${soil.nitrogenN}, P: ${soil.phosphorusP}, K: ${soil.potassiumK}"),
                );
              },
            );
          }
        },
      ),
    );
  }
}
