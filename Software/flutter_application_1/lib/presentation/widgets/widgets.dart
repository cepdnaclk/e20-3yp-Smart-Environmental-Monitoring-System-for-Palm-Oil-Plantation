import 'package:flutter/material.dart';

// ✅ Custom Button with Optional Icon & Loading State
Widget customButton(String text, VoidCallback onPressed, {IconData? icon, bool isLoading = false}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: isLoading ? null : onPressed, // ✅ Disable if loading
    child: isLoading
        ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, color: Colors.white),
        if (icon != null) SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

// ✅ Social Media Login Button (with Custom Size)
Widget socialIcon(String iconPath, {double size = 25, double padding = 10}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: size,
      child: Image.asset(iconPath, width: size),
    ),
  );
}

// ✅ Custom TextField with Icon, Hint, and Validation
Widget customTextField(
    String label, {
      bool obscureText = false,
      TextEditingController? controller,
      IconData? icon,
      String? hintText,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator, // ✅ Added validation support
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator, // ✅ Validate Input
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    ),
  );
}
