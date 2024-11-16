import 'package:fire/UI/auth/api_services.dart';
import 'package:fire/UI/auth/signup.dart';
import 'package:fire/UI/ui_screens/cart_screen.dart';
import 'package:fire/UI/ui_screens/product_screen.dart';
import 'package:fire/firestore/fetchdatafromfirestore.dart';
import 'package:fire/model/postmodel.dart';
import 'package:fire/provider/cart_provider.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/widget/list_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerEffect() {
  return Expanded(
    child: ListView.builder(
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
                          height: 20,
                          width: double.infinity,
                          color: Colors.grey),
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
    ),
  );
}

Widget GoogleButton(context) {
  return NetworkImageButton(
      icon: Icons.g_mobiledata,
      buttonText: "SignUp with google account",
      onPressed: () async {
        UserCredential? usercred = await ApiService().loginWithGoogle();
        if (usercred != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Fetchdatafromfirestore()));
        } else {
          Utilred().fluttertoastmessage("Something went Wrong");
        }
      });
}

class NoTransitionRoute extends PageRouteBuilder {
  final Widget page;

  NoTransitionRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}

Column buildIconColumn(String imagePath, String label) {
  return Column(
    children: [
      Image.asset(imagePath, fit: BoxFit.cover, width: 42, height: 41),
      const SizedBox(height: 6),
      text(label, 12, Colors.black, FontWeight.w400),
    ],
  );
}

Widget buildPostList(List<Documents> posts) {
  return SizedBox(
    height: 350,
    child: ListView.builder(
      itemCount: posts.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var post = posts[index];

        // Create a CartItem from the post data
        var cartItem = CartItem(
          post.fields!.title!.stringValue.toString(),
          post.fields!.price!.stringValue.toString(),
          post.fields!.imageUrl!.stringValue.toString(),
        );

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductScreen(post: post, id: post.name ?? ""),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  if (post.fields!.imageUrl!.stringValue != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Image.network(
                        post.fields!.imageUrl!.stringValue.toString(),
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
                              post.fields!.title!.stringValue ?? "No Title",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            text(
                              "Price: \$${post.fields!.price!.stringValue.toString()}",
                              15,
                              Colors.black,
                              FontWeight.bold,
                            ),
                          ],
                        ),
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
                              builder: (context) => CartScreen(
                                documentId: post.name ?? "",
                              ),
                            ),
                          );
                        },
                        child: text(
                          "View Cart",
                          13,
                          Colors.black,
                          FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final cartProvider =
                              Provider.of<CartProvider>(context, listen: false);
                          cartProvider.addItem(cartItem);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${cartItem.title} added to cart"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class NetworkImageButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  IconData? icon;

  NetworkImageButton({
    required this.icon,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          text(buttonText, 12, Colors.black, FontWeight.w700)
        ],
      ),
    );
  }
}
