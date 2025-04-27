// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/presentation/screens/authenticate/SignUpScreen.dart';


// class Authenticate extends StatefulWidget {
//   const Authenticate({super.key});

//   @override
//   State<Authenticate> createState() => _AuthenticateState();
// }

// class _AuthenticateState extends State<Authenticate> {
//   bool singinPage = true;

//   //toggle pages
//   void switchPages() {
//     setState(() {
//       singinPage = !singinPage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (singinPage == true) {
//       return SignIn(toggle: switchPages);
//     } else {
//       return SignUpScreen(toggle: switchPages);
//     }
//   }
// }