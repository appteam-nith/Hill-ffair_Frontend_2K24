import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Import Dio for HTTP requests
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/signup_screen.dart';
import 'chat_page.dart';





class MessageListPage extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  Dio dio = Dio();
  List<dynamic> users = [];
  bool isLoading = true;

  List<dynamic> name = [
    'Mia khalifa',
    'Tom Hardy',
    'Emilia Clarke',
    'Kate Winslet',
    '	Daniel Craig',
    'Anthony Hopkins',
    'Johnny Depp',
    'Christian Bale',
    'Tyler Perry'
  ];

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch users when the widget initializes
  }

  Future<void> fetchUsers() async {
    String? mongoDbUserId = await firebaseId.getMongoDbUserId();
    try {
      // Replace with your backend API endpoint
      final response = await dio.get(
          'https://appteam-backend-hill-2k24.onrender.com/match/matches-found/$mongoDbUserId');

      // Assuming the API returns a "matches" list containing "_id" for each user
      setState(() {
        users = response
            .data['matches']; // Access the "matches" list from the response
        isLoading = false;
        print('ids of matches is $users');
      });
    } catch (error) {
      print('Error fetching users: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFCEE8FF),
      appBar: AppBar(
        backgroundColor: Color(
          0xFF80C0FB,
        ),
        title: Text('Messages'),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 4.0, // Set elevation for the Card
                  margin: EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0), // Optional margin
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Optional rounded corners
                  ),
                  child: ListTile(
                    leading: Container(
                      width: screenWidth * 0.08, // Set the width
                      height: screenHeight * 0.04, // Set the height
                      decoration: BoxDecoration(
                        color: Color(0xFF80C0FB), // Set the background color
                        shape: BoxShape.rectangle, // Make it a square
                      ),
                    ),
                    title: Text('${name[index]}'), // Display the user's ID
                    subtitle: Text('Tap to chat'),
                    onTap: () async {
                      String? mongoDbUserId =
                          await firebaseId.getMongoDbUserId();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userId: "67153b6e9223739cd771f926",
                            recipientId: user['_id'],
                            userName: 'User ${name[index]}',
                          ),
                        ),
                      );
                      print("clicked on user ${user["_id"]}");
                    },
                  ),
                );
              },
            ),
    );
  }
}
