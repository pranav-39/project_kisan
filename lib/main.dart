import 'package:flutter/material.dart';
import 'package:project_kisan_flutter/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Kisan',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: '/',
    );
  }
}