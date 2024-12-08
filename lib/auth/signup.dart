// import 'package:fire/UI/auth/login.dart';
// import 'package:fire/UI/ui_screens/verify_by_phone.dart';
// import 'package:fire/provider/auth_provider.dart';
// import 'package:fire/utils/utils.dart';
// import 'package:fire/widget/button.dart';
// import 'package:fire/widget/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _formkey = GlobalKey<FormState>();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   bool loading = false;

//   @override
//   void dispose() {
//     super.dispose();
//     _email.dispose();
//     _password.dispose();
//   }

//   void signUp(BuildContext context) async {
//     setState(() {
//       loading = true;
//     });

//     if (_formkey.currentState!.validate()) {
//       // Use the AuthProvider to sign up
//       await Provider.of<AuthProvider>(context, listen: false).signUp(
//         _email.text.trim(),
//         _password.text.trim(),

//       );

//       final user = Provider.of<AuthProvider>(context, listen: false).user;
//       if (user != null) {
//         Utilgreen().fluttertoastmessage("SignUp successfully");
//       } else {
//         Utilred().fluttertoastmessage("Error signing up");
//       }

//       setState(() {
//         loading = false;
//       });
//     } else {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(vertical: 200),
//         child: Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 child: Column(
//                   children: [
//                     Text(
//                       "CREATE",
//                       style: GoogleFonts.prata(
//                           fontSize: 25, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       "YOUR ACCOUNT",
//                       style: GoogleFonts.prata(
//                           fontSize: 25, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               Form(
//                   key: _formkey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextFormField(
//                         keyboardType: TextInputType.emailAddress,
//                         controller: _email,
//                         decoration: const InputDecoration(
//                             prefixIcon: Icon(Icons.email),
//                             hintText: "Email",
//                             helperText: "Enter Email e.g email@gmail.com"),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Enter Email";
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         keyboardType: TextInputType.text,
//                         obscureText: true,
//                         controller: _password,
//                         decoration: const InputDecoration(
//                           prefixIcon: Icon(Icons.password),
//                           hintText: "Password",
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Enter Password";
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   )),
//               const SizedBox(
//                 height: 50,
//               ),
//               Button(
//                 loading: loading,
//                 title: "Sign up",
//                 onTap: () {
//                   signUp(context);
//                 },
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//
//                   }),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Already have an account ?"),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const Login()));
//                     },
//                     child: const Text(
//                       "Login",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:fire/auth/login.dart';
import 'package:fire/auth/verify_by_phone.dart';
import 'package:fire/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fire/provider/auth_provider.dart';
import 'package:fire/widget/button.dart';
import 'package:fire/utils/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loading = false;
  String userRole = 'Buyer'; // Default role is 'user'

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  void signUp(BuildContext context) async {
    setState(() {
      loading = true;
    });

    if (_formkey.currentState!.validate()) {
      await Provider.of<AuthProvider>(context, listen: false).signUp(
        _email.text.trim(),
        _password.text.trim(),
        userRole,
      );

      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        setState(() {
          loading = false;
        });
        Utilgreen().fluttertoastmessage("SignUp successfully");
      } else {
        setState(() {
          loading = false;
        });
        Utilred().fluttertoastmessage("Error signing up");
      }

      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 200),
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
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: userRole,
                      onChanged: (String? newRole) {
                        setState(() {
                          userRole = newRole!;
                        });
                      },
                      items: <String>['Buyer', 'Seller']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Button(
                loading: loading,
                title: "Sign up",
                onTap: () {
                  signUp(context);
                },
              ),
              const SizedBox(height: 12),
              GoogleButton(context),
              const SizedBox(
                height: 12,
              ),
              NetworkImageButton(
                  icon: Icons.phone,
                  buttonText: "SignUp with phone number",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerifyByPhone()));
                  }),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
