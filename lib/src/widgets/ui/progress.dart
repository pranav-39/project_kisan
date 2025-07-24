import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final double value; // from 0 to 100
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  const Progress({
    Key? key,
    required this.value,
    this.height = 16,
    this.backgroundColor,
    this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double normalized = value.clamp(0, 100) / 100;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: normalized,
        minHeight: height,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(
          progressColor ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
