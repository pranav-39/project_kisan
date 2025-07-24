import 'package:flutter/material.dart';

class InputOTP extends StatelessWidget {
  final int length;
  final List<TextEditingController> controllers;
  final void Function(String)? onCompleted;

  const InputOTP({
    super.key,
    required this.length,
    required this.controllers,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(length * 2 - 1, (i) {
        if (i % 2 == 1) return const InputOTPSeparator();
        final index = i ~/ 2;
        return InputOTPSlot(
          controller: controllers[index],
          isFirst: index == 0,
          isLast: index == length - 1,
          onCompleted: onCompleted,
        );
      }),
    );
  }
}

class InputOTPSlot extends StatelessWidget {
  final TextEditingController controller;
  final bool isFirst;
  final bool isLast;
  final void Function(String)? onCompleted;

  const InputOTPSlot({
    super.key,
    required this.controller,
    this.isFirst = false,
    this.isLast = false,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? const Radius.circular(8) : Radius.zero,
              right: isLast ? const Radius.circular(8) : Radius.zero,
            ),
          ),
        ),
        onChanged: (val) {
          if (val.isNotEmpty && onCompleted != null) {
            onCompleted!(val);
          }
        },
      ),
    );
  }
}

class InputOTPSeparator extends StatelessWidget {
  const InputOTPSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Icon(Icons.circle, size: 6, color: Colors.grey),
    );
  }
}
