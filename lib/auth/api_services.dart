import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/UI/ui_screens/role_selection.dart';
import 'package:fire/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  final auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection("Posts");
  final fireStore = FirebaseFirestore.instance.collection("Posts").snapshots();
  bool isLoading = false;
  // File? _image;
  final picker = ImagePicker();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final baseUrl = "https://firestore.googleapis.com/v1/";

  static String apiUrl =
      'https://firestore.googleapis.com/v1/projects/testing-39754/databases/(default)/documents/Posts/';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Check if the user is signing in for the first time
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Navigate to role selection screen if it's a new user
        // ignore: use_build_context_synchronously
        await _navigateToRoleSelection(context);
      }

      return userCredential;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  _navigateToRoleSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoleSelectionScreen(),
      ),
    );
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      await _googleSignIn.signOut();
      Utilgreen().fluttertoastmessage("Successfully Logout");
    } catch (error) {
      Utilred().fluttertoastmessage("Logout failed: $error");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Fetch Data to update Data
  Future<Map<String, dynamic>> fetchPost(String id) async {
    final url = Uri.parse('$baseUrl$id');

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer your_api_token", // Add if API requires it
      });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch post data. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error fetching post data: $e');
      return {};
    }
  }
}

// Model for Product
class Product {
  final String id;
  final String title;
  final String description;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }
}
