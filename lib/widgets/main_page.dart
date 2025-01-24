import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hillfair/home.dart';
import 'package:hillfair/screens/home_page.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/verify_email_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
// main page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data;

            if (user != null && user.emailVerified) {
              return Home();
            } else {
              return VerifyEmailScreen();
            }
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
