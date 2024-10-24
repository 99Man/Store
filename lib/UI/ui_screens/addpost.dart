
import 'package:fire/utils/utils.dart';
import 'package:fire/widget/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("Post");
  bool loading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Add Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  final id = DateTime.now().millisecond.toString();
                  if (_companyController.text.isNotEmpty &&
                      _countryController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty &&
                      _priceController.text.isNotEmpty &&
                      _quantityController.text.isNotEmpty &&
                      _titleController.text.isNotEmpty) {
                    _databaseRef.child(id).set({
                      "title": _titleController.text,
                      "description": _descriptionController.text,
                      "price": _priceController.text.toString(),
                      "quantity": _quantityController.text.toString(),
                      "company name": _companyController.text,
                      "country": _countryController.text,
                      "id": id
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().fluttertoastmessage("Post Added");
                    }).onError((error, stacktrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().fluttertoastmessage(error.toString());
                    });
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      loading = false;
                    });
                    Utils().fluttertoastmessage("Fill every textfield");
                  }
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
