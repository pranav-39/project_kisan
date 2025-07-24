// database_client.dart
import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'schema.dart'; // Your Dart schema definitions

class DatabaseClient {
  static late final PostgreSQLConnection _connection;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');

    final connectionString = dotenv.env['DATABASE_URL'];
    if (connectionString == null) {
      throw Exception(
        'DATABASE_URL must be set in .env file. Did you forget to provision a database?',
      );
    }

    // Parse connection string
    final uri = Uri.parse(connectionString);
    _connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').last,
      useSSL: true,
    );

    await _connection.open();
    _isInitialized = true;
  }

  static PostgreSQLConnection get connection {
    if (!_isInitialized) {
      throw Exception('Database client not initialized. Call initialize() first.');
    }
    return _connection;
  }

  static Future<void> close() async {
    if (_isInitialized) {
      await _connection.close();
      _isInitialized = false;
    }
  }
}
