import 'package:fire/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utilred().fluttertoastmessage("No user found for that email");
        print("No user found for that email.");
        throw "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        Utilred().fluttertoastmessage("Incorrect password provided for that user.");
        throw "Incorrect password provided for that user.";
      } else {
        print("Error signing in: $e");
        throw "Error signing in: $e";
      }
    } catch (e) {
      print("Error signing in: $e");
      throw "An unexpected error occurred.";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      print("Error signing up: $e");
    }
  }
}
