import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '/services/notification/notification_services.dart';

class AuthService extends ChangeNotifier {
  // instanse of auth
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final notificationService = NotificationsService();

  // su ly dang nhap
  Future<UserCredential> signInWithEmailAndPassword(String email,
      String pass) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'status': true,
        'selected': false,
        'avata':
        'https://www.vietnamfineart.com.vn/wp-content/uploads/2023'
            '/03/hinh-anh-co-gai-cute-anime-8-min-4.jpg',
      }, SetOptions(merge: true));
      await notificationService.requestPermission();
      await notificationService.getToken();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // tạo tài khoản mới
  Future<UserCredential> signUpWithEmailAndPassword(String email, String pass,
      String name) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      // lưu user vào db
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'status': true,
        'name': name,
        'selected': false,
        'avata':
        'https://www.vietnamfineart.com.vn/wp-content/uploads/'
            '2023/03/hinh-anh-co-gai-cute-anime-8-min-4.jpg'
      });
      await notificationService.requestPermission();
      await notificationService.getToken();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sử lý đăng xuất
  Future<void> signOut() async {
    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      "status": false,
    });
    return await FirebaseAuth.instance.signOut();
  }
}
