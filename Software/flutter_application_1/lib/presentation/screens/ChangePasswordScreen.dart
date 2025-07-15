import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final email = user.email!;

      // Step 1: Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: email,
        password: _currentPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      // Step 2: Update password
      await user.updatePassword(_newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password updated successfully'),
        backgroundColor: Colors.green,
      ));

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String error = e.message ?? 'Something went wrong';
      if (e.code == 'wrong-password') {
        error = 'The current password is incorrect.';
      } else if (e.code == 'requires-recent-login') {
        error = 'You need to log in again before changing the password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Enter your current and new password to change it securely."),
              const SizedBox(height: 20),
              TextFormField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(labelText: "Current Password"),
                obscureText: true,
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter current password' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
                validator: (value) => value != null && value.length >= 6
                    ? null
                    : 'Password must be at least 6 characters',
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Update Password"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
