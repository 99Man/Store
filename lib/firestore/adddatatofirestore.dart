import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/utils/text.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/widget/button.dart';

class Adddatatofirestore extends StatefulWidget {
  const Adddatatofirestore({super.key});

  @override
  State<Adddatatofirestore> createState() => _AddPostState();
}

class _AddPostState extends State<Adddatatofirestore> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  Future getImageGallery() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        Utils().fluttertoastmessage("Image selected");
      } else {
        Utils().fluttertoastmessage("No image selected");
      }
    });
  }

  Future uploadImageToStorage() async {
    if (_image != null) {
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref =
          storage.ref().child('images/$imageFileName');

      firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
      await uploadTask;

      return await ref.getDownloadURL();
    } else {
      throw Exception('Error: No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Post Your Product", 22, Colors.black, FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              ElevatedButton(
                onPressed: getImageGallery,
                child: text("Upload Image", 12, Colors.black, FontWeight.w900),
              ),
              const SizedBox(height: 15),
              _image != null
                  ? Image.file(_image!,
                      height: 150, width: 150, fit: BoxFit.cover)
                  : text("No image selected", 12, Colors.grey, FontWeight.w700),
              const SizedBox(height: 15),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company Name'),
              ),
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              const SizedBox(height: 20),
              Button(
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();

                  try {
                    if (_titleController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty &&
                        _priceController.text.isNotEmpty &&
                        _quantityController.text.isNotEmpty &&
                        _companyController.text.isNotEmpty &&
                        _countryController.text.isNotEmpty &&
                        _image != null) {
                      String imageUrl = await uploadImageToStorage();

                      firestore.collection('Posts').doc(id).set({
                        "title": _titleController.text,
                        "description": _descriptionController.text,
                        "price": _priceController.text,
                        "quantity": _quantityController.text,
                        "company_name": _companyController.text,
                        "country": _countryController.text,
                        "image_url": imageUrl,
                        "id": id
                      }).then((value) {
                        Utils().fluttertoastmessage("Post successfully added");
                      }).catchError((error) {
                        Utils()
                            .fluttertoastmessage("Failed to add post: $error");
                      });
                    } else {
                      Utils().fluttertoastmessage("Fill every text field");
                    }
                  } catch (error) {
                    Utils().fluttertoastmessage("Error: $error");
                  }

                  setState(() {
                    loading = false;
                  });
                },
                title: "Add Post",
                loading: loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
