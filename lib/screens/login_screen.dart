// import 'dart:developer';
// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// import '../helper/dialogs.dart';
// import 'home_screen.dart';
// import '../api/apis.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isAnimate = false;
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // For auto triggering animation
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() => _isAnimate = true);
//     });
//   }
//
//   // Handles Google login button click
//   _handleGoogleBtnClick() {
//     // For showing progress bar
//     Dialogs.showProgressBar(context);
//
//     _signInWithGoogle().then((user) async {
//       // For hiding progress bar
//       Navigator.pop(context);
//
//       if (user != null) {
//         log('\nUser: ${user.user}');
//         log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
//
//         if (await APIs.userExists() && mounted) {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => HomeScreen()));
//         } else {
//           await APIs.createUser().then((value) {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (_) => HomeScreen()));
//           });
//         }
//       }
//     });
//   }
//
//   Future<UserCredential?> _signInWithGoogle() async {
//     try {
//       await InternetAddress.lookup('google.com');
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication? googleAuth =
//       await googleUser?.authentication;
//
//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//
//       // Once signed in, return the UserCredential
//       return await APIs.auth.signInWithCredential(credential);
//     } catch (e) {
//       log('\n_signInWithGoogle: $e');
//
//       if (mounted) {
//         Dialogs.showSnackbar(
//             context, 'Something Went Wrong (Check Internet!)');
//       }
//
//       return null;
//     }
//   }
//
//   // Handles email and password login
//   _handleEmailPasswordLogin() async {
//     try {
//       Dialogs.showProgressBar(context);
//
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim());
//
//       Navigator.pop(context);
//
//       if (userCredential.user != null) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (_) => HomeScreen()));
//       }
//     } on FirebaseAuthException catch (e) {
//       Navigator.pop(context);
//       String message = 'An error occurred, please try again';
//       if (e.code == 'user-not-found') {
//         message = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Wrong password provided.';
//       }
//       Dialogs.showSnackbar(context, message);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Initializing media query (for getting device screen size)
//     final mq = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Stack(children: [
//         // App logo
//         Positioned(
//           top: mq.height * .15,
//           right: mq.width * .25,
//           width: mq.width * .6,
//           height: mq.width * .6,
//           child: Image.asset('assets/images/app logonew.png'),
//         ),
//
//         // Google login button
//         Positioned(
//           bottom: mq.height * .15,
//           left: mq.width * .05,
//           width: mq.width * .9,
//           height: mq.height * .06,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple[100],
//               shape: const StadiumBorder(),
//               elevation: 1,
//             ),
//
//             // On tap
//             onPressed: _handleGoogleBtnClick,
//
//             // Google icon
//             icon: Image.asset('assets/images/google.png', height: mq.height * .03),
//
//             // Login with Google label
//             label: RichText(
//               text: const TextSpan(
//                 style: TextStyle(color: Colors.black, fontSize: 16),
//                 children: [
//                   TextSpan(text: 'Login with '),
//                   TextSpan(
//                     text: 'Google',
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         // Email and password login form
//         Positioned(
//           bottom: mq.height * .25,
//           left: mq.width * .05,
//           width: mq.width * .9,
//           child: Column(
//             children: [
//               TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   labelStyle: TextStyle(color: Colors.deepPurpleAccent), // Change label (hint) color
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.deepPurpleAccent), // Change border color
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.deepPurple), // Change focused border color
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.deepPurpleAccent), // Change enabled border color
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   labelStyle: TextStyle(color: Colors.deepPurpleAccent),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.deepPurpleAccent),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.deepPurple),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.deepPurpleAccent),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: _handleEmailPasswordLogin,
//                 child: const Text('Login with Email'),
//               ),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';
import 'dart:io';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/applogo.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(143, 148, 251, 1),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: _handleEmailPasswordLogin,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: _handleGoogleBtnClick,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/google.png', height: 24),
                                SizedBox(width: 10),
                                Text(
                                  "Login with Google",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleEmailPasswordLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      log("Login failed: $e");
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  _handleGoogleBtnClick() {
    _signInWithGoogle().then((user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log("Google sign-in failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: $e")),
      );
      return null;
    }
  }
}


