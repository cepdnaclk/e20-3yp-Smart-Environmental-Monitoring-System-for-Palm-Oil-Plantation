import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../widgets/widgets.dart';

class ResetPassword extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextField("New Password", controller: passwordController, obscureText: true),
              SizedBox(height: 10),
              customTextField("Confirm Password", controller: confirmPasswordController, obscureText: true),
              SizedBox(height: 20),
              customButton("Continue", () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
