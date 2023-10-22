import 'package:flutter/material.dart';

class MyChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  final Color colorText;
  const MyChatBubble({
    super.key,
    required this.message,
    required this.color,
    required this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 18, color: colorText),
      ),
    );
  }
}
