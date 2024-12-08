import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/UI/ui_screens/all_post.dart';
import 'package:fire/auth/api_services.dart';
import 'package:fire/notification/notification.dart';
import 'package:fire/provider/product_provider.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire/auth/login.dart';
import 'package:fire/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, String? idToken});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection("Posts");
  final fireStore = FirebaseFirestore.instance.collection("Posts").snapshots();
  bool isLoading = false;

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1605902711622-cfb43c4437b5?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1616124619460-ff4ed8f4683c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vdGJhbGwlMjBzaGlydHxlbnwwfHwwfHx8MA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1684785617085-3a875d81920f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGVjb21tZXJjZXxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fGZvb3RiYWxsJTIwa2l0fGVufDB8fDB8fHww',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts()
          .then((_) {});
      NotificationRequest().getTokenInitialize();
      NotificationRequest().flutterPlugin(context);
    });
  }

  Future<void> handleRefresh() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  Widget buildCarousel() {
    return CarouselSlider(
      items: imgList.map((item) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            item,
            fit: BoxFit.cover,
            width: 1000,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
    );
  }

  Widget buildIconColumn(String image, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(image, width: 40, height: 40),
        const SizedBox(height: 8),
        Text(label,
            style: GoogleFonts.roboto(fontSize: 12, color: Colors.black)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'ABD Store',
          style: GoogleFonts.prata(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Do you really want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await ApiService().logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          } catch (error) {
                            Utilred()
                                .fluttertoastmessage("Logout failed: $error");
                          }
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.black),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LiquidPullToRefresh(
              onRefresh: handleRefresh,
              color: Colors.white,
              backgroundColor: Colors.black,
              animSpeedFactor: 2,
              showChildOpacityTransition: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildIconColumn("assets/icons/male.png", "Male"),
                          buildIconColumn("assets/icons/female.png", "Female"),
                          buildIconColumn(
                              "assets/icons/glasses.png", "Glasses"),
                          buildIconColumn("assets/icons/makeup.png", "MakeUp"),
                        ],
                      ),
                      const SizedBox(height: 37),
                      buildCarousel(),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("Featured Products", 20, Colors.black,
                              FontWeight.bold),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllPost()));
                              },
                              child: text("Show All", 15, Colors.grey,
                                  FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Consumer<ProductProvider>(
                          builder: (context, postProvider, child) {
                        if (postProvider.isLoading) {
                          return buildShimmerEffect();
                        }
                        if (postProvider.error != null) {
                          return Center(
                              child: Text("Error: ${postProvider.error}"));
                        }
                        var limitedPost =
                            postProvider.products!.take(5).toList();
                        if (postProvider.products == null ||
                            postProvider.products!.isEmpty) {
                          return const Center(
                              child: Text("No Products Available"));
                        }
                        if (limitedPost.isEmpty) {
                          return const Center(
                              child: Text("No Products Available"));
                        }
                        return buildPostList(postProvider.products!);
                      }),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
