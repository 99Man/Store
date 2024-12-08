import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoleSelectionScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Role'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Please choose your role:'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateUserRole('Buyer');
                Navigator.pop(context); // Navigate back after role selection
              },
              child: Text('Buyer'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateUserRole('Seller');
                Navigator.pop(context); // Navigate back after role selection
              },
              child: Text('Seller'),
            ),
          ],
        ),
      ),
    );
  }

  // Store the selected role in Firestore
  Future<void> _updateUserRole(String role) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'role': role, // Store role in Firestore
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error saving user role: $e");
    }
  }
}
