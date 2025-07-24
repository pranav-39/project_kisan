// database_schema.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ==================== MODELS ====================

class User {
  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profileImageUrl;
  final String? location;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
    this.location,
    this.language = 'en',
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    profileImageUrl: json['profile_image_url'],
    location: json['location'],
    language: json['language'] ?? 'en',
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'profile_image_url': profileImageUrl,
    'location': location,
    'language': language,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

class DiseaseScan {
  final int? id;
  final String userId;
  final String imageData;
  final String? diagnosis;
  final int? confidence;
  final List<String>? remedies;
  final DateTime scanDate;

  DiseaseScan({
    this.id,
    required this.userId,
    required this.imageData,
    this.diagnosis,
    this.confidence,
    this.remedies,
    required this.scanDate,
  });

  factory DiseaseScan.fromJson(Map<String, dynamic> json) => DiseaseScan(
    id: json['id'],
    userId: json['user_id'],
    imageData: json['image_data'],
    diagnosis: json['diagnosis'],
    confidence: json['confidence'],
    remedies: json['remedies'] != null
        ? List<String>.from(json['remedies'])
        : null,
    scanDate: DateTime.parse(json['scan_date']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'image_data': imageData,
    'diagnosis': diagnosis,
    'confidence': confidence,
    'remedies': remedies,
    'scan_date': scanDate.toIso8601String(),
  };
}

class MarketPrice {
  final int? id;
  final String crop;
  final int price;
  final String unit;
  final String market;
  final String? trend;
  final int? trendPercentage;
  final DateTime lastUpdated;

  MarketPrice({
    this.id,
    required this.crop,
    required this.price,
    this.unit = 'kg',
    required this.market,
    this.trend,
    this.trendPercentage,
    required this.lastUpdated,
  });

  double get priceInRupees => price / 100;

  factory MarketPrice.fromJson(Map<String, dynamic> json) => MarketPrice(
    id: json['id'],
    crop: json['crop'],
    price: json['price'],
    unit: json['unit'] ?? 'kg',
    market: json['market'],
    trend: json['trend'],
    trendPercentage: json['trend_percentage'],
    lastUpdated: DateTime.parse(json['last_updated']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'crop': crop,
    'price': price,
    'unit': unit,
    'market': market,
    'trend': trend,
    'trend_percentage': trendPercentage,
    'last_updated': lastUpdated.toIso8601String(),
  };
}

class GovernmentScheme {
  final int? id;
  final String name;
  final String description;
  final String? amount;
  final List<String>? eligibility;
  final String? applicationLink;
  final bool isActive;
  final String? category;

  GovernmentScheme({
    this.id,
    required this.name,
    required this.description,
    this.amount,
    this.eligibility,
    this.applicationLink,
    this.isActive = true,
    this.category,
  });

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) => GovernmentScheme(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    amount: json['amount'],
    eligibility: json['eligibility'] != null
        ? List<String>.from(json['eligibility'])
        : null,
    applicationLink: json['application_link'],
    isActive: json['is_active'] ?? true,
    category: json['category'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'amount': amount,
    'eligibility': eligibility,
    'application_link': applicationLink,
    'is_active': isActive,
    'category': category,
  };
}

class Activity {
  final int? id;
  final String userId;
  final String type;
  final String title;
  final String? description;
  final String? icon;
  final DateTime createdAt;

  Activity({
    this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.description,
    this.icon,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'],
    userId: json['user_id'],
    type: json['type'],
    title: json['title'],
    description: json['description'],
    icon: json['icon'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'type': type,
    'title': title,
    'description': description,
    'icon': icon,
    'created_at': createdAt.toIso8601String(),
  };
}

// ==================== DATABASE SERVICE ====================

class AppDatabase {
  static const _dbName = 'farm_assistant.db';
  static const _dbVersion = 1;

  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT,
        first_name TEXT,
        last_name TEXT,
        profile_image_url TEXT,
        location TEXT,
        language TEXT DEFAULT 'en',
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE disease_scans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        image_data TEXT NOT NULL,
        diagnosis TEXT,
        confidence INTEGER,
        remedies TEXT,
        scan_date TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE market_prices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        crop TEXT NOT NULL,
        price INTEGER NOT NULL,
        unit TEXT DEFAULT 'kg',
        market TEXT NOT NULL,
        trend TEXT,
        trend_percentage INTEGER,
        last_updated TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE government_schemes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        amount TEXT,
        eligibility TEXT,
        application_link TEXT,
        is_active INTEGER DEFAULT 1,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        created_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migration logic here when you upgrade the database version
  }

  // ==================== CRUD OPERATIONS ====================

  // Users
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toJson());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((json) => User.fromJson(json)).toList();
  }

  // DiseaseScans
  Future<int> insertDiseaseScan(DiseaseScan scan) async {
    final db = await database;
    return await db.insert('disease_scans', scan.toJson());
  }

  Future<List<DiseaseScan>> getDiseaseScansByUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'disease_scans',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return maps.map((json) => DiseaseScan.fromJson(json)).toList();
  }

  // MarketPrices
  Future<int> insertMarketPrice(MarketPrice price) async {
    final db = await database;
    return await db.insert('market_prices', price.toJson());
  }

  Future<List<MarketPrice>> getMarketPrices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('market_prices');
    return maps.map((json) => MarketPrice.fromJson(json)).toList();
  }

  // GovernmentSchemes
  Future<int> insertGovernmentScheme(GovernmentScheme scheme) async {
    final db = await database;
    return await db.insert('government_schemes', scheme.toJson());
  }

  Future<List<GovernmentScheme>> getActiveGovernmentSchemes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'government_schemes',
      where: 'is_active = ?',
      whereArgs: [1],
    );
    return maps.map((json) => GovernmentScheme.fromJson(json)).toList();
  }

  // Activities
  Future<int> insertActivity(Activity activity) async {
    final db = await database;
    return await db.insert('activities', activity.toJson());
  }

  Future<List<Activity>> getUserActivities(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activities',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((json) => Activity.fromJson(json)).toList();
  }
}

// ==================== VALIDATORS ====================

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }

  static String? validateImageData(String? value) {
    if (value == null || value.isEmpty) return 'Image data is required';
    // Add base64 validation if needed
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) return 'Price is required';
    if (int.tryParse(value) == null) return 'Enter a valid price';
    return null;
  }
}