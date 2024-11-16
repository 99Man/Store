import 'package:fire/firestore/fetchdatafromfirestore.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/widget/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.verificationid});
  final String verificationid;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController _otp = TextEditingController();
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: text("Enter Your OTP", 18, Colors.black, FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _otp,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: "Enter your OTP",
                    helperText: "OTP is send to your given number"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Email";
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
                    setState(() {
                      loading = true;
                    });
                    try {
                      final cred = PhoneAuthProvider.credential(
                          verificationId: widget.verificationid,
                          smsCode: _otp.text);
                      await auth.signInWithCredential(cred);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Fetchdatafromfirestore()));
                      setState(() {
                        loading = false;
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      Utilred().fluttertoastmessage(e.toString());
                      print(e.toString());
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                  title: "Verify")
            ]),
      ),
    );
  }
}
