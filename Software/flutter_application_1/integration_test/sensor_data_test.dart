import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/main.dart';  // Make sure this path is correct

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Test case: Ensure the Sensor Data screen loads and displays data
  testWidgets('Sensor Data Screen loads and displays data', (WidgetTester tester) async {
    // Pump the app and let it settle (load the initial screen)
    await tester.pumpWidget(const MyApp());

    // Wait for all animations and data fetching to complete
    await tester.pumpAndSettle();

    // Check if the app bar contains the text "Sensor Data"
    expect(find.text('Sensor Data'), findsOneWidget);

    // Ensure that at least one ListTile is displayed (which represents sensor data entries)
    expect(find.byType(ListTile), findsWidgets);
  });

  // Additional test case for network/API loading (if applicable):
  testWidgets('Sensor data loads after fetching from API', (WidgetTester tester) async {
    // Here you would simulate network calls or mock data loading.
    // For this example, we'll assume it should display data after fetching.

    await tester.pumpWidget(const MyApp());

    // Wait for network request or async task completion.
    await tester.pumpAndSettle();

    // Verify that the list of sensor data is displayed after fetching data
    expect(find.byType(ListTile), findsWidgets);
    // Optionally verify specific text or data in the ListTile
    expect(find.text('Sensor 1'), findsOneWidget);  // Replace 'Sensor 1' with actual data
  });
}
