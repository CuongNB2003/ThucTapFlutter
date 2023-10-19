import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show BuildContext, InputDecoration, OutlineInputBorder, StatelessWidget, TextEditingController, TextField, TextInputType, TextStyle, Widget;

class MyTextFieldMessage extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextFieldMessage({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        fontSize: 16,
      ),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        hintText: hintText,
      ),
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }
}
