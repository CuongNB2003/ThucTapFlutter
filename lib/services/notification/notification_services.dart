import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thuc_tap_flutter/views/screens/chat/chat_screen.dart';

const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Hign Importance Notifications',
    description:
    'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('id người nhận: ${message.data['senderId']}');
  }

// Lưu senderId vào SharedPreferences.
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('senderId', message.data['senderId']);
}

class NotificationsService {
  static const key =
      'AAAAHCp0Nao:APA91bGHrpEYG3ulwPvrpgt_2kQDeNTMciggBmwOuI-F1bWJVqWDQUo1ZtJCVnZIsZN47Or0w_K_Q1mebbhxsJLMSASUwfdXOQvPNxgH3M0u6yNscEjyzF46-NSF6_zEvNvV2B6JZNHJ';
  // thông báo cục bố
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // tạo thong báo cục bộ
  void _initLocalNotification() async {
    var androidSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (response) {
        debugPrint(response.payload.toString());
      },
    );
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );

    final androidDetails = AndroidNotificationDetails(
      'com.example.thuc_tap_flutter.urgent',
      'mychannelid',
      importance: Importance.max,
      styleInformation: styleInformation,
      priority: Priority.max,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: message.data['body'],
    );
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async =>
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));

  String receiverToken = '';
  // lấy địa token người nhận
  Future<void> getReceiverToken(String? receiverId) async {
    final getToken = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();

    receiverToken = await getToken.data()!['token'];
  }

  void firebaseNotification(context) {
    _initLocalNotification();

    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              ChatScreen(receiveUserID: message.data['senderId']),
        ),
      );
    });

    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) async {
      await showLocalNotification(message);
    });
  }

  // gửi thông báo cho người nhận
  Future<void> sendNotification(
      {required String title,
      required String senderId,
      required String content}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key',
        },
        body: jsonEncode(<String, dynamic>{
          "to": receiverToken,
          'priority': 'high',
          'notification': <String, dynamic>{
            'body': content,
            'title': title, // có thể đổi thành tên người gửi ở đây
          },
          'data': <String, String>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'senderId': senderId,
          }
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
