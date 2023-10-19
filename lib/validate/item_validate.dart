import 'package:flutter/material.dart' show Alignment, Color, Colors, CrossAxisAlignment;

class ItemValidate {
  Alignment determineAlignment(String senderId, String currentUserId){
    Alignment alignment = (senderId == currentUserId)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return alignment;
  }

  CrossAxisAlignment determineCrossAxisAlignment(String senderId, String currentUserId){
    CrossAxisAlignment crossAxisAlignment = (senderId == currentUserId)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return crossAxisAlignment;
  }

  Color determineColor(String senderId, String currentUserId){
    Color color = (senderId == currentUserId)
        ? Colors.blue
        : Colors.grey.shade200;
    return color;
  }

  String determineName(String senderId, String currentUserId, String senderEmail){
    String name = (senderId == currentUserId)
        ? 'You'
        : senderEmail;
    return name;
  }
}