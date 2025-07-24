import 'package:flutter/material.dart';

enum ToastType { normal, destructive }

class ToastData {
  final String title;
  final String? description;
  final Widget? action;
  final ToastType type;

  ToastData({
    required this.title,
    this.description,
    this.action,
    this.type = ToastType.normal,
  });
}

class Toaster {
  static final List<OverlayEntry> _entries = [];

  static void show(BuildContext context, ToastData toast) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (_) => ToastWidget(
        toast: toast,
        onClose: () {
          entry.remove();
          _entries.remove(entry);
        },
      ),
    );

    _entries.add(entry);
    overlay.insert(entry);
  }
}
