import 'package:flutter/material.dart';
import 'package:thuc_tap_flutter/views/resources/color.dart';

class MyItemChat extends StatelessWidget {
  final void Function() onTap;
  final String imageUrl;
  final String title;
  final bool content;
  final Color color;

  const MyItemChat({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                    content
                        ? const Text(
                      'Online',
                      style: TextStyle(color: CustomColors.green),
                    )
                        : const Text(
                      'Offline',
                      style: TextStyle(color: CustomColors.red),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: color),
          ],
        ),
      ),
    );
  }
}
