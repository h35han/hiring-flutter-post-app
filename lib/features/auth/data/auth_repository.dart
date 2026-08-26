import 'dart:convert';

import 'package:flutter_post_app/core/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

import '../data/models/user_model.dart';

class AuthRepository {
  final SecureStorage _storage;
  final http.Client _client;

  AuthRepository(this._storage, this._client);

  Future<String?> getCachedToken() => _storage.read('access_token');

  Future<bool> isSessionActive() async => await getCachedToken() != null;

  Future<User> login(String name, String password) async {
    var response = await _client.post(
      Uri.https('dummyjson.com', 'auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': name, 'password': password, 'expiresInMins': 30}),
    );
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    _storage.write('access_token', decodedResponse['accessToken']);
    return User(name: decodedResponse['username']);
  }

  Future<User> getUser() async {
    var token = await getCachedToken();
    var response = await _client.get(
      Uri.https('dummyjson.com', 'auth/me'),
      headers: {'Content-Type': 'application/json', "Authorization": 'Bearer $token'},
    );
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return User(name: decodedResponse['username']);
  }
}
