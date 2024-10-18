import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/global_variables.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/verify_email_screen.dart';
import 'package:hillfair/widgets/snack_bar.dart';
import 'package:hillfair/widgets/widgets.dart';
import 'package:hillfair/widgets/main_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool isLoading = false;
  bool isChecked = false;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void signupUser() async {
    String res = await signupUserByEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);
    if (res == "success") {
      setState(() {
        isLoading = true;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => MainPage()));
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "User Already Exists...");
    }
  }

  Future<void> reloadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    String res = "an error occured";
    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user!.emailVerified) {
        res = "Email Verification Successful";
      } else {
        res = "Email is not verified";
      }
      showSnackBar(context, "Email Not Verified");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(fit: StackFit.expand, children: [
        Opacity(
          opacity: 1,
          child: Image.asset(
            'assets/images/bg_image_1.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customText("Sign Up"),
            SizedBox(
              height: 50,
            ),
            Form(
              key: formKey2,
              child: Column(children: [
                buildTextField(
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
                buildTextField(
                  label: 'Confirm Password',
                  controller: confirmpasswordController,
                  icon: Icons.key_off_outlined,
                  isPassword: true,
                  validator: (confirmpassword) {
                    if (confirmpassword == null || confirmpassword.isEmpty) {
                      return 'Please confirm your password';
                    } else if (confirmpassword != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ]),
            ),
            SizedBox(height: 50),
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
                    }),
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
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            customButton("Sign Up", () {
              if (formKey2.currentState!.validate()) {
                if (isChecked) {
                  signupUser();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please Agree to Privacy Policy......')),
                  );
                }
              }
            }),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already hava an account?",
                    style: GoogleFonts.inriaSans(
                      color: const Color(0xff543310),
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => LoginScreen()));
                    },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.inriaSans(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        )
      ]),
    );
  }
}
