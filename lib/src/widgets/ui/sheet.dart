// lib/widgets/sheet.dart

import 'package:flutter/material.dart';

enum SheetSide { top, bottom, left, right }

class Sheet extends StatelessWidget {
  final Widget child;
  final bool isOpen;
  final VoidCallback onClose;
  final SheetSide side;

  const Sheet({
    super.key,
    required this.child,
    required this.isOpen,
    required this.onClose,
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
          alignment: _getAlignment(),
          child: Material(
            elevation: 20,
            child: Container(
              width: side == SheetSide.left || side == SheetSide.right
                  ? MediaQuery.of(context).size.width * 0.75
                  : double.infinity,
              height: side == SheetSide.top || side == SheetSide.bottom
                  ? MediaQuery.of(context).size.height * 0.5
                  : double.infinity,
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Stack(
                children: [
                  child,
                  Positioned(
                    top: 16,
                    right: 16,
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

  Alignment _getAlignment() {
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
}
