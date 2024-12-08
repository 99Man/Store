import 'dart:convert';
import 'dart:io';
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

  List<Documents>? get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<dynamic> fetchProducts() async {
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
    return;
  }

  Future<void> fetchUserData() async {
    try {
      await fetchProducts();
      if (_products == null || _products!.isEmpty) {
        Utilred().fluttertoastmessage("No products found.");
        return;
      }

      _products = _products!.where((product) {
        final userId = product.fields?.userId?.stringValue;
        return userId != null &&
            userId == FirebaseAuth.instance.currentUser!.uid;
      }).toList();

      if (_products!.isNotEmpty) {
        Utilgreen().fluttertoastmessage("Fetch User Data Successfully");
      } else {
        Utilred().fluttertoastmessage("No matching data for the current user");
      }
    } catch (e) {
      Utilgreen().fluttertoastmessage(FirebaseAuth.instance.currentUser!.uid);
      Utilred().fluttertoastmessage("Error: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> deletePost(String id) async {
    _isLoading = true;
    final response = await http.delete(Uri.parse("$apiUrl$id"));

    if (response.statusCode == 200) {
      _isLoading = false;
      Utilgreen().fluttertoastmessage("Delete Successful");
      notifyListeners();
    } else {
      _isLoading = false;
      Utilred().fluttertoastmessage("Something went wrong");
    }
  }

  Future<String?> getAuthToken() async {
    _isLoading = true;
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _isLoading = false;
        String? token = await user.getIdToken();
        return token;
      }
    } catch (e) {
      _isLoading = false;
      print("Error getting token: $e");
    }
    return null;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _isLoading = true;
    try {
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference ref =
          storage.ref().child('images/$imageFileName');
      _isLoading = false;
      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask;
      Utilgreen().fluttertoastmessage("New image uploaded");

      // Get the download URL of the uploaded image
      return await ref.getDownloadURL();
    } catch (e) {
      _isLoading = false;
      Utilgreen().fluttertoastmessage("Error uploading image: $e");
      throw e;
    }
  }

  Future<void> updatePost(
    String postId,
    String title,
    String description,
    String id,
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
        Utilred().fluttertoastmessage("Error uploading image: $e");
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
        "id": {"stringValue": id},
        "userId": {"stringValue": FirebaseAuth.instance.currentUser!.uid}
      }
    };

    final url = Uri.parse("$apiUrl$postId");
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
        return;
      } else {
        Utilred().fluttertoastmessage(
            "Failed to update post: ${response.statusCode} - ${response.body.toString()}");
        print(
            'Failed to update post: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("Error updating post: $e");
    }
  }
}
