// lib/widgets/ui/tooltip.dart
import 'package:flutter/material.dart';

class Tooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Duration showDuration;
  final Duration waitDuration;
  final TooltipTriggerMode triggerMode;
  final bool preferBelow;

  const Tooltip({
    super.key,
    required this.message,
    required this.child,
    this.padding,
    this.elevation,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.showDuration = const Duration(milliseconds: 1500),
    this.waitDuration = const Duration(milliseconds: 500),
    this.triggerMode = TooltipTriggerMode.longPress,
    this.preferBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: message,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: elevation ?? 4,
      textStyle: TextStyle(
        color: textColor ?? colorScheme.onSurface,
        fontSize: 12,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 4),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      showDuration: showDuration,
      waitDuration: waitDuration,
      triggerMode: triggerMode,
      preferBelow: preferBelow,
      child: child,
    );
  }
}