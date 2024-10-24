// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fire/UI/ui_screens/product_screen.dart';
// import 'package:fire/firestore/adddatatofirestore.dart';
// import 'package:fire/utils/sized.dart';
// import 'package:fire/utils/text.dart';
// import 'package:fire/widget/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fire/UI/auth/login.dart';
// import 'package:fire/utils/utils.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Fetchdatafromfirestore extends StatefulWidget {
//   const Fetchdatafromfirestore({super.key, String? idToken});

//   @override
//   State<Fetchdatafromfirestore> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<Fetchdatafromfirestore> {
//   final auth = FirebaseAuth.instance;
//   CollectionReference ref = FirebaseFirestore.instance.collection("Posts");
//   final fireStore = FirebaseFirestore.instance.collection("Posts").snapshots();

//   final List<String> imgList = [
//     'https://images.unsplash.com/photo-1605902711622-cfb43c4437b5?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     'https://images.unsplash.com/photo-1643906226799-59eab234e41d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGVjb21tZXJjZXxlbnwwfHwwfHx8MA%3D%3D',
//     'https://plus.unsplash.com/premium_photo-1684785617085-3a875d81920f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGVjb21tZXJjZXxlbnwwfHwwfHx8MA%3D%3D',
//     'https://plus.unsplash.com/premium_photo-1684179639963-e141ce2f8074?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGVjb21tZXJjZXxlbnwwfHwwfHx8MA%3D%3D',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     print("Rebuild");
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Firestore',
//           style: GoogleFonts.prata(fontWeight: FontWeight.bold, fontSize: 25),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               auth.signOut().then((value) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => Login()),
//                 );
//               }).onError((error, stacktrace) {
//                 Utils().fluttertoastmessage(error.toString());
//               });
//             },
//             icon: const Icon(Icons.logout_outlined, color: Colors.black),
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: fireStore,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return buildShimmerEffect();
//           }
//           if (snapshot.hasError) {
//             Utils().fluttertoastmessage("Some Error Occurred");
//             return const Center(child: Text("Error occurred"));
//           }

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: Column(
//                 children: <Widget>[
//                   const SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       buildIconColumn("assets/icons/male.png", "Male"),
//                       buildIconColumn("assets/icons/female.png", "Female"),
//                       buildIconColumn("assets/icons/glasses.png", "Glasses"),
//                       buildIconColumn("assets/icons/makeup.png", "MakeUp"),
//                     ],
//                   ),
//                   const SizedBox(height: 37),
//                   CarouselSlider(
//                     items: imgList.map((item) {
//                       return Container(
//                         width: getWidth(context),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(30),
//                           child: Image.network(
//                             item,
//                             fit: BoxFit.cover,
//                             width: 1000,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     options: CarouselOptions(
//                       height: 200.0,
//                       enlargeCenterPage: true,
//                       autoPlay: true,
//                       autoPlayInterval: const Duration(seconds: 3),
//                       aspectRatio: 16 / 9,
//                       viewportFraction: 0.8,
//                     ),
//                   ),
//                   const SizedBox(height: 35),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       text("Feature Products", 20, Colors.black,
//                           FontWeight.bold),
//                       text("Show All", 12, const Color(0xFF9B9B9B),
//                           FontWeight.bold)
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               ProductScreen(snapshot.data!.docs),
//                         ),
//                       );
//                     },
//                     child: buildPostList(snapshot.data!.docs),
//                   ),
//                   SizedBox(
//                     height: 100,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const Adddatatofirestore()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Column buildIconColumn(String imagePath, String label) {
//     return Column(
//       children: [
//         Image.asset(imagePath, fit: BoxFit.cover, width: 42, height: 41),
//         const SizedBox(height: 6),
//         text(label, 12, Colors.black, FontWeight.w400),
//       ],
//     );
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/UI/ui_screens/product_screen.dart';
import 'package:fire/firestore/adddatatofirestore.dart';
import 'package:fire/utils/sized.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire/UI/auth/login.dart';
import 'package:fire/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class Fetchdatafromfirestore extends StatefulWidget {
  const Fetchdatafromfirestore({super.key, String? idToken});

  @override
  State<Fetchdatafromfirestore> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Fetchdatafromfirestore> {
  final auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection("Posts");
  final fireStore = FirebaseFirestore.instance.collection("Posts").snapshots();

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1605902711622-cfb43c4437b5?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1643906226799-59eab234e41d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGVjb21tZXJjZXxlbnwwfHwwfHx8MA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1684785617085-3a875d81920f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGVjb21tZXJjZXxlbnwwfHwwfHx8MA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1684179639963-e141ce2f8074?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGVjb21tZXJjZXxlbnwwfHwwfHx8MA%3D%3D',
  ];

  @override
  Widget build(BuildContext context) {
    print("Rebuild");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Firestore',
          style: GoogleFonts.prata(fontWeight: FontWeight.bold, fontSize: 25),
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
                Utils().fluttertoastmessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.black),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildShimmerEffect(); 
          }
          if (snapshot.hasError) {
            Utils().fluttertoastmessage("Some Error Occurred");
            return const Center(child: Text("Error occurred"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Products Available"));
          }

          return SingleChildScrollView(
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
                      buildIconColumn("assets/icons/glasses.png", "Glasses"),
                      buildIconColumn("assets/icons/makeup.png", "MakeUp"),
                    ],
                  ),
                  const SizedBox(height: 37),
                  CarouselSlider(
                    items: imgList.map((item) {
                      return Container(
                        width: getWidth(context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                            width: 1000,
                          ),
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
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("Featured Products", 20, Colors.black,
                          FontWeight.bold),
                      text("Show All", 12, const Color(0xFF9B9B9B),
                          FontWeight.bold)
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductScreen(snapshot.data!.docs),
                        ),
                      );
                    },
                    child: buildPostList(snapshot.data!.docs),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Adddatatofirestore()),
          );
        },
        child: const Icon(Icons.add),
      ),
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

  Widget buildPostList(List<QueryDocumentSnapshot<Object?>> docs) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        var data = docs[index].data() as Map<String, dynamic>;
        
        return ListTile(
          title: Text(data['title'] ?? 'No Title'), 
          subtitle: Text(data['description'] ??
              'No Description'), 
          leading: Image.network(data['image_url'] ??
              'Default Image URL'), 
        );
      },
    );
  }
}
