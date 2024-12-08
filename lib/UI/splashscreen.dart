import 'package:fire/notification/notification.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/widget/splashwidget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Splash _splashScreen = Splash();
  NotificationRequest notifications = NotificationRequest();
  @override
  void initState() {
    super.initState();
    _initializeSplashScreen();
  }

  void _initializeSplashScreen() async {
    notifications.requestNotificationPermission();

    // GetServices().getServerKey();
    // FirebaseMessaging.instance.deleteToken();
    notifications.setupInteractNotifications(context);

    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    _splashScreen.login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/screeen.avif"),
                  fit: BoxFit.cover)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text("Welcome to ABD store", 20, Colors.white, FontWeight.w800),
                text("The home for sports", 14, Colors.white, FontWeight.w600),
              ],
            ),
          ),
        )
      ],
    );
  }
}
