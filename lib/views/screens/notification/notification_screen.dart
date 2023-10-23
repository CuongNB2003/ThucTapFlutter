import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thuc_tap_flutter/model/user.dart';
import 'package:thuc_tap_flutter/services/notification/notification_services.dart';
import 'package:thuc_tap_flutter/views/resources/color.dart';
import 'package:thuc_tap_flutter/views/widgets/my_button.dart';
import 'package:thuc_tap_flutter/views/widgets/my_text_field_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final notificationsService = NotificationsService();
  bool _isLoading = false;
  List<UserModel> models = [];

  Future<void> _getAllDataFromFirestore() async {
    String? currentId = FirebaseAuth.instance.currentUser?.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: currentId)
        .get();
    setState(() {
      models = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      if (kDebugMode) {
        print('Danh sách người gui: $models');
      }
    });
  }

  void sendAllNotification() async {
    if(mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    // Lấy danh sách token từ các người dùng đã chọn
    List<String> selectedTokens = models
        .where((model) => model.selected)
        .map((model) => model.uid)
        .toList();
    print('ListToken: $selectedTokens');

    String title = _titleCtrl.text;
    String content = _contentCtrl.text;

    // Thực hiện push thông báo đến các người dùng đã chọn
    for (String token in selectedTokens) {
      await notificationsService.getReceiverToken(token);
      await notificationsService.sendNotification(title: title, content: content, senderId: token);
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    notificationsService.firebaseNotification(context);
    _getAllDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            'Nhập thông báo',
            style: TextStyle(
              color: CustomColors.themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 30),
          MyTextFieldNotification(
            controller: _titleCtrl,
            hintText: 'Nhập tiêu đề',
            titleOrContent: true,
          ),
          const SizedBox(height: 10),
          MyTextFieldNotification(
            controller: _contentCtrl,
            hintText: 'Nhập nội dung',
            titleOrContent: false,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildListUser(),
          ),
          MyButton(
            onTap: sendAllNotification,
            text: 'Bắn thông báo',
            sizeHeigh: double.infinity,
            isLoading: _isLoading,
            textEnabled: 'Đang gửi...',
          ),
        ],
      ),
    );
  }

  Widget _buildListUser() {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            print('========Lỗi ở đây: ${snapshot.hasData}');
          }
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              return _buildItemUser(model);
            },
          );
        }
      },
    );
  }

  Widget _buildItemUser(UserModel model) {
    return ChangeNotifierProvider<UserModel>.value(
      value: model,
      child: Consumer<UserModel>(
        builder: (context, model, child) {
          return ListTile(
            title: Text(model.name),
            subtitle: Text(model.email),
            leading: Checkbox(
              value: model.selected,
              onChanged: (value) {
                model.isSelected = value!;
                print('======Giá trị của user ${model.selected}');
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }
}
