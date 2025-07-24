import 'package:flutter/material.dart';

class CustomAspectRatio extends StatelessWidget {
  final double aspectRatio;
  final Widget child;

  const CustomAspectRatio({
    Key? key,
    required this.aspectRatio,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: child,
    );
  }
}
