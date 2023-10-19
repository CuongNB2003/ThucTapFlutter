import 'package:flutter/material.dart';

class MyItemChat extends StatelessWidget {
  final void Function() onTap;
  final String imageUrl;
  final String title;
  final String content;

  const MyItemChat({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(content),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}