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

// ✅ Social Media Icon (Static)
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

// ✅ Social Media Icon with Tap
Widget socialIconNew(String iconPath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 22,
      child: Image.asset(iconPath, width: 25),
    ),
  );
}

// ✅ Custom TextField Widget with onChanged and labelStyle support
Widget customTextField(
    String label, {
      bool obscureText = false,
      TextEditingController? controller,
      TextStyle? style,
      Color? fillColor,
      TextStyle? hintStyle,
      TextStyle? labelStyle, // 👈 make optional
      ValueChanged<String>? onChanged,
    }) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    style: style,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: labelStyle ?? TextStyle(color: Colors.black), // 👈 default
      filled: true,
      fillColor: fillColor ?? Colors.white,
      hintStyle: hintStyle,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
