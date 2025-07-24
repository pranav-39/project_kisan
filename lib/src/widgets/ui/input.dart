import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isDisabled;
  final String? placeholder;
  final bool obscureText;

  const Input({
    super.key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isDisabled = false,
    this.placeholder,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: !isDisabled,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: placeholder,
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).disabledColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }
}
