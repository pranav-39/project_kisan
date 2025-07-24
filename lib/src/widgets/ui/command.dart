import 'package:flutter/material.dart';

class Command extends StatelessWidget {
  final Widget child;

  const Command({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class CommandDialog extends StatelessWidget {
  final Widget child;
  final bool open;

  const CommandDialog({super.key, required this.child, required this.open});

  @override
  Widget build(BuildContext context) {
    if (!open) return const SizedBox.shrink();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Command(child: child),
    );
  }
}

class CommandInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CommandInput({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommandList extends StatelessWidget {
  final List<Widget> children;

  const CommandList({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      children: children,
    );
  }
}

class CommandItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CommandItem({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class CommandEmpty extends StatelessWidget {
  const CommandEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        "No results found",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}

class CommandGroup extends StatelessWidget {
  final String heading;
  final List<Widget> children;

  const CommandGroup({
    super.key,
    required this.heading,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            heading,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        ...children,
      ],
    );
  }
}

class CommandSeparator extends StatelessWidget {
  const CommandSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1);
  }
}

class CommandShortcut extends StatelessWidget {
  final String label;

  const CommandShortcut({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.grey,
        letterSpacing: 1,
      ),
    );
  }
}
