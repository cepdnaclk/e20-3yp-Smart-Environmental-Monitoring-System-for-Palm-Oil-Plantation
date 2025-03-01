import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/ForgetPassword.dart';
import 'package:flutter_application_1/presentation/screens/ResetPassword.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/presentation/screens/LoginScreen.dart'; // Adjust import
import 'package:flutter_application_1/core/routes.dart';

void main() {
  testWidgets('LoginScreen renders email and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Verify email and password fields are present
    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
  });

  testWidgets('Text fields accept input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Find the text fields
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;

    // Enter text
    await tester.enterText(emailField, "test@example.com");
    await tester.enterText(passwordField, "passwordnew123");
    await tester.pump();

    // Verify input
    expect(find.text("test@example.com"), findsOneWidget);
    expect(find.text("passwordnew123"), findsOneWidget);
  });

  testWidgets('ForgetPassword screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ForgetPassword()));

    // ✅ Check if the header text is present
    expect(find.text("Forget Your Password?"), findsOneWidget);

    // ✅ Check if email field is present
    expect(find.text("Email"), findsOneWidget);

    // ✅ Check if Continue button is present
    expect(find.text("Continue"), findsOneWidget);
  });

  testWidgets('Email input accepts text', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ForgetPassword()));

    // Find the email input field
    final emailField = find.byType(TextField);

    // ✅ Enter email text
    await tester.enterText(emailField, "test@example.com");
    await tester.pump();

    // ✅ Verify input is displayed correctly
    expect(find.text("test@example.com"), findsOneWidget);
  });

  testWidgets('Clicking "Continue" navigates to ResetPassword screen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ForgetPassword(),
      onGenerateRoute: AppRoutes.generateRoute, // Ensure the route generator is used
    ));

    // ✅ Tap the Continue button
    await tester.tap(find.text("Continue"));
    await tester.pumpAndSettle(); // Ensure the navigation completes

    // ✅ Verify navigation to ResetPassword screen
    expect(find.byType(ResetPassword), findsOneWidget);
  });
}
