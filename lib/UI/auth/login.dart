import 'package:fire/UI/auth/signup.dart';
import 'package:fire/firestore/fetchdatafromfirestore.dart';
import 'package:fire/provider/auth_provider.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/widget/button.dart';
import 'package:fire/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  void login() async {
    setState(() {
      loading = true;
    });

    if (_formkey.currentState!.validate()) {
      try {
        // Use the AuthProvider to sign in
        await Provider.of<AuthProvider>(context, listen: true)
            .signInWithEmailAndPassword(_email.text, _password.text);
        Utilgreen().fluttertoastmessage("Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Fetchdatafromfirestore()),
        );
      } catch (error) {
        Utilred().fluttertoastmessage("Authentication failed: $error");
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild login");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    "LOG INTO",
                    style: GoogleFonts.prata(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "YOUR ACCOUNT",
                    style: GoogleFonts.prata(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 19),
            Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email",
                      helperText: "Enter Email e.g email@gmail.com",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: _password,
                    decoration: const InputDecoration(
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
              ),
            ),
            const SizedBox(height: 50),
            Button(
              loading: loading,
              title: "Login",
              onTap: () {
                login();
              },
            ),
            SizedBox(
              height: 20,
            ),
            GoogleButton(context),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
