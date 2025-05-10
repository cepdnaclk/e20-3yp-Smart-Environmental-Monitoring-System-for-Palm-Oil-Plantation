import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../widgets/widgets.dart';

class ResetPassword extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextField(
                      "New Password",
                      controller: passwordController,
                      obscureText: true,
                      // style: const TextStyle(color: Colors.white),
                      // fillColor: Colors.white.withOpacity(0.2),
                      // hintStyle: const TextStyle(color: Colors.white70),
                      // labelStyle: const TextStyle(color: Colors.white), // ✅ Required
                    ),
                    const SizedBox(height: 12),
                    customTextField(
                      "Confirm Password",
                      controller: confirmPasswordController,
                      obscureText: true,
                      // style: const TextStyle(color: Colors.white),
                      // fillColor: Colors.white.withOpacity(0.2),
                      // hintStyle: const TextStyle(color: Colors.white70),
                      // labelStyle: const TextStyle(color: Colors.white), // ✅ Required
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: 190,
                        height: 60,
                        child: customButton("Continue", () {
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
