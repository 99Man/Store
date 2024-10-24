import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/utils/sized.dart';
import 'package:fire/utils/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot> posts;

  ProductScreen(this.posts, {super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection("Posts");

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  get post => widget.posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          var post = widget.posts[index];

          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Image.network(
                  post["image_url"],
                  width: getWidth(context),
                  fit: BoxFit.cover,
                  height: getHeigth(context) / 2,
                ),
              ),
              IntrinsicHeight(
                child: SingleChildScrollView(
                  child: Container(
                    width: getWidth(context),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text("Product :   " + post["title"].toString(),
                                  18, Colors.black, FontWeight.bold),
                            ],
                          ),
                          SizedBox(height: 25),
                          text("Price :    \$ " + post["price"].toString(), 18,
                              Colors.black, FontWeight.bold),
                          Divider(),
                          SizedBox(height: 5),
                          text(
                              "Company Name: " +
                                  post["company_name"].toString(),
                              18,
                              Colors.black,
                              FontWeight.bold),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text("Country: " + post["country"].toString(), 18,
                                  Colors.black, FontWeight.bold),
                            ],
                          ),
                          SizedBox(height: 20),
                          text("Description: ", 22, Colors.black,
                              FontWeight.bold),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: text(post["description"].toString(), 18,
                                Colors.grey, FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> showMyDialog(QueryDocumentSnapshot post, String id) async {
    _titleController.text = post["title"];
    _descriptionController.text = post["description"];
    _priceController.text = post["price"];
    _countryController.text = post["country"];
    _companyController.text = post["company_name"];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title')),
                TextField(
                    controller: _descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Description')),
                TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price')),
                TextField(
                    controller: _companyController,
                    decoration:
                        const InputDecoration(labelText: 'Company Name')),
                TextField(
                    controller: _countryController,
                    decoration: const InputDecoration(labelText: 'Country')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
              onPressed: () async {
                await ref.doc(id).update({
                  "title": _titleController.text,
                  "description": _descriptionController.text,
                  "price": _priceController.text,
                  "company name": _companyController.text,
                  "country": _countryController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
