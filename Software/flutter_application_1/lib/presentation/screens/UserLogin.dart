import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../widgets/widgets.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hello",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: customButton("Login", () {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    }),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: customButton("Sign Up", () {
                      Navigator.pushNamed(context, AppRoutes.signup);
                    }),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Sign Up Using",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 3, color: Colors.black)],
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      socialIcon("assets/icons/google.png"),
                      SizedBox(width: 12),
                      socialIcon("assets/icons/facebook.png"),
                      SizedBox(width: 12),
                      socialIcon("assets/icons/twitter.png"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
