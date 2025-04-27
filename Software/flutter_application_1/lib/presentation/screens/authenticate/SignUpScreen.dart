 import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/services/AuthService.dart';
import '../../widgets/widgets.dart';
import '../../../core/routes.dart';


class SignUpScreen extends StatefulWidget {
  final VoidCallback toggle; // 🔥 Add this line to accept toggle function

  const SignUpScreen({Key? key, required this.toggle}) : super(key: key); // 🔥 Add toggle to constructor

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthServices _auth = AuthServices();

  String name = "";
  String email = "";
  String password = "";
  String error = "";

  String selectedRole = "Laborer"; // Default role

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
              customTextField(
                "Name", 
                controller: nameController,
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
              SizedBox(height: 10),

              Text("Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),

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

              customTextField(
                "Email", 
                controller: emailController,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),

              customTextField(
                "Password", 
                controller: passwordController,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  dynamic result = await _auth.registerWithEmailAndPassword(email, password);

                  if (result == null) {
                    setState(() {
                      error = "Please enter a valid email!";
                    });
                  } else {
                    // Navigate to home if successful
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
              ),

              SizedBox(height: 10),

              // 🔥 Add a TextButton for switching to Login
              Center(
                child: TextButton(
                  onPressed: widget.toggle, // Call the toggle function
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SignUpScreen extends StatefulWidget {

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthServices _auth = AuthServices();

//   // email password states
//   String name = "";
//   String email = "";
//   String password = "";
//   String error = "";

//   String selectedRole = "Laborer"; // Default selected role

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.85,
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             image: DecorationImage(
//               image: AssetImage("assets/images/background.jpeg"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start, // Align left
//             children: [
//               // ✅ Name Field
//               customTextField(
//                 "Name", 
//                 controller: nameController,
//                    onChanged: (val) {
//                           setState(() {
//                             name = val;
//                           });
//                         },
//                 ),

//               SizedBox(height: 10),

//               // ✅ Role Selection Label
//               Text("Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),

//               // ✅ Dropdown for Role Selection
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedRole,
//                       items: ["Laborer", "Manager"].map((String role) {
//                         return DropdownMenuItem(
//                           value: role,
//                           child: Text(role, style: TextStyle(fontSize: 16)),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedRole = newValue!;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),

//               // Email field
//               customTextField("Email", 
//                     controller: emailController,
//                        onChanged: (val) {
//                           setState(() {
//                             email = val;
//                           });
//                         },

//                     ),

//               // Password field
//               customTextField(
//                 "Password", 
//                 controller: passwordController, 
//                 obscureText: true,
//                 onChanged: (val) {
//                       setState(() {
//                         password = val;
//                       });
//                     },
                      
//                 ),

//               SizedBox(height: 20),

//               // customButton("Sign Up", () {
//               //   // Here you can handle the signup logic, including passing the selectedRole
//               //   Navigator.pushReplacementNamed(context, AppRoutes.login);
//               // }),


//               ElevatedButton(
//                   onPressed: () async {
//                     dynamic result = await _auth.registerWithEmailAndPassword(email, password);

//                     if (result == null) {
//                       setState(() {
//                         error = "Please enter a valid email!";
//                       });
//                     } else {
//                       // Navigate to home if successful
//                       Navigator.pushReplacementNamed(context, AppRoutes.home);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

