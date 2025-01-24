import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/mesage_page_list.dart';
import 'package:hillfair/screens/quiz_page.dart';
import 'package:hillfair/widgets/custom_route.dart';


// matchespage
class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  String? QuizStatus;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await checkQuizStatus(); // Ensure quiz status is checked before navigation
    String? fetchedMongoDbId = await firebaseId.getMongoDbUserId();

    // Store the Timer instance so it can be cancelled in dispose
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Ensure the widget is still in the widget tree
        if (QuizStatus == 'submitted') {
          Navigator.push(
            context,
            createFadeRoute(MessageListPage()),
          );
        } else {
          Navigator.push(
            context,
            createFadeRoute(QuizPage(
              userId: fetchedMongoDbId!,
            )),
          );
        }
      }
    });
  }

  Future<void> checkQuizStatus() async {
    String? status =
        await getQuizStatus(); // Assuming this fetches from Firestore
    if (mounted) {
      // Check if the widget is still in the widget tree
      setState(() {
        QuizStatus = status;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer?.cancel();
    super.dispose();
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
