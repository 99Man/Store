import 'package:fire/UI/admin_screens/admin_screen.dart';
import 'package:fire/auth/otp_screen.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/widget/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyByPhone extends StatefulWidget {
  const VerifyByPhone({super.key});

  @override
  State<VerifyByPhone> createState() => _VerifyByPhoneState();
}

class _VerifyByPhoneState extends State<VerifyByPhone> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    _phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            text("Verify by Phone Number", 18, Colors.black, FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phone,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: "Verify my phone number",
                    helperText: "Enter number e.g: +123456789"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Phone Number";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Button(
                  loading: loading,
                  onTap: () async {
                    if (_phone.text.isEmpty) {
                      Utilred()
                          .fluttertoastmessage("Phone number cannot be empty.");
                      return;
                    }
                    setState(() {
                      loading = true;
                    });
                    await auth.verifyPhoneNumber(
                      phoneNumber: _phone.text.trim(),
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        setState(() {
                          loading = false;
                        });
                        await auth.signInWithCredential(credential);
                        Utilgreen().fluttertoastmessage(
                            "Phone verification completed automatically");
                      },
                      verificationFailed: (error) {
                        setState(() {
                          loading = false;
                        });
                        print(error.message);
                        if (error.code == 'invalid-phone-number') {
                          Utilred().fluttertoastmessage(
                              "The phone number entered is invalid.");
                        } else if (error.code == 'quota-exceeded') {
                          Utilred().fluttertoastmessage(
                              "SMS quota exceeded. Try again later.");
                        } else {
                          Utilred().fluttertoastmessage(
                              error.message ?? "Verification failed.");
                        }
                      },
                      codeSent:
                          (String verificationId, int? forceResendingToken) {
                        showOTPDialogBox(
                            context: context,
                            codeController: _codeController,
                            loading: loading,
                            onpressed: () async {
                              PhoneAuthCredential phoneAuth =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: _codeController.text.trim());
                              await auth.signInWithCredential(phoneAuth);
                              Navigator.pop(context);
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminScreen()));
                            });
                        setState(() {
                          loading = false;
                        });
                        print("Code Sent : ${verificationId}");

                        Utilgreen()
                            .fluttertoastmessage("OTP sent to ${_phone.text}");
                      },
                      codeAutoRetrievalTimeout: (verificationId) {
                        setState(() {
                          loading = false;
                        });
                        Utilred().fluttertoastmessage("Auto Retrival timeout");
                      },
                    );
                  },
                  title: "Verify")
            ]),
      ),
    );
  }
}
