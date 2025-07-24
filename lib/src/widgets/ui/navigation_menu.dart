import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final List<NavigationMenuItem> items;

  const NavigationMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items,
    );
  }
}

class NavigationMenuItem extends StatelessWidget {
  final String label;
  final Widget? dropdownContent;

  const NavigationMenuItem({
    super.key,
    required this.label,
    this.dropdownContent,
  });

  @override
  Widget build(BuildContext context) {
    return dropdownContent == null
        ? TextButton(
      onPressed: () {},
      child: Text(label),
    )
        : _HoverMenu(
      label: label,
      dropdownContent: dropdownContent!,
    );
  }
}

class _HoverMenu extends StatefulWidget {
  final String label;
  final Widget dropdownContent;

  const _HoverMenu({
    required this.label,
    required this.dropdownContent,
  });

  @override
  State<_HoverMenu> createState() => _HoverMenuState();
}

class _HoverMenuState extends State<_HoverMenu> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              _isHovering ? Icons.expand_less : Icons.expand_more,
              size: 16,
            ),
            label: Text(widget.label),
          ),
          AnimatedOpacity(
            opacity: _isHovering ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: _isHovering
                ? Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: widget.dropdownContent,
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
