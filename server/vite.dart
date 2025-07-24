import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

void main() {
  // Initialize logging similar to your express log function
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  runApp(MyApp(logger: logger));
}

class MyApp extends StatelessWidget {
  final Logger logger;

  const MyApp({super.key, required this.logger});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Simulate the Express "*" catch-all route
      onGenerateRoute: (settings) {
        logger.i('Route requested: ${settings.name}');

        // Try to load the route, fallback to home
        try {
          return MaterialPageRoute(
            builder: (context) => _getPageForRoute(settings.name ?? '/'),
          );
        } catch (e) {
          logger.e('Route error: $e');
          return MaterialPageRoute(builder: (context) => const HomePage());
        }
      },
      // Simulate Vite's dev mode behavior
      debugShowCheckedModeBanner: true,
    );
  }

  Widget _getPageForRoute(String route) {
    switch (route) {
      case '/':
        return const HomePage();
      case '/about':
        return const AboutPage();
    // Add other routes here
      default:
      // Simulate your Express static file fallback
        return const HomePage();
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? htmlContent;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  // Simulate reading index.html like your Express server
  Future<void> _loadContent() async {
    try {
      final content = await rootBundle.loadString('assets/index.html');
      setState(() {
        htmlContent = content;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(htmlContent: htmlContent ?? '<p>Not found</p>'),
    );
  }
}

// Simple widget to display HTML content
class WebViewWidget extends StatelessWidget {
  final String htmlContent;

  const WebViewWidget({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    // In a real app, you'd use the webview_flutter package
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(htmlContent),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About Page')),
    );
  }
}