import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../../core/routes.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // DARK overlay for clarity
          Container(
            color: Colors.black.withOpacity(0.75),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05), // faint card, but strong overlay
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInput("Name", nameController),
                    const SizedBox(height: 12),
                    _buildInput("Email", emailController),
                    const SizedBox(height: 12),
                    _buildInput("Password", passwordController, obscure: true),
                    const SizedBox(height: 24),
                    Text(
                      "Sign-Up Using",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialIcon('assets/icons/google.png'),
                        const SizedBox(width: 10),
                        socialIcon('assets/icons/facebook.png'),
                        const SizedBox(width: 10),
                        socialIcon('assets/icons/twitter.png'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      },
                      child: const Text(
                        "Already have an account? LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 150,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.home);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
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

  Widget _buildInput(String label, TextEditingController controller, {bool obscure = false}) {
    return customTextField(
      label,
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      labelStyle: const TextStyle(color: Colors.white),
      fillColor: Colors.white.withOpacity(0.15),
      hintStyle: const TextStyle(color: Colors.white70),
    );
  }
}
