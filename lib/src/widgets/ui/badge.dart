import 'package:flutter/material.dart';

enum BadgeVariant {
  primary,
  secondary,
  destructive,
  outline
}

class Badge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;

  const Badge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.primary,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    Color bgColor;
    Color textColor;
    Color borderColor;

    switch (variant) {
      case BadgeVariant.primary:
        bgColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        borderColor = Colors.transparent;
        break;
      case BadgeVariant.secondary:
        bgColor = colorScheme.secondary;
        textColor = colorScheme.onSecondary;
        borderColor = Colors.transparent;
        break;
      case BadgeVariant.destructive:
        bgColor = Colors.red.shade600;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;
      case BadgeVariant.outline:
        bgColor = Colors.transparent;
        textColor = colorScheme.onSurface;
        borderColor = colorScheme.outline;
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );
  }
}
