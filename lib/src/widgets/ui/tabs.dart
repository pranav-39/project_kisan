import 'package:flutter/material.dart';

class AppTabs extends StatefulWidget {
  final List<String> tabLabels;
  final List<Widget> tabContents;

  const AppTabs({
    super.key,
    required this.tabLabels,
    required this.tabContents,
  });

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.tabLabels.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _controller,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).colorScheme.background,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            labelColor: Theme.of(context).colorScheme.onBackground,
            unselectedLabelColor: Theme.of(context).hintColor,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: widget.tabLabels
                .map((label) => Tab(text: label))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.tabContents,
          ),
        ),
      ],
    );
  }
}
