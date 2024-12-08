import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/provider/cart_provider.dart';
import 'package:fire/provider/product_provider.dart';
import 'package:fire/utils/sized.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/widget/list_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllItemProductScreen extends StatefulWidget {
  final QueryDocumentSnapshot post;
  final String id;

  AllItemProductScreen({required this.id, required this.post});

  @override
  State<AllItemProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<AllItemProductScreen> {
  late String documentId;
  final auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection("Posts");
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    documentId = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var cartItem = CartItem(
        id: post["id"].toString(),
        title: post["title"].toString(),
        price: post["price"].toString(),
        imgUrl: post["image_url"].toString(),
        sellerId: post["userId"].toString());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProductProvider>(
              builder: (context, postProvider, child) {
                // var post = postProvider.products!.first;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Image.network(
                    post["image_url"].toString(),
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text("Product Title :   ${post["title"].toString()}",
                              18, Colors.black, FontWeight.bold),
                          const SizedBox(height: 25),
                          text("Price :    \$ ${post["price"]}", 18,
                              Colors.black, FontWeight.bold),
                          const Divider(),
                          const SizedBox(height: 5),
                          text(
                              "Company Name: ${post["company_name"].toString()}",
                              18,
                              Colors.black,
                              FontWeight.bold),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text("Country : ${post["country"].toString()}",
                                  16, Colors.black, FontWeight.normal),
                              text("Quantity : ${post["quantity"].toString()}",
                                  16, Colors.black, FontWeight.normal),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 5),
                          text(
                              "Description : ${post["description"].toString()}",
                              18,
                              Colors.black,
                              FontWeight.normal),
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () async {
                                final cartProvider = Provider.of<CartProvider>(
                                    context,
                                    listen: false);
                                cartProvider.addItem(cartItem);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 1),
                                    content:
                                        Text("${cartItem.title} added to cart"),
                                  ),
                                );
                                // GetServices getServices = GetServices();
                                // String accesstoken =
                                //     await getServices.getServerKey();
                                // print("Server Token : $accesstoken");
                              },
                              child: Container(
                                width: getWidth(context),
                                height: 62,
                                decoration: BoxDecoration(
                                    color: const Color(0xFF33302E),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: text("Add To Cart", 15, Colors.white,
                                      FontWeight.bold),
                                ),
                              ),
                            ),
                          )
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
