import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final String content;

  const MyDialog({super.key, required this.onTap, required this.title, required this.content,});


  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title:  Text(title),
      content:  Text(content),
      actions: [
        CupertinoDialogAction(
            onPressed: onTap,
            child: const Text('OK')
        ),
        CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Cancel')
        ),
      ],
    );
  }

}