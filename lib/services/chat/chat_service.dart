import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:thuc_tap_flutter/model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final docSnapshot = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    // lấy thông tin người dùng hiện tại
    final String currenUserId = _firebaseAuth.currentUser!.uid;
    final String currenUserEmail = _firebaseAuth.currentUser!.email.toString();
    final String currenUserName = docSnapshot['name'];
    final int timestamp = DateTime.now().microsecondsSinceEpoch;

    // tạo tin nhắn mới
    Message newMessage = Message(
      senderId: currenUserId,
      senderEmail: currenUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
      senderName: currenUserName,
    );
    // xây dựng id phòng trò chuyện từ id người dùng và id người nhận hiện tại (được sắp xếp để đảm bảo tính duy nhất)
    List<String> ids = [currenUserId, receiverId];
    ids.sort(); // sắp xếp ids
    String chatRoomId = ids.join('_'); //kết hợp 2 id thành 1
    // thêm tin nhắn mới vào cơ sở dữ liệu
    await _database
        .ref()
        .child('chat_rooms')
        .child(chatRoomId)
        .child('message')
        .push()
        .set(newMessage.toMap());
  }

  Stream<List<Message>> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort(); // sắp xếp ids
    String chatRoomId = ids.join('_');
    return _database
        .ref()
        .child('chat_rooms')
        .child(chatRoomId)
        .child('message')
        .orderByChild('timestamp')
        .onValue
        .map((event) {
      if (event.snapshot.value is Map) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final messages = data.values
            .map((v) => Message.fromMap(Map<String, dynamic>.from(v)))
            .toList();
        messages.sort(
              (a, b) => b.timestamp.compareTo(a.timestamp),
        ); // Sắp xếp theo thứ tự giảm dần
        return messages;
      } else {
        return [];
      }
    });
  }



}
