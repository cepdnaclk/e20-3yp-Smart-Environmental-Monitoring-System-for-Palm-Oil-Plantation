import 'package:flutter/material.dart';

// ✅ Custom Button
Widget customButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: onPressed,
    child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}

// ✅ Social Media Login Button
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

// ✅ Custom TextField Widget (Fixed)
Widget customTextField(
    String label, {
      bool obscureText = false,
      TextEditingController? controller,
      TextStyle? style,
      Color? fillColor,
      TextStyle? hintStyle,
      required TextStyle labelStyle,
    }) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    style: style,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: labelStyle,
      filled: true,
      fillColor: fillColor ?? Colors.white,
      hintStyle: hintStyle,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
