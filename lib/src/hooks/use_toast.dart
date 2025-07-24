import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const int toastLimit = 1;
const int toastRemoveDelay = 1000000;

class ToastOptions {
  final String? id;
  final String title;
  final String? description;
  final Widget? action;
  final Duration duration;
  final Color backgroundColor;
  final TextStyle textStyle;
  final ToastGravity gravity;
  final bool dismissible;

  const ToastOptions({
    this.id,
    required this.title,
    this.description,
    this.action,
    this.duration = const Duration(milliseconds: 3000),
    this.backgroundColor = Colors.black54,
    this.textStyle = const TextStyle(color: Colors.white),
    this.gravity = ToastGravity.BOTTOM,
    this.dismissible = true,
  });
}

class ToastController {
  static final List<String> _activeToastIds = [];
  static final Map<String, FToast> _toastInstances = {};

  static void showToast(BuildContext context, ToastOptions options) {
    // Generate ID if not provided
    final id = options.id ?? UniqueKey().toString();

    // Remove oldest toast if limit reached
    if (_activeToastIds.length >= toastLimit) {
      _removeToast(_activeToastIds.first);
    }

    final fToast = FToast();
    fToast.init(context);

    Widget toastContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: options.backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(options.title, style: options.textStyle),
          if (options.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(options.description!, style: options.textStyle),
            ),
          if (options.action != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: options.action!,
            ),
        ],
      ),
    );

    _activeToastIds.add(id);
    _toastInstances[id] = fToast;

    fToast.showToast(
      child: toastContent,
      gravity: options.gravity,
      toastDuration: options.duration,
    );

    // Auto-dismiss after delay
    if (options.dismissible) {
      Future.delayed(Duration(milliseconds: toastRemoveDelay), () {
        dismissToast(id);
      });
    }
  }

  static void dismissToast(String id) {
    if (_toastInstances.containsKey(id)) {
      _toastInstances[id]?.removeCustomToast();
      _removeToast(id);
    }
  }

  static void dismissAllToasts() {
    for (var id in _activeToastIds.toList()) {
      dismissToast(id);
    }
  }

  static void _removeToast(String id) {
    _activeToastIds.remove(id);
    _toastInstances.remove(id);
  }
}

// Usage example
class ToastExample extends StatelessWidget {
  const ToastExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toast Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ToastController.showToast(
                  context,
                  ToastOptions(
                    title: 'Hello Flutter!',
                    description: 'This is a toast notification',
                  ),
                );
              },
              child: const Text('Show Toast'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ToastController.dismissAllToasts,
              child: const Text('Dismiss All'),
            ),
          ],
        ),
      ),
    );
  }
}

// Hook-like usage (alternative approach)
class ToastProvider extends InheritedWidget {
  final void Function(ToastOptions) showToast;
  final void Function(String) dismissToast;
  final void Function() dismissAllToasts;

  const ToastProvider({
    super.key,
    required super.child,
    required this.showToast,
    required this.dismissToast,
    required this.dismissAllToasts,
  });

  static ToastProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToastProvider>();
  }

  @override
  bool updateShouldNotify(ToastProvider oldWidget) => false;
}

class ToastWrapper extends StatefulWidget {
  final Widget child;

  const ToastWrapper({super.key, required this.child});

  @override
  State<ToastWrapper> createState() => _ToastWrapperState();
}

class _ToastWrapperState extends State<ToastWrapper> {
  void showToast(ToastOptions options) {
    ToastController.showToast(context, options);
  }

  void dismissToast(String id) {
    ToastController.dismissToast(id);
  }

  void dismissAllToasts() {
    ToastController.dismissAllToasts();
  }

  @override
  Widget build(BuildContext context) {
    return ToastProvider(
      showToast: showToast,
      dismissToast: dismissToast,
      dismissAllToasts: dismissAllToasts,
      child: widget.child,
    );
  }
}

// Usage with provider
void showCustomToast(BuildContext context, String message) {
  ToastProvider.of(context)?.showToast(
    ToastOptions(
      title: message,
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(color: Colors.white),
    ),
  );
}