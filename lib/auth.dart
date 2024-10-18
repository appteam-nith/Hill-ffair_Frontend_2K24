import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//for signup

Future<String> signupUserByEmailAndPassword(
    {required String email,
    required String password,
    required String name}) async {
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




