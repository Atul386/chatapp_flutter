import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      // For hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // App bar
        appBar: AppBar(
          title: const Text('Profile Screen'),
          backgroundColor: const Color.fromRGBO(83, 89, 196, 1),
        ),

        // Floating button to log out
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
            onPressed: () async {
              // For showing progress dialog
              Dialogs.showProgressBar(context);

              await APIs.updateActiveStatus(false);

              // Sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  // For hiding progress dialog
                  Navigator.pop(context);

                  // For moving to home screen
                  Navigator.pop(context);

                  // Replacing home screen with login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                });
              });
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Logout'),
          ),
        ),

        // Body
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // For adding some space
                  SizedBox(height: screenSize.height * 0.03),

                  // User profile picture
                  Stack(
                    children: [
                      // Profile picture
                      _image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(screenSize.height * 0.1),
                        child: Image.file(
                          File(_image!),
                          width: screenSize.height * 0.2,
                          height: screenSize.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(screenSize.height * 0.1),
                        child: CachedNetworkImage(
                          width: screenSize.height * 0.2,
                          height: screenSize.height * 0.2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) => const CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),

                      // Edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: _showBottomSheet,
                          shape: const CircleBorder(),
                          color: const Color.fromRGBO(143, 148, 251, 1),
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  // For adding some space
                  SizedBox(height: screenSize.height * 0.03),

                  // User email label
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),

                  // For adding some space
                  SizedBox(height: screenSize.height * 0.05),

                  // Name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Color.fromRGBO(143, 148, 251, 1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'eg. Atul K',
                      hintStyle: TextStyle(color: Colors.grey[700]),
                      label: const Text(
                        'Name',
                        style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                      ),
                    ),
                    cursorColor: const Color.fromRGBO(143, 148, 251, 1),
                  ),

                  // For adding some space
                  SizedBox(height: screenSize.height * 0.02),

                  // About input field
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.info_outline, color: Color.fromRGBO(143, 148, 251, 1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'eg. Feeling Happy',
                      hintStyle: TextStyle(color: Colors.grey[700]),
                      label: const Text(
                        'About',
                        style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                      ),
                    ),
                    cursorColor: const Color.fromRGBO(143, 148, 251, 1),
                  ),

                  // For adding some space
                  SizedBox(height: screenSize.height * 0.05),

                  // Update profile button
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(83, 89, 200, 1),
                          Color.fromRGBO(143, 148, 251, .6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                  context, 'Profile Updated Successfully!');
                            });
                          }
                        },
                        child: const Text(
                          "UPDATE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    final Size screenSize = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: screenSize.height * 0.03,
            bottom: screenSize.height * 0.05,
          ),
          children: [
            // Pick profile picture label
            const Text(
              'Pick Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            // For adding some space
            SizedBox(height: screenSize.height * 0.02),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pick from gallery button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(screenSize.width * 0.3, screenSize.height * 0.15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      APIs.updateProfilePicture(File(_image!));

                      // For hiding bottom sheet
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: Image.asset('assets/images/add_image.png'),
                ),

                // Take picture from camera button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(screenSize.width * 0.3, screenSize.height * 0.15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      APIs.updateProfilePicture(File(_image!));

                      // For hiding bottom sheet
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: Image.asset('assets/images/camera.png'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
