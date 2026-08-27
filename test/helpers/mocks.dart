import 'dart:convert';

import 'package:flutter_post_app/core/session/session_handler.dart';
import 'package:flutter_post_app/core/storage/secure_storage.dart';
import 'package:flutter_post_app/features/auth/data/auth_repository.dart';
import 'package:flutter_post_app/features/auth/data/models/user_model.dart';
import 'package:flutter_post_app/features/dashboard/data/dashboard_repository.dart';
import 'package:flutter_post_app/features/dashboard/data/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;

class FakeSecureStorage extends SecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write(String key, String data) async => _store[key] = data;

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  Future<dynamic> purge() async => _store.clear();
}

class StubHttpClient {
  final _stubs = <_Stub>[];
  final requests = <RecordedRequest>[];
  late final http.Client client;

  StubHttpClient() {
    client = http_testing.MockClient((request) async {
      String? body;
      body = request.body;
      requests.add(RecordedRequest(request.method, request.url, headers: request.headers, body: body));
      for (final s in _stubs) {
        if (s.method == request.method && request.url.toString().contains(s.pattern)) {
          return s.response;
        }
      }
      return http.Response('{}', 200);
    });
  }

  void stubGet(String pattern, http.Response response) =>
      _stubs.add(_Stub(pattern: pattern, method: 'GET', response: response));

  void stubPost(String pattern, http.Response response) =>
      _stubs.add(_Stub(pattern: pattern, method: 'POST', response: response));
}

class _Stub {
  final String pattern;
  final String method;
  final http.Response response;
  const _Stub({required this.pattern, required this.method, required this.response});
}

class RecordedRequest {
  final String method;
  final Uri uri;
  final Map<String, String>? headers;
  final String? body;
  const RecordedRequest(this.method, this.uri, {this.headers, this.body});
}

http.Response jsonResponse(Map<String, dynamic> body, {int status = 200}) {
  return http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json'});
}

http.Response rawResponse(String body, {int status = 200}) => http.Response(body, status);

class FakeAuthRepository extends AuthRepository {
  User? _cachedUser;
  bool _sessionActive = false;
  Object? _loginError;
  Object? _getUserError;

  FakeAuthRepository()
    : super(SessionHandler(FakeSecureStorage()), http_testing.MockClient((_) async => http.Response('{}', 200)));

  void whenLoginThrows(Object error) => _loginError = error;
  void whenGetUserThrows(Object error) => _getUserError = error;
  void setSessionActive(bool active) => _sessionActive = active;
  void setUser(User user) => _cachedUser = user;

  @override
  Future<bool> isSessionActive() async => _sessionActive;

  @override
  Future<User> login(String name, String password) async {
    if (_loginError != null) {
      final e = _loginError!;
      _loginError = null;
      throw e;
    }
    _cachedUser ??= User(name: name);
    return _cachedUser!;
  }

  @override
  Future<User> getUser() async {
    if (_getUserError != null) {
      final e = _getUserError!;
      _getUserError = null;
      throw e;
    }
    return _cachedUser ?? const User(name: 'test');
  }

  @override
  Future logout() async {
    _cachedUser = null;
    _sessionActive = false;
  }
}

class FakeDashboardRepository extends DashboardRepository {
  List<Post> _recentPosts = [];
  List<Post> _featuredPosts = [];
  List<Post> _searchedPosts = [];
  Object? _recentError;
  Object? _featuredError;
  Object? _searchError;

  FakeDashboardRepository()
    : super(SessionHandler(FakeSecureStorage()), http_testing.MockClient((_) async => http.Response('{}', 200)));

  void setRecentPosts(List<Post> posts) => _recentPosts = posts;
  void setFeaturedPosts(List<Post> posts) => _featuredPosts = posts;
  void setSearchedPosts(List<Post> posts) => _searchedPosts = posts;
  void whenRecentPostsThrows(Object error) => _recentError = error;
  void whenFeaturedPostsThrows(Object error) => _featuredError = error;
  void whenSearchPostsThrows(Object error) => _searchError = error;

  @override
  Future<List<Post>> fetchRecentPosts({int? offset = 0}) async {
    if (_recentError != null) {
      final e = _recentError!;
      _recentError = null;
      throw e;
    }
    return _recentPosts;
  }

  @override
  Future<List<Post>> fetchFeaturedPosts({int? offset = 0}) async {
    if (_featuredError != null) {
      final e = _featuredError!;
      _featuredError = null;
      throw e;
    }
    return _featuredPosts;
  }

  @override
  Future<List<Post>> searchPosts(String query, {int? offset = 0}) async {
    if (_searchError != null) {
      final e = _searchError!;
      _searchError = null;
      throw e;
    }
    return _searchedPosts;
  }
}
