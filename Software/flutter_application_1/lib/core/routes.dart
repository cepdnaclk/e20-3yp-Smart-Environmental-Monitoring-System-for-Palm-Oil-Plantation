import 'package:flutter/material.dart';
import '../presentation/screens/UserLogin.dart';
import '../presentation/screens/LoginScreen.dart';
import '../presentation/screens/HomeScreen.dart';
import '../presentation/screens/SignUpScreen.dart';
import '../presentation/screens/SoilParametersDisplay.dart';
import '../presentation/screens/StatisticsScreen.dart';
import '../presentation/screens/ForgetPassword.dart';
import '../presentation/screens/ResetPassword.dart';

class AppRoutes {
  static const String home = '/home';
  static const String userLogin = '/userLogin';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String soilParameters = '/soilParameters';
  static const String statistics = '/statistics';
  static const String forgetPassword = '/forgetPassword';
  static const String resetPassword = '/resetPassword';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case userLogin:
        return MaterialPageRoute(builder: (_) => UserLogin());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case soilParameters:
        return MaterialPageRoute(builder: (_) => SoilParametersDisplay());
      case statistics:
        return MaterialPageRoute(builder: (_) => StatisticsScreen(divisionNumber: '',));
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPassword());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPassword());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen()); // Default to login
    }
  }
}
