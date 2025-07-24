import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final List<AccordionItemData> items;

  const Accordion({Key? key, required this.items}) : super(key: key);

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  List<bool> _expanded = [];

  @override
  void initState() {
    super.initState();
    _expanded = List.filled(widget.items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 4),
        expansionCallback: (int index, bool isOpen) {
          setState(() {
            _expanded[index] = !isOpen;
          });
        },
        children: widget.items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;

          return ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _expanded[i],
            headerBuilder: (context, isOpen) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration: isOpen ? TextDecoration.underline : null,
                  ),
                ),
                trailing: AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: isOpen ? 0.5 : 0,
                  child: const Icon(Icons.expand_more),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: item.content,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AccordionItemData {
  final String title;
  final Widget content;

  AccordionItemData({
    required this.title,
    required this.content,
  });
}
