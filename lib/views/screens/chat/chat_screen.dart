import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuc_tap_flutter/model/message.dart';
import 'package:thuc_tap_flutter/services/chat/chat_service.dart';
import 'package:thuc_tap_flutter/validate/item_validate.dart';
import 'package:thuc_tap_flutter/views/widgets/my_chat_bubble.dart';
import 'package:thuc_tap_flutter/views/widgets/my_loading.dart';
import 'package:thuc_tap_flutter/views/widgets/my_text_field_send.dart';

class ChatScreen extends StatefulWidget {
  final String receiveUserEmail;
  final String receiveUserID;
  final String receiveUserName;

  const ChatScreen({
    super.key,
    required this.receiveUserEmail,
    required this.receiveUserID,
    required this.receiveUserName,
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
      // ignore: use_build_context_synchronously
      FocusScope.of(context).unfocus();
      _messageCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveUserName),
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
      child: Expanded(
        child: MyTextFieldSend(
          controller: _messageCtrl,
          hintText: "Enter message",
          onTap: sendMessage,
          icon: const Icon(
            Icons.send,
            size: 35,
            color: Colors.blue,
          ),
          messOrSearch: true,
        ),
      ),
    );
  }

// build message list
  Widget _buildMessageList() {
    return StreamBuilder<List<Message>>(
      stream: _chatService.getMessage(
          widget.receiveUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error",
                style: TextStyle(color: Colors.red, fontSize: 24)),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoading(
            withLoading: 50,
            heightLoading: 50,
            color: Colors.white,
          );
        }

        return snapshot.hasData && snapshot.data!.isNotEmpty
            ? ListView(
                reverse: true,
                children: snapshot.data!
                    .map((message) => _buildMessageItem(message))
                    .toList())
            : Container();
      },
    );
  }

// build message item
  Widget _buildMessageItem(Message message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: _validate.determineAlignment(
          message.senderId,
          _firebaseAuth.currentUser!.uid,
        ),
        child: Column(
          crossAxisAlignment: _validate.determineCrossAxisAlignment(
            message.senderId,
            _firebaseAuth.currentUser!.uid,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                _validate.determineName(
                  message.senderId,
                  _firebaseAuth.currentUser!.uid,
                  message.senderName,
                ),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            MyChatBubble(
              message: message.message,
              color: _validate.determineColor(
                message.senderId,
                _firebaseAuth.currentUser!.uid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
