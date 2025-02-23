import 'package:flutter/material.dart';
import '../widgets/widgets.dart'; // ✅ Ensure this is imported
import '../../core/routes.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customTextField("Name"),  // ✅ Now correctly recognized
              customTextField("Email"),
              customTextField("Password", obscureText: true),
              SizedBox(height: 20),
              customButton("Sign Up", () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
