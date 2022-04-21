// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

dynamic serverKey = "AAAAmV26y_A:APA91bFxu49TgLwaFAzmbGJx2PYrjj-8OKGUBy02WoCPhfrqhCgLUcfIXgbDmPb2wMypHf151ukofi32BXUX9g4HpV_y6x6uDY23CThHmPgX4sH92m1Z8J_idCX5oy0gHDZk-QA6kOgs";

class FCMServices {
  static fcmGetTokenandSubscribe(topic) {
    FirebaseMessaging.instance.getToken().then((value) {
      FirebaseMessaging.instance.subscribeToTopic("$topic");
    });
  }

  static Future<http.Response> sendFCM(topic, id, title, description) {
    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "key=$serverKey",
      },
      body: jsonEncode({
        "to": "/topics/$topic",
        "notification": {
          "title": title,
          "body": description,
        },
        "mutable_content": true,
        "content_available": true,
        "priority": "high",
        "data": {
          "android_channel_id": "Gylac",
          "id": id,
          "userName": "ali",
        }
      }),
    );
  }
}
