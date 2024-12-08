import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/auth/login.dart';
import 'package:fire/UI/admin_screens/bottom_nav_admin.dart';
import 'package:fire/UI/user_screens/bottom_nav_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Splash {
  void login(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      final userid = user.uid;
      try {
        final userSnapshot = await FirebaseFirestore.instance
            .collection("User")
            .doc(userid)
            .get();
        if (userSnapshot.exists) {
          // final userData = userSnapshot.data();

          final role = userSnapshot["role"];

          if (role == "Seller") {
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NechanavigationAdmin())));
          } else if (role == "Buyer") {
            Timer(const Duration(seconds: 3), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Nechanavigation()));
            });
          } else {
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login())));
          }
        } else {
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login())));
        }
      } catch (e) {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login())));
      }
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login())));
    }
  }
}
