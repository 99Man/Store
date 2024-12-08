import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire/auth/login.dart';
import 'package:fire/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref("Post");
  final TextEditingController _search = TextEditingController();
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              }).onError((error, stacktrace) {
                Utilred().fluttertoastmessage(error.toString());
              });
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: _search,
              onChanged: (String value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(19),
                  )),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseRef,
              itemBuilder: (context, snapshot, animation, index) {
                final title =
                    snapshot.child("title").value?.toString() ?? 'No Title';
                final description =
                    snapshot.child("description").value?.toString() ??
                        'No Description';
                final price =
                    snapshot.child("Price").value?.toString() ?? '0.0';
                
                final company =
                    snapshot.child("company name").value?.toString() ??
                        'No Title';
                final Country =
                    snapshot.child("country").value?.toString() ?? 'No Title';
                final id = snapshot.child("id").value.toString();
                if (_search.text.isEmpty) {
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(description),
                    trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert_sharp),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      databaseRef
                                          .child(snapshot
                                              .child("id")
                                              .value
                                              .toString())
                                          .remove();
                                    },
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                  )),
                              PopupMenuItem(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title, description, price,
                                      company, Country, id);
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text("Edit"),
                              ))
                            ]),
                  );
                } else if (title
                        .toLowerCase()
                        .contains(_search.text.toLowerCase()) ||
                    description
                        .toLowerCase()
                        .contains(_search.text.toLowerCase()) ||
                    price.toLowerCase().contains(_search.text.toLowerCase())) {
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(description),
                    trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert_outlined),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      databaseRef
                                          .child(snapshot
                                              .child("id")
                                              .value
                                              .toString())
                                          .remove();
                                    },
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                  )),
                              PopupMenuItem(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title, id, description, price,
                                      company, Country);
                                },
                                leading: Icon(Icons.edit),
                                title: Text("Edit"),
                              ))
                            ]),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const AddPost()),
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String subtitle, String price,
      String country, String comapny, String id) async {
    _companyController.text = comapny;
    _countryController.text = country;
    _priceController.text = price;
    _titleController.text = title;
    _descriptionController.text = subtitle;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              
              title: Text("Update"),
              content: Container(
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
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
                      decoration:
                          const InputDecoration(labelText: 'Company Name'),
                    ),
                    TextField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: 'Country'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      databaseRef.child(id).update({
                        "title": _titleController.text,
                        "price": _priceController.text,
                        "country": _countryController.text,
                        "quantity": _quantityController.text,
                        "description": _descriptionController.text,
                        "company": _companyController.text
                      }).then((value) {
                        Utilgreen().fluttertoastmessage("Update Successfully");
                      }).onError((error, stacktrace) {
                        Utilred().fluttertoastmessage(error.toString());
                      });
                    },
                    child: Text("Update")),
              ],
            ),
          );
        });
  }
}
