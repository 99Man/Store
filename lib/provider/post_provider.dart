import 'dart:convert';
import 'dart:io';
import 'package:fire/utils/utils.dart';
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
  setState() {
    _loading = true;
  }

  void clearFields() {
    setState() {
      _loading = false;
    }

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
    setState() {
      _loading = false;
    }

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
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference ref =
          storage.ref().child('images/$imageFileName');

      firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
      await uploadTask;

      Utilgreen().fluttertoastmessage("Image is Uploaded");
      return await ref.getDownloadURL();
    } else {
      throw Exception('Error: No image selected');
    }
  }

  Future<void> postDataToFirestore() async {
    _loading = true;
    notifyListeners();

    dynamic id = DateTime.now().millisecondsSinceEpoch.toString();
    final String url =
        'https://firestore.googleapis.com/v1/projects/testing-39754/databases/(default)/documents/Posts/';
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _companyController.text.isNotEmpty &&
        _countryController.text.isNotEmpty &&
        _image != null) {}
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
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Utilgreen().fluttertoastmessage("Post successfully added");
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _quantityController.clear();
        _companyController.clear();
        _countryController.clear();
      } else {
        Utilred().fluttertoastmessage("Failed to add post: ${response.body}");
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
