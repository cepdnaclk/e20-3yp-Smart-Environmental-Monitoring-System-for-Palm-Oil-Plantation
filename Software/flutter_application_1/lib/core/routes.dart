import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/UserModel.dart';
import 'package:flutter_application_1/data/services/FirebaseServiced.dart';
import 'package:flutter_application_1/presentation/screens/DeviceTwoScreen.dart';
import 'package:flutter_application_1/presentation/screens/FieldDetailScreen.dart';
import 'package:flutter_application_1/presentation/screens/FieldList.dart';
import 'package:flutter_application_1/presentation/screens/ParameterChart.dart';
import 'package:flutter_application_1/presentation/screens/RecentActivitiesScreen.dart';
import 'package:flutter_application_1/presentation/screens/SettingsScreen.dart';
import 'package:flutter_application_1/presentation/screens/ThresholdSettingScreen.dart';
import 'package:flutter_application_1/presentation/screens/TreeDetectionPage.dart';
import 'package:flutter_application_1/presentation/screens/chart.dart';
import 'package:flutter_application_1/presentation/screens/map.dart';
import 'package:flutter_application_1/presentation/screens/sensorDataScreen.dart';
import 'package:flutter_application_1/presentation/screens/soilParametersDisplay.dart';
import 'package:flutter_application_1/presentation/screens/SectionList.dart';
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
  static const String section = '/section';
  static const String field = '/field';
  static const String chart = '/chart';
  static const String treeDetection = '/treeDetectionPage';
  static const String settingsScreen = '/settingsScreen';
  static const String recentActivities = '/recentActivitiesScreen';
  static const String map = '/mapScreen';
  static const String fieldDetailsScreen = '/fieldDetailsScreen';
  static const String parameterChart = '/parameterChart';
  static const String thresholdSetting = '/thresholdSetting';




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
          case treeDetection:
            return _protectedRoute(() => TreeDetectionPage(), user);
          case thresholdSetting:
            return _protectedRoute(() => ThresholdSettingsScreen(), user);
          // case parameterChart:
          //   final args = settings.arguments as Map?;
          //   final title = args?['title'] ?? '';
          //   final parameter = args?['parameter'] ?? '';
          //   final sectionName = args?['sectionName'] ?? '';
          //   final sectionDescription = args?['sectionDescription'] ?? '';
          //   final sensorData = args?['sensorData'];
          //   final stats = args?['stats'];

          //   return _protectedRoute(
          //     () => ParameterChart(
          //       title: title,
          //       parameter: parameter,
          //       sectionName: sectionName,
          //       sectionDescription: sectionDescription,
          //       sensorData: sensorData,
          //       stats: stats,
          //     ),
          //     user,
          //   );


          case parameterChart:
          final args = settings.arguments as Map?;
          return _protectedRoute(
            () => ParameterChart(
              title: args?['title'] ?? '',
              parameter: args?['parameter'] ?? '',
              sectionName: args?['sectionName'] ?? '',
              sectionPath: args?['sectionPath'] ?? '',
              sectionDescription: args?['sectionDescription'] ?? '',
              sensorData: args?['sensorData'], // likely null
              stats: args?['stats'], // likely null
            ),
            user,
          );



          case settingsScreen:
            return _protectedRoute(() => SettingsScreen(), user);
          case recentActivities:

            return _protectedRoute(
                  () => RecentActivitiesScreen(
                // activities: [
                //   {"title": "Sensor: Soil Moisture", "time": "Today - 10:35 AM"},
                //   {"title": "Sensor: Light Intensity", "time": "Today - 11:24 AM"},
                //   {"title": "Device Two Accessed", "time": "Today - 11:26 AM"},
                // ],
              ),
              user,
            );
          case fieldDetailsScreen:
            final args = settings.arguments as Map?;
            final fieldName = args?['fieldName'] ?? '';
            final fieldData = args?['fieldData'];
            final fieldId = args?['fieldId'] ?? '';

            return _protectedRoute(
                  () => FieldDetailScreen(
                fieldId: fieldId,
                fieldName: fieldName,
                fieldData: fieldData,
              ),
              user,
            );

        // case section:
          //   return _protectedRoute(() => SectionListScreen(stateId: '', stateName: '',), user);

          case section:
            final args = settings.arguments as Map?;
            final stateId = args?['stateId'] ?? '';
            final stateName = args?['stateName'] ?? '';
            return _protectedRoute(() => SectionListScreen(stateId: stateId, stateName: stateName), user);
          // case section:
          //   return _protectedRoute(() => SectionListScreen(stateId: '', stateName: '',), user);
          case map:
            final args = settings.arguments as Map<String, dynamic>?;

            final stateId = args?['stateId'];
            final sectionId = args?['sectionId'];
            final fieldId = args?['fieldId'];
            final showOverlay = args?['showOverlay'] ?? false;

            return _protectedRoute(
              () => MapScreen(
                stateId: stateId,
                sectionId: sectionId,
                fieldId: fieldId,
                showOverlay: showOverlay,
              ),
              user,
            );

          // case field:
          //   final args = settings.arguments as Map?;
          //   final sectionId = args?['sectionId'] ?? '';
          //   final sectionName = args?['sectionName'] ?? '';
          //   return _protectedRoute(() => FieldListScreen(sectionId: sectionId, sectionName: sectionName), user);
          case field:
            final args = settings.arguments as Map?;
            final stateId = args?['stateId'] ?? '';
            final sectionId = args?['sectionId'];
            final sectionName = args?['sectionName'];

            return _protectedRoute(
              () => FieldListScreen(
                stateId: stateId,
                sectionId: sectionId,
                sectionName: sectionName,
              ),
              user,
            );
          case chart:
            return _protectedRoute(() {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchSensorData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data found.'));
                  } else {
                    final sensorData = snapshot.data!;
                    return HumidityChart(sensorData: sensorData);
                  }
                },
              );
            }, user);
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