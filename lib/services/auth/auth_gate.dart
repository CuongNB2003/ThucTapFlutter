import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thuc_tap_flutter/services/auth/login_or_register.dart';
import 'package:thuc_tap_flutter/views/screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // trang thai user da dang nhap
          if(snapshot.hasData) {
            return const HomeScreen();
          }
          // trang thai user chua dang nhap
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
