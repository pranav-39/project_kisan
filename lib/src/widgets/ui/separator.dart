import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final Axis orientation;
  final bool decorative;
  final double thickness;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const Separator({
    Key? key,
    this.orientation = Axis.horizontal,
    this.decorative = true,
    this.thickness = 1.0,
    this.color,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = color ?? Theme.of(context).dividerColor;

    return Container(
      margin: margin,
      width: orientation == Axis.horizontal ? double.infinity : thickness,
      height: orientation == Axis.horizontal ? thickness : double.infinity,
      color: decorative ? borderColor : Colors.transparent,
    );
  }
}
