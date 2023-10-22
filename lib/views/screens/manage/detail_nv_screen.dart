import 'package:flutter/material.dart';
import 'package:thuc_tap_flutter/model/nhan_vien.dart';
import 'package:thuc_tap_flutter/services/auth/auth_gate.dart';
import 'package:thuc_tap_flutter/services/nhanvien/nhanvien_service.dart';
import 'package:thuc_tap_flutter/validate/my_validate.dart';
import 'package:thuc_tap_flutter/views/widgets/my_button.dart';
import 'package:thuc_tap_flutter/views/widgets/my_button_ontline.dart';
import 'package:thuc_tap_flutter/views/widgets/my_dialog.dart';
import 'package:thuc_tap_flutter/views/widgets/my_text_field.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.data});
  final NhanVien data;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _nameECtrl = TextEditingController();
  final TextEditingController _emailECtrl = TextEditingController();
  final TextEditingController _phoneECtrl = TextEditingController();
  final TextEditingController _idECtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _myValidate = MyValidate();
  late String name = widget.data.name.toString();

  void showDialogEdit() {
    if(_formKey.currentState!.validate()){
      showDialog(
        context: context,
        builder: (context) => MyDialog(
          onTap: onClickEdit,
          title: "Xác nhận thông tin",
          content: "Ấn nút OK để sửa $name trong DB",
        ),
      );
    }
  }

  void showDialogDelete() {
    showDialog(
      context: context,
      builder: (context) => MyDialog(
        onTap: onClickDelete,
        title: "Xác nhận thông tin",
        content: "Ấn nút OK để xóa $name khỏi DB",
      ),
    );
  }

  void onClickEdit() {
    NhanVien nhanVien = NhanVien(
      name: _nameECtrl.text,
      email: _emailECtrl.text,
      phone: _phoneECtrl.text,
    );
    updateNhanVien(nhanVien, _idECtrl.text);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AuthGate()));
  }

  void onClickDelete() {
    deleteNhanVien(_idECtrl.text);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AuthGate()));
  }

  @override
  Widget build(BuildContext context) {
    if(mounted) {
      setState(() {
        _idECtrl.text = widget.data.id.toString();
        _nameECtrl.text = widget.data.name.toString();
        _emailECtrl.text = widget.data.email.toString();
        _phoneECtrl.text = widget.data.phone.toString();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          width: double.infinity,
          alignment: AlignmentDirectional.topStart,
          // color: Colors.grey,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Biên soạn thông tin nhân viên\n',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                MyTextField(
                  controller: _idECtrl,
                  hintText: "ID",
                  obscureText: false,
                  icon: const Icon(Icons.insert_drive_file_outlined),
                  isRightIcon: false,
                  onValidate: null,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: _nameECtrl,
                  hintText: "Nhập name",
                  obscureText: false,
                  icon: const Icon(Icons.perm_identity_outlined),
                  isRightIcon: false,
                  onValidate: (value) => _myValidate.validateName(value),
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: _emailECtrl,
                  hintText: "Nhập email",
                  obscureText: false,
                  icon: const Icon(Icons.email_outlined),
                  isRightIcon: false,
                  onValidate: (value) => _myValidate.validateEmail(value),
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: _phoneECtrl,
                  hintText: "Nhập phone",
                  obscureText: false,
                  icon: const Icon(Icons.phone_enabled_outlined),
                  isRightIcon: false,
                  onValidate: (value) => _myValidate.validatePhone(value),
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onTap: showDialogEdit,
                      text: "Sửa",
                      textEnabled: '',
                      sizeHeigh: 160,
                      isLoading: false,
                    ),
                    MyButtonOutline(
                      onTap: showDialogDelete,
                      text: "Xóa",
                      sizeHeigh: 160,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
