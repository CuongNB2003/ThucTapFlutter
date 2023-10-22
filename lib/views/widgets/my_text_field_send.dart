import 'package:flutter/material.dart';

class MyTextFieldSend extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function() onTap;
  final Icon icon;
  final bool messOrSearch;

  const MyTextFieldSend({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onTap,
    required this.icon,
    required this.messOrSearch,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 100.0), // Đặt chiều cao tối đa là 100.0
      child: TextField(
        style: const TextStyle(fontSize: 16),
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          suffixIcon: IconButton(
            icon: icon,
            onPressed: onTap,
          ),
          hintText: hintText,
          contentPadding:
          const EdgeInsets.fromLTRB(20, 10, 0, 10),
        ),
        maxLines: messOrSearch ? null : 1,
        keyboardType: messOrSearch ? TextInputType.multiline : TextInputType.text,
      ),
    );
  }
}
