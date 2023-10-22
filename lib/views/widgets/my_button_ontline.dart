import 'package:flutter/material.dart';
import 'package:thuc_tap_flutter/views/resources/color.dart';

class MyButtonOutline extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final double sizeHeigh;

  const MyButtonOutline({
    super.key,
    required this.onTap,
    required this.text,
    required this.sizeHeigh,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.white,
        foregroundColor: CustomColors.themeColor,
        minimumSize: Size(sizeHeigh, 48),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: CustomColors.themeColor)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: CustomColors.themeColor),
      ),
    );
  }
}
