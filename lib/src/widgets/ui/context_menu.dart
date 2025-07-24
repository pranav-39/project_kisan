import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  final Widget child;

  const ContextMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ContextMenuTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback onLongPress;

  const ContextMenuTrigger({super.key, required this.child, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: child,
    );
  }
}

class ContextMenuContent extends StatelessWidget {
  final List<Widget> children;

  const ContextMenuContent({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class ContextMenuItem extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool inset;
  final bool enabled;

  const ContextMenuItem({
    super.key,
    required this.child,
    required this.onTap,
    this.inset = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: EdgeInsets.fromLTRB(inset ? 24 : 12, 12, 12, 12),
        child: DefaultTextStyle(
          style: TextStyle(
            color: enabled ? Theme.of(context).colorScheme.onSurface : Colors.grey,
            fontSize: 14,
          ),
          child: child,
        ),
      ),
    );
  }
}

class ContextMenuCheckboxItem extends StatelessWidget {
  final Widget child;
  final bool checked;
  final VoidCallback onChanged;

  const ContextMenuCheckboxItem({
    super.key,
    required this.child,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenuItem(
      onTap: onChanged,
      inset: true,
      child: Row(
        children: [
          Icon(checked ? Icons.check_box : Icons.check_box_outline_blank, size: 18),
          const SizedBox(width: 8),
          child,
        ],
      ),
    );
  }
}

class ContextMenuRadioItem extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onChanged;

  const ContextMenuRadioItem({
    super.key,
    required this.child,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenuItem(
      onTap: onChanged,
      inset: true,
      child: Row(
        children: [
          Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, size: 18),
          const SizedBox(width: 8),
          child,
        ],
      ),
    );
  }
}

class ContextMenuLabel extends StatelessWidget {
  final String text;
  final bool inset;

  const ContextMenuLabel({super.key, required this.text, this.inset = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(inset ? 24 : 12, 8, 12, 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class ContextMenuSeparator extends StatelessWidget {
  const ContextMenuSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1);
  }
}

class ContextMenuShortcut extends StatelessWidget {
  final String text;

  const ContextMenuShortcut({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.grey,
        letterSpacing: 1,
      ),
    );
  }
}

class ContextMenuGroup extends StatelessWidget {
  final List<Widget> children;

  const ContextMenuGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}

// Placeholder for Portal (no-op in Flutter)
class ContextMenuPortal extends StatelessWidget {
  final Widget child;

  const ContextMenuPortal({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}

// Submenu structure
class ContextMenuSub extends StatelessWidget {
  final Widget child;

  const ContextMenuSub({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}

class ContextMenuSubTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const ContextMenuSubTrigger({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ContextMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(child: child),
          const Icon(Icons.chevron_right, size: 16),
        ],
      ),
    );
  }
}

class ContextMenuSubContent extends StatelessWidget {
  final List<Widget> children;

  const ContextMenuSubContent({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ContextMenuContent(children: children);
  }
}

class ContextMenuRadioGroup extends StatelessWidget {
  final List<Widget> children;

  const ContextMenuRadioGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) => Column(children: children);
}
