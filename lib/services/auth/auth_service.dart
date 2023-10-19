import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier{
  // instanse of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // su ly dang nhap
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String pass) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      // lưu user vào db
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid' : userCredential.user!.uid,
        'email' : email,
      }, SetOptions(merge: true));

      return userCredential;


    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // tạo tài khoản mới
  Future<UserCredential> signUpWithEmailAndPassword(String email, String pass) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
      );

      // lưu user vào db
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid' : userCredential.user!.uid,
        'email' : email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sử lý đăng xuất
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}