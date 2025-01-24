import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

//for signup

Future<String> signupUserByEmailAndPassword(
    {required String email,
    required String password,
    required String name,
    String? gender,
    DateTime? DOB}) async {
  String res = "Empty fields are not allowed";
  try {
    if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user?.uid)
          .set({"name": name, "email": email, "uid": credential.user?.uid});
      res = "success";
    }
  } catch (e) {
    res = e.toString();
  }
  return res;
}

//for login

Future<String> loginUserByEmailAndPassword(
    {required String email, required String password}) async {
  String res = "Empty fields are not allowed";
  try {
    if (email.isNotEmpty || password.isNotEmpty) {
      //login a user
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      res = "success";
    }
  } catch (e) {
    res = e.toString();
  }
  return res;
}

//for logout

Future<String> logoutUser() async {
  String res = "Some error Occurred";
  try {
    await FirebaseAuth.instance.signOut();
    res = "success";
  } catch (e) {
    res = e.toString();
  }
  return res;
}

//for email verification

Future<String?> getCurrentUserUID() async {
  try {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Return the Firebase UID
      return user.uid;
    } else {
      print('No user is currently signed in.');
      return null;
    }
  } catch (e) {
    print('Error getting Firebase UID: $e');
    return null;
  }
}

class TokenService {
  final Dio dio;

  TokenService(this.dio);

  Future<void> sendTokenToBackend(String token) async {
    try {
      final response = await dio.post(
        '',
        data: {'token': token},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200) {
        print('Token sent successfully');
      } else {
        print('Failed to send token: ${response.data}');
      }
    } catch (e) {
      print('Error sending token: $e');
    }
  }
}




Future<void> initializeQuizStatus() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    String uid = currentUser.uid;

    // Reference to the Firestore document for this user
    DocumentReference userQuizRef = FirebaseFirestore.instance.collection('quizSubmissions').doc(uid);

    // Get the document snapshot
    DocumentSnapshot snapshot = await userQuizRef.get();

    // If the document does not exist, create it with status as null
    if (!snapshot.exists) {
      await userQuizRef.set({
        'status': null,
      });
      print("Quiz initialized with status null.");
    }
  } else {
    print("User not logged in!");
  }
}


Future<String?> getQuizStatus() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    String uid = currentUser.uid;

    // Reference to the Firestore document for this user
    DocumentReference userQuizRef = FirebaseFirestore.instance.collection('quizSubmissions').doc(uid);

    // Get the document snapshot
    DocumentSnapshot snapshot = await userQuizRef.get();

    // Check if the document exists and if status is defined
    if (snapshot.exists && (snapshot.data() as Map<String, dynamic>)['status'] != null) {
      return (snapshot.data() as Map<String, dynamic>)['status'] as String;
    } else {
      return null; // No status found, user may not have taken the quiz
    }
  } else {
    print("User not logged in!");
    return null;
  }
}
//  submitt

Future<void> submitQuiz() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    String uid = currentUser.uid;

    // Reference to the Firestore document for this user
    DocumentReference userQuizRef =
        FirebaseFirestore.instance.collection('quizSubmissions').doc(uid);

    // Before submission, initialize with null or check existing data
    DocumentSnapshot snapshot = await userQuizRef.get();

    if (!snapshot.exists) {
      // Set the status as null initially if it doesn't exist
      await userQuizRef.set({'status': null});
    }

    // When the user submits the quiz, update the status to "submitted"
    await userQuizRef.update({
      'status': 'submitted',
      'submittedAt': FieldValue.serverTimestamp(), // Optionally store the submission time
    });

    // Now, save the submission status in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('quizSubmissionStatus', 'submitted');
    await prefs.setString('quizSubmissionTime', DateTime.now().toIso8601String());

    print("Quiz submitted successfully and status stored in SharedPreferences!");
  } else {
    print("User not logged in!");
  }
}