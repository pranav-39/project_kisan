// lib/widgets/slider.dart

import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        inactiveTrackColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        activeTrackColor: Theme.of(context).colorScheme.primary,
        thumbColor: Theme.of(context).colorScheme.background,
        overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        disabledThumbColor: Colors.grey.shade400,
        disabledActiveTrackColor: Colors.grey.shade300,
        disabledInactiveTrackColor: Colors.grey.shade200,
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
      ),
    );
  }
}
