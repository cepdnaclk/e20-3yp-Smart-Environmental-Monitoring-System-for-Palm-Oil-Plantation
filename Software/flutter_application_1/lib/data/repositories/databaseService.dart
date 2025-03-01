import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/soilParametersModel.dart';
import 'package:flutter_application_1/domain/entities/SoilParameters.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SoilParameters>> getSoilParameters() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('SoilParameters').get();

      List<SoilParameters> soilParamsList = snapshot.docs.map((doc) {
        return SoilParametersModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return soilParamsList;
    } catch (e) {
      throw Exception("Failed to load soil parameters: $e");
    }
  }
}
