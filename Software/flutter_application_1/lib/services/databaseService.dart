import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/soilParameters.dart';


class FirestoreService {
  final CollectionReference soilCollection =
      FirebaseFirestore.instance.collection('soilParamters');

  // Fetch all soil parameter documents
  Future<List<soilParameters>> getsoilParameterss() async {
    QuerySnapshot snapshot = await soilCollection.get();
    return snapshot.docs
        .map((doc) => soilParameters.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Fetch a single soil parameter document by ID
  Future<soilParameters?> getsoilParametersById(String id) async {
    DocumentSnapshot doc = await soilCollection.doc(id).get();
    if (doc.exists) {
      return soilParameters.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Add a new soil parameter document
  Future<void> addsoilParameters(soilParameters soilParameters) async {
    await soilCollection.add(soilParameters.toMap());
  }

  // Update an existing soil parameter document
  Future<void> updatesoilParameters(soilParameters soilParameters) async {
    await soilCollection.doc(soilParameters.id).update(soilParameters.toMap());
  }

  // Delete a soil parameter document
  Future<void> deletesoilParameters(String id) async {
    await soilCollection.doc(id).delete();
  }
}
