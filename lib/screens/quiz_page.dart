import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/screens/time_screen.dart';
import 'package:hillfair/widgets/custom_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

bool quizSubmitted = false;

class UserService {
  final Dio dio = Dio();
  final String baseUrl =
      'https://hillffair-backend-2k24.onrender.com'; // Your base URL

  Future<void> updateUserQuizAnswers(String userId, List<int> quizAnswers) async {
    String url =
        '$baseUrl/user/updateQuizAnswers/$userId'; // Construct the URL with the userId

    // Create the request body
    Map<String, dynamic> requestBody = {
      'quizAnswers': quizAnswers,
    };

    try {
      Response response = await dio.put(
        url,
        data: json.encode(requestBody), // Encode the body to JSON
        options: Options(
          headers: {'Content-Type': 'application/json'}, // Set content type
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Call the submitQuiz function when successful
        await submitQuiz();

        print('Quiz answers updated successfully.');
      } else {
        print(
            'Failed to update quiz answers: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Error occurred while updating quiz answers: $e');
    }
  }
}

class QuizPage extends StatefulWidget {
  final String userId; // Pass the userId through the constructor

  const QuizPage({Key? key, required this.userId})
      : super(key: key); // Constructor

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  int questionIndex = 0;
  bool isLoading = true;
  List<dynamic> questions = [];
  List<int> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    initializeQuizStatus();
  }

  Future<void> _fetchQuestions() async {
    try {
      final Dio dio = Dio();
      final response = await dio.get(
          'https://hillffair-backend-2k24.onrender.com/questions/question');

      if (response.statusCode == 200) {
        final List<dynamic> fetchedQuestions = response.data;

        if (fetchedQuestions.isNotEmpty) {
          setState(() {
            questions = fetchedQuestions.map((question) {
              return {
                'questionText': question['question'] ?? '',
                'answers': [
                  question['option1'] ?? '',
                  question['option2'] ?? '',
                  question['option3'] ?? '',
                  question['option4'] ?? ''
                ]
              };
            }).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          // Show error message on the screen
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("No Questions"),
              content: Text("No questions were received from the backend."),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _selectAnswer(int answerIndex) {
    if (questionIndex < questions.length) {
      if (selectedAnswers.length > questionIndex) {
        selectedAnswers[questionIndex] = answerIndex;
      } else {
        selectedAnswers.add(answerIndex);
      }
    }

    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
      });
    }
  }

  Future<void> _submitQuiz() async {
    if (questionIndex == questions.length - 1) {
      if (selectedAnswers.length <= questionIndex) {
        _selectAnswer(selectedAnswers.last);
      }
    }

    UserService userService = UserService();
    await userService.updateUserQuizAnswers(widget.userId, selectedAnswers);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quiz submitted successfully!')),
    );

    // Navigate to another page, e.g., ClockScreen
    Navigator.pushReplacement(context, createFadeRoute(ClockScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFAAC0CE),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : questions.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      height: screenHeight * .4,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(screenWidth * 0.08),
                          bottomRight: Radius.circular(screenWidth * 0.08),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.1),
                        child: Column(
                          children: [
                            Text(
                              'Let\'s play',
                              style: TextStyle(
                                fontSize: screenWidth * 0.1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.08),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.05,
                                horizontal: screenWidth * 0.05,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5E6D9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                questions[questionIndex]['questionText'] ?? 'No question available',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Column(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenHeight * 0.04,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _selectAnswer(index + 1);
                            },
                            child: Stack(
                              children: [
                                Container(
                                    height: screenHeight * 0.06,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF1075CC), 
                                          Color(0xFFE6F3FF), 
                                          Color(0xFF1075CC), 
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0), 
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    )),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03,
                                      ),
                                      child: Text(
                                        questions[questionIndex]['answers'][index] ?? 'No option',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    if (questionIndex == questions.length - 1)
                      ElevatedButton(
                        onPressed: () {
                          _submitQuiz();
                        },
                        child: Text("Submit Quiz"),
                      ),
                  ],
                )
              : Center(child: Text('No questions available.')),
    );
  }
}

Future<void> submitQuiz() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    String uid = currentUser.uid;

    DocumentReference userQuizRef =
        FirebaseFirestore.instance.collection('quizSubmissions').doc(uid);

    DocumentSnapshot snapshot = await userQuizRef.get();

    if (!snapshot.exists) {
      await userQuizRef.set({'status': null});
    }

    await userQuizRef.update({
      'status': 'submitted',
      'submittedAt': FieldValue.serverTimestamp(),
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('quizSubmissionStatus', 'submitted');
    await prefs.setString('quizSubmissionTime', DateTime.now().toIso8601String());

    print("Quiz submitted successfully and status stored in SharedPreferences!");
  } else {
    print("User not logged in!");
  }
}
