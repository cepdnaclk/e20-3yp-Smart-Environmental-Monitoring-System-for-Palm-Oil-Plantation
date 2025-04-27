import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Environmental Monitoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login, // Start at Login Screen
      onGenerateRoute: AppRoutes.generateRoute, // Route manager
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/firebase_options.dart';
// import 'package:flutter_application_1/presentation/screens/DeviceTwoScreen.dart';
// import 'package:flutter_application_1/presentation/screens/SignUpScreen.dart';
// import 'package:flutter_application_1/presentation/screens/sensorDataScreen.dart'; // Import SensorDataDisplay
// import 'package:flutter_application_1/presentation/screens/SoilParametersDisplay.dart'; // Import SoilParametersDisplay

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
//       title: 'Sensor & Soil Data',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//         useMaterial3: true,
//       ),
//       // home: const SensorDataDisplay(), // Change this to SoilParametersDisplay if needed
//       // home: const SoilParametersDisplay(),
//       // home: SignUpScreen(),
//       home: DeviceTwoScreen(),
//     );
//   }
// }


