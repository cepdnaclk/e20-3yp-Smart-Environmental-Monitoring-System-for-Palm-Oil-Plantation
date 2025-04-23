import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/DeviceTwoScreen.dart';
import 'package:flutter_application_1/presentation/screens/sensorDataScreen.dart';
import 'package:flutter_application_1/presentation/screens/soilParametersDisplay.dart';
import '../presentation/screens/UserLogin.dart';
import '../presentation/screens/LoginScreen.dart';
import '../presentation/screens/HomeScreen.dart';
import '../presentation/screens/SignUpScreen.dart';
import '../presentation/screens/StatisticsScreen.dart';
import '../presentation/screens/ForgetPassword.dart';
import '../presentation/screens/ResetPassword.dart';

class AppRoutes {
  static const String home = '/home';
  static const String userlogin = '/userlogin';
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
      case userlogin:
        return MaterialPageRoute(builder: (_) => UserLogin());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      // case soilParameters:
      //   return MaterialPageRoute(builder: (_) => SoilParametersDisplay());
      case statistics:
        final String divisionNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => StatisticsScreen(divisionNumber: divisionNumber),
        );
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPassword());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPassword());
         case sensorDataDisplay:
        return MaterialPageRoute(builder: (_) => SensorDataDisplay());
      case deviceTwoScreen:
        return MaterialPageRoute(builder: (_) => DeviceTwoScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}


