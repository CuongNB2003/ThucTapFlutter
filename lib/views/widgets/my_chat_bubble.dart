import 'package:flutter/material.dart' show BorderRadius, BoxDecoration, BuildContext, Color, Container, EdgeInsets, StatelessWidget, Text, TextStyle, Widget;

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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
