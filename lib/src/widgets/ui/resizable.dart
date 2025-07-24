import 'package:flutter/material.dart';
import 'package:flutter_split_view/flutter_split_view.dart';

class ResizablePanelGroup extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final List<double>? initialWeights;

  const ResizablePanelGroup({
    Key? key,
    required this.children,
    this.direction = Axis.horizontal,
    this.initialWeights,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplitView(
      viewMode: SplitViewMode.Custom,
      initialWeights: initialWeights ??
          List<double>.filled(children.length, 1 / children.length),
      gripSize: 8,
      gripColor: Theme.of(context).dividerColor,
      gripColorActive: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      children: children,
      mode: direction == Axis.vertical
          ? SplitViewMode.Vertical
          : SplitViewMode.Horizontal,
    );
  }
}
