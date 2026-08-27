import 'dart:convert';

import 'package:flutter_post_app/core/config/app_config.dart';
import 'package:flutter_post_app/core/session/session_handler.dart';
import 'package:http/http.dart' as http;

import 'models/post_model.dart';

class DashboardRepository {
  final SessionHandler _sessionHandler;
  final http.Client _client;

  DashboardRepository(this._sessionHandler, this._client);

  Future<List<Post>> fetchRecentPosts({int? offset = 0}) async {
    var response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}/posts?sortBy=id&order=desc&skip=$offset&limit=${AppConfig.paginationLimit}'),
      headers: {'Content-Type': 'application/json'},
    );

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var posts = decodedResponse["posts"];

    if (posts is List) return posts.map((data) => Post.fromJson(data)).toList();
    return [];
  }

  Future<List<Post>> fetchFeaturedPosts({int? offset = 0}) async {
    var response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}/posts?sortBy=views&skip=$offset&order=desc&limit=${AppConfig.paginationLimit}'),
      headers: {'Content-Type': 'application/json'},
    );

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var posts = decodedResponse["posts"];

    if (posts is List) return posts.map((data) => Post.fromJson(data)).toList();
    return [];
  }

  Future<List<Post>> searchPosts(String query, {int? offset = 0}) async {
    var response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}/posts/search?q=$query&skip=$offset&limit=${AppConfig.paginationLimit}'),
      headers: {'Content-Type': 'application/json'},
    );

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var posts = decodedResponse["posts"];

    if (posts is List) return posts.map((data) => Post.fromJson(data)).toList();
    return [];
  }
}
