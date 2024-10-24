import 'package:fire/UI/auth/login.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/widget/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  void signUp() {
    setState(() {
      loading = true;
    });
    if (_formkey.currentState!.validate()) {}
    _auth
        .createUserWithEmailAndPassword(
            email: _email.text.toString(), password: _password.text.toString())
        .then((value) async {
      setState(() {
        loading = false;
      });
      String idToken = await _auth.currentUser!.getIdToken() ?? '';
      Utils().fluttertoastmessage("User ID Token: $idToken");
      Utils().fluttertoastmessage("SignUp successfully");
    }).onError((error, stackTrace) {
      Utils().fluttertoastmessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 200),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    "CREATE",
                    style: GoogleFonts.prata(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "YOUR ACCOUNT",
                    style: GoogleFonts.prata(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: "Email",
                          helperText: "Enter Email e.g email@gmail.com"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: _password,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        hintText: "Password",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            Button(
                loading: loading,
                title: "Sign up",
                onTap: () {
                  signUp();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account ?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
