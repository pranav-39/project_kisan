import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool isDisabled;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : () => onChanged(!value),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: value ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
        child: value
            ? const Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        )
            : null,
      ),
    );
  }
}
