import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/global_variables.dart';
import 'package:hillfair/screens/signup_screen.dart';
import 'package:hillfair/widgets/main_page.dart';
import 'package:hillfair/widgets/widgets.dart';
import '../widgets/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    passwordLoginController.dispose();
    emailLoginController.dispose();
    super.dispose();
  }

  void login() async {
    String res = await loginUserByEmailAndPassword(
      email: emailLoginController.text,
      password: passwordLoginController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const MainPage()));
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Invalid Email and Password Combination...");
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
            customText("Sign In"),
            SizedBox(
              height: 50,
            ),
            Form(
              key: formKey1,
              child: Column(children: [
                buildTextField(
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
                    }),
              ]),
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
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            customButton(
              "Sign In",
              () {
                if (formKey1.currentState!.validate()) {
                  login();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid Credentials....')),
                  );
                }
                
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",
                    style: GoogleFonts.inriaSans(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => SignupScreen()));
                    },
                    child: Text(
                      "Sign Up",
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
