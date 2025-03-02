import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/presentation/widgets/widgets.dart'; // Adjust your import

void main() {
  testWidgets('customButton renders and triggers onPressed', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: customButton("Click Me", () {
            pressed = true;
          }),
        ),
      ),
    );
    // Verify the button is displayed
    expect(find.text("Click Me"), findsOneWidget);
    // Tap the button
    await tester.tap(find.text("Click Me"));
    await tester.pump();

    // Verify the button's callback is triggered
    expect(pressed, isTrue);
  });

  testWidgets('socialIcon renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: socialIcon("assets/icons/google.png"),
        ),
      ),
    );

    // Verify the CircleAvatar exists
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Verify the image inside the avatar exists
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('customTextField renders and accepts input', (WidgetTester tester) async {
    TextEditingController testController = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: customTextField("Enter Name", controller: testController),
        ),
      ),
    );
    // Verify the label text appears
    expect(find.text("Enter Name"), findsOneWidget);
    // Enter text into the field
    await tester.enterText(find.byType(TextField), "Mineth De Croos");
    await tester.pump();
    // Verify the controller holds the entered text
    expect(testController.text, "Mineth De Croos");
  });


}
