// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/data/models/soilParametersModel.dart';


// class FirestoreService {
//   final CollectionReference soilCollection =
//       FirebaseFirestore.instance.collection('soilParamters');

//   // Fetch all soil parameter documents
//   Future<List<soilParameters>> getsoilParameterss() async {
//     QuerySnapshot snapshot = await soilCollection.get();
//     return snapshot.docs
//         .map((doc) => soilParameters.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//         .toList();
//   }

//   // Fetch a single soil parameter document by ID
//   Future<soilParameters?> getsoilParametersById(String id) async {
//     DocumentSnapshot doc = await soilCollection.doc(id).get();
//     if (doc.exists) {
//       return soilParameters.fromMap(doc.id, doc.data() as Map<String, dynamic>);
//     }
//     return null;
//   }

//   // Add a new soil parameter document
//   Future<void> addsoilParameters(soilParameters soilParameters) async {
//     await soilCollection.add(soilParameters.toMap());
//   }

//   // Update an existing soil parameter document
//   Future<void> updatesoilParameters(soilParameters soilParameters) async {
//     await soilCollection.doc(soilParameters.id).update(soilParameters.toMap());
//   }

//   // Delete a soil parameter document
//   Future<void> deletesoilParameters(String id) async {
//     await soilCollection.doc(id).delete();
//   }
// }

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
