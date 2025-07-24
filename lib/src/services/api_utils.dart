// cn.dart
import 'package:flutter/material.dart';

// Combines multiple BoxDecoration objects, merging their properties
BoxDecoration mergeDecorations(List<BoxDecoration> decorations) {
  if (decorations.isEmpty) return const BoxDecoration();
  if (decorations.length == 1) return decorations.first;

  return decorations.reduce((acc, decoration) {
    return acc.copyWith(
      color: decoration.color ?? acc.color,
      border: decoration.border ?? acc.border,
      borderRadius: decoration.borderRadius ?? acc.borderRadius,
      boxShadow: decoration.boxShadow ?? acc.boxShadow,
      gradient: decoration.gradient ?? acc.gradient,
      backgroundBlendMode: decoration.backgroundBlendMode ?? acc.backgroundBlendMode,
      shape: decoration.shape ?? acc.shape,
    );
  });
}

/// Combines multiple TextStyle objects, merging their properties
TextStyle mergeTextStyles(List<TextStyle> styles) {
  if (styles.isEmpty) return const TextStyle();
  if (styles.length == 1) return styles.first;

  return styles.reduce((acc, style) {
    return acc.merge(style);
  });
}

/// Main utility function that merges multiple styling classes
Widget cn(
    Widget child, {
      List<BoxDecoration> decorations = const [],
      List<TextStyle> textStyles = const [],
      EdgeInsetsGeometry? padding,
      EdgeInsetsGeometry? margin,
      double? width,
      double? height,
      AlignmentGeometry? alignment,
    }) {
  return Container(
    padding: padding,
    margin: margin,
    width: width,
    height: height,
    alignment: alignment,
    decoration: mergeDecorations(decorations),
    child: DefaultTextStyle(
      style: mergeTextStyles(textStyles),
      child: child,
    ),
  );
}

// Alternative version for simpler class merging (more similar to your original)
String mergeClasses(List<String> classes) {
  // This is a simplified version - in Flutter we typically merge styles rather than class strings
  return classes.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
}