import 'dart:async'; // For the Timer
import 'package:flutter/material.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/quiz_page.dart'; // Ensure you import your firebaseId class

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  void initState() {
    super.initState();

    // Use Timer to navigate to QuizPage after 3 seconds
    Timer(const Duration(seconds: 3), () {
      navigateToQuizPage(context); // Pass the current context
    });
  }

  // Navigate to QuizPage after retrieving the MongoDB user ID
  void navigateToQuizPage(BuildContext context) async {
    String? mongoDbUserId = await firebaseId.getMongoDbUserId();

    if (mongoDbUserId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizPage(userId: mongoDbUserId)

            // Pass the user ID here
            ),
      );
      print('$mongoDbUserId');
    } else {
      // Handle the case where the user ID is null (e.g., show an error)
      print('MongoDB User ID is not available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: screenWidth,
          child: Image.asset(
            'assets/images/Android Large - 99.jpg',
            width: screenWidth,
            fit: BoxFit.fitWidth,
          ),
        ),
      ]),
    );
  }
}
