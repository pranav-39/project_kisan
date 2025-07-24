// server.dart
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_logger/shelf_logger.dart';
import 'services/gemini_service.dart';
import 'services/market_service.dart';
import 'services/schemes_service.dart';
import 'services/weather_service.dart';
import 'storage/storage.dart';

void main() async {
  // Initialize services
  final geminiService = GeminiService();
  final marketService = MarketService();
  final schemesService = SchemesService();
  final weatherService = WeatherService();
  final storage = Storage();

  // Create router
  final app = Router();

  // Middleware pipeline
  final handler = Pipeline()
      .addMiddleware(logger())
      .addMiddleware(_errorHandler())
      .addHandler(app);

  // Disease diagnosis endpoint
  app.post('/api/diagnose-disease', (Request request) async {
    try {
      final body = await request.readAsString();
      final jsonBody = jsonDecode(body) as Map<String, dynamic>;

      final imageData = jsonBody['imageData'] as String?;
      final userId = jsonBody['userId'] as String?;

      if (imageData == null) {
        return Response(400, body: jsonEncode({'error': 'Image data is required'}));
      }

      // Remove data:image/jpeg;base64, prefix if present
      final base64Data = imageData.replaceFirst(RegExp(r'^data:image\/[a-z]+;base64,'), '');

      final diagnosis = await geminiService.diagnoseCropDisease(base64Data);

      // Save to database if userId provided
      if (userId != null) {
        await storage.createDiseaseScan(
          userId: int.parse(userId),
          imageData: base64Data,
          diagnosis: diagnosis.disease,
          confidence: diagnosis.confidence,
          remedies: diagnosis.remedies,
        );

        // Add activity
        await storage.createActivity(
          userId: int.parse(userId),
          type: 'scan',
          title: 'Disease scan completed',
          description: '${diagnosis.disease} detected in crop',
          icon: 'fas fa-camera',
        );
      }

      return Response.ok(jsonEncode(diagnosis));
    } catch (error) {
      print('Disease diagnosis error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to diagnose disease'}),
      );
    }
  });

  // Market prices endpoint
  app.get('/api/market-prices', (Request request) async {
    try {
      final prices = await marketService.getCurrentPrices();
      return Response.ok(jsonEncode(prices));
    } catch (error) {
      print('Market prices error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch market prices'}),
      );
    }
  });

  // Market price for specific crop
  app.get('/api/market-prices/<crop>', (Request request, String crop) async {
    try {
      final price = await marketService.getPriceForCrop(crop);

      if (price == null) {
        return Response.notFound(
          jsonEncode({'error': 'Crop not found'}),
        );
      }

      return Response.ok(jsonEncode(price));
    } catch (error) {
      print('Market price error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch crop price'}),
      );
    }
  });

  // Market insight endpoint
  app.post('/api/market-insight', (Request request) async {
    try {
      final body = await request.readAsString();
      final jsonBody = jsonDecode(body) as Map<String, dynamic>;

      final query = jsonBody['query'] as String?;
      final userId = jsonBody['userId'] as String?;

      if (query == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Query is required'}),
        );
      }

      final insight = await geminiService.getMarketInsight(query);

      // Add activity if userId provided
      if (userId != null) {
        await storage.createActivity(
          userId: int.parse(userId),
          type: 'market',
          title: 'Market analysis requested',
          description: 'Analysis for: $query',
          icon: 'fas fa-chart-line',
        );
      }

      return Response.ok(jsonEncode({'insight': insight}));
    } catch (error) {
      print('Market insight error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to get market insight'}),
      );
    }
  });

  // Government schemes endpoint
  app.get('/api/schemes', (Request request) async {
    try {
      final schemes = await schemesService.getAllSchemes();
      return Response.ok(jsonEncode(schemes));
    } catch (error) {
      print('Schemes error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch schemes'}),
      );
    }
  });

  // Search schemes endpoint
  app.get('/api/schemes/search', (Request request) async {
    try {
      final query = request.url.queryParameters['q'];

      if (query == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Search query is required'}),
        );
      }

      final schemes = await schemesService.searchSchemes(query);
      return Response.ok(jsonEncode(schemes));
    } catch (error) {
      print('Scheme search error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to search schemes'}),
      );
    }
  });

  // Scheme recommendation endpoint
  app.post('/api/schemes/recommend', (Request request) async {
    try {
      final body = await request.readAsString();
      final jsonBody = jsonDecode(body) as Map<String, dynamic>;

      final query = jsonBody['query'] as String?;
      final userId = jsonBody['userId'] as String?;

      if (query == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Query is required'}),
        );
      }

      final recommendation = await schemesService.getSchemeRecommendation(query);

      // Add activity if userId provided
      if (userId != null) {
        await storage.createActivity(
          userId: int.parse(userId),
          type: 'scheme',
          title: 'Scheme recommendation requested',
          description: 'Query: $query',
          icon: 'fas fa-landmark',
        );
      }

      return Response.ok(jsonEncode({'recommendation': recommendation}));
    } catch (error) {
      print('Scheme recommendation error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to get scheme recommendation'}),
      );
    }
  });

  // Voice query endpoint
  app.post('/api/voice-query', (Request request) async {
    try {
      final body = await request.readAsString();
      final jsonBody = jsonDecode(body) as Map<String, dynamic>;

      final query = jsonBody['query'] as String?;
      final userId = jsonBody['userId'] as String?;

      if (query == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Query is required'}),
        );
      }

      final response = await geminiService.processVoiceQuery(query);

      // Add activity if userId provided
      if (userId != null) {
        await storage.createActivity(
          userId: int.parse(userId),
          type: 'voice',
          title: 'Voice query processed',
          description: query,
          icon: 'fas fa-microphone',
        );
      }

      return Response.ok(jsonEncode({'response': response}));
    } catch (error) {
      print('Voice query error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to process voice query'}),
      );
    }
  });

  // User activities endpoint
  app.get('/api/activities/<userId>', (Request request, String userId) async {
    try {
      final activities = await storage.getActivitiesByUserId(int.parse(userId));
      return Response.ok(jsonEncode(activities));
    } catch (error) {
      print('Activities error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch activities'}),
      );
    }
  });

  // Weather endpoint
  app.get('/api/weather', (Request request) async {
    try {
      final location = request.url.queryParameters['location'];
      final weather = await weatherService.getCurrentWeather(location);
      return Response.ok(jsonEncode(weather));
    } catch (error) {
      print('Weather error: $error');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch weather data'}),
      );
    }
  });

  // Start server
  final server = await io.serve(handler, '0.0.0.0', 5000);
  print('Server running on port ${server.port}');
}

Middleware _errorHandler() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (error, stack) {
        print('Error: $error\n$stack');
        return Response.internalServerError(
          body: jsonEncode({'error': 'Internal Server Error'}),
        );
      }
    };
  };
}