import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/home.dart';
import 'package:hillfair/screens/home_page.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/widgets/custom_route.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  File? _image; // To store the selected image file
  final ImagePicker _picker = ImagePicker();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with some default values, you can fetch actual data from backend
    setInitialValues(context);
  }
// edit profile 

  void setInitialValues(BuildContext context) async {
    String? fetchedMongoDbUserId = await firebaseId.getMongoDbUserId();
    String? fetchedEmail = await firebaseId.getEmail();
    String? fetchedUsername = await firebaseId.getUsername();

    firstNameController.text = fetchedUsername!;
    lastNameController.text = "";
    usernameController.text = fetchedEmail!;
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inriaSans(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.08),
        child: Column(
          children: [
            SizedBox(height: screenheight * 0.04),

            // Profile image with edit icon
            Stack(
              children: [
                CircleAvatar(
                  radius: screenwidth * 0.20,
                  backgroundImage: _image != null
                      ? FileImage(_image!) // If image is selected, show it
                      : AssetImage('assets/images/Android Large - 99 (5).png')
                          as ImageProvider, // Default placeholder
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      radius: screenwidth * 0.05,
                      child: Icon(
                        Icons.camera_enhance,
                        color: Colors.white,
                        size: screenwidth * 0.05,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenheight * 0.06),

            // First Name Field
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenheight * 0.04),

            // Last Name Field
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenheight * 0.04),

            // Username Field
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenheight * 0.04),

            // Save Button

            Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenheight * 0.02,
                  horizontal: screenwidth * 0.25,
                ),
                child: Container(
                    height: screenheight * 0.05,
                    width: screenwidth * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenwidth * 0.03),
                      color: Color(0xFF124A7D),
                    )))
          ],
        ),
      ),
    );
  }
}
