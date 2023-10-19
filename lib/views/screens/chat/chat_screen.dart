import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuc_tap_flutter/services/chat/chat_service.dart';
import 'package:thuc_tap_flutter/validate/item_validate.dart';
import 'package:thuc_tap_flutter/views/widgets/my_chat_bubble.dart';
import 'package:thuc_tap_flutter/views/widgets/my_text_field_mess.dart';

class ChatScreen extends StatefulWidget {
  final String receiveUserEmail;
  final String receiveUserID;

  const ChatScreen({
    super.key,
    required this.receiveUserEmail,
    required this.receiveUserID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageCtrl = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ItemValidate _validate = ItemValidate();

  void sendMessage() async {
    if (_messageCtrl.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiveUserID,
        _messageCtrl.text,
      );
      // sau khi gửi thì xóa text
      _messageCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveUserEmail),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // mess input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: MyTextFieldMessage(
              controller: _messageCtrl,
              hintText: "Enter message",
              obscureText: false,
            ),
          ),

          // send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 35,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessage(
          widget.receiveUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error${snapshot.error}",
                style: const TextStyle(color: Colors.red, fontSize: 24)),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Loading...",
                style: TextStyle(color: Colors.blue, fontSize: 24)),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: _validate.determineAlignment(
          data['senderId'],
          _firebaseAuth.currentUser!.uid,
        ),
        child: Column(
          crossAxisAlignment: _validate.determineCrossAxisAlignment(
            data['senderId'],
            _firebaseAuth.currentUser!.uid,
          ),
          children: [
            Text(
              _validate.determineName(
                data['senderId'],
                _firebaseAuth.currentUser!.uid,
                data['senderEmail'],
              ),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            MyChatBubble(
              message: data['message'],
              color: _validate.determineColor(
                data['senderId'],
                _firebaseAuth.currentUser!.uid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
