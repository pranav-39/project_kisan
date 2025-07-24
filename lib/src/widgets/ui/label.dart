import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final bool isDisabled;
  final TextStyle? style;

  const Label({
    super.key,
    required this.text,
    this.isDisabled = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.2,
            color: isDisabled
                ? Theme.of(context).disabledColor
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
    );
  }
}
