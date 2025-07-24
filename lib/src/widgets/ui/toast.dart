import 'package:flutter/material.dart';

class Toast extends StatelessWidget {
  final String title;
  final String? description;
  final bool isDestructive;
  final VoidCallback? onClose;

  const Toast({
    Key? key,
    required this.title,
    this.description,
    this.isDestructive = false,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = isDestructive ? Colors.red.shade100 : Theme.of(context).colorScheme.background;
    final borderColor = isDestructive ? Colors.red.shade300 : Theme.of(context).dividerColor;
    final textColor = isDestructive ? Colors.red.shade900 : Theme.of(context).colorScheme.onBackground;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      description!,
                      style: TextStyle(color: textColor.withOpacity(0.9)),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20, color: textColor.withOpacity(0.5)),
            onPressed: onClose ?? () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}
