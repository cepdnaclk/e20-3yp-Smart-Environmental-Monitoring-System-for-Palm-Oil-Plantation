import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        children: [
          const Text("Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text("Receive alerts"),
            value: true,
            onChanged: (bool value) {
              // Add logic to toggle notification settings
            },
          ),
          SwitchListTile(
            title: const Text("Vibrate on alert"),
            value: false,
            onChanged: (bool value) {
              // Add logic to toggle vibration
            },
          ),
          const SizedBox(height: 24),

          const Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Edit Profile"),
            onTap: () {
              // Navigate to profile editing screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {
              // Handle change password logic
            },
          ),
          const SizedBox(height: 24),

          const Text("App Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            subtitle: const Text("Version 1.0.0"),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: () async {
              // Optional: confirm logout
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Log Out")),
                  ],
                ),
              );

              if (confirm == true) {
                // Replace with your AuthService().signOut() or similar
                Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: _selectedIndex),
    );
  }
}
