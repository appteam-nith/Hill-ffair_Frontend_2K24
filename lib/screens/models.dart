import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// HighlightImage model
class HighlightImage {
  final String url;
  final String? title;

  HighlightImage({required this.url, this.title});

  factory HighlightImage.fromJson(Map<String, dynamic> json) {
    return HighlightImage(
      url: json['url'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
    };
  }
}

class Event {
  final String url; // The URL for the event
  final String title; // The title of the event
  final String description; // The description of the event

  // Constructor
  Event({
    required this.url,
    required this.title,
    required this.description,
  });

  // Factory constructor to create an Event from a JSON object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      url: json['url'],
      title: json['title'],
      description: json['description'],
    );
  }

  // Method to convert an Event instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'description': description,
    };
  }
}

Future<void> fetchMongoDbUser(String? uid) async {
  Dio dio = Dio();

  try {
    final response = await dio.get(
      'https://hillffair-backend-2k24.onrender.com/user/login',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final userData = response.data;

      // Extract user details
      final String mongoDbUserId = userData['mongoDbUserId'];
      final String username = userData['username'];
      final String email = userData['email'];
      final String dob = userData['dob'];
      final String gender = userData['gender'];

      // Store user data in local storage (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('mongoDbUserId', mongoDbUserId);
      await prefs.setString('username', username);
      await prefs.setString('email', email);
      await prefs.setString('gender', gender);
      await prefs.setString('dob', dob);

      print("Stored user data in local storage:");
      print("MongoDB User ID: $mongoDbUserId");
      print("Username: $username");
      print("Email: $email");
      print("Gender: $gender");
      print("DOB:$dob");
    } else {
      print(
          'Failed to fetch user data from backend: ${response.statusMessage}');
    }
  } catch (e) {
    print('Error occurred while fetching data: $e');
  }
}

// Future<String?> getUserDatafrompref() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? mongoDbUserId = prefs.getString('mongoDbUserId');
//   String? username = prefs.getString('username');
//   String? email = prefs.getString('email');
//   String? gender = prefs.getString('gender');
//   String? dob = prefs.getString('dob');

//   print("Retrieved from local storage:");
//   print("MongoDB User ID: $mongoDbUserId");
//   print("Username: $username");
//   print("Email: $email");
//   print("Gender: $gender");
//   print("DOB:$dob");

//   return mongoDbUserId; // Return the MongoDB user ID
// }

// ignore: camel_case_types

