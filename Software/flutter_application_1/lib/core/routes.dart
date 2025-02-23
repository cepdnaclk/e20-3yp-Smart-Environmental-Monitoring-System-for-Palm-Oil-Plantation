import 'package:flutter/material.dart';
import '../presentation/screens/HomeScreen.dart';
import '../presentation/screens/LoginScreen.dart';
import '../presentation/screens/SignUpScreen.dart';
import '../presentation/screens/SoilParametersDisplay.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String soilParameters = '/soilParameters';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case soilParameters:
        return MaterialPageRoute(builder: (_) => SoilParametersDisplay());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen()); // Default to login
    }
  }
}
