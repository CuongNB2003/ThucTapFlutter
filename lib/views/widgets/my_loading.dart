import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLoading extends StatelessWidget {
  final double withLoading;
  final double heightLoading;
  final Color color;
  const MyLoading({
    super.key,
    required this.withLoading,
    required this.heightLoading,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: withLoading,
        height: heightLoading,
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }
}
