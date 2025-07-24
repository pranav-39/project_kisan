// storage.dart
import 'dart:collection';
import 'models.dart'; // Contains your data model classes

abstract class IStorage {
  Future<User?> getUser(int id);
  Future<User?> getUserByUsername(String username);
  Future<User> createUser(InsertUser user);
  Future<DiseaseScan> createDiseaseScan({
    required int userId,
    required String imageData,
    String? diagnosis,
    int? confidence,
    List<String>? remedies,
  });
  Future<Activity> createActivity({
    required int userId,
    required String type,
    required String title,
    String? description,
    String? icon,
  });
  Future<List<Activity>> getActivitiesByUserId(int userId);
}

class MemStorage implements IStorage {
  final Map<int, User> _users = {};
  final Map<int, DiseaseScan> _diseaseScans = {};
  final Map<int, Activity> _activities = {};
  int _currentId = 1;
  int _scanId = 1;
  int _activityId = 1;

  @override
  Future<User?> getUser(int id) async {
    return _users[id];
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    return _users.values.firstWhere(
          (user) => user.username == username,
      orElse: () => null as User,
    );
  }

  @override
  Future<User> createUser(InsertUser insertUser) async {
    final id = _currentId++;
    final user = User(
      id: id,
      username: insertUser.username,
      name: insertUser.name,
      location: insertUser.location,
      profileImage: insertUser.profileImage,
      language: insertUser.language,
      createdAt: DateTime.now(),
    );
    _users[id] = user;
    return user;
  }

  @override
  Future<DiseaseScan> createDiseaseScan({
    required int userId,
    required String imageData,
    String? diagnosis,
    int? confidence,
    List<String>? remedies,
  }) async {
    final id = _scanId++;
    final diseaseScan = DiseaseScan(
      id: id,
      userId: userId,
      imageData: imageData,
      diagnosis: diagnosis,
      confidence: confidence,
      remedies: remedies,
      scanDate: DateTime.now(),
    );
    _diseaseScans[id] = diseaseScan;
    return diseaseScan;
  }

  @override
  Future<Activity> createActivity({
    required int userId,
    required String type,
    required String title,
    String? description,
    String? icon,
  }) async {
    final id = _activityId++;
    final activity = Activity(
      id: id,
      userId: userId,
      type: type,
      title: title,
      description: description,
      icon: icon,
      createdAt: DateTime.now(),
    );
    _activities[id] = activity;
    return activity;
  }

  @override
  Future<List<Activity>> getActivitiesByUserId(int userId) async {
    return _activities.values
        .where((activity) => activity.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

// Singleton instance
final storage = MemStorage();