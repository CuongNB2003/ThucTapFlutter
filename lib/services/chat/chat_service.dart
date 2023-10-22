import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:thuc_tap_flutter/model/message.dart';
import 'package:thuc_tap_flutter/services/notification/notification_services.dart';

class ChatService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final notificationService = NotificationsService();

  Future<void> sendMessage(String receiverId, String message) async {
    final docSnapshot = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    // lấy thông tin người dùng hiện tại
    final currenUserId = _firebaseAuth.currentUser!.uid;
    final String currenUserEmail = _firebaseAuth.currentUser!.email.toString();
    final String currenUserName = docSnapshot['name'];
    final Timestamp timestamp = Timestamp.now();

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
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
    // lấy token người nhận bằng id sau đó gửi thong báo đến người nhận
    print('id người nhận ne: $receiverId');
    await notificationService.getReceiverToken(receiverId);
    await notificationService.sendNotification(title: currenUserName, senderId: receiverId, content: message);
  }

  Stream<List<Message>> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort(); // sắp xếp ids
    String chatRoomId = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
    });
  }
}
