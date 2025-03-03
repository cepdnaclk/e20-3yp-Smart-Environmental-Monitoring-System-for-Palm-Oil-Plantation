// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AuthProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> checkUserRole(BuildContext context) async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       // Fetch user role from Firestore
//       String role = "Laborer"; // Example; replace with Firestore query
//       if (role == "Manager") {
//         Navigator.pushReplacementNamed(context, "/manager");
//       } else {
//         Navigator.pushReplacementNamed(context, "/laborer");
//       }
//     } else {
//       Navigator.pushReplacementNamed(context, "/login");
//     }
//   }
// }
