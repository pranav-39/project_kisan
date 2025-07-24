// lib/widgets/ui/toggle.dart
import 'package:flutter/material.dart';

class Toggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final ToggleVariant variant;
  final ToggleSize size;
  final Widget? child;
  final Widget? icon;
  final bool disabled;
  final EdgeInsetsGeometry? padding;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Color? borderColor;
  final double? borderRadius;

  const Toggle({
    super.key,
    required this.value,
    this.onChanged,
    this.variant = ToggleVariant.defaultVariant,
    this.size = ToggleSize.medium,
    this.child,
    this.icon,
    this.disabled = false,
    this.padding,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  State<Toggle> createState() => _ToggleState();
}

enum ToggleVariant { defaultVariant, outline }
enum ToggleSize { small, medium, large }

class _ToggleState extends State<Toggle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Handle colors
    final activeColor = widget.activeColor ?? colorScheme.secondaryContainer;
    final inactiveColor = widget.inactiveColor ?? Colors.transparent;
    final activeTextColor = widget.activeTextColor ?? colorScheme.onSecondaryContainer;
    final inactiveTextColor = widget.inactiveTextColor ?? colorScheme.onSurface;
    final borderColor = widget.borderColor ?? theme.dividerColor;
    final disabledColor = colorScheme.onSurface.withOpacity(0.38);

    // Handle sizes
    final sizeValues = {
      ToggleSize.small: const Size(36, 36),
      ToggleSize.medium: const Size(40, 40),
      ToggleSize.large: const Size(44, 44),
    };
    final defaultPadding = {
      ToggleSize.small: const EdgeInsets.symmetric(horizontal: 10),
      ToggleSize.medium: const EdgeInsets.symmetric(horizontal: 12),
      ToggleSize.large: const EdgeInsets.symmetric(horizontal: 16),
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.disabled ? null : () => widget.onChanged?.call(!widget.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding ?? defaultPadding[widget.size],
          constraints: BoxConstraints(
            minWidth: sizeValues[widget.size]!.width,
            minHeight: sizeValues[widget.size]!.height,
          ),
          decoration: BoxDecoration(
            color: widget.disabled
                ? inactiveColor.withOpacity(0.5)
                : widget.value
                ? activeColor
                : _isHovered
                ? colorScheme.surfaceVariant
                : inactiveColor,
            border: widget.variant == ToggleVariant.outline
                ? Border.all(
              color: widget.disabled
                  ? borderColor.withOpacity(0.5)
                  : borderColor,
            )
                : null,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: widget.disabled
                        ? disabledColor
                        : widget.value
                        ? activeTextColor
                        : inactiveTextColor,
                    size: 16,
                  ),
                  child: widget.icon!,
                ),
                if (widget.child != null) const SizedBox(width: 8),
              ],
              if (widget.child != null)
                DefaultTextStyle(
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: widget.disabled
                        ? disabledColor
                        : widget.value
                        ? activeTextColor
                        : inactiveTextColor,
                  ),
                  child: widget.child!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}