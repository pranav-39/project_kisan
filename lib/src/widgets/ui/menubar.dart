import 'package:flutter/material.dart';

class Menubar extends StatelessWidget {
  const Menubar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        MenubarMenu(
          title: 'File',
          items: [
            MenubarItemData(label: 'New File', shortcut: '⌘N'),
            MenubarItemData(label: 'Open...', shortcut: '⌘O'),
            MenubarItemData.separator(),
            MenubarItemData(label: 'Save', shortcut: '⌘S', disabled: true),
          ],
        ),
        SizedBox(width: 16),
        MenubarMenu(
          title: 'Edit',
          items: [
            MenubarItemData(label: 'Undo', shortcut: '⌘Z'),
            MenubarItemData(label: 'Redo', shortcut: '⇧⌘Z'),
            MenubarItemData.separator(),
            MenubarItemData(label: 'Cut', shortcut: '⌘X'),
            MenubarItemData(label: 'Copy', shortcut: '⌘C'),
            MenubarItemData(label: 'Paste', shortcut: '⌘V'),
          ],
        ),
      ],
    );
  }
}

class MenubarMenu extends StatelessWidget {
  final String title;
  final List<MenubarItemData> items;

  const MenubarMenu({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenubarItemData>(
      tooltip: title,
      onSelected: (item) {
        debugPrint('Selected: ${item.label}');
      },
      itemBuilder: (context) {
        return items.map((item) {
          if (item.isSeparator) {
            return const PopupMenuDivider();
          }

          return PopupMenuItem<MenubarItemData>(
            value: item,
            enabled: !item.disabled,
            child: Row(
              children: [
                if (item.checked != null)
                  Icon(
                    item.checked! ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 16,
                  )
                else if (item.radio != null)
                  Icon(
                    item.radio! ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    size: 16,
                  )
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(item.label)),
                if (item.shortcut != null)
                  Text(
                    item.shortcut!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class MenubarItemData {
  final String label;
  final String? shortcut;
  final bool disabled;
  final bool? checked;
  final bool? radio;
  final bool isSeparator;

  const MenubarItemData({
    required this.label,
    this.shortcut,
    this.disabled = false,
    this.checked,
    this.radio,
  }) : isSeparator = false;

  const MenubarItemData.separator()
      : label = '',
        shortcut = null,
        disabled = false,
        checked = null,
        radio = null,
        isSeparator = true;
}
