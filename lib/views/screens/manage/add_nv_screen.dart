import 'package:flutter/material.dart';
import 'package:thuc_tap_flutter/model/nhan_vien.dart';
import 'package:thuc_tap_flutter/services/auth/auth_gate.dart';
import 'package:thuc_tap_flutter/services/nhanvien/nhanvien_service.dart';
import 'package:thuc_tap_flutter/validate/my_validate.dart';
import 'package:thuc_tap_flutter/views/widgets/my_button.dart';
import 'package:thuc_tap_flutter/views/widgets/my_button_ontline.dart';
import 'package:thuc_tap_flutter/views/widgets/my_dialog.dart';
import 'package:thuc_tap_flutter/views/widgets/my_text_field.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _myValidate = MyValidate();

  void showDialogAdd() {
    if(_formKey.currentState!.validate()){
      showDialog(
        context: context,
        builder: (context) => MyDialog(
          onTap: onClickPost,
          title: "Xác nhận thông tin",
          content: "Ấn nút OK để ghi thông tin vào DB",
        ),
      );
    }
  }

  void onClickPost() async {
    NhanVien nhanVien = NhanVien(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
    );
    createNhanVien(nhanVien);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AuthGate()));
  }

  void onClickCancell() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Add',
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          width: double.infinity,
          alignment: AlignmentDirectional.topStart,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đăng ký nhân viên mới.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                MyTextField(
                  controller: _nameCtrl,
                  hintText: "Nhập name",
                  obscureText: false,
                  icon: const Icon(Icons.perm_identity_outlined),
                  isRightIcon: false,
                  onValidate: (value) => _myValidate.validateName(value),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: _emailCtrl,
                  hintText: "Nhập email",
                  obscureText: false,
                  icon: const Icon(Icons.email_outlined),
                  isRightIcon: false,
                  onValidate: (value) => _myValidate.validateEmail(value),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: _phoneCtrl,
                  hintText: "Nhập phone",
                  obscureText: false,
                  icon: const Icon(Icons.phone_enabled_outlined),
                  isRightIcon: false,
                  onValidate: (value) => _myValidate.validatePhone(value),
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onTap: showDialogAdd,
                      text: "Thêm",
                      textEnabled: '',
                      sizeHeigh: 160,
                      isLoading: false,
                    ),
                    MyButtonOutline(
                      onTap: onClickCancell,
                      text: "Hủy",
                      sizeHeigh: 160,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
