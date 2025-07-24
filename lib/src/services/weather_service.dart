// weather_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherData {
  final String location;
  final int temperature;
  final int humidity;
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

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['location'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      rainfall: json['rainfall'],
      condition: json['condition'],
      advice: json['advice'],
      forecast: json['forecast'] != null
          ? (json['forecast'] as List)
          .map((e) => DayForecast.fromJson(e))
          .toList()
          : null,
    );
  }
}

class DayForecast {
  final String date;
  final int temperature;
  final String condition;
  final double rainfall;
  final int humidity;

  DayForecast({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.rainfall,
    required this.humidity,
  });

  factory DayForecast.fromJson(Map<String, dynamic> json) {
    return DayForecast(
      date: json['date'],
      temperature: json['temperature'],
      condition: json['condition'],
      rainfall: json['rainfall'],
      humidity: json['humidity'],
    );
  }
}

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  final String _baseUrl = "https://api.openweathermap.org/data/2.5";
  String? _apiKey;

  void setApiKey(String key) {
    _apiKey = key;
  }

  Future<WeatherData> getCurrentWeather([String location = "Bangalore, Karnataka, IN"]) async {
    try {
      if (_apiKey == null) {
        return _getIntelligentMockWeather(location);
      }

      final currentUrl = "$_baseUrl/weather?q=${Uri.encodeComponent(location)}&appid=$_apiKey&units=metric";
      final forecastUrl = "$_baseUrl/forecast?q=${Uri.encodeComponent(location)}&appid=$_apiKey&units=metric";

      final [currentResponse, forecastResponse] = await Future.wait([
        http.get(Uri.parse(currentUrl)),
        http.get(Uri.parse(forecastUrl)),
      ]);

      if (currentResponse.statusCode != 200 || forecastResponse.statusCode != 200) {
        throw Exception('Weather API request failed');
      }

      final currentData = jsonDecode(currentResponse.body);
      final forecastData = jsonDecode(forecastResponse.body);

      return _formatWeatherData(currentData, forecastData);
    } catch (error) {
      print("Weather API error: $error");
      return _getIntelligentMockWeather(location);
    }
  }

  WeatherData _formatWeatherData(Map<String, dynamic> current, Map<String, dynamic> forecast) {
    final temperature = (current['main']['temp'] as num).round();
    final humidity = current['main']['humidity'] as int;
    final condition = current['weather'][0]['main'] as String;

    // Calculate rainfall from forecast data
    double rainfall = forecast['list']
        .sublist(0, 8) // Next 24 hours (3-hour intervals)
        .fold(0.0, (total, item) {
      return total + ((item['rain']?['3h'] as num?)?.toDouble() ?? 0.0);
    });

    return WeatherData(
      location: "${current['name']}, ${current['sys']['country']}",
      temperature: temperature,
      humidity: humidity,
      rainfall: double.parse(rainfall.toStringAsFixed(1)),
      condition: _mapCondition(condition),
      advice: _generateFarmingAdvice(temperature, humidity, rainfall, condition),
      forecast: _formatForecast(forecast['list']),
    );
  }

  List<DayForecast> _formatForecast(List<dynamic> forecastList) {
    final dailyData = <String, Map<String, dynamic>>{};
    final dateFormat = DateFormat('EEE, MMM d');

    // Group by date and calculate daily averages
    for (final item in forecastList.sublist(0, 35)) { // 5 days of data
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dateKey = dateFormat.format(date);

      dailyData.putIfAbsent(dateKey, () => {
        'temps': <num>[],
        'conditions': <String>[],
        'rainfall': 0.0,
        'humidity': <int>[],
      });

      final dayData = dailyData[dateKey]!;
      (dayData['temps'] as List<num>).add(item['main']['temp']);
      (dayData['conditions'] as List<String>).add(item['weather'][0]['main']);
      dayData['rainfall'] += (item['rain']?['3h'] as num?)?.toDouble() ?? 0.0;
      (dayData['humidity'] as List<int>).add(item['main']['humidity']);
    }

    return dailyData.entries.map((entry) {
      final date = entry.key;
      final data = entry.value;
      final temps = data['temps'] as List<num>;
      final conditions = data['conditions'] as List<String>;
      final rainfall = data['rainfall'] as double;
      final humidity = data['humidity'] as List<int>;

      return DayForecast(
          date: date,
          temperature: (temps.reduce((a, b) => a + b) / temps.length).round(),
          condition: _mapCondition(_getMostFrequent(conditions)),
          rainfall: double.parse(rainfall.toStringAsFixed(1)),
          humidity: (humidity.reduce((a, b) => a + b) ~/ humidity.length,
          );
      }).toList();
  }

  String _getMostFrequent(List<String> items) {
    final frequencyMap = <String, int>{};
    for (final item in items) {
      frequencyMap[item] = (frequencyMap[item] ?? 0) + 1;
    }
    return frequencyMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String _mapCondition(String condition) {
    const conditionMap = {
      'Clear': 'Sunny',
      'Clouds': 'Cloudy',
      'Rain': 'Rainy',
      'Drizzle': 'Light Rain',
      'Thunderstorm': 'Stormy',
      'Snow': 'Snowy',
      'Mist': 'Misty',
      'Fog': 'Foggy',
    };
    return conditionMap[condition] ?? condition;
  }

  String _generateFarmingAdvice(int temp, int humidity, double rainfall, String condition) {
    final advice = StringBuffer();

    if (temp > 35) {
      advice.write("Very hot weather. Provide shade for crops and increase irrigation frequency. ");
    } else if (temp > 30) {
      advice.write("Hot weather. Water crops early morning or evening to prevent heat stress. ");
    } else if (temp < 15) {
      advice.write("Cool weather. Protect sensitive crops from cold. Reduce watering frequency. ");
    } else {
      advice.write("Favorable temperature for most crops. ");
    }

    if (humidity > 80) {
      advice.write("High humidity increases risk of fungal diseases. Ensure good air circulation. ");
    } else if (humidity < 40) {
      advice.write("Low humidity may stress plants. Consider light misting in evening. ");
    }

    if (rainfall > 10) {
      advice.write("Heavy rainfall expected. Ensure proper drainage to prevent waterlogging. ");
    } else if (rainfall > 2) {
      advice.write("Moderate rainfall expected. Good for irrigation savings. ");
    } else {
      advice.write("Little to no rainfall. Plan irrigation accordingly. ");
    }

    if (condition.contains('Storm')) {
      advice.write("Storm warning! Secure crops and equipment. Avoid outdoor farm work.");
    }

    return advice.toString().trim();
  }

  WeatherData _getIntelligentMockWeather(String location) {
    final now = DateTime.now();
    final month = now.month;
    final isKarnataka = location.toLowerCase().contains('karnataka');
    final isMonsoon = month >= 6 && month <= 9; // June to September
    final isWinter = month >= 11 || month <= 2; // November to February

    double baseTemp = 25;
    int humidity = 60;
    double rainfall = 0;
    String condition = "Partly Cloudy";

    if (isKarnataka) {
      if (isMonsoon) {
        baseTemp = 24;
        humidity = 85;
        rainfall = 15 + (Random().nextDouble() * 20);
        condition = "Rainy";
      } else if (isWinter) {
        baseTemp = 22;
        humidity = 55;
        rainfall = 0;
        condition = "Clear";
      } else {
        baseTemp = 28;
        humidity = 70;
        rainfall = 2;
        condition = "Partly Cloudy";
      }
    }

    // Add some realistic variation
    final temperature = (baseTemp + (Random().nextDouble() * 6 - 3)).round();
    final finalHumidity = (humidity + (Random().nextDouble() * 20 - 10)).clamp(30, 95);
    final finalRainfall = (rainfall * (0.5 + Random().nextDouble())).toStringAsFixed(1);

    return WeatherData(
      location: location.isNotEmpty ? location : "Karnataka, India",
      temperature: temperature,
      humidity: finalHumidity,
      rainfall: double.parse(finalRainfall),
      condition: condition,
      advice: _generateFarmingAdvice(temperature, finalHumidity, double.parse(finalRainfall), condition),
    );
  }
}

final weatherService = WeatherService();