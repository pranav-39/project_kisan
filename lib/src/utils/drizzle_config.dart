// database_config.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class DatabaseConfig {
  static const dialect = 'sqlite'; // Flutter typically uses SQLite
  static const migrationsDir = './migrations';
  static const schemaFile = './lib/database/schema.dart';

  static Future<QueryExecutor> openConnection() async {
    // For SQLite in Flutter
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  }

  static void validateEnvironment() {
    // In Flutter, we might check for other required environment variables
    // For example, you might want to check if the database file is accessible
    // or if certain platform-specific requirements are met
    if (const bool.fromEnvironment('dart.vm.product')) {
      // We're in release mode, perform additional checks if needed
    }
  }
}

// Usage in your database class would look like:
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(DatabaseConfig.openConnection());

  @override
  int get schemaVersion => 1; // Increment this for new migrations

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Implement your migration logic here
      if (from < 2) {
        // Example migration from version 1 to 2
        await m.addColumn(diseaseScans, diseaseScans.confidence);
      }
    },
  );
}