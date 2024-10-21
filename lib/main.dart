import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hillfair/home.dart';
import 'package:hillfair/screens/edit_profile.dart';
import 'package:hillfair/screens/models.dart';
import 'package:hillfair/screens/quiz_page.dart';

import 'package:hillfair/widgets/events.dart';
import 'package:hillfair/screens/home_page.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/signup_screen.dart';
import 'package:hillfair/screens/verify_email_screen.dart';

import 'package:hillfair/widgets/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.brown),
        home: MainPage());
  }
}
