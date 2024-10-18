import 'package:flutter/material.dart';
import 'package:hillfair/screens/mesage_page_list.dart';
import 'package:hillfair/screens/time_screen.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int questionIndex = 0;

  final List<Map<String, Object>> questions = [
    {
      'questionText': 'What is the capital of France?',
      'answers': ['Berlin', 'Paris', 'Madrid', 'Rome'],
      'correctAnswer': 'Paris'
    },
    {
      'questionText': 'What is 2 + 2?',
      'answers': ['3', '4', '5', '6'],
      'correctAnswer': '4'
    },
    {
      'questionText': 'What is the capital of France?',
      'answers': ['Berlin', 'Paris', 'Madrid', 'Rome'],
      'correctAnswer': 'Paris'
    },
    {
      'questionText': 'What is the capital of France?',
      'answers': ['Berlin', 'Paris', 'Madrid', 'Rome'],
      'correctAnswer': 'Paris'
    },
    {
      'questionText': 'What is the capital of France?',
      'answers': ['Berlin', 'Paris', 'Madrid', 'Rome'],
      'correctAnswer': 'Paris'
    },
    {
      'questionText': 'What is the capital of France?',
      'answers': ['Berlin', 'Paris', 'Madrid', 'Rome'],
      'correctAnswer': 'Paris'
    },
    {
      'questionText': 'What is the capital of France?',
      'answers': ['Berlin', 'Paris', 'Madrid', 'Rome'],
      'correctAnswer': 'Paris'
    },
    {
      'questionText': 'What is the capital of France?',
      'answers': ['Berlin', 'Paris', 'Madrid', 'Rome'],
      'correctAnswer': 'Paris'
    },
    // Add more questions here, up to 10 or more as needed.
  ];

  void nextQuestion() {
    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
      });
    } else {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ClockScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final mediaQuery = MediaQuery.of(context);
    final double padding = screenwidth * 0.05;

    return Scaffold(
      backgroundColor:
          Color(0xFFF8EDE3), // Background color similar to the image
      body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: screenheight * .4,
              width: screenwidth,
              decoration: BoxDecoration(
                  color: Color(0xFFBE875C),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(screenwidth * 0.08),
                      bottomRight: Radius.circular(screenwidth * 0.08))),
              child: Padding(
                padding: EdgeInsets.only(top: screenheight * 0.1),
                child: Column(
                  children: [
                    Text(
                      'Lets play',
                      style: TextStyle(
                        fontSize: screenwidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenheight * 0.08),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenheight * 0.05,
                        horizontal: screenwidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5E6D9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        questions[questionIndex]['questionText'] as String,
                        style: TextStyle(
                          fontSize: screenwidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(height: screenheight * 0.03),
          Column(
            children: (questions[questionIndex]['answers'] as List<String>)
                .map((answer) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenheight * 0.01,
                          horizontal: screenheight * 0.04),
                      child: ElevatedButton(
                        onPressed: () {
                          nextQuestion();
                        },
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.white,
                          // onPrimary: Colors.black,
                          padding: EdgeInsets.symmetric(
                            vertical: screenheight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenwidth * 0.03),
                            side: BorderSide(
                              color: Colors
                                  .green, // Border color for the selected answer
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            answer,
                            style: TextStyle(
                              fontSize: screenwidth * 0.045,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: screenheight * 0.05),
          GestureDetector(
            onTap: () {
              nextQuestion();
            
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenheight * 0.02,
                horizontal: screenwidth * 0.25,
              ),
              child: Container(
                height: screenheight * 0.06,
                width: screenwidth * 0.35,
                decoration: BoxDecoration(
                    color: Color(0xFFBE875C),
                    borderRadius: BorderRadius.circular(screenwidth * 0.03)),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: screenwidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
          // ElevatedButton(
          //   onPressed: nextQuestion,
          //   style: ElevatedButton.styleFrom(

          //     padding: EdgeInsets.symmetric(
          //       vertical: screenheight * 0.02,
          //       horizontal: screenwidth * 0.25,
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(screenwidth*0.03),
          //     ),
          //   ),
          //   child: Text(
          //     'Next',
          //     style: TextStyle(
          //       fontSize: screenwidth * 0.05,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
