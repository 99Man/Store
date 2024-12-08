import 'package:fire/provider/post_provider.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    bool loading = false;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Add Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              postProvider.image != null
                  ? Image.file(postProvider.image!)
                  : const Text("No Image Selected"),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await postProvider.getImageGallery();
                  },
                  child:
                      text("Upload Image", 12, Colors.black, FontWeight.w700)),
              TextField(
                controller: postProvider.titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: postProvider.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: postProvider.priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: postProvider.quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: postProvider.companyController,
                decoration: const InputDecoration(labelText: 'Company Name'),
              ),
              TextField(
                controller: postProvider.countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              const SizedBox(height: 20),
              Button(
                  onTap: () async {
                    setState(() {
                      loading = loading;
                    });
                    if (postProvider.areFieldsValid()) {
                      await postProvider.postDataToFirestore();
                      setState(() {
                        loading = false;
                      });
                    } else {
                      setState(() {
                        loading = false;
                      });
                      postProvider.setState();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please fill in all fields and select an image')),
                      );
                    }
                  },
                  title: "Add Post"),
              const SizedBox(
                height: 300,
              )
            ],
          ),
        ),
      ),
    );
  }
}
