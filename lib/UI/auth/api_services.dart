import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print("Error signing in with email and password: $e");
      return null;
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
      Utilred().fluttertoastmessage("Google Sign-in Error : ${e.toString()}");
    }
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
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

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      Utilgreen().fluttertoastmessage("Successfully Logout");
    } catch (error) {
      Utilred().fluttertoastmessage("Logout failed: $error");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  //Uploading Image to firestorage

  //Fetch Data to display data
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        return jsonData.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
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

  Future<String?> getAuthToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        return token; // This is the authorization token
      }
    } catch (e) {
      print("Error getting token: $e");
    }
    return null;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference ref =
          storage.ref().child('images/$imageFileName');

      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask;
      Utilgreen().fluttertoastmessage("New image uploaded");

      // Get the download URL of the uploaded image
      return await ref.getDownloadURL();
    } catch (e) {
      Utilgreen().fluttertoastmessage("Error uploading image: $e");
      throw e;
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
