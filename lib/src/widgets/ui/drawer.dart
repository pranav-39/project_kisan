import 'package:flutter/material.dart';

class DrawerWidget {
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool shouldScaleBackground = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => _DrawerOverlay(
        shouldScaleBackground: shouldScaleBackground,
        child: builder(context),
      ),
    );
  }
}

class _DrawerOverlay extends StatelessWidget {
  final Widget child;
  final bool shouldScaleBackground;

  const _DrawerOverlay({
    required this.child,
    this.shouldScaleBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (shouldScaleBackground)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

class DrawerHeader extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DrawerHeader({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.headlineSmall!,
        child: child,
      ),
    );
  }
}

class DrawerFooter extends StatelessWidget {
  final Widget child;

  const DrawerFooter({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class DrawerTitle extends StatelessWidget {
  final String text;

  const DrawerTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class DrawerDescription extends StatelessWidget {
  final String text;

  const DrawerDescription({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
      ),
      textAlign: TextAlign.center,
    );
  }
}
