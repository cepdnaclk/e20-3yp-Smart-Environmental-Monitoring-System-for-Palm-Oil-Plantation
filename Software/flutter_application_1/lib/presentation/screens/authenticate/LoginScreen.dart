import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/data/services/AuthService.dart';
import 'package:flutter_application_1/presentation/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  final Function toggle;
  const LoginScreen({Key? key, required this.toggle}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthServices _auth = AuthServices();

  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /*customTextField(
                      "Email",
                      controller: emailController,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    customTextField(
                      "Password",
                      controller: passwordController,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),*/
                    customInputField(
                      hintText: "Enter your email",
                      icon: Icons.email_outlined,
                      controller: emailController,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    customInputField(
                      hintText: "Enter your password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: passwordController,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.forgetPassword);
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Login with",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialIconNew('assets/icons/google.png', () async {
                          await _auth.signInWithGoogle();
                        }),
                        const SizedBox(width: 12),
                        const Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        /*const SizedBox(width: 10),
                        socialIconNew('assets/icons/facebook.png', () {}),
                        const SizedBox(width: 10),
                        socialIconNew('assets/icons/twitter.png', () {}),*/
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: const Text(
                              "SIGNUP",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        dynamic result = await _auth.signInUsingEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() {
                            error = "Could not sign in with those credentials";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Login", style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 10),
                    if (error.isNotEmpty)
                      Center(
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
























// // 

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/data/services/AuthService.dart';
// import '../../../core/routes.dart';
// import '../../widgets/widgets.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthServices _auth = AuthServices();

//   String email = "";
//   String password = "";
//   String error = "";
//   bool loading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/background.jpeg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Center(
//             child: SingleChildScrollView(
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     customTextField(
//                       "Email",
//                       controller: emailController,
//                       onChanged: (val) {
//                         setState(() {
//                           email = val;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 15),
//                     customTextField(
//                       "Password",
//                       controller: passwordController,
//                       obscureText: true,
//                       onChanged: (val) {
//                         setState(() {
//                           password = val;
//                         });
//                       },
//                     ),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, AppRoutes.forgetPassword);
//                         },
//                         child: const Text(
//                           "Forgot Password?",
//                           style: TextStyle(color: Colors.white, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Center(
//                       child: Text(
//                         "Login with",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // 👇 Google login button
//                         socialIconNew('assets/icons/google.png', () async {
//                           await _auth.signInWithGoogle();
//                           // if (result != null) {
//                           //   Navigator.pushNamed(context, '/home'); // 👈 Navigate to your home page after login
//                           // } else {
//                           //   ScaffoldMessenger.of(context).showSnackBar(
//                           //     const SnackBar(content: Text("Google Sign-In Failed")),
//                           //   );
//                           // }
//                         }),
//                         const SizedBox(width: 10),
//                         // 👇 Facebook (you can implement later)
//                         socialIconNew('assets/icons/facebook.png', () {}),
//                         const SizedBox(width: 10),
//                         // 👇 Twitter (you can implement later)
//                         socialIconNew('assets/icons/twitter.png', () {}),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, AppRoutes.signup);
//                         },
//                         child: const Text(
//                           "Do not have an account? SIGNUP",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),

//                     ElevatedButton(
//                       // onPressed: () async {
//                       //   if (email.isNotEmpty && password.isNotEmpty) {
//                       //     setState(() {
//                       //       loading = true;
//                       //     });

//                       //     dynamic result = await _auth.signInUsingEmailAndPassword(email, password);
                          
//                       //     setState(() {
//                       //       loading = false;
//                       //     });

//                       //     if (result != null) {
//                       //       Navigator.pushReplacementNamed(context, AppRoutes.home);
//                       //     } else {
//                       //       setState(() {
//                       //         error = "Invalid email or password!";
//                       //       });
//                       //     }
//                       //   } else {
//                       //     setState(() {
//                       //       error = "Please enter email and password!";
//                       //     });
//                       //   }
//                       // },
//                       onPressed: () async {
//                         dynamic result = await _auth.signInUsingEmailAndPassword(email, password);
//                         if (result == null) {
//                           setState(() {
//                             error = "Could not sign in with those credentials";
//                           });
//                         } 
//                         // 🚀 No need Navigator.pushReplacementNamed(context, AppRoutes.home);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.black,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text("Login", style: TextStyle(fontSize: 16)),
//                     ),
//                     const SizedBox(height: 10),
//                     if (error.isNotEmpty)
//                       Center(
//                         child: Text(
//                           error,
//                           style: TextStyle(color: Colors.red, fontSize: 14),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (loading)
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }
Widget customInputField({
  required String hintText,
  required IconData icon,
  bool isPassword = false,
  required TextEditingController controller,
  void Function(String)? onChanged,
}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    style: const TextStyle(color: Colors.white),
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white10,
      prefixIcon: Icon(icon, color: Colors.white70),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
