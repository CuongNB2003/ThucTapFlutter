import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String senderName;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderName,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId' : senderId,
      'senderName' : senderName,
      'receiverId' : receiverId,
      'message' : message,
      'timestamp' : timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      senderName: map['senderName'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }

}
