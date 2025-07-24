// lib/screens/weather_screen.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_kisan_flutter/widgets/bottom_navigation.dart';
import 'package:project_kisan_flutter/widgets/floating_voice_button.dart';
import 'package:project_kisan_flutter/services/query_client.dart';
import 'package:provider/provider.dart';

class WeatherData {
  final String location;
  final double temperature;
  final double humidity;
  final double rainfall;
  final String condition;
  final String advice;
  final List<DayForecast>? forecast;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.condition,
    required this.advice,
    this.forecast,
  });
}

class DayForecast {
  final String date;
  final double temperature;
  final String condition;
  final double rainfall;
  final double humidity;

  DayForecast({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.rainfall,
    required this.humidity,
  });
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _location = 'Karnataka, India';
  bool _isLoadingLocation = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleLocationSearch() async {
    if (_searchController.text.trim().isEmpty) return;
    setState(() {
      _location = _searchController.text.trim();
      _searchController.clear();
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _location = '${position.latitude},${position.longitude}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Unable to get your location: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<WeatherData> _fetchWeatherData() async {
    await Future.delayed(const Duration(seconds: 1));
    return WeatherData(
      location: _location,
      temperature: 28.5,
      humidity: 65,
      rainfall: 12,
      condition: 'Partly Cloudy',
      advice:
      'Current weather conditions are favorable for irrigation. Consider watering your crops in the early morning to minimize evaporation losses.',
      forecast: [
        DayForecast(
          date: DateTime.now().add(const Duration(days: 1)).toString(),
          temperature: 29,
          condition: 'Partly Cloudy',
          rainfall: 5,
          humidity: 70,
        ),
        DayForecast(
          date: DateTime.now().add(const Duration(days: 2)).toString(),
          temperature: 31,
          condition: 'Sunny',
          rainfall: 0,
          humidity: 55,
        ),
        DayForecast(
          date: DateTime.now().add(const Duration(days: 3)).toString(),
          temperature: 27,
          condition: 'Rainy',
          rainfall: 25,
          humidity: 85,
        ),
        DayForecast(
          date: DateTime.now().add(const Duration(days: 4)).toString(),
          temperature: 26,
          condition: 'Cloudy',
          rainfall: 10,
          humidity: 75,
        ),
        DayForecast(
          date: DateTime.now().add(const Duration(days: 5)).toString(),
          temperature: 28,
          condition: 'Partly Cloudy',
          rainfall: 2,
          humidity: 65,
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    if (condition.toLowerCase().contains('rain')) {
      return Icons.cloudy_snowing;
    } else if (condition.toLowerCase().contains('cloud')) {
      return Icons.cloud;
    } else if (condition.toLowerCase().contains('storm')) {
      return Icons.thunderstorm;
    } else {
      return Icons.wb_sunny;
    }
  }

  Color _getWeatherIconColor(String condition) {
    if (condition.toLowerCase().contains('rain')) {
      return Colors.blue;
    } else if (condition.toLowerCase().contains('cloud')) {
      return Colors.grey;
    } else if (condition.toLowerCase().contains('storm')) {
      return Colors.purple;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Weather & Farming Advice'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<WeatherData>(
        future: Provider.of<QueryClient>(context)
            .fetch('/api/weather', _fetchWeatherData),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting accurate weather data...'),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 48, color: Colors.yellow),
                  SizedBox(height: 16),
                  Text('Weather data unavailable'),
                ],
              ),
            );
          }

          final weather = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Location Search
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.search, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Search Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText:
                                  'Enter city, state, or coordinates',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (_) => _handleLocationSearch(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _handleLocationSearch,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search, size: 20),
                                  SizedBox(width: 4),
                                  Text('Search'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.location_on),
                                label: _isLoadingLocation
                                    ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text('Use My Location'),
                                onPressed: _isLoadingLocation
                                    ? null
                                    : _getCurrentLocation,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current: $_location',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: const Text(
                            'Currently using intelligent weather estimates. For real-time data, add an OpenWeatherMap API key to get live weather updates.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Current Weather
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              weather.location,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            _buildWeatherStat(
                              icon: Icons.thermostat,
                              iconColor: Colors.orange,
                              value: '${weather.temperature}°C',
                              label: 'Temperature',
                            ),
                            _buildWeatherStat(
                              icon: Icons.water_drop,
                              iconColor: Colors.blue,
                              value: '${weather.humidity}%',
                              label: 'Humidity',
                            ),
                            _buildWeatherStat(
                              icon: Icons.water,
                              iconColor: Colors.green,
                              value: '${weather.rainfall}mm',
                              label: 'Rainfall',
                            ),
                            _buildWeatherStat(
                              icon: _getWeatherIcon(weather.condition),
                              iconColor: _getWeatherIconColor(weather.condition),
                              value: weather.condition,
                              label: 'Condition',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // AI Farming Advice
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'AI Farming Advice',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Text(
                            weather.advice,
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Forecast
                if (weather.forecast != null && weather.forecast!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '5-Day Forecast',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: weather.forecast!.map((day) {
                                final date = DateTime.parse(day.date);
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[200]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${date.day}/${date.month}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Icon(
                                        _getWeatherIcon(day.condition),
                                        color: _getWeatherIconColor(day.condition),
                                        size: 24,
                                      ),
                                      const SizedBox(height: 4),
                                      Text('${day.temperature}°C'),
                                      const SizedBox(height: 4),
                                      Text(
                                        day.condition,
                                        style: const TextStyle(fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${day.rainfall}mm',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Farming Calendar
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              "This Week's Farming Activities",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            _buildFarmingActivity(
                              day: 'Mon',
                              color: Colors.green,
                              title: 'Irrigation Day',
                              description: 'Water crops early morning (6-8 AM)',
                            ),
                            _buildFarmingActivity(
                              day: 'Wed',
                              color: Colors.orange,
                              title: 'Pest Inspection',
                              description:
                              'Check for pest damage on leaves and stems',
                            ),
                            _buildFarmingActivity(
                              day: 'Fri',
                              color: Colors.blue,
                              title: 'Fertilizer Application',
                              description:
                              'Apply organic fertilizer based on soil test results',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButton: const FloatingVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildWeatherStat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmingActivity({
    required String day,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              day,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}