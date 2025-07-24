import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final Alignment alignment;
  final double sideOffset;

  const HoverCard({
    super.key,
    required this.trigger,
    required this.content,
    this.alignment = Alignment.center,
    this.sideOffset = 8.0,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  void _onEnter(PointerEvent _) => setState(() => _isHovered = true);
  void _onExit(PointerEvent _) => setState(() => _isHovered = false);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: Stack(
        alignment: widget.alignment,
        clipBehavior: Clip.none,
        children: [
          widget.trigger,
          if (_isHovered)
            Positioned(
              top: widget.sideOffset,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 240,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  child: widget.content,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
