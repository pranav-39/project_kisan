// server.dart
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_logger/shelf_logger.dart';

void main() async {
  // Create app
  final app = Router();

  // Middleware
  final pipeline = Pipeline()
      .addMiddleware(logger()) // Request logging
      .addMiddleware(_errorHandler()) // Error handling
      .addMiddleware(_requestLogger()) // Custom request logging
      .addHandler(app);

  // Register routes (similar to your registerRoutes)
  _registerRoutes(app);

  // Serve static files in production
  if (const bool.fromEnvironment('dart.vm.product')) {
    final staticHandler = createStaticHandler(
      'build/web', // Flutter web build directory
      defaultDocument: 'index.html',
    );
    app.all('/<ignored|.*>', staticHandler);
  }

  // Start server
  final server = await io.serve(
    pipeline,
    '0.0.0.0',
    5000,
    shared: true,
  );

  print('Serving on port ${server.port}');
}

// Middleware for error handling
Middleware _errorHandler() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (err, stack) {
        print('Error: $err\n$stack');
        final status = err is HttpException ? err.statusCode : 500;
        final message = err is HttpException ? err.message : 'Internal Server Error';

        return Response(
          status,
          body: {'message': message},
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}

// Middleware for request logging
Middleware _requestLogger() {
  return (Handler innerHandler) {
    return (Request request) async {
      final path = request.url.path;
      if (!path.startsWith('/api')) {
        return await innerHandler(request);
      }

      final start = DateTime.now();
      late Response response;
      String? responseBody;

      try {
        response = await innerHandler(request);

        // Capture response body for logging
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          responseBody = await response.readAsString();
        }

        return response;
      } finally {
        final duration = DateTime.now().difference(start);
        var logLine = '${request.method} ${path} ${response.statusCode} in ${duration.inMilliseconds}ms';

        if (responseBody != null) {
          logLine += ' :: $responseBody';
          if (logLine.length > 80) {
            logLine = '${logLine.substring(0, 79)}…';
          }
        }

        print(logLine);
      }
    };
  };
}
