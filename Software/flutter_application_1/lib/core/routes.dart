import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/UserModel.dart';
import 'package:flutter_application_1/presentation/screens/DeviceTwoScreen.dart';
import 'package:flutter_application_1/presentation/screens/sensorDataScreen.dart';
import 'package:flutter_application_1/presentation/screens/soilParametersDisplay.dart';
import 'package:provider/provider.dart';
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
    return MaterialPageRoute(
      builder: (context) {
        final user = Provider.of<UserModel?>(context, listen: false);

        switch (settings.name) {
          // 🔓 Public Routes
          case login:
            return LoginScreen(toggle: () {});
          case signup:
            return SignUpScreen(toggle: () {});
          case userLogin:
            return UserLogin();
          case forgetPassword:
            return ForgetPassword();
          case resetPassword:
            return ResetPassword();

          // 🔐 Protected Routes
          case home:
            return _protectedRoute(() => HomeScreen(), user);
          case soilParameters:
            return _protectedRoute(() => SoilParametersDisplay(), user);
          case statistics:
            return _protectedRoute(() => StatisticsScreen(), user);
          case sensorDataDisplay:
            return _protectedRoute(() => SensorDataDisplay(), user);
          case deviceTwoScreen:
            return _protectedRoute(() => DeviceTwoScreen(), user);

          // 🌐 Default route (could redirect to home or login)
          default:
            return user != null ? HomeScreen() : LoginScreen(toggle: () {});
        }
      },
    );
  }

  static Widget _protectedRoute(Widget Function() screenBuilder, UserModel? user) {
    if (user != null) {
      return screenBuilder();
    } else {
      return LoginScreen(toggle: () {});
    }
  }
}



// class AppRoutes {
//   static const String home = '/home';
//   static const String userLogin = '/userLogin';
//   static const String login = '/login';
//   static const String signup = '/signup';
//   static const String soilParameters = '/soilParameters';
//   static const String statistics = '/statistics';
//   static const String forgetPassword = '/forgetPassword';
//   static const String resetPassword = '/resetPassword';
//   static const String sensorDataDisplay = '/sensorDataDisplay';
//   static const String deviceTwoScreen = '/deviceTwoScreen';

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case userLogin:
//         return MaterialPageRoute(builder: (_) => UserLogin());
//       // case home:
//       //   return MaterialPageRoute(builder: (_) => HomeScreen());
//       case login:
//         return MaterialPageRoute(builder: (_) => LoginScreen(toggle: () {}));
//       // case signup:
//       //   return MaterialPageRoute(builder: (_) => SignUpScreen());
//       // case soilParameters:
//       //   return MaterialPageRoute(builder: (_) => SoilParametersDisplay());
//       case statistics:
//         return MaterialPageRoute(builder: (_) => StatisticsScreen());
//       case forgetPassword:
//         return MaterialPageRoute(builder: (_) => ForgetPassword());
//       case resetPassword:
//         return MaterialPageRoute(builder: (_) => ResetPassword());
//          case sensorDataDisplay:
//         return MaterialPageRoute(builder: (_) => SensorDataDisplay());
//       case deviceTwoScreen:
//         return MaterialPageRoute(builder: (_) => DeviceTwoScreen());
//       // default:
//       //   return MaterialPageRoute(builder: (_) => LoginScreen(toggle: () {})); // Default to login
//       default:
//         return MaterialPageRoute(builder: (_) => HomeScreen()); // Default to login
//     }
//   }
// }
