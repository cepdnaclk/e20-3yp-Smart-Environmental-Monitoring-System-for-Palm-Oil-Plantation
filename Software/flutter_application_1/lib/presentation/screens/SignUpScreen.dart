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

  String selectedRole = "Laborer"; // Default selected role

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
            crossAxisAlignment: CrossAxisAlignment.start, // Align left
            children: [
              // ✅ Name Field
              customTextField("Name", controller: nameController),

              SizedBox(height: 10),

              // ✅ Role Selection Label
              Text("Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),

              // ✅ Dropdown for Role Selection
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

              customTextField("Email", controller: emailController),
              customTextField("Password", controller: passwordController, obscureText: true),

              SizedBox(height: 20),

              customButton("Sign Up", () {
                // Here you can handle the signup logic, including passing the selectedRole
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
