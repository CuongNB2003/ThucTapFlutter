import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thuc_tap_flutter/services/auth/auth_gate.dart';
import 'package:thuc_tap_flutter/services/auth/auth_service.dart';
import 'package:thuc_tap_flutter/services/firebase_options.dart';
import 'package:thuc_tap_flutter/views/resources/color.dart';


Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thực Tập Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.themeColor),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
