import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/services/AuthService.dart';
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
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextField(
                      "Name",
                      controller: nameController,
                      onChanged: (val) => setState(() => name = val),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Role",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedRole,
                            items: ["Laborer", "Manager"].map((String role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(role, style: TextStyle(fontSize: 16)),
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
                    customTextField(
                      "Email",
                      controller: emailController,
                      onChanged: (val) => setState(() => email = val),
                    ),
                    customTextField(
                      "Password",
                      controller: passwordController,
                      obscureText: true,
                      onChanged: (val) => setState(() => password = val),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
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
                      ),
                      child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: widget.toggle,
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
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