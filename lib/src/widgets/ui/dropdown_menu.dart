import 'package:flutter/material.dart';

class DropdownMenu extends StatelessWidget {
  final Widget trigger;
  final List<DropdownMenuEntry> items;

  const DropdownMenu({
    super.key,
    required this.trigger,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, _) {
        return GestureDetector(
          onTap: () => controller.open(),
          child: trigger,
        );
      },
      menuChildren: items.map((e) => e.build(context)).toList(),
    );
  }
}

abstract class DropdownMenuEntry {
  Widget build(BuildContext context);
}

class DropdownMenuItem extends DropdownMenuEntry {
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  DropdownMenuItem({
    required this.child,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: child,
        ),
      ),
    );
  }
}

class DropdownMenuCheckboxItem extends DropdownMenuEntry {
  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  DropdownMenuCheckboxItem({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: checked,
      onChanged: (val) => onChanged(val ?? false),
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class DropdownMenuRadioItem<T> extends DropdownMenuEntry {
  final String label;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  DropdownMenuRadioItem({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class DropdownMenuLabel extends DropdownMenuEntry {
  final String text;

  DropdownMenuLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DropdownMenuSeparator extends DropdownMenuEntry {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1);
  }
}
