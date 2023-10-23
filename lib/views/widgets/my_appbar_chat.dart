import 'package:flutter/cupertino.dart';

class MyAppbarChat extends StatelessWidget {
  final String avata;
  final String name;
  final bool status;
  const MyAppbarChat({super.key, required this.avata, required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            avata,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              status ? 'Online' : 'Offline',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
