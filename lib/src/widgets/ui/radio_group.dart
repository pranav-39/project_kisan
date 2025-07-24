import 'package:flutter/material.dart';

class RadioGroup<T> extends StatelessWidget {
  final T groupValue;
  final List<RadioOption<T>> options;
  final ValueChanged<T?> onChanged;

  const RadioGroup({
    Key? key,
    required this.groupValue,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        return RadioGroupItem<T>(
          value: option.value,
          groupValue: groupValue,
          label: option.label,
          onChanged: onChanged,
        );
      }).toList(),
    );
  }
}

class RadioGroupItem<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T?> onChanged;

  const RadioGroupItem({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
                : null,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class RadioOption<T> {
  final T value;
  final String label;

  RadioOption({required this.value, required this.label});
}
