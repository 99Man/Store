import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/UI/ui_screens/cart_screen.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/widget/list_items.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerEffect() {
  return ListView.builder(
    itemCount: 6,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 20, width: double.infinity, color: Colors.grey),
                    const SizedBox(height: 10),
                    Container(
                        height: 20,
                        width: double.infinity / 2,
                        color: Colors.grey),
                    const SizedBox(height: 10),
                    Container(height: 20, width: 100, color: Colors.grey),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildPostList(List<QueryDocumentSnapshot> posts) {
  List<CartItem> selectedItems = [];
  return Container(
    height: 400,
    child: ListView.builder(
      itemCount: posts.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var post = posts[index];
        var cartItem = CartItem(
          post["title"]?.toString() ?? "No Title",
          post["price"]?.toString() ?? "Unknown",
          post["image_url"]?.toString() ?? 'https://placehold.co/126x200',
        );
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                if (post["image_url"] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: Image.network(
                      post["image_url"],
                      width: 170,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post["title"]?.toString() ?? "No Title",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          text(
                              "Price: \$ ${post["price"]?.toString() ?? "Unknown"}",
                              15,
                              Colors.black,
                              FontWeight.bold),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CartScreen(selectedItems)));
                        },
                        child: text(
                            "View Cart", 13, Colors.black, FontWeight.w700)),
                    IconButton(
                        onPressed: () {
                          selectedItems.add(cartItem);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("${cartItem.title} added to cart")),
                          );
                        },
                        icon: Icon(Icons.add)),
                  ],
                ),
                const SizedBox(height: 4.0),
              ],
            ),
          ),
        );
      },
    ),
  );
}
