import 'package:fire/utils/text.dart';
import 'package:fire/widget/splashwidget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Splash _splashScreen = Splash();

  @override
  void initState() {
    super.initState();
    _splashScreen.login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1586880244386-8b3e34c8382c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGVjb21tZXJjZXxlbnwwfHwwfHx8MA%3D%3D"),
              fit: BoxFit.cover, 
            ),
          ),
        ),
        Scaffold(
          backgroundColor:
              Colors.transparent, 
          body: Align(
            alignment: Alignment
                .center, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, 
              children: [
                text("Welcome to ABD store", 20, Colors.black, FontWeight.w800),
                text(
                    "The home for a sports", 14, Colors.black, FontWeight.w600),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
