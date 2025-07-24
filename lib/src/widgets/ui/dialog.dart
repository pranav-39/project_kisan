import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget>? actions;
  final VoidCallback? onClose;

  const DialogWidget({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(title: title, onClose: onClose),
            const SizedBox(height: 16),
            content,
            if (actions != null) ...[
              const SizedBox(height: 24),
              DialogFooter(actions: actions!)
            ],
          ],
        ),
      ),
    );
  }
}

class DialogHeader extends StatelessWidget {
  final Widget title;
  final VoidCallback? onClose;

  const DialogHeader({
    super.key,
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: title),
        if (onClose != null)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
      ],
    );
  }
}

class DialogFooter extends StatelessWidget {
  final List<Widget> actions;

  const DialogFooter({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions.map((action) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: action,
      )).toList(),
    );
  }
}
