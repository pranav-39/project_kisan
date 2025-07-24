import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const CardWidget({
    super.key,
    this.child,
    this.padding,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}

class CardHeader extends StatelessWidget {
  final Widget? child;

  const CardHeader({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge!,
        child: child ?? const SizedBox(),
      ),
    );
  }
}

class CardTitle extends StatelessWidget {
  final String text;

  const CardTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class CardDescription extends StatelessWidget {
  final String text;

  const CardDescription(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
    );
  }
}

class CardContent extends StatelessWidget {
  final Widget? child;

  const CardContent({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: child,
    );
  }
}

class CardFooter extends StatelessWidget {
  final Widget? child;

  const CardFooter({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: child,
    );
  }
}
