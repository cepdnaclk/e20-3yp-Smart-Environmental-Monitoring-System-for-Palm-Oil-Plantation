import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/HomeScreen.dart';
import 'package:flutter_application_1/presentation/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/data/models/UserModel.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //the user data that the provider proides this can be a user data or can be null.
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}

// // Without welcome screen
// class Wrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserModel?>(context);

//     // Check if user is null
//     if (user == null) {
//       return LoginScreen(); // Not logged in
//     } else {
//       return HomeScreen(); // Logged in
//     }
//   }
// }

// // With welcome screen
// class Wrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserModel?>(context);

//     if (user == null) {
//       return UserLogin(); // 👈 Show your custom welcome screen first
//     } else {
//       return HomeScreen(); // Logged in user goes to Home
//     }
//   }
// }