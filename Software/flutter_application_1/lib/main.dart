import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:provider/provider.dart'; // ADD this
import 'firebase_options.dart';
import 'package:flutter_application_1/data/services/AuthService.dart'; // Your AuthService
import 'package:flutter_application_1/data/models/UserModel.dart'; // Your UserModel
import 'package:flutter_application_1/wrapper.dart'; // We will create this
import 'package:flutter_application_1/data/services/SensorListenerService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/presentation/screens/NewParameterChart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Force enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  final sensorService = SensorListenerService();
  sensorService.initializePlugin();
  sensorService.startListening();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthServices().user,  // Listening to Firebase user auth changes
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Environmental Monitoring',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: Wrapper(), //START with the Wrapper
        onGenerateRoute: (settings) {
          if (settings.name == '/newParameterChart') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => NewParameterChart(
                title: args['title'],
                parameter: args['parameter'],
                collection: args['collection'],
              ),
            );
          }

          // Fallback to general app routes
          return AppRoutes.generateRoute(settings);
        },


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