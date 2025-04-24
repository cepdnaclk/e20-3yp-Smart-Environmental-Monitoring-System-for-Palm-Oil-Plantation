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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    customTextField(
                      "Name",
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      fillColor: Colors.white.withOpacity(0.2),
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    customTextField(
                      "Email",
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      fillColor: Colors.white.withOpacity(0.2),
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    customTextField(
                      "Password",
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      fillColor: Colors.white.withOpacity(0.2),
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Sign-Up Using",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        },
                        child: const Text(
                          "Already have an account? LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 130,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: SignUp logic here
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
