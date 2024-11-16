import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/model/postmodel.dart';
import 'package:fire/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductProvider with ChangeNotifier {
  List<Documents>? _products;
  bool _isLoading = false;
  String? _error;
  String apiUrl =
      "https://firestore.googleapis.com/v1/projects/testing-39754/databases/(default)/documents/Posts/";
  String baseUrl = "https://firestore.googleapis.com/v1/";
  final fireStore = FirebaseFirestore.instance.collection("Posts").snapshots();

  List<Documents>? get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = ProductData.fromJson(json.decode(response.body));
        _products = data.documents;
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      Utilred().fluttertoastmessage(_error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl$id"));

    if (response.statusCode == 200) {
      Utilgreen().fluttertoastmessage("Delete Successful");
      notifyListeners(); // Notify listeners to update UI after deletion
    } else {
      Utilred().fluttertoastmessage("Something went wrong");
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

  Future<void> updatePost(
    String postId,
    String title,
    String description,
    String price,
    String companyName,
    String country,
    String quantity,
    String existingImageUrl,
    File? newImageFile,
  ) async {
    String? imageUrlToUpdate = existingImageUrl;
    String? token = await getAuthToken();

    if (token == null || token.isEmpty) {
      print("Token is missing or invalid.");
      Utilred().fluttertoastmessage("Token is missing or invalid.");
      return;
    }

    if (newImageFile != null) {
      try {
        imageUrlToUpdate = await uploadImageToStorage(newImageFile);
      } catch (e) {
        Utilgreen().fluttertoastmessage("Error uploading image: $e");
        return;
      }
    }

    final data = {
      "fields": {
        "title": {"stringValue": title},
        "description": {"stringValue": description},
        "price": {"stringValue": price},
        "company_name": {"stringValue": companyName},
        "country": {"stringValue": country},
        "quantity": {"stringValue": quantity},
        "image_url": {"stringValue": imageUrlToUpdate},
      }
    };

    final url = Uri.parse("$baseUrl$postId");
    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        Utilgreen().fluttertoastmessage('Post updated successfully');
        await fetchProducts();
        notifyListeners();
      } else {
        print(
            'Failed to update post: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("Error updating post: $e");
    }
  }
}
