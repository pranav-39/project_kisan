import 'package:flutter/material.dart';
import 'dart:math';

class VoiceIndicator extends StatefulWidget {
  const VoiceIndicator({super.key, this.color = Colors.green, this.barCount = 5});

  final Color color;
  final int barCount;

  @override
  State<VoiceIndicator> createState() => _VoiceIndicatorState();
}

class _VoiceIndicatorState extends State<VoiceIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    final random = Random();
    _barAnimations = List.generate(widget.barCount, (index) {
      final delay = index * 0.1;
      return Tween<double>(begin: 4.0, end: 20.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, 1.0, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.barCount, (index) {
        return AnimatedBuilder(
          animation: _barAnimations[index],
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: 4,
                height: _barAnimations[index].value,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
