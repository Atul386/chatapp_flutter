import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../helper/dialogs.dart';
import 'home_screen.dart';


import '../api/apis.dart';

//login screen -- implements google sign in or sign up feature for app
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  // Handles Google login button click
  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if (await APIs.userExists() && mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) =>  HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) =>  HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');

      if (mounted) {
        Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)');
      }

      return null;
    }
  }

  // Handles email and password login
  _handleEmailPasswordLogin() async {
    try {
      Dialogs.showProgressBar(context);

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      Navigator.pop(context);

      if (userCredential.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) =>  HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String message = 'An error occurred, please try again';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      Dialogs.showSnackbar(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        //app logo
        Positioned(
          top: mq.height * .15,
          right: mq.width * .25,
          width: mq.width * .6,
          height: mq.width * .6,
          child: Image.asset('assets/images/applogo.png'),
        ),

        // Google login button
        Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.deepPurple[100],
                    shape: const StadiumBorder(),
                    elevation: 1),

                // on tap
                onPressed: _handleGoogleBtnClick,

                //google icon
                icon: Image.asset('assets/images/google.png', height: mq.height * .03),

                //login with google label
                label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ]),
                ))),

        // Email and password login form
        Positioned(
          bottom: mq.height * .25,
          left: mq.width * .05,
          width: mq.width * .9,
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _handleEmailPasswordLogin,
                child: Text('Login with Email'),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
