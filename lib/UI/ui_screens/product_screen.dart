import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/UI/auth/api_services.dart';
import 'package:fire/model/postmodel.dart';
import 'package:fire/provider/product_provider.dart';
import 'package:fire/utils/sized.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final Documents post;
  final String id;

  ProductScreen({required this.id, required this.post});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late String documentId;
  final auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection("Posts");

  @override
  void initState() {
    super.initState();
    documentId = widget.id;
  }

  // final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _descriptionController = TextEditingController();
  // final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _companyController = TextEditingController();
  // final TextEditingController _countryController = TextEditingController();
  // final TextEditingController _quantityController = TextEditingController();
  File? _selectedImage;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      Utilgreen().fluttertoastmessage("New Image is selected");
    }
  }

  void showdeletedialog(ProductProvider postProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Post"),
          content: Text("Are you sure you want to delete this post"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await postProvider.deletePost(documentId);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(context, ProductProvider postProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Post !"),
          content: Text("Do you want to update this post ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                editpost(context, postProvider);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void editpost(BuildContext context, ProductProvider postProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (documentId.isEmpty) {
          Utilred().fluttertoastmessage("The document is empty");
        } else {
          ApiService().fetchPost(documentId);
          Utilgreen().fluttertoastmessage("Data Fetched successfully");
        }

        final post = widget.post;
        return EditPostDialog(
          documentId: documentId,
          pickImage: pickImage,
          postProvider: postProvider,
          post: post,
          selectedImage: _selectedImage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("rebuiling the widget");
    var post = widget.post;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final postProvider = Provider.of<ProductProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == "Delete") {
                showdeletedialog(postProvider);
              } else if (value == "Edit") {
                showEditDialog(context, postProvider);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "Delete",
                child: ListTile(
                  title: Text('Delete'),
                  trailing: Icon(Icons.delete),
                ),
              ),
              const PopupMenuItem(
                value: "Edit",
                child: ListTile(
                  title: Text('Edit'),
                  trailing: Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProductProvider>(
              builder: (context, postProvider, child) {
                var post = postProvider.products!.first;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Image.network(
                    post.fields!.imageUrl!.stringValue.toString(),
                    width: getWidth(context),
                    fit: isPortrait ? BoxFit.cover : BoxFit.contain,
                    height: isPortrait
                        ? getHeigth(context) / 2
                        : getHeigth(context) / 1,
                  ),
                );
              },
            ),
            IntrinsicHeight(
              child: Container(
                width: getWidth(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 50),
                  child: Consumer<ProductProvider>(
                    builder: (context, postProvider, child) {
                      var post = postProvider.products!.first;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                              "Product Title :   ${post.fields!.title!.stringValue.toString()}",
                              18,
                              Colors.black,
                              FontWeight.bold),
                          const SizedBox(height: 25),
                          text(
                              "Price :    \$ ${post.fields!.price!.stringValue.toString()}",
                              18,
                              Colors.black,
                              FontWeight.bold),
                          const Divider(),
                          const SizedBox(height: 5),
                          text(
                              "Company Name: ${post.fields!.companyName!.stringValue.toString()}",
                              18,
                              Colors.black,
                              FontWeight.bold),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text(
                                  "Country : ${post.fields!.country!.stringValue.toString()}",
                                  16,
                                  Colors.black,
                                  FontWeight.normal),
                              text(
                                  "Quantity : ${post.fields!.quantity!.stringValue.toString()}",
                                  16,
                                  Colors.black,
                                  FontWeight.normal),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 5),
                          text(
                              "Description : ${post.fields!.description!.stringValue.toString()}",
                              18,
                              Colors.black,
                              FontWeight.normal),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditPostDialog extends StatelessWidget {
  final String documentId;
  final Documents post;
  final ProductProvider postProvider;
  final File? selectedImage;
  final Future<void> Function() pickImage;

  const EditPostDialog({
    required this.documentId,
    required this.post,
    required this.postProvider,
    required this.selectedImage,
    required this.pickImage,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: post.fields!.title!.stringValue.toString());
    final TextEditingController descriptionController = TextEditingController(
        text: post.fields!.description!.stringValue.toString());
    final TextEditingController priceController =
        TextEditingController(text: post.fields!.price!.stringValue.toString());
    final TextEditingController companyController = TextEditingController(
        text: post.fields!.companyName!.stringValue.toString());
    final TextEditingController countryController = TextEditingController(
        text: post.fields!.country!.stringValue.toString());
    final TextEditingController quantityController = TextEditingController(
        text: post.fields!.quantity!.stringValue.toString());

    return AlertDialog(
      title: const Text("Update"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: companyController,
              decoration: const InputDecoration(labelText: 'Company Name'),
            ),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                await pickImage();
              },
              child: const Text("Change Image"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await postProvider.updatePost(
              documentId,
              titleController.text,
              descriptionController.text,
              priceController.text,
              companyController.text,
              countryController.text,
              quantityController.text,
              post.fields!.imageUrl!.stringValue.toString(),
              selectedImage,
            );
            Navigator.pop(context);
          },
          child: const Text("Update"),
        ),
      ],
    );
  }
}
