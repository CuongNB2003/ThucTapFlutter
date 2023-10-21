class MessageRealtime {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String senderName;
  final String message;
  final int timestamp;

  MessageRealtime({
    required this.senderName,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId' : senderId,
      'senderEmail' : senderEmail,
      'senderName' : senderName,
      'receiverId' : receiverId,
      'message' : message,
      'timestamp' : timestamp,
    };
  }

  factory MessageRealtime.fromMap(Map<String, dynamic> map) {
    return MessageRealtime(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      receiverId: map['receiverId'],
      senderName: map['senderName'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }

}