import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuc_tap_flutter/views/screens/chat/chat_screen.dart';
import 'package:thuc_tap_flutter/views/widgets/my_loading.dart';

class ListChatScreen extends StatefulWidget {
  const ListChatScreen({super.key});

  @override
  State<ListChatScreen> createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error",
              style: TextStyle(color: Colors.red, fontSize: 24),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoading(
            withLoading: 50,
            heightLoading: 50,
            color: Colors.blue,
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiveUserEmail: data['email'],
                  receiveUserID: data['uid'],
                  receiveUserName: data['name'],
                ),
              ));
        },
        child: Row(
          children: [
            const SizedBox(
              height: 50,
              width: 50,
              child: Icon(Icons.perm_identity_outlined),
            ),
            Text(
              data['name'],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
