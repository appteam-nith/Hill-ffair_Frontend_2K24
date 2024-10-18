import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image; // To store the selected image file
  final ImagePicker _picker = ImagePicker();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with some default values, you can fetch actual data from backend
    firstNameController.text = "Sabrina";
    lastNameController.text = "Aryan";
    usernameController.text = "@Sabrina";
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
      appBar: AppBar(
        title: Text('Edit Profile'),
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
                  radius: screenwidth * 0.15,
                  backgroundImage: _image != null
                      ? FileImage(_image!) // If image is selected, show it
                      : AssetImage('assets/image.png')
                          as ImageProvider, // Default placeholder
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: screenwidth * 0.05,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: screenwidth * 0.05,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenheight * 0.04),

            // First Name Field
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenheight * 0.02),

            // Last Name Field
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenheight * 0.02),

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
                ),
                child: Center(
                  child: Text(
                    'Save settings',
                    style: TextStyle(
                      fontSize: screenwidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
