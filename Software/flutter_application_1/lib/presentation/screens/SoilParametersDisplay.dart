import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/SoilParameters.dart';
import 'package:flutter_application_1/data/repositories/databaseService.dart';

class SoilParametersDisplay extends StatefulWidget {
  const SoilParametersDisplay({super.key});

  @override
  _SoilParametersDisplayState createState() => _SoilParametersDisplayState();
}

class _SoilParametersDisplayState extends State<SoilParametersDisplay> {
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  late Future<List<SoilParameters>> futureSoilParameters;

  @override
  void initState() {
    super.initState();
    futureSoilParameters = firestoreRepository.getSoilParameters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Soil Parameters")),
      body: FutureBuilder<List<SoilParameters>>(
        future: futureSoilParameters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          } else {
            List<SoilParameters> soilParams = snapshot.data!;
            return ListView.builder(
              itemCount: soilParams.length,
              itemBuilder: (context, index) {
                SoilParameters soil = soilParams[index];
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
