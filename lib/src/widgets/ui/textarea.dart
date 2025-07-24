import 'package:flutter/material.dart';

class AppTextarea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool enabled;
  final int minLines;
  final int maxLines;

  const AppTextarea({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.minLines = 4,
    this.maxLines = 8,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}
