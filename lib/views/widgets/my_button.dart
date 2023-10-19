import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final double sizeHeigh;

  const MyButton({
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
            minimumSize: Size(sizeHeigh, 48),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ));
  }
}
