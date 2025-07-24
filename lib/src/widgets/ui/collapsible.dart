import 'package:flutter/material.dart';

class Collapsible extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final bool initiallyExpanded;

  const Collapsible({
    super.key,
    required this.trigger,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  State<Collapsible> createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible> {
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggle,
          child: widget.trigger,
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
          _isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: widget.content,
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
