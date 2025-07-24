import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}

enum ButtonSize {
  defaultSize,
  sm,
  lg,
  icon,
}

class Button extends StatelessWidget {
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback? onPressed;
  final Widget child;
  final bool disabled;

  const Button({
    super.key,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.defaultSize,
    this.onPressed,
    this.disabled = false,
  });

  Color _backgroundColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return Theme.of(context).colorScheme.primary;
      case ButtonVariant.destructive:
        return Colors.red;
      case ButtonVariant.secondary:
        return Colors.grey.shade300;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return Colors.transparent;
    }
  }

  Color _foregroundColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return Theme.of(context).colorScheme.onPrimary;
      case ButtonVariant.destructive:
        return Colors.white;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return Theme.of(context).colorScheme.primary;
    }
  }

  EdgeInsets _padding() {
    switch (size) {
      case ButtonSize.defaultSize:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case ButtonSize.icon:
        return const EdgeInsets.all(12);
    }
  }

  BorderSide? _border() {
    if (variant == ButtonVariant.outline) {
      return const BorderSide(color: Colors.grey);
    }
    return BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.6 : 1.0,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: _backgroundColor(context),
          foregroundColor: _foregroundColor(context),
          padding: _padding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: _border()!,
          ),
        ),
        onPressed: disabled ? null : onPressed,
        child: child,
      ),
    );
  }
}
