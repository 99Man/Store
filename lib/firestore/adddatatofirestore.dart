import 'package:fire/provider/post_provider.dart';
import 'package:fire/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/widget/button.dart';

class AddDataToFirestore extends StatefulWidget {
  const AddDataToFirestore({super.key});

  @override
  State<AddDataToFirestore> createState() => _AddDataToFirestoreState();
}

class _AddDataToFirestoreState extends State<AddDataToFirestore> {
  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: true);
    postProvider.clearFields();
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
          child: Consumer<PostProvider>(
            builder: (context, postProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  postProvider.image != null
                      ? Image.file(postProvider.image!,
                          height: 150, width: 150, fit: BoxFit.cover)
                      : text("No image selected", 12, Colors.grey,
                          FontWeight.w700),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: postProvider.getImageGallery,
                    child:
                        text("Upload Image", 12, Colors.black, FontWeight.w900),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(postProvider.titleController, 'Title'),
                  _buildTextField(
                      postProvider.descriptionController, 'Description'),
                  _buildTextField(postProvider.priceController, 'Price',
                      isNumber: true),
                  _buildTextField(postProvider.quantityController, 'Quantity',
                      isNumber: true),
                  _buildTextField(
                      postProvider.companyController, 'Company Name'),
                  _buildTextField(postProvider.countryController, 'Country'),
                  const SizedBox(height: 20),
                  Button(
                    onTap: () async {
                      if (postProvider.areFieldsValid()) {
                        await postProvider.postDataToFirestore();
                      } else {
                        Utilred().fluttertoastmessage("Fill every text field");
                      }
                    },
                    title: "Add Post",
                    loading: postProvider.loading,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: labelText),
    );
  }
}
