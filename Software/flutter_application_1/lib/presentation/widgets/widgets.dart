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

// Social Media Login Button
Widget socialIconNew(String iconPath, VoidCallback onPressed) {
  return IconButton(
    icon: Image.asset(
      iconPath,
      width: 50,
      height: 50,
    ),
    onPressed: onPressed,
  );
}

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

// // ✅ Custom TextField Widget (with controller support)
// Widget customTextField(String label, {bool obscureText = false, TextEditingController? controller, required Null Function(dynamic val) onChanged}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: TextField(
//       controller: controller, // ✅ Now supports input controllers
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     ),
//   );
// }

Widget customTextField(
    String label, {
      bool obscureText = false,
      TextEditingController? controller,
      Function(dynamic val)? onChanged, // ✅ made optional
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged, // this works fine even if it's null
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}



