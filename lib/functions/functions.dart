import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearStoredData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Remove individual fields from SharedPreferences
  await prefs.remove('mongoDbUserId');
  await prefs.remove('username');
  await prefs.remove('email');
  await prefs.remove('dob');
  await prefs.remove('gender');

  print('All user data has been cleared from local storage.');
}

class FirebaseId {
  String? firebaseUID;

  FirebaseId({this.firebaseUID});

  // Converts a FirebaseId instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'firebaseUID': firebaseUID,
    };
  }

  String toJson() => json.encode(toMap());

  // Method to retrieve MongoDB User ID from SharedPreferences
  Future<String?> getMongoDbUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mongoDbUserId');
  }

  // Method to retrieve Username from SharedPreferences
  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Method to retrieve Email from SharedPreferences
  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // Method to retrieve Date of Birth from SharedPreferences
  Future<String?> getDob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('dob');
  }

  // Method to retrieve Gender from SharedPreferences
  Future<String?> getGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gender');
  }
}
