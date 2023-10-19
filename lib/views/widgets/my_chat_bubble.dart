import 'package:flutter/material.dart';

class MyChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  const MyChatBubble({
    super.key,
    required this.message, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
