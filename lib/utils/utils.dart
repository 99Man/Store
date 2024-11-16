import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utilred {
  void fluttertoastmessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 15,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
class Utilgreen {
  void fluttertoastmessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 15,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
