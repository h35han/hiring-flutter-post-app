import 'dart:convert';
import 'dart:io';

import 'package:flutter_post_app/core/config/app_config.dart';
import 'package:flutter_post_app/core/session/session_handler.dart';
import 'package:http/http.dart' as http;

import '../data/models/user_model.dart';

class AuthRepository {
  final SessionHandler _sessionHandler;
  final http.Client _client;

  AuthRepository(this._sessionHandler, this._client);

  Future<bool> isSessionActive() async => await _sessionHandler.getCachedToken() != null;

  Future<User> login(String name, String password) async {
    var response = await _client.post(
      Uri.parse('${AppConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': name, 'password': password, 'expiresInMins': 60}),
    );

    if (response.statusCode == HttpStatus.unauthorized) {
      _sessionHandler.clearSession();
      throw UnauthorizedException();
    }

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    _sessionHandler.setSession(decodedResponse['accessToken']);
    return User(name: decodedResponse['username']);
  }

  Future<User> getUser() async {
    var token = await _sessionHandler.getCachedToken();
    var response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}/auth/me'),
      headers: {'Content-Type': 'application/json', "Authorization": 'Bearer $token'},
    );

    if (response.statusCode == HttpStatus.unauthorized) {
      _sessionHandler.clearSession();
      throw UnauthorizedException();
    }

    _sessionHandler.setSession(token!);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return User(name: decodedResponse['username']);
  }

  Future logout() => _sessionHandler.clearSession();
}

class UnauthorizedException implements Exception {}
