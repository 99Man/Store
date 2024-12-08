import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/UI/admin_screens/bottom_nav_admin.dart';
import 'package:fire/UI/user_screens/bottom_nav_user.dart';
import 'package:fire/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TextEditingController _codeController = TextEditingController();
  // TextEditingController _phone = TextEditingController();

  User? get user => _user;

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      // ignore: use_build_context_synchronously
      checkUserRole(context);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utilred().fluttertoastmessage("No user found for that email");
        throw "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        Utilred()
            .fluttertoastmessage("Incorrect password provided for that user.");
        throw "Incorrect password provided for that user.";
      } else {
        throw "Error signing in: $e";
      }
    } catch (e) {
      throw "An unexpected error occurred.";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String userRole) async {
    try {
      // Create the user with Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After user is created, add the user role to Firestore
      await _firestore.collection('User').doc(userCredential.user?.uid).set({
        'email': email,
        'role': userRole, // Store the role (Buyer or Seller)
        'createdAt': FieldValue.serverTimestamp(),
      });

      // You can also add custom claims if you need role-based access control (optional)
      // Firebase Admin SDK is needed for this part, which can be done server-side

      notifyListeners(); // Notify listeners after sign-up
    } catch (e) {
      throw Exception("Error signing up: $e");
    }
  }

  Future<void> makeAdmin(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'role': 'admin',
    });
  }

  // Future phoneVerify(context)async{
  //   if (_phone.text.isEmpty) {
  //                     Utilred()
  //                         .fluttertoastmessage("Phone number cannot be empty.");
  //                     // return;
  //                   }
  //                   // setState(() {
  //                   //   loading = true;
  //                   // });
  //                   await _auth.verifyPhoneNumber(
  //                     phoneNumber: _phone.text,
  //                     verificationCompleted:
  //                         (PhoneAuthCredential credential) async {
  //                       // setState(() {
  //                       //   loading = false;
  //                       // });
  //                       await _auth.signInWithCredential(credential);
  //                       Utilgreen().fluttertoastmessage(
  //                           "Phone verification completed automatically");
  //                     },
  //                     verificationFailed: (error) {
  //                       // setState(() {
  //                       //   loading = false;
  //                       // });
  //                       print(error.message);
  //                       if (error.code == 'invalid-phone-number') {
  //                         Utilred().fluttertoastmessage(
  //                             "The phone number entered is invalid.");
  //                       } else if (error.code == 'quota-exceeded') {
  //                         Utilred().fluttertoastmessage(
  //                             "SMS quota exceeded. Try again later.");
  //                       } else {
  //                         Utilred().fluttertoastmessage(
  //                             error.message ?? "Verification failed.");
  //                       }
  //                     },
  //                     codeSent:
  //                         (String verificationId, int? forceResendingToken) {
  //                       showOTPDialogBox(
  //                           context: context,
  //                           codeController: _codeController,
  //                           onpressed: () async {
  //                             PhoneAuthCredential phoneAuth =
  //                                 PhoneAuthProvider.credential(
  //                                     verificationId: verificationId,
  //                                     smsCode: _codeController.text.trim());
  //                             await _auth.signInWithCredential(phoneAuth);
  //                             Navigator.pop(context);
  //                         }
  //                       );
  //                       // setState(() {
  //                       //   loading = false;
  //                       // });
  //                       print("Code Sent : ${verificationId}");

  //                       Utilgreen()
  //                           .fluttertoastmessage("OTP sent to ${_phone.text}");
  //                     },
  //                     codeAutoRetrievalTimeout: (verificationId) {
  //                       // setState(() {
  //                       //   loading = false;
  //                       // });
  //                       Utilred().fluttertoastmessage("Auto Retrival timeout");
  //                     },
  //                   );
  // }

  Future<void> checkUserRole(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    print("User Id : ${user!.uid.toString()}");

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();
      if (kDebugMode) {
        print("UserDoc full detail of User : ${userDoc.data()}");
      }

      String role = userDoc['role'];
      if (role == 'Seller') {
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => const NechanavigationAdmin()));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Nechanavigation()));
      }
    }
  }
}
