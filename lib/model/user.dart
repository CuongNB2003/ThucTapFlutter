import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  final String name;
  final String email;
  final String token;
  final String uid;
  bool selected;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.token,
    this.selected = false,
  });

  bool get isSelected => selected;

  set isSelected(bool value) {
    selected = value;
    notifyListeners();
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      token: map['token'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
    );
  }
}
