import 'dart:convert';
import 'dart:io';
import 'package:fire/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PostProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  File? _image;
  File? get image => _image;

  final TextEditingController _titleController = TextEditingController();
  TextEditingController get titleController => _titleController;

  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  final TextEditingController _priceController = TextEditingController();
  TextEditingController get priceController => _priceController;

  final TextEditingController _quantityController = TextEditingController();
  TextEditingController get quantityController => _quantityController;

  final TextEditingController _companyController = TextEditingController();
  TextEditingController get companyController => _companyController;

  final TextEditingController _countryController = TextEditingController();
  TextEditingController get countryController => _countryController;

  void setState() {
    _loading = true;
    notifyListeners();
  }

  void clearFields() {
    _loading = false;

    companyController.clear();
    countryController.clear();
    descriptionController.clear();
    quantityController.clear();
    titleController.clear();
    priceController.clear();
    _image = null;
    notifyListeners();
  }

  bool areFieldsValid() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        companyController.text.isNotEmpty &&
        countryController.text.isNotEmpty &&
        image != null;
  }

  Future<void> getImageGallery() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedImage != null) {
      _image = File(pickedImage.path);
      Utilgreen().fluttertoastmessage("Image selected");
    } else {
      Utilred().fluttertoastmessage("No image selected");
    }

    notifyListeners();
  }

  Future<String> uploadImageToStorage() async {
    if (_image != null) {
      try {
        String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.FirebaseStorage storage =
            firebase_storage.FirebaseStorage.instance;
        firebase_storage.Reference ref =
            storage.ref().child('images/$imageFileName');

        firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
        await uploadTask;

        return await ref.getDownloadURL();
      } catch (error) {
        throw Exception('Error uploading image: $error');
      }
    } else {
      throw Exception('Error: No image selected');
    }
  }

  Future<void> postDataToFirestore() async {
    if (!areFieldsValid()) {
      Utilred()
          .fluttertoastmessage("Please fill in all fields and select an image");
      return;
    }

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print('User is authenticated, UID: ${currentUser.uid}');
    } else {
      print('User is not authenticated');
      return; // Ensure the user is authenticated before proceeding
    }

    _loading = true;
    notifyListeners();

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    String postUrl =
        'https://firestore.googleapis.com/v1/projects/testing-39754/databases/(default)/documents/Posts/';

    final body = {
      "fields": {
        "title": {"stringValue": _titleController.text},
        "description": {"stringValue": _descriptionController.text},
        "price": {"stringValue": _priceController.text},
        "quantity": {"stringValue": _quantityController.text},
        "company_name": {"stringValue": _companyController.text},
        "country": {"stringValue": _countryController.text},
        "image_url": {"stringValue": await uploadImageToStorage()},
        "id": {"stringValue": id},
        "userId": {"stringValue": FirebaseAuth.instance.currentUser!.uid}
      },
    };

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Step 2: Update seller's metadata with the new post ID
        final String sellerUrl =
            'https://firestore.googleapis.com/v1/projects/testing-39754/databases/(default)/documents/User/${currentUser.uid}';

        final sellerresponse = await http.get(Uri.parse(sellerUrl),
            headers: {"Content-type": "application/json"});
        if (sellerresponse.statusCode == 200) {
          final sellerData = json.decode(sellerresponse.body);
          List<dynamic> currentPost = [];
          if (sellerData["fields"]?["posts"]?["arrayValue"]?["values"] !=
              null) {
            currentPost =
                sellerData["fields"]?["posts"]?["arrayValue"]?["values"];
          }
          currentPost.add({"stringValue": id});
          final metadataBody = {
            "fields": {
              "role": {"stringValue": "Seller"},
              "posts": {
                "arrayValue": {
                  "values": [
                    {"stringValue": id}
                  ]
                }
              }
            }
          };

          final metadataResponse = await http.patch(
            Uri.parse(sellerUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(metadataBody),
          );

          if (metadataResponse.statusCode == 200) {
            Utilgreen().fluttertoastmessage("Post successfully added");
            resetForm();
          } else {
            print(metadataResponse.body.toString());
            Utilred().fluttertoastmessage(
                "Failed to update seller metadata: ${metadataResponse.body.toString()}");
          }
        } else {
          print(sellerresponse.body.toString());
          Utilred().fluttertoastmessage(
              "Failed to update seller metadata ${sellerresponse.body.toString()}");
        }
      } else {
        print(response.body.toString());
        Utilred().fluttertoastmessage(
            "Failed to add post: ${response.body.toString()}");
      }
    } catch (error) {
      Utilred().fluttertoastmessage("Error: $error");
    }

    _loading = false;
    notifyListeners();
  }

  void resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.clear();
    _companyController.clear();
    _countryController.clear();
    _image = null;
    notifyListeners();
  }
}
