import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/global_variables.dart';
import 'package:hillfair/home.dart';
import 'package:hillfair/screens/signup_screen.dart';
import 'package:hillfair/widgets/custom_route.dart';
import 'package:hillfair/widgets/main_page.dart';
import 'package:hillfair/widgets/widgets.dart';
import 'package:hillfair/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// FirebaseId class to handle UID and API request




class firebaseId {
  String? firebaseUID;

  firebaseId({this.firebaseUID});

  // Converts a firebaseId instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'firebaseUID': firebaseUID,
    };
  }

  String toJson() => json.encode(toMap());

  // Method to send data and retrieve response
  Future<void> fetchData() async {
    Dio dio = Dio();
    String url = 'https://hillffair-backend-2k24.onrender.com/user/login';

    try {
      // Make a POST request with firebaseUID in the request body
      Response response = await dio.post(
        url,
        data: toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract the response data
        final responseData = response.data;

        // Extracting individual fields from the response
        final String mongoDbUserId = responseData['mongoDbUserId'];
        final String username = responseData['username'];
        final String email = responseData['email'];
        final String dob = responseData['dob'];
        final String gender = responseData['gender'];

        print("Data retrieved successfully");
        print('MongoDB User ID: $mongoDbUserId');
        print('Username: $username');
        print('Email: $email');
        print('DOB: $dob');
        print('Gender: $gender');

        // Store MongoDB User ID locally using SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mongoDbUserId', mongoDbUserId);
        await prefs.setString('username', username);
        await prefs.setString('email', email);
        await prefs.setString('dob', dob);
        await prefs.setString('gender', gender);

        print('MongoDB User ID saved locally.');
      } else {
        // If response status code is not 200 or 201, print an error
        print(
            'Failed to retrieve data: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print("An error occurred: $e");
    }
  }

  // Method to retrieve MongoDB User ID from SharedPreferences
  static Future<String?> getMongoDbUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mongoDbUserId');
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gender');
  }
}

// LoginScreen StatefulWidget to handle the UI and logic
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  bool isLoading = false;
  String? uid;

  @override
  void dispose() {
    passwordLoginController.dispose();
    emailLoginController.dispose();
    super.dispose();
  }

  // Login method
  void login() async {
    setState(() {
      isLoading = true;
    });

    // Login user using email and password
    String res = await loginUserByEmailAndPassword(
      email: emailLoginController.text,
      password: passwordLoginController.text,
    );

    if (res == "success") {
      // Get Firebase UID
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        // Create a firebaseId instance with the Firebase UID
        firebaseId newUser = firebaseId(firebaseUID: uid);

        // Fetch user data from your API
        await newUser.fetchData();

        // Navigate to MainPage on success
        Navigator.pushReplacement(context, createFadeRoute(MainPage()));
      } else {
        // Handle the error if the UID is null
        showSnackBar(context, "Failed to retrieve Firebase UID.");
      }
    } else {
      // Show error if login fails
      showSnackBar(context, "Invalid Email and Password Combination...");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 1,
            child: Image.asset(
              'assets/images/Untitled (1).png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customText("Sign In"),
              SizedBox(height: 50),
              Form(
                key: formKey1,
                child: Column(
                  children: [
                    buildTextField(
                      width: screenSize.width * 0.90,
                      label: 'Email',
                      icon: Icons.email,
                      controller: emailLoginController,
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(email)) {
                          return 'Please enter a valid email address';
                        } else if (!email.endsWith('@nith.ac.in')) {
                          return "Please enter a valid NITH email address";
                        }
                        return null;
                      },
                    ),
                    buildTextField(
                      width: screenSize.width * 0.90,
                      label: 'Password',
                      icon: Icons.key_outlined,
                      controller: passwordLoginController,
                      isPassword: true,
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your password';
                        } else if (password.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: TextButton(
                      onPressed: () {
                        dialogBox(context);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.inriaSans(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              customButton(
                MediaQuery.of(context).size.width * 0.9,
                "Sign In",
                () {
                  if (formKey1.currentState!.validate()) {
                    login(); // Call the login method here
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid Credentials....')),
                    );
                  }
                },
              ),
              if (isLoading)
                CircularProgressIndicator(), // Loading indicator when the API is being called
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.inriaSans(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(createFadeRoute(SignupScreen()));
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.inriaSans(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
