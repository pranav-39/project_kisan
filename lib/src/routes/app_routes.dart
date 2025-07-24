// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:project_kisan_flutter/screens/home_screen.dart';
import 'package:project_kisan_flutter/screens/disease_scanner_screen.dart';
import 'package:project_kisan_flutter/screens/market_prices_screen.dart';
import 'package:project_kisan_flutter/screens/government_schemes_screen.dart';
import 'package:project_kisan_flutter/screens/weather_screen.dart';
import 'package:project_kisan_flutter/screens/not_found_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/scan':
        return MaterialPageRoute(builder: (_) => const DiseaseScannerScreen());
      case '/market':
        return MaterialPageRoute(builder: (_) => const MarketPricesScreen());
      case '/schemes':
        return MaterialPageRoute(builder: (_) => const GovernmentSchemesScreen());
      case '/weather':
        return MaterialPageRoute(builder: (_) => const WeatherScreen());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}