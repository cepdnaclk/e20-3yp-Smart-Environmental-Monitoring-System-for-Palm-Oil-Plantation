import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import '../widgets/widgets.dart';
import 'package:flutter_application_1/presentation/screens/ChangePasswordScreen.dart';
import 'package:flutter_application_1/presentation/screens/EditProfileScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 1;
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkAdminViaClaims();
  }

  // Future<void> checkAdmin() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  //     if (doc.exists && doc['role'] == 'admin') {
  //       setState(() {
  //         _isAdmin = true;
  //       });
  //     }
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }


  Future<void> checkAdminViaClaims() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final idTokenResult = await user.getIdTokenResult();
    final claims = idTokenResult.claims;

    if (claims != null && claims['admin'] == true) {
      setState(() {
        _isAdmin = true;
      });
    }
  }

  setState(() {
    _isLoading = false;
  });
}


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              children: [
                const Text("Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SwitchListTile(
                  title: const Text("Receive alerts"),
                  value: true,
                  onChanged: (bool value) {
                    // Toggle notification logic
                  },
                ),
                SwitchListTile(
                  title: const Text("Vibrate on alert"),
                  value: false,
                  onChanged: (bool value) {
                    // Toggle vibration logic
                  },
                ),
                const SizedBox(height: 24),

                // 👇 Admin-only button inserted here
                if (_isAdmin)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text("Set Notification Thresholds"),
                    onPressed: () {
                     Navigator.pushNamed(
                            context,
                            AppRoutes.thresholdSetting);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),

                const SizedBox(height: 24),
                const Text("Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Edit Profile"),
                  onTap: () {
                    Navigator.pushNamed(context, '/editProfile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text("Change Password"),
                  onTap: () {
                    Navigator.pushNamed(context, '/changePassword');
                  },
                ),

                const SizedBox(height: 24),

                const Text("App Info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("About"),
                  subtitle: const Text("Version 1.0.0"),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Log Out"),
                  onTap: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Logout"),
                        content:
                            const Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text("Log Out")),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      // Replace with your actual sign out logic
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (_) => false);
                    }
                  },
                ),
              ],
            ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: _selectedIndex),
    );
  }
}





Future<bool> isAdmin() async {
  final user = FirebaseAuth.instance.currentUser;
  final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  return doc.exists && doc['role'] == 'admin';
}
