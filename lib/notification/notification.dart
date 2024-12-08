import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/UI/admin_screens/view_user_order.dart';
import 'package:fire/UI/user_screens/view_orders.dart';
import 'package:fire/auth/login.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/utils/variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationRequest {
  FirebaseMessaging notification = FirebaseMessaging.instance;

  // String userId = FirebaseAuth.instance.currentUser!.uid;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidNotifications =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosNotifications = const DarwinInitializationSettings();

    var initilizationSetting = InitializationSettings(
      android: androidNotifications,
      iOS: iosNotifications,
    );

    await _flutterLocalNotificationsPlugin.initialize(initilizationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void flutterPlugin(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print("Hello notication is received successfully");
      initLocalNotifications(context, message);
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(),
        "High Importance Notification",
        importance: Importance.high);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      importance: Importance.high,
      channelDescription: "Your Channel Decription",
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
      ticker: "ticker",
    );

    DarwinNotificationDetails iosNotificaionDetail =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificaionDetail);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
          payload: message.data["screen"] ?? "default");
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await notification.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        // provisional: true,
        carPlay: true,
        announcement: true,
        criticalAlert: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Utilgreen().fluttertoastmessage("Authorization is granted by User");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Utilgreen()
          .fluttertoastmessage("Provisional Authorization is granted by User");
    } else {
      AppSettings.openAppSettings();
      Utilred().fluttertoastmessage("Permission is not granted");
    }
  }

  static Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token!;
  }

  Future<String?> sendDeviceToken(String userId, String deviceToken) async {
    try {
      FirebaseFirestore.instance.collection("User").doc(userId).set({
        "deviceToken": devicetoken,
      }, SetOptions(merge: true));
      // Utilgreen().fluttertoastmessage("Device token is saved successfully");
    } catch (e) {
      Utilred().fluttertoastmessage(
          "There is some error fetching the device token: $e");
    }
    return deviceToken;
  }

  void isTokenRefresh() {
    notification.onTokenRefresh.listen((newtoken) async {
      devicetoken = newtoken;
      await sendDeviceToken(
          FirebaseAuth.instance.currentUser!.uid, devicetoken!);

      Utilgreen()
          .fluttertoastmessage("Token is refresh: ${newtoken.toString()}");
      print("Token is refresh");
    }, onError: (error) {
      Utilred().fluttertoastmessage(
          "Token is not refreshed due to some error : $error");
    });
  }

  Future<String?> getSellerField(String sellerId) async {
    String? sellertoken;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot sellerdata =
          await _firestore.collection("User").doc(sellerId).get();
      if (sellerdata.exists) {
        sellertoken = sellerdata["deviceToken"];
        // Utilgreen().fluttertoastmessage(
        //     "The token of the seller device: ${receiverId!}");
      }
    } catch (e) {
      Utilred().fluttertoastmessage("Some issue occured: $e");
    }
    return sellertoken;
  }

  Future<void> sendPushNotification(
      String senderId, String receivertoken, String title, String body) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;

    if (receivertoken.isNotEmpty) {
      try {
        await FirebaseMessaging.instance.sendMessage(to: receivertoken, data: {
          "title": title,
          "body": body,
        });
        Utilgreen().fluttertoastmessage("Notification send");
      } catch (e) {
        Utilred().fluttertoastmessage("There is some error !!!");
      }
    } else {
      Utilred().fluttertoastmessage("Receiver token is not available");
    }
  }

  Future<void> setupInteractNotifications(BuildContext context) async {
    RemoteMessage? initializeApp =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initializeApp != null) {
      handleMessage(context, initializeApp);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  Future<String?> getTokenInitialize() async {
    await getDeviceToken().then((value) {
      if (kDebugMode) {
        print("Device Token: $value");
      }

      devicetoken = value;
      NotificationRequest().sendDeviceToken(
          FirebaseAuth.instance.currentUser!.uid, devicetoken!);
      // Utilgreen().fluttertoastmessage(devicetoken!);
    });
    return devicetoken!;
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    User? user = FirebaseAuth.instance.currentUser;
    String screen = message.data["screen"] ?? "default";
    if (user == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else if (message.data["type"] == "placed order") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewUserOrders(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                  )));
    }
    // if (screen == "cart") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => CartScreen(
    //                 documentId: FirebaseAuth.instance.currentUser!.uid,
    //               )));
    // }
    if (screen == "order") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewOrders(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                  )));
    }
  }
}
