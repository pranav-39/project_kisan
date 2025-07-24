import 'package:flutter/material.dart';

enum AlertVariant { defaultStyle, destructive }

class Alert extends StatelessWidget {
  final AlertVariant variant;
  final Widget? icon;
  final Widget title;
  final Widget? description;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const Alert({
    Key? key,
    required this.title,
    this.description,
    this.icon,
    this.variant = AlertVariant.defaultStyle,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  }) : super(key: key);

  Color _backgroundColor(BuildContext context) {
    switch (variant) {
      case AlertVariant.destructive:
        return Colors.red.shade50;
      default:
        return Theme.of(context).colorScheme.background;
    }
  }

  Color _borderColor(BuildContext context) {
    switch (variant) {
      case AlertVariant.destructive:
        return Colors.red.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _iconColor(BuildContext context) {
    switch (variant) {
      case AlertVariant.destructive:
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.onBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        border: Border.all(color: _borderColor(context)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 2),
              child: IconTheme(
                data: IconThemeData(color: _iconColor(context), size: 24),
                child: icon!,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  child: title,
                ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium!,
                      child: description!,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
