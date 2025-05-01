// import 'package:flutter_application_1/data/repositories/RoleRepository.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final RoleRepository _roleRepo = RoleRepository();

//   Future<User?> signUp(String email, String password, String name, String role) async {
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       User? user = userCredential.user;
//       if (user != null) {
//         // Store role in Firestore or any database
//         // Example using Firebase Firestore:
//         await user.updateDisplayName(name);
//         await saveUserRole(user.uid, role);
//       }
//       return user;
//     } catch (e) {
//       print("Error during sign-up: $e");
//       return null;
//     }
//   }

//   Future<void> saveUserRole(String userId, String role) async {
//     // Example: Firebase Firestore implementation
//     // FirebaseFirestore.instance.collection('users').doc(userId).set({'role': role});
//   }
// }
