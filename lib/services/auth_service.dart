// ignore_for_file: empty_catches

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:nepstyle_management_system/constants/sharedPreferences/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//creating new account
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    log("Signup Tapped");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final name = await getName();
      log(name.toString());
      log(userCredential.user!.uid);
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'name': name,
          'profileImageUrl': ''
        },
      );

      return "Account Created";

      // return user;
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
    // log("Signup Tapped");
  }

  //Logging In with Email and password
  Future<String> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log(userCredential.toString());
      String uid = userCredential.user!.uid;

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String? name = userDoc.data()?['name'];
        log(name.toString());
        if (name != null) {
          // Store the user's name in SharedPreferences
          saveName(name);

          return "logged";
        }
      }
      return "logged";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

// for logging user out
  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
// checking user is logged in or not

  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null; // returns boolean value true if user is logged in
  }

  static Future<String> getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    return user.toString();
  }

  static Future<String> resetPassword(String email) {
    return FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((_) => "Password reset email sent");
  }
}
