import 'package:flutter/material.dart';

enum ToggleSize { small, medium, large }
enum ToggleVariant { defaultVariant, outline }

class ToggleGroup extends StatefulWidget {
  final List<String> labels;
  final List<bool> isSelected;
  final ValueChanged<int> onPressed;
  final ToggleSize size;
  final ToggleVariant variant;

  const ToggleGroup({
    Key? key,
    required this.labels,
    required this.isSelected,
    required this.onPressed,
    this.size = ToggleSize.medium,
    this.variant = ToggleVariant.defaultVariant,
  }) : super(key: key);

  @override
  State<ToggleGroup> createState() => _ToggleGroupState();
}

class _ToggleGroupState extends State<ToggleGroup> {
  late List<bool> _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.isSelected;
  }

  double getPadding() {
    switch (widget.size) {
      case ToggleSize.small:
        return 8.0;
      case ToggleSize.large:
        return 16.0;
      case ToggleSize.medium:
      default:
        return 12.0;
    }
  }

  ButtonStyle getStyle(bool isSelected) {
    final borderColor =
    widget.variant == ToggleVariant.outline ? Colors.grey : Colors.transparent;
    final bgColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface;

    return TextButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: isSelected ? Colors.white : Colors.black87,
      side: BorderSide(color: borderColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      padding: EdgeInsets.symmetric(horizontal: getPadding(), vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(widget.labels.length, (index) {
        return TextButton(
          onPressed: () {
            setState(() {
              for (int i = 0; i < _selection.length; i++) {
                _selection[i] = i == index;
              }
            });
            widget.onPressed(index);
          },
          style: getStyle(_selection[index]),
          child: Text(widget.labels[index]),
        );
      }),
    );
  }
}
