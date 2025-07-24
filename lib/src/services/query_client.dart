import 'package:dio/dio.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Error handling utility
Future<void> throwIfNotOk(Response response) async {
  if (response.statusCode! < 200 || response.statusCode! >= 300) {
    final errorText = response.data?.toString() ?? response.statusMessage;
    throw Exception('${response.statusCode}: $errorText');
  }
}

// API client setup
final apiClientProvider = Provider((ref) {
  final dio = Dio();

  // Configure default options
  dio.options
    ..contentType = 'application/json'
    ..responseType = ResponseType.json
    ..validateStatus = (status) => true; // We'll handle status codes manually

  // Add interceptors
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Add your auth tokens or other headers here
      return handler.next(options);
    },
    onError: (error, handler) {
      // Global error handling
      return handler.next(error);
    },
  ));

  return dio;
});

// API request function
Future<Response> apiRequest({
  required String method,
  required String url,
  dynamic data,
  required Dio dio,
}) async {
  final response = await dio.request(
    url,
    data: data,
    options: Options(method: method),
  );

  await throwIfNotOk(response);
  return response;
}

// Query configuration
enum UnauthorizedBehavior { returnNull, throwError }

// Query function wrapper
Future<T> Function() getQueryFn<T>({
  required String url,
  required Dio dio,
  UnauthorizedBehavior on401 = UnauthorizedBehavior.throwError,
}) {
  return () async {
    final response = await dio.get(url);

    if (on401 == UnauthorizedBehavior.returnNull &&
        response.statusCode == 401) {
      return null as T;
    }

    await throwIfNotOk(response);
    return response.data as T;
  };
}

// Hook-based query implementation
QueryResult<T> useQuery<T>({
  required String queryKey,
  required Future<T> Function() queryFn,
  bool enabled = true,
}) {
  final state = useState<AsyncValue<T>>(const AsyncValue.loading());
  final isMounted = useIsMounted();

  useEffect(() {
    if (!enabled) return null;

    Future<void> fetchData() async {
      state.value = const AsyncValue.loading();
      try {
        final data = await queryFn();
        if (isMounted()) {
          state.value = AsyncValue.data(data);
        }
      } catch (error) {
        if (isMounted()) {
          state.value = AsyncValue.error(error, StackTrace.current);
        }
      }
    }

    fetchData();
    return null;
  }, [queryKey, enabled]);

  return QueryResult<T>(state.value);
}

class QueryResult<T> {
  final AsyncValue<T> state;

  const QueryResult(this.state);

  bool get isLoading => state.isLoading;
  bool get hasError => state.hasError;
  T? get data => state.value;
  Object? get error => state.error;
  StackTrace? get stackTrace => state.stackTrace;
}

// Example usage
class UserRepository {
  final Dio dio;

  UserRepository(this.dio);

  Future<List<User>> getUsers() async {
    final response = await apiRequest(
      method: 'GET',
      url: '/api/users',
      dio: dio,
    );
    return (response.data as List).map((e) => User.fromJson(e)).toList();
  }
}

final userRepositoryProvider = Provider((ref) {
  final dio = ref.watch(apiClientProvider);
  return UserRepository(dio);
});

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Widget using the query
class UserList extends HookConsumerWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepo = ref.watch(userRepositoryProvider);
    final query = useQuery<List<User>>(
      queryKey: '/api/users',
      queryFn: () => userRepo.getUsers(),
    );

    if (query.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (query.hasError) {
      return Center(child: Text('Error: ${query.error}'));
    }

    return ListView.builder(
      itemCount: query.data?.length ?? 0,
      itemBuilder: (context, index) {
        final user = query.data![index];
        return ListTile(title: Text(user.name));
      },
    );
  }
}