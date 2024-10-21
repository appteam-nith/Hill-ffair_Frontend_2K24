import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/global_variables.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/verify_email_screen.dart';
import 'package:hillfair/widgets/custom_route.dart';
import 'package:hillfair/widgets/snack_bar.dart';
import 'package:hillfair/widgets/widgets.dart';
import 'package:hillfair/widgets/main_page.dart';
import 'package:intl/intl.dart';

// User Model
class User {
  String? firebaseUID;
  String username;
  String email;
  String password; // Include password here if necessary for sign-up
  String dob;
  String gender;

  User({
    this.firebaseUID,
    required this.username,
    required this.email,
    required this.password, // Required for sign-up
    required this.dob,
    required this.gender,
  });

  // Converts a User instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'firebaseUID': firebaseUID,
      'username': username,
      'email': email,
      'password': password, // Include password in the request
      'dob': dob,
      'gender': gender,
    };
  }

  // Converts a User instance to JSON
  String toJson() => json.encode(toMap());

  // Method to send data to the backend
  Future<void> sendData() async {
    Dio dio = Dio();
    String url = 'https://hillffair-backend-2k24.onrender.com/user/register';

    try {
      Response response = await dio.post(
        url,
        data: toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Data sent successfully.");
      } else {
        print("Failed to send data: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = true;
  bool isChecked = false;
  final List<String> genders = ["Male", "Female"];
  String? selectedGender;
  DateTime? selectedDate;
  String? uid;

  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>(); // Add form key

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // void getCurrentUserUid(){
  //   String? currentUserId =  FirebaseAuth.instance.currentUser!.uid ;
  //   if( currentUserId != null){
  //           setState(() {

  //   });
  //   }

  // if (currentUser != null) {
  //   setState(() {
  //     uid = currentUser.uid; // Set the class-level uid variable
  //   });
  // } else {
  //   print("No user is currently signed in.");
  // }
  // }

  void signupUser() async {
    String res = await signupUserByEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      gender: selectedGender,
      DOB: selectedDate,
    );

    if (res == "success") {
      // getCurrentUserUid(); // Get the UID from Firebase
      setState(() {
        uid = FirebaseAuth.instance.currentUser!.uid;
      });

      // Create User object
      User newUser = User(
        firebaseUID: uid,
        username: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        dob: DateFormat('yyyy-MM-dd').format(selectedDate!),
        gender: selectedGender!.toLowerCase(),
      );

      await newUser.sendData(); // Send data after Firebase sign-up
      Navigator.pushReplacement(context, createFadeRoute(MainPage()));
      print(res);
    } else {
      showSnackBar(context, "User Already Exists...");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(fit: StackFit.expand, children: [
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
            customText("Sign Up"),
            SizedBox(height: 50),
            Form(
              key: formKey2,
              child: Column(children: [
                buildTextField(
                  width: screenSize.width * 0.90,
                  label: 'Enter Your Name',
                  icon: Icons.account_circle,
                  controller: nameController,
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'Please enter your name';
                    } else if (name.length <= 3) {
                      return "Your Name must have at least 3 characters";
                    }
                    return null;
                  },
                ),
                buildTextField(
                  width: screenSize.width * 0.90,
                  label: 'Enter Your Email',
                  icon: Icons.mail,
                  controller: emailController,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(email)) {
                      return 'Please enter a valid email address';
                    } else if (!email.endsWith('nith.ac.in')) {
                      return "Please enter a valid NITH email address";
                    } else if (!email.startsWith('2')) {
                      return "Sorry You cannot access this application";
                    }
                    return null;
                  },
                ),
                buildTextField(
                  width: screenSize.width * 0.90,
                  label: 'Enter Password',
                  icon: Icons.key_outlined,
                  controller: passwordController,
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
              ]),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: screenSize.width * 0.95,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.42,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xff000000).withOpacity(0.2),
                            border: Border.all(width: 2, color: Colors.black),
                          ),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                selectedGender ?? 'Gender',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Spacer(),
                            DropdownButton<String>(
                              hint: Text(""),
                              value: selectedGender,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 30,
                                color: Colors.black,
                              ),
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 10, 10, 10)),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                              items: genders.map((String gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                            )
                          ]),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 60,
                          width: screenSize.width * 0.42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xff000000).withOpacity(0.2),
                            border: Border.all(width: 2, color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              selectedDate != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(selectedDate!)
                                  : "DD/MM/YYYY",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  activeColor: Color.fromARGB(255, 255, 255, 255),
                  checkColor: const Color.fromARGB(255, 111, 12, 12),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text(
                  'I agree to the ',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    ' Terms and Privacy Policy',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 39, 16, 28),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            customButton("Sign Up", () {
              if (formKey2.currentState!.validate()) {
                if (selectedDate != null && selectedGender != null) {
                  if (isChecked) {
                    signupUser(); // Triggers Firebase registration
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please Agree to Privacy Policy...')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please fill your Gender and DOB...')),
                  );
                }
              }
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context, createFadeRoute(LoginScreen()));
                  },
                  child: Text(
                    " Login",
                    style: TextStyle(
                      color: Color.fromARGB(255, 9, 14, 157),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ]),
    );
  }
}
