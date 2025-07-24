// lib/widgets/bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_kisan_flutter/routes/app_routes.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final router = Provider.of<RouterNotifier>(context, listen: false);

    final navItems = [
      {
        'path': '/',
        'icon': Icons.home,
        'label': 'Home',
      },
      {
        'path': '/scan',
        'icon': Icons.camera_alt,
        'label': 'Scan',
      },
      {
        'path': '/market',
        'icon': Icons.show_chart,
        'label': 'Market',
      },
      {
        'path': '/schemes',
        'icon': Icons.account_balance,
        'label': 'Schemes',
      },
      {
        'path': '/weather',
        'icon': Icons.wb_sunny,
        'label': 'Weather',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.map((item) {
              final isActive = currentRoute == item['path'];
              return InkWell(
                onTap: () => router.push(item['path']),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 24,
                        color: isActive
                            ? Colors.green[800]
                            : Colors.grey[600],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? Colors.green[800]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// You'll need this in your routes/app_routes.dart file
class RouterNotifier extends ChangeNotifier {
  void push(String routeName) {
    // Implement your navigation logic here
    // This would typically use Navigator.pushNamed
    notifyListeners();
  }
}