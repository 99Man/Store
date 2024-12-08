import 'package:fire/UI/user_screens/bottom_nav_user.dart';
import 'package:fire/auth/api_services.dart';
import 'package:fire/UI/user_screens/user_product_screen.dart';
import 'package:fire/model/postmodel.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        UserCredential? usercred = await ApiService().signInWithGoogle(context);
        if (usercred != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Nechanavigation()));
        } else {
          Utilred().fluttertoastmessage("Something went Wrong");
        }
      });
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

Widget buildIcon(String assetPath, bool isSelected) {
  return SizedBox(
    width: 23,
    height: 23,
    child: Image.asset(
      assetPath,
      color: isSelected ? Colors.white : Colors.grey,
    ),
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

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProductScreen(post: post, id: post.name ?? ""),
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
                            Container(
                              width: 120,
                              child: Text(
                                post.fields!.title!.stringValue ?? "No Title",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

Widget buildPostAdminList(List<Documents> posts) {
  return SizedBox(
    height: 350,
    child: ListView.builder(
      itemCount: posts.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var post = posts[index];

        if (posts.isEmpty) {
          return const Center(child: Text("No Products Available"));
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProductScreen(post: post, id: post.name ?? ""),
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
                            Container(
                              width: 120,
                              child: Text(
                                post.fields!.title!.stringValue ?? "No Title",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
