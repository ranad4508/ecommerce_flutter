import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:admin_web_app/Models/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class PushNotificationFunction {
  // for sending push notification
  static Future<void> sendPushNotification(
      String title, String msg, String token) async {
    try {
      final body = {
        "to": token,
        "notification": {
          "title": title, //our name should be send
          "body": msg,
          //  "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };
      // ignore: avoid_print
      print(body);
      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Key=AAAA1bDtpf8:APA91bGiJxl8SKRxl4svBLf2THKJvgZ_BckGBVVr2lav22jTegN71vAhkvbJchcR39JIlG8quQVramrrlESnFubyU-16bhWiTA4HotiVe17Pc_dyDtgwda8nAyH79wF1-SCGmR5uHHQQ'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');

      // ignore: avoid_print
      print('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  sendFirebaseNotification(
      NotificationsModel notificationsModel, String userID, String uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Notifications')
        .doc(uid)
        .set(notificationsModel.toMap());
  }
}
