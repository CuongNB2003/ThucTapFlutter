import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final void Function()? onTap;
  final String? Function(String?)? onValidate;
  final bool isRightIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    this.onTap,
    required this.isRightIcon,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          suffixIcon: isRightIcon
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onTap,
                )
              : null,
          prefixIcon: icon),
      validator: onValidate,
    );
  }
}
