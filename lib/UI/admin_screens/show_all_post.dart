import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/UI/admin_screens/product_admin_screen.dart';
import 'package:fire/utils/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MyProductScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> _fetchMyPosts() async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) throw Exception("User not logged in");

    final postsSnapshot = await _firestore
        .collection('Posts')
        .where('userId', isEqualTo: userId)
        .get();

    return postsSnapshot.docs;
  }

  Future<void> _deletePost(BuildContext context, String postId) async {
    try {
      await _firestore.collection('Posts').doc(postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post deleted successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting post: $e")),
      );
    }
  }

  Future<void> handleRefresh() async {
    await _fetchMyPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: text("My Products", 22, Colors.black, FontWeight.bold),
        centerTitle: true,
      ),
      body: LiquidPullToRefresh(
        onRefresh: handleRefresh,
        color: Colors.white,
        backgroundColor: Colors.black,
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        child: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: _fetchMyPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No products found."));
            }

            final posts = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate the number of columns based on screen width
                  int crossAxisCount = (constraints.maxWidth / 200).floor();
                  crossAxisCount = crossAxisCount < 4 ? 2 : crossAxisCount;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          crossAxisCount, // Set dynamic number of columns
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 18.0,
                      childAspectRatio:
                          0.75, // Adjust aspect ratio for item proportions
                    ),
                    itemCount: posts.length,
                    scrollDirection: Axis.vertical, // Vertical scrolling
                    itemBuilder: (context, index) {
                      var post = posts[index];
                      return _buildPostItem(post, context);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostItem(QueryDocumentSnapshot post, context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductScreen(id: post.id, post: post)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Image.network(
              post["image_url"] ?? "",
              width: double.infinity,
              height: 185,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            post["title"] ?? "No Title",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          text("Price: \$${post["price"] ?? "N/A"}", 15, Colors.black,
              FontWeight.bold),
        ],
      ),
    );
  }

  // void _showDeleteDialog(BuildContext context, String postId) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Delete Post"),
  //         content: const Text("Are you sure you want to delete this post?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               _deletePost(context, postId);
  //             },
  //             child: const Text("Delete"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
