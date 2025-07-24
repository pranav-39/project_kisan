import 'package:flutter/material.dart';

class ScrollArea extends StatefulWidget {
  final Widget child;
  final Axis scrollDirection;
  final ScrollController? controller;

  const ScrollArea({
    Key? key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.controller,
  }) : super(key: key);

  @override
  State<ScrollArea> createState() => _ScrollAreaState();
}

class _ScrollAreaState extends State<ScrollArea> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true, // shows scrollbar always (like Radix)
      radius: const Radius.circular(8),
      thickness: 6,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: widget.scrollDirection,
        child: widget.child,
      ),
    );
  }
}
