import 'package:flutter/material.dart';

class CustomSelect<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final String Function(T) labelBuilder;
  final bool isEnabled;

  const CustomSelect({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = isEnabled ? Colors.grey : Colors.grey.shade300;
    final backgroundColor = isEnabled ? Colors.white : Colors.grey.shade100;

    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButton<T>(
          value: value,
          onChanged: isEnabled ? onChanged : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: Theme.of(context).textTheme.bodyMedium,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Row(
                children: [
                  if (value == item)
                    const Icon(Icons.check, size: 18, color: Colors.black54)
                  else
                    const SizedBox(width: 18),
                  const SizedBox(width: 6),
                  Flexible(child: Text(labelBuilder(item), overflow: TextOverflow.ellipsis)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
