import 'package:flutter/material.dart';

// Custom Button
Widget customButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: onPressed,
    child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}

// Social Media Login Button
Widget socialIcon(String iconPath) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 22,
      child: Image.asset(iconPath, width: 25),
    ),
  );
}

// ✅ Custom TextField Widget
Widget customTextField(String label, {bool obscureText = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

