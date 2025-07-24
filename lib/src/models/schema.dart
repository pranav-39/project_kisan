// database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Sessions,
    Users,
    DiseaseScans,
    MarketPrices,
    GovernmentSchemes,
    Activities,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DataClassName('Session')
class Sessions extends Table {
  TextColumn get sid => text()();
  JsonColumn get sess => json()();
  DateTimeColumn get expire => dateTime()();

  @override
  Set<Column> get primaryKey => {sid};
}

@DataClassName('User')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().nullable()();
  TextColumn get firstName => text().named('first_name').nullable()();
  TextColumn get lastName => text().named('last_name').nullable()();
  TextColumn get profileImageUrl => text().named('profile_image_url').nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get language => text().withDefault(const Constant('en'))();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DiseaseScan')
class DiseaseScans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id').nullable().references(Users, #id)();
  TextColumn get imageData => text().named('image_data')();
  TextColumn get diagnosis => text().nullable()();
  IntColumn get confidence => integer().nullable()();
  JsonColumn get remedies => json().nullable().map(const ArrayConverter())();
  DateTimeColumn get scanDate => dateTime().named('scan_date').withDefault(currentDateAndTime)();
}

@DataClassName('MarketPrice')
class MarketPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get crop => text()();
  IntColumn get price => integer()();
  TextColumn get unit => text().withDefault(const Constant('kg'))();
  TextColumn get market => text()();
  TextColumn get trend => text().nullable()();
  IntColumn get trendPercentage => integer().named('trend_percentage').nullable()();
  DateTimeColumn get lastUpdated => dateTime().named('last_updated').withDefault(currentDateAndTime)();
}

@DataClassName('GovernmentScheme')
class GovernmentSchemes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get amount => text().nullable()();
  JsonColumn get eligibility => json().nullable().map(const ArrayConverter())();
  TextColumn get applicationLink => text().named('application_link').nullable()();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  TextColumn get category => text().nullable()();
}

@DataClassName('Activity')
class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id').nullable().references(Users, #id)();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}

// Model classes
class ArrayConverter extends TypeConverter<List<String>, String> {
  const ArrayConverter();

  @override
  List<String>? mapToDart(String? fromDb) {
    if (fromDb == null) return null;
    return List<String>.from(json.decode(fromDb));
  }

  @override
  String? mapToSql(List<String>? value) {
    if (value == null) return null;
    return json.encode(value);
  }
}

// Schema validation classes
class InsertUser {
  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profileImageUrl;
  final String? location;
  final String? language;

  InsertUser({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
    this.location,
    this.language,
  });
}

class InsertDiseaseScan {
  final String? userId;
  final String imageData;

  InsertDiseaseScan({
    this.userId,
    required this.imageData,
  });
}

class InsertMarketPrice {
  final String crop;
  final int price;
  final String? unit;
  final String market;
  final String? trend;
  final int? trendPercentage;

  InsertMarketPrice({
    required this.crop,
    required this.price,
    this.unit,
    required this.market,
    this.trend,
    this.trendPercentage,
  });
}

class InsertGovernmentScheme {
  final String name;
  final String description;
  final String? amount;
  final List<String>? eligibility;
  final String? applicationLink;
  final String? category;

  InsertGovernmentScheme({
    required this.name,
    required this.description,
    this.amount,
    this.eligibility,
    this.applicationLink,
    this.category,
  });
}

class InsertActivity {
  final String? userId;
  final String type;
  final String title;
  final String? description;
  final String? icon;

  InsertActivity({
    this.userId,
    required this.type,
    required this.title,
    this.description,
    this.icon,
  });
}