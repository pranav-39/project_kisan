// lib/widgets/sheet.dart

import 'package:flutter/material.dart';

enum SheetSide { top, bottom, left, right }

class AppSheet extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final Widget child;
  final SheetSide side;

  const AppSheet({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.child,
    this.side = SheetSide.right,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        Align(
          alignment: _alignment(),
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 24,
            child: Container(
              width: _isVertical() ? double.infinity : MediaQuery.of(context).size.width * 0.75,
              height: _isVertical() ? MediaQuery.of(context).size.height * 0.5 : double.infinity,
              padding: const EdgeInsets.all(24),
              child: Stack(
                children: [
                  child,
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Alignment _alignment() {
    switch (side) {
      case SheetSide.top:
        return Alignment.topCenter;
      case SheetSide.bottom:
        return Alignment.bottomCenter;
      case SheetSide.left:
        return Alignment.centerLeft;
      case SheetSide.right:
      default:
        return Alignment.centerRight;
    }
  }

  bool _isVertical() => side == SheetSide.top || side == SheetSide.bottom;
}

class SheetHeader extends StatelessWidget {
  final Widget child;

  const SheetHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [child],
    );
  }
}

class SheetFooter extends StatelessWidget {
  final List<Widget> children;

  const SheetFooter({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: children,
    );
  }
}

class SheetTitle extends StatelessWidget {
  final String title;

  const SheetTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class SheetDescription extends StatelessWidget {
  final String description;

  const SheetDescription(this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
    );
  }
}
