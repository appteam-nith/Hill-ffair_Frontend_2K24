// ignore_for_file: file_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/widgets/snack_bar.dart';
import 'package:hillfair/widgets/widgets.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool emailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!emailVerified) {
      sendVerificationEmail();

      timer =
          Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerification());
    }
  }

  Future sendVerificationEmail() async {
    String res = "Some error Occurred";
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (emailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => emailVerified
      ? LoginScreen()
      : Scaffold(
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
              Icon(
                Icons.email_rounded,
                color: const Color.fromARGB(255, 56, 26, 14),
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A Verification Email Has been Sent to Your Email...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inriaSans(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              customButton3(
                  "Resend Email",
                  canResendEmail
                      ? sendVerificationEmail
                      : () {
                          return null;
                        }),
              SizedBox(
                height: 15,
              ),
              customButton2("cancel", logoutUser),
            ],
          )
        ]));
}
