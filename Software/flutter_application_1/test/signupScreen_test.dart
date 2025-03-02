import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/presentation/screens/SignUpScreen.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/presentation/screens/HomeScreen.dart';

void main() {
  testWidgets('SignUpScreen renders all UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpScreen()));

    //Check if the text fields are present
    expect(find.text("Name"), findsOneWidget);
    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);

    //Check if the Role dropdown exists
    expect(find.text("Role"), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);

    //Check if the Sign Up button is present
    expect(find.text("Sign Up"), findsOneWidget);
  });

  testWidgets('Name, email, and password fields accept input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpScreen()));
    // Find the input fields
    final nameField = find.byType(TextField).at(0);
    final emailField = find.byType(TextField).at(1);
    final passwordField = find.byType(TextField).at(2);

    //Enter text
    await tester.enterText(nameField, "Mineth De Croos");
    await tester.enterText(emailField, "mineth@email.com");
    await tester.enterText(passwordField, "password123");
    await tester.pump();

    //Verify input is displayed
    expect(find.text("Mineth De Croos"), findsOneWidget);
    expect(find.text("mineth@email.com"), findsOneWidget);
    expect(find.text("password123"), findsOneWidget);
  });

  testWidgets('Dropdown allows selecting a role', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpScreen()));

    //Open the dropdown
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    //Find "Manager" inside the dropdown list
    final managerItem = find.descendant(
      of: find.byType(DropdownMenuItem<String>),
      matching: find.text("Manager"),
    );

    //Tap to select "Manager"
    await tester.tap(managerItem);
    await tester.pumpAndSettle();

    //Verify that "Manager" is now the selected value
    expect(find.text("Manager"), findsWidgets); // Allow multiple matches
  });


  testWidgets('Clicking "Sign Up" navigates to HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SignUpScreen(),
      onGenerateRoute: AppRoutes.generateRoute, // Ensure route generator is used
    ));

    //Tap the "Sign Up" button
    await tester.tap(find.text("Sign Up"));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    //Verify it navigated to LoginScreen
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
