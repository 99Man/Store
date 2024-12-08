import 'dart:convert';

import 'package:fire/notification/services/get_services.dart';
import 'package:http/http.dart' as http;

class PushNotifications {
  static Future<void> getPushNotificaitons({
    
    required String title,
    required String body,
    required Map<String, dynamic> data,
    required String? receiverId,
    required String? senderId,
  }) async {
    String serverKey = await GetServices().getServerKey();
    String url =
        "https://fcm.googleapis.com/v1/projects/testing-39754/messages:send";
    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };
    Map<String, dynamic> message = {
      "message": {
        "token": receiverId,
        "notification": {"title": title, "body": body},
      }
    };
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(message));
    if (response.statusCode == 200) {
      // Utilgreen().fluttertoastmessage("Notification is send successfully");
    } else {
      // Utilred().fluttertoastmessage(
      // "There is some issue in sending the notification");
    }
  }
}
