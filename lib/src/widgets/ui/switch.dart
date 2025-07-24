// lib/widgets/custom_switch.dart

import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isEnabled;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: isEnabled ? onChanged : null,
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveThumbColor: Theme.of(context).colorScheme.background,
      inactiveTrackColor: Theme.of(context).colorScheme.surfaceVariant,
      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
    );
  }
}
