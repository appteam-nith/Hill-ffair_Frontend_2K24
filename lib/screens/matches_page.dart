import 'package:flutter/material.dart';
import 'package:hillfair/screens/quiz_page.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: screenwidth,
          child: Image.asset(
            'assets/images/Android Large - 99.jpg',
            width: screenwidth,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => QuizPage()));
                },
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 40,
                )))
      ]),
    );
  }
}
