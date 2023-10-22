import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier{
  // instanse of auth
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;
  // su ly dang nhap
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String pass) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final fCMToken = await _firebaseMessaging.getToken();
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid' : userCredential.user!.uid,
        'email' : email,
        'status' : true,
        'fCMToken' : fCMToken,
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // tạo tài khoản mới
  Future<UserCredential> signUpWithEmailAndPassword(String email, String pass, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
      );
      final fCMToken = await _firebaseMessaging.getToken();
      // lưu user vào db
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid' : userCredential.user!.uid,
        'email' : email,
        'status' : true,
        'name' : name,
        'fCMToken' : fCMToken,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sử lý đăng xuất
  Future<void> signOut() async {
    await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).update({
      "status": false,
    });
    return await FirebaseAuth.instance.signOut();
  }
}