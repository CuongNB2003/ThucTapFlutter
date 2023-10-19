import 'package:flutter/material.dart';

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
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        minimumSize: Size(sizeHeigh, 48),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.blue)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.blue),
      ),
    );
  }
}
