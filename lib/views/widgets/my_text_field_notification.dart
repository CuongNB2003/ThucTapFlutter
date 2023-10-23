import 'package:flutter/material.dart';

class MyTextFieldNotification extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool titleOrContent;

  const MyTextFieldNotification({
    super.key,
    required this.controller,
    required this.hintText, required this.titleOrContent,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        contentPadding:
        EdgeInsets.symmetric(vertical: titleOrContent ? 10 : 50 , horizontal: 20),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      maxLines:
      titleOrContent ? 1 : null,
      keyboardType:
      titleOrContent ? TextInputType.text : TextInputType.multiline,
    );
  }
}
