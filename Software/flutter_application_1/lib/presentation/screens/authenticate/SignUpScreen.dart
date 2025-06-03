import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/services/AuthService.dart';
import 'package:flutter_application_1/presentation/screens/authenticate/LoginScreen.dart';
import '../../widgets/widgets.dart';
import '../../../core/routes.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggle;

  const SignUpScreen({Key? key, required this.toggle}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthServices _auth = AuthServices();

  String name = "";
  String email = "";
  String password = "";
  String error = "";
  String selectedRole = "Laborer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background.jpeg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*customInputField(
                      hintText: "Enter your name",
                      icon: Icons.person_outline,
                      controller: nameController,
                      onChanged: (val) => setState(() => name = val),
                    ),*/

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Text(
                              "Role:",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.grey[900],
                                  iconEnabledColor: Colors.white70,
                                  isExpanded: true,
                                  value: selectedRole,
                                  items: ["Laborer", "Manager"].map((String role) {
                                    return DropdownMenuItem(
                                      value: role,
                                      child: Text(
                                        role,
                                        style: const TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedRole = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),*/
                      const SizedBox(height: 10),
                    ],
                  ),

                    customInputField(
                      hintText: "Enter your email",
                      icon: Icons.email_outlined,
                      controller: emailController,
                      onChanged: (val) => setState(() => email = val),
                    ),
                    const SizedBox(height: 10),
                    customInputField(
                      hintText: "Enter your password",
                      icon: Icons.lock_outline,
                      controller: passwordController,
                      isPassword: true,
                      onChanged: (val) => setState(() => password = val),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity, // Match field width if inside a fixed-width container
                        child: ElevatedButton(
                          onPressed: () async {
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = "Please enter a valid email!";
                              });
                            } else {
                              Navigator.pushReplacementNamed(context, AppRoutes.home);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            shadowColor: Colors.greenAccent,
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),


                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: widget.toggle,
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
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