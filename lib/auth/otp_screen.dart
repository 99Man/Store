import 'package:fire/utils/text.dart';
import 'package:flutter/material.dart';

void showOTPDialogBox(
    {required BuildContext context,
    required TextEditingController codeController,
    bool loading = false,
    required VoidCallback onpressed}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: const Text("Enter OTP"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: codeController,
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: onpressed,
                  child: text("Done", 15, Colors.black, FontWeight.w800))
            ],
          ));
}
