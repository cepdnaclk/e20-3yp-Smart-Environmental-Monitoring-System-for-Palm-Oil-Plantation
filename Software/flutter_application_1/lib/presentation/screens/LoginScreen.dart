import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hello", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 40),

                customButton("Login", () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                }),
                SizedBox(height: 15),

                customButton("Sign Up", () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                }),

                SizedBox(height: 40),

                Text("Sign Up Using", style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialIcon("assets/icons/google.png"),
                    socialIcon("assets/icons/facebook.png"),
                    socialIcon("assets/icons/twitter.png"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
