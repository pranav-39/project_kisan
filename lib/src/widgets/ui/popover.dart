import 'package:flutter/material.dart';

class Popover extends StatelessWidget {
  final Widget trigger;
  final Widget content;
  final double width;
  final Alignment alignment;

  const Popover({
    Key? key,
    required this.trigger,
    required this.content,
    this.width = 300,
    this.alignment = Alignment.center,
  }) : super(key: key);

  void _showPopover(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final target = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Taps outside should close the popover
          Positioned.fill(
            child: GestureDetector(
              onTap: () => entry.remove(),
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            left: target.dx,
            top: target.dy + size.height + 8,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopover(context),
      child: trigger,
    );
  }
}
