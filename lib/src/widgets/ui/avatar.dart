// lib/widgets/ui/avatar.dart
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String? fallbackText;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? customFallback;
  final BoxFit fit;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const Avatar({
    super.key,
    this.imageUrl,
    this.fallbackText,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.customFallback,
    this.fit = BoxFit.cover,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: imageUrl != null
              ? Image.network(
            imageUrl!,
            width: size,
            height: size,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _buildFallback(context),
          )
              : _buildFallback(context),
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      color: backgroundColor ?? colorScheme.surfaceVariant,
      child: Center(
        child: customFallback ??
            Text(
              fallbackText != null && fallbackText!.isNotEmpty
                  ? fallbackText!.substring(0, 1).toUpperCase()
                  : '?',
              style: TextStyle(
                color: textColor ?? colorScheme.onSurfaceVariant,
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}