import 'dart:convert';
import 'package:dio/dio.dart'; // Import Dio
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hillfair/screens/mesage_page_list.dart';
import 'package:hillfair/screens/time_screen.dart';
import 'package:hillfair/widgets/custom_route.dart';

class UserService {
  final Dio dio = Dio();
  final String baseUrl =
      'https://hillffair-backend-2k24.onrender.com'; // Your base URL

  Future<void> updateUserQuizAnswers(
      String userId, List<int> quizAnswers) async {
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
    selectedAnswers.add(answerIndex);

    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
      });
    }
  }

  // Function to handle the submission of quiz answers
  void _submitQuiz() async {
    UserService userService = UserService();
    await userService.updateUserQuizAnswers(widget.userId, selectedAnswers);
    // Show a success message or navigate to another page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quiz submitted successfully!')),
    );
    // You may want to navigate away after submission
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AnotherPage()));
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
                    // Display the current question
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
                                questions[questionIndex]['questionText'] ??
                                    'No question available',
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

                    // Display answer options
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
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03),
                                    color: Colors
                                        .transparent, // Transparent to show SVG
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/images/Frame 9294.svg',
                                  width: screenWidth,
                                  height: screenHeight * 0.06,
                                  fit: BoxFit.cover,
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03,
                                      ),
                                      child: Text(
                                        questions[questionIndex]['answers']
                                                [index] ??
                                            'No option',
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

                    // Show the "Submit" button if it's the last question
                    if (questionIndex == questions.length - 1)
                      ElevatedButton(
                        onPressed: () {
                          _submitQuiz();
                          Navigator.push(
                              context, createFadeRoute(ClockScreen()));
                        }, // Call the submission function
                        child: Text("Submit Quiz"),
                      ),
                  ],
                )
              : Center(child: Text('No questions available.')),
    );
  }
}
