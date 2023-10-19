import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final String textEnabled;
  final double sizeHeigh;
  final bool isLoading;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.sizeHeigh,
    required this.isLoading,
    required this.textEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(sizeHeigh, 48),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: !isLoading
          ? Text(text, style: const TextStyle(fontSize: 20))
          : Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Căn giữa các mục theo trục chính
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Căn giữa các mục theo trục chéo
              children: [
                Container(
                  height: 20,
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  width: 20,
                  child: const CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
                Text(
                  textEnabled,
                  style: const TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ],
            ),
    );
  }
}
