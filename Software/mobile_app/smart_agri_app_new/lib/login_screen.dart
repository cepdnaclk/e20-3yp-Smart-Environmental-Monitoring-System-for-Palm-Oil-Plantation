import 'package:flutter/material.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpeg'), // Change to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay and Content
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hello",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 40),
                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: Text("Login"),
                ),
                SizedBox(height: 15),
                // Sign-up Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 75),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                  },
                  child: Text("Sign Up"),
                ),
                SizedBox(height: 40),
                Text(
                  "Sign Up Using",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
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

  // Social Icon Button
  Widget socialIcon(String iconPath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 22,
        child: Image.asset(iconPath, width: 25),
      ),
    );
  }
}
