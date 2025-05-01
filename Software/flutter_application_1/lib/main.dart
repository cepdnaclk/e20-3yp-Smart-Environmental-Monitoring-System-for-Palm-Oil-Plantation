import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:provider/provider.dart'; // ADD this
import 'firebase_options.dart';
import 'package:flutter_application_1/data/services/AuthService.dart'; // Your AuthService
import 'package:flutter_application_1/data/models/UserModel.dart'; // Your UserModel
import 'package:flutter_application_1/wrapper.dart'; // We will create this

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthServices().user,  // 👈 Listening to Firebase user auth changes
      initialData: null,           // 👈 Start with null (not logged in)
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Environmental Monitoring',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: Wrapper(), // 👈 START with the Wrapper
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'core/routes.dart';
// import 'firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   FirebaseFirestore.instance.settings = const Settings(
//     persistenceEnabled: true,
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Smart Environmental Monitoring',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//         useMaterial3: true,
//       ),
//       initialRoute: AppRoutes.login, // Start at Login Screen
//       onGenerateRoute: AppRoutes.generateRoute, // Route manager
//     );
//   }
// }