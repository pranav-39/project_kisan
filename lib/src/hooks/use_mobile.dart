import 'package:flutter/material.dart';

const double mobileBreakpoint = 768;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Detector Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Function to get the current mobile status
  bool get isMobile => MediaQuery.of(context).size.width < mobileBreakpoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Detector')),
      body: Center(
        child: Builder(
          builder: (context) {
            // Using MediaQuery directly in build will automatically rebuild when size changes
            final bool mobile = MediaQuery.of(context).size.width < mobileBreakpoint;

            return Text(
              'You are on ${mobile ? 'MOBILE' : 'DESKTOP'}',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    );
  }
}

// Alternative implementation as a reusable hook-like function
class IsMobileBuilder extends StatefulWidget {
  final Widget Function(bool isMobile) builder;

  const IsMobileBuilder({super.key, required this.builder});

  @override
  State<IsMobileBuilder> createState() => _IsMobileBuilderState();
}

class _IsMobileBuilderState extends State<IsMobileBuilder> {
  late bool _isMobile;

  @override
  void initState() {
    super.initState();
    _isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update when screen size changes
    final newValue = MediaQuery.of(context).size.width < mobileBreakpoint;
    if (newValue != _isMobile) {
      setState(() {
        _isMobile = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_isMobile);
  }
}