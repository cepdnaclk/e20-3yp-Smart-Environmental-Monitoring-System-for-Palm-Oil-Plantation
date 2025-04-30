import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/DeviceTwoScreen.dart';
import 'package:flutter_application_1/presentation/screens/sensorDataScreen.dart';
import 'package:flutter_application_1/presentation/screens/soilParametersDisplay.dart';
import '../presentation/screens/UserLogin.dart';
import '../presentation/screens/authenticate/LoginScreen.dart';
import '../presentation/screens/HomeScreen.dart';
import '../presentation/screens/authenticate/SignUpScreen.dart';
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
  static const String sensorDataDisplay = '/sensorDataDisplay';
  static const String deviceTwoScreen = '/deviceTwoScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case userLogin:
        return MaterialPageRoute(builder: (_) => UserLogin());
      // case home:
      //   return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen(toggle: () {}));
      // case signup:
      //   return MaterialPageRoute(builder: (_) => SignUpScreen());
      // case soilParameters:
      //   return MaterialPageRoute(builder: (_) => SoilParametersDisplay());
      case statistics:
        return MaterialPageRoute(builder: (_) => StatisticsScreen());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPassword());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPassword());
         case sensorDataDisplay:
        return MaterialPageRoute(builder: (_) => SensorDataDisplay());
      case deviceTwoScreen:
        return MaterialPageRoute(builder: (_) => DeviceTwoScreen());
      // default:
      //   return MaterialPageRoute(builder: (_) => LoginScreen(toggle: () {})); // Default to login
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen()); // Default to login
    }
  }
}


